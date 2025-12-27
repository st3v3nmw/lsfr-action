#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if lsfr.yaml exists
if [ ! -f "lsfr.yaml" ]; then
  echo -e "${RED}lsfr.yaml not found in current directory${NC}"
  echo "Make sure you're running this action in a directory with an lsfr challenge."
  exit 1
fi

# Parse lsfr.yaml
echo "Reading lsfr.yaml..."
CHALLENGE=$(grep "^challenge:" lsfr.yaml | awk '{print $2}')
CURRENT_STAGE=$(grep "^  current:" lsfr.yaml | awk '{print $2}')

# Read completed stages into array
COMPLETED_STAGES=()
in_completed=false
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*completed:[[:space:]]*$ ]]; then
    in_completed=true
  elif [[ "$line" =~ ^[[:space:]]*-[[:space:]]+(.+)$ ]]; then
    if [ "$in_completed" = true ]; then
      stage="${BASH_REMATCH[1]}"
      COMPLETED_STAGES+=("$stage")
    fi
  elif [[ "$line" =~ ^[^[:space:]] && "$in_completed" = true ]]; then
    # End of completed section
    break
  fi
done < lsfr.yaml

echo -e "${GREEN}Challenge:${NC} $CHALLENGE"
echo -e "${GREEN}Current stage:${NC} $CURRENT_STAGE"
if [ ${#COMPLETED_STAGES[@]} -gt 0 ]; then
  echo -e "${GREEN}Completed stages:${NC} ${COMPLETED_STAGES[*]}"
else
  echo -e "${YELLOW}No completed stages yet${NC}"
fi
echo ""

# Test all completed stages + current
STAGES_TO_TEST=("${COMPLETED_STAGES[@]}")
if [ -n "$CURRENT_STAGE" ]; then
  STAGES_TO_TEST+=("$CURRENT_STAGE")
fi

echo "Testing all stages: ${STAGES_TO_TEST[*]}"

if [ ${#STAGES_TO_TEST[@]} -eq 0 ]; then
  echo -e "${YELLOW}No stages to test${NC}"
  exit 0
fi

# Run tests
FAILED_STAGES=()
PASSED_STAGES=()

for stage in "${STAGES_TO_TEST[@]}"; do
  echo ""
  echo "═══════════════════════════════════════════════════════════════"
  echo -e "Testing stage: ${GREEN}$stage${NC}"
  echo "═══════════════════════════════════════════════════════════════"

  if lsfr test "$stage"; then
    PASSED_STAGES+=("$stage")
  else
    FAILED_STAGES+=("$stage")
  fi
done

# Summary
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Summary"
echo "═══════════════════════════════════════════════════════════════"

if [ ${#PASSED_STAGES[@]} -gt 0 ]; then
  echo -e "${GREEN}Passed (${#PASSED_STAGES[@]}):${NC} ${PASSED_STAGES[*]}"
fi

if [ ${#FAILED_STAGES[@]} -gt 0 ]; then
  echo -e "${RED}Failed (${#FAILED_STAGES[@]}):${NC} ${FAILED_STAGES[*]}"
fi

# Exit with error if any stage failed
if [ ${#FAILED_STAGES[@]} -gt 0 ]; then
  echo ""
  echo -e "${RED}Tests failed${NC}"
  exit 1
else
  echo ""
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
fi
