#!/bin/bash

count=0
count=$(find . -type f -name "*.txt" | wc -l)

echo "$count"
