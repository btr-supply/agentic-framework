#!/usr/bin/env sh
# Release script - bumps version, updates tags, pushes to GitHub

set -e

# Parse arguments
BUMP_TYPE="${1:-patch}"

# Get current version
CURRENT_VERSION=$(grep '"version"' package.json | sed 's/.*"version": "\(.*\)".*/\1/')

# Parse version parts
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)

# Calculate new version
case "$BUMP_TYPE" in
  major)  MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor)  MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch)  PATCH=$((PATCH + 1)) ;;
  *)      echo "Usage: $0 [major|minor|patch]"; exit 1 ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

echo "Current version: $CURRENT_VERSION"
echo "New version: $NEW_VERSION"

# Update package.json
sed -i.bak "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" package.json
rm -f package.json.bak

# Commit (if there are changes)
if git diff --quiet package.json; then
  echo "No changes to commit"
else
  git add package.json
  git commit -m "[ops] Bump version to v${NEW_VERSION}"
fi

# Create and push tags
git tag "v${NEW_VERSION}"
git tag -d latest 2>/dev/null || true
git tag latest

echo "Pushing tags..."
git push
git push origin "v${NEW_VERSION}"
git push origin ":refs/tags/latest" 2>/dev/null || true
git push origin latest

echo "Released v${NEW_VERSION} (latest tag updated)"
