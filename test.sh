#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if lc.state exists
if [ ! -f "lc.state" ]; then
  echo -e "${RED}lc.state not found in current directory${NC}"
  echo "Make sure you're running this action in a directory with a LittleClusters challenge."
  exit 1
fi

# Run tests using lc
echo "Running tests..."
if lc test --so-far; then
  echo ""
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo ""
  echo -e "${RED}Tests failed${NC}"
  exit 1
fi
