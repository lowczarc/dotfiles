#!/bin/python

import sys
import os

PID = sys.argv[1]
mapPath = "/proc/{}/maps".format(PID)
memPath = "/proc/{}/mem".format(PID)

mapsFile = open(mapPath, "r");
memFile = open(memPath, "rb", 0);

def getPwds():
    for line in mapsFile.readlines():
        r = line.split()

        if len(r) < 6:
            continue

        if r[5] == "[heap]":
            heapRange = r[0].split('-')

            start = int(heapRange[0], 16)
            end = int(heapRange[1], 16)

            size = end - start

            memFile.seek(start)

            chunk = memFile.read(size)
            res = 0
            while True:
                res = chunk.find(b"PWD=/", res);
                if (res == -1):
                    break
                length = chunk.find(b"\00", res) - res;

                if (res != 0 and chunk[res-1] != 0):
                    res += length
                    continue

                yield chunk[res+4:res+length].decode("utf8")
                res += length

def getPWD():
    cwdPath = os.readlink("/proc/{}/cwd".format(PID))

    for possiblePWD in getPwds():
        if (os.path.normpath(cwdPath) == os.path.normpath(possiblePWD)):
            return os.path.normpath(possiblePWD)

        try:
            possibleCWD = os.readlink(possiblePWD)

            if os.path.normpath(possibleCWD) == os.path.normpath(cwdPath):
                return possiblePWD
        except:
            pass

    return cwdPath

print(getPWD())
