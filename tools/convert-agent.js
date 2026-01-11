#!/usr/bin/env node
/**
 * Agent Converter - Converts canonical agent files to platform-specific formats
 *
 * Usage:
 *   node convert-agent.js input.agent.md              # Generate all formats
 *   node convert-agent.js input.agent.md --claude     # Claude Code only
 *   node convert-agent.js input.agent.md --vscode     # VS Code only
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');

// Platform-specific configurations
const PLATFORMS = {
  claude: {
    outputDir: '.claude/agents',
    extension: '.md',
    frontmatter: (data) => ({
      name: data.name,
      description: data.description,
      tools: data.tools || ['Read', 'Write', 'Edit', 'Bash', 'Glob', 'Grep', 'Task'],
      model: data.model || 'sonnet',
      ...(data.disallowedTools && { disallowedTools: data.disallowedTools }),
      ...(data.permissionMode && { permissionMode: data.permissionMode }),
      ...(data.skills && { skills: data.skills }),
    })
  },

  vscode: {
    outputDir: '.github/agents',
    extension: '.agent.md',
    frontmatter: (data) => ({
      description: data.description,
      name: data.name,
      tools: (data.tools || ['Read', 'Write', 'Edit', 'Bash', 'Glob', 'Grep', 'Task'])
        .map(t => {
          // Map Claude Code tool names to VS Code equivalents
          const toolMap = {
            'Read': 'search',
            'Write': 'edit',
            'Edit': 'edit',
            'Bash': 'terminal',
            'Glob': 'search',
            'Grep': 'search',
            'Task': 'agent'
          };
          return toolMap[t] || t.toLowerCase();
        }),
      ...(data.model && { model: data.model === 'sonnet' ? 'Claude Sonnet 4' : data.model }),
      ...(data.handoffs && { handoffs: data.handoffs }),
      target: 'vscode',
      infer: true
    })
  }
};

/**
 * Parse canonical agent file (.agent.md format)
 * Format:
 * ---
 * name: sibyl
 * title: CEO + Research Lead
 * icon: 🔮
 * description: CEO + Research Lead + Multi-Agent Coordinator
 * tools: Read, Write, Edit, Bash, Glob, Grep, Task
 * model: sonnet
 * handoffs: |
 *   - label: Delegate to Neo
 *     agent: neo
 *     prompt: Please review this from a frontend architecture perspective.
 * ---
 *
 * Agent content here...
 */
function parseAgentFile(content) {
  const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!frontmatterMatch) {
    throw new Error('Invalid agent file format: missing frontmatter');
  }

  const frontmatterText = frontmatterMatch[1];
  const body = frontmatterMatch[2].trim();

  // Parse YAML frontmatter
  const data = {};
  let currentKey = null;
  let currentMultiline = null;
  let inArray = false;

  const lines = frontmatterText.split('\n');
  for (const line of lines) {
    const trimmed = line.trim();

    // Handle multiline values
    if (currentMultiline) {
      if (trimmed === '|') {
        currentMultiline.type = 'literal';
        continue;
      }
      if (trimmed.startsWith('|')) {
        currentMultiline.type = 'literal';
        currentMultiline.value = '';
        continue;
      }
      if (trimmed === '>' || trimmed.startsWith('>')) {
        currentMultiline.type = 'folded';
        continue;
      }
      if (line.startsWith('    ') || line.startsWith('\t')) {
        if (currentMultiline.type === 'literal') {
          currentMultiline.value += (currentMultiline.value ? '\n' : '') + trimmed;
        } else {
          currentMultiline.value += (currentMultiline.value ? ' ' : '') + trimmed;
        }
        continue;
      }
      // End of multiline
      data[currentMultiline.key] = currentMultiline.value.trim();
      currentMultiline = null;
    }

    // Handle array items
    if (trimmed.startsWith('- ')) {
      if (!inArray) {
        inArray = true;
        data[currentKey] = [];
      }
      const itemValue = trimmed.slice(2).trim();
      if (itemValue) {
        data[currentKey].push(itemValue);
      }
      continue;
    }

    // Handle key-value pairs
    if (trimmed.includes(':')) {
      inArray = false;
      const [key, ...valueParts] = trimmed.split(':');
      const value = valueParts.join(':').trim();

      if (value === '' || value === '|' || value === '>') {
        currentMultiline = { key, value: '' };
        if (value === '|' || value === '>') {
          currentMultiline.type = value;
        }
      } else {
        data[key] = value;
        currentKey = key;
      }
    }
  }

  // Clean up any pending multiline
  if (currentMultiline) {
    data[currentMultiline.key] = currentMultiline.value.trim();
  }

  return { ...data, body };
}

/**
 * Generate YAML frontmatter string
 */
function toYAML(obj, indent = 0) {
  const spaces = ' '.repeat(indent);
  let result = '';

  for (const [key, value] of Object.entries(obj)) {
    if (value === undefined || value === null) continue;

    if (Array.isArray(value)) {
      result += `${spaces}${key}:\n`;
      for (const item of value) {
        if (typeof item === 'object') {
          result += `${spaces}  - ${toYAML(item, 0).trim()}\n`;
        } else {
          result += `${spaces}  - ${item}\n`;
        }
      }
    } else if (typeof value === 'object') {
      result += `${spaces}${key}:\n${toYAML(value, indent + 2)}`;
    } else {
      result += `${spaces}${key}: ${value}\n`;
    }
  }

  return result;
}

/**
 * Generate platform-specific agent file
 */
function generatePlatformFile(agentData, platform) {
  const config = PLATFORMS[platform];
  if (!config) {
    throw new Error(`Unknown platform: ${platform}`);
  }

  const frontmatter = config.frontmatter(agentData);
  const yaml = toYAML(frontmatter);

  return `---\n${yaml}---\n\n${agentData.body}\n`;
}

/**
 * Main conversion function
 */
function convert(inputFile, platforms = Object.keys(PLATFORMS)) {
  const content = fs.readFileSync(inputFile, 'utf8');
  const agentData = parseAgentFile(content);

  const results = [];

  for (const platform of platforms) {
    const config = PLATFORMS[platform];
    const output = generatePlatformFile(agentData, platform);

    const outputPath = path.join(
      ROOT,
      config.outputDir,
      `${agentData.name}${config.extension}`
    );

    results.push({ platform, outputPath, output });
  }

  return { agentData, results };
}

// CLI interface
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);
  const inputFile = args[0];

  if (!inputFile) {
    console.error('Usage: node convert-agent.js <input-file> [--claude] [--vscode] [--all]');
    process.exit(1);
  }

  const platforms = [];
  if (args.includes('--claude')) platforms.push('claude');
  if (args.includes('--vscode')) platforms.push('vscode');
  if (args.includes('--all') || platforms.length === 0) {
    platforms.push(...Object.keys(PLATFORMS));
  }

  try {
    const { agentData, results } = convert(inputFile, platforms);

    console.log(`Converting: ${agentData.name} - ${agentData.title}`);
    console.log(`  Description: ${agentData.description}`);

    for (const { platform, outputPath, output } of results) {
      const fullPath = path.resolve(ROOT, outputPath);
      const dir = path.dirname(fullPath);

      // Create directory if needed
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }

      // Write file
      fs.writeFileSync(fullPath, output, 'utf8');
      console.log(`  ✓ ${platform}: ${outputPath}`);
    }
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

export { convert, parseAgentFile, generatePlatformFile, PLATFORMS };
