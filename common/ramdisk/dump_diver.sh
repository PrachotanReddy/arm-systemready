#!/bin/bash

LOG_FILE="/mnt/acs_results/dump_hardware_errors_summary.log"
PARENT_DIR="/mnt/acs_results"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

> $LOG_FILE

# checking if input file is present
if [ -n "$1" ] && [ -f "$1" ]; then
    PARENT_DIR="$1"
    echo -e "${GREEN}Using provided directory path: $PARENT_DIR${NC}"
else
    echo -e "${GREEN}Using default dump directory: $PARENT_DIR${NC}"
fi

echo -e "${GREEN}Finding hardware, driver, and device errors...${NC}"

echo -e "${YELLOW}Errors and warnings from Linux and UEFI dump:${NC}" >> $LOG_FILE
grep -rnEi '(error|fail|fault).*?(hardware|hw|driver|device|firmware|pcie|usb)' "$PARENT_DIR"/linux_dump "$PARENT_DIR"/uefi_dump >> $LOG_FILE

if [ $(wc -l < "$LOG_FILE") -gt 1 ]; then
    echo -e "${GREEN}Hardware/Device/Firmware error summary saved to $LOG_FILE${NC}"
    cat $LOG_FILE
else
    echo -e "${GREEN}No device/driver errors or faults were found in linux_dump and uefi_dump.${NC}"
    rm $LOG_FILE
    echo -e "${YELLOW}Summary file $LOG_FILE has been deleted as it was empty.${NC}"
fi