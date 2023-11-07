#!/usr/bin/env python

import subprocess
import argparse

from enum import Enum
from sys import exit
from shutil import which

# ===============================
#           Definitions
# ===============================

class ZigOptions(list[str], Enum):
    Build = ["build"],
    Run = ["build", "run"],
    Test = ["build", "test"],
    BuildLib = ["build-lib"],
    Version = ["version"],
    Clean = ["clean"]

zigOptionsSE = {"build" : ZigOptions.Build, "run" : ZigOptions.Run, "test" : ZigOptions.Test, "doc" : ZigOptions.BuildLib, "clean" : ZigOptions.Clean}

def zig(option: ZigOptions, *args: str) -> str:
    command = ["zig", *option, *args]
    output = subprocess.run(command, capture_output=True, check=False)
    error = output.stderr.decode()
    out = output.stdout.decode().rstrip()
    if output.returncode == 0:
        return out;
    else:
        print("Stderr:\033[1;31m")
        print(error)
        print("\033[0m")
        print("Stdout:")
        print(out)
        exit("Error running zig subprocess")

# ================================
#           Cli Program
# ================================

parser = argparse.ArgumentParser(prog="Zig Build Helper for Zig Collections", description="Simplifies Zig Commands")
parser.add_argument(
        "do",
        metavar="A",
        type=str,
        nargs=1,
        choices=["run", "build", "test", "doc", "clean"],
        help="Action to do [run, build, test, doc, clean]")

# =========================
#           Start
# =========================

# Verify zig install
if which("zig") is None:
    exit("Zig is not installed!")

# Verify Version
isVersionValid = False
versionStrList: list[str] = zig(ZigOptions.Version).split(".")
version = []
try:
    version = [int(x) for x in versionStrList]
except ValueError:
    version = [0, 11, 0]

if (version[0] > 0):
    isVersionValid = True
elif(version[1] >= 11):
    isVersionValid = True

if not isVersionValid:
    exit("Zig Version is not valid!, minimum required is 0.11.0")

# Running
args = parser.parse_args()
argument = zigOptionsSE[args.do[0]]

if (argument == ZigOptions.Build):
    zig(ZigOptions.Build)
elif (argument == ZigOptions.BuildLib):
    zig(ZigOptions.BuildLib, "-femit-docs", "-fno-emit-bin", "src/zig_collections.zig")
elif (argument == ZigOptions.Test):
    zig(ZigOptions.Test)
elif (argument == ZigOptions.Run):
    zig(ZigOptions.Run)
elif (argument == ZigOptions.Clean):
    subprocess.run(["rm", "-rf", "./zig-cache/", "./zig-out/", "./docs", "./.mypy_cache"])
