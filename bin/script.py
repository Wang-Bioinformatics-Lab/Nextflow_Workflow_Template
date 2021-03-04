import sys
import argparse

import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('input_filename')
parser.add_argument('output_filename')

args = parser.parse_args()

with open(args.output_filename, "w") as o:
    o.write("OUTPUT")