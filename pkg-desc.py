import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("path")
args = parser.parse_args()
print(args.path)

with open(args.path, 'r') as f:
    list = list(filter(None, f.read().split("\n")))
    for elt in list:
        subprocess.run(["pacman",  "-Ss", "^"+elt+"$"])
