#!/usr/bin/env bash
# Top 5 processes by memory (RES)
top -l 1 -stats pid,command,mem -o mem -n 6 | tail -n +2 | head -n 5
