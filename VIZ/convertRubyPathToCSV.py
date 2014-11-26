#!/usr/bin/env python
# encoding: utf-8

import ast


filename = 'coordinate_map'

with open(filename) as f:
    myFileAsLines = f.readlines()

for line in myFileAsLines:
    myData = ast.literal_eval(line)

    previousD = ""
    for d in myData:
        if d != previousD:
            print ','.join([str(x) for x in d])
        previousD = d
        
    
