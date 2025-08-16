#!/usr/bin/env bash
# Prints swap used/total from sysctl
sysctl vm.swapusage 2>/dev/null | awk -F'[ ,]+' '{for(i=1;i<=NF;i++) if($i=="used"){u=$(i+1)} else if($i=="total"){t=$(i+1)}} END{print "swap: " u " / " t}'
