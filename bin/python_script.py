import sys
import argparse
import pandas as pd

def main():
    parser = argparse.ArgumentParser(description='Test write out a file.')
    parser.add_argument('input_filename')
    parser.add_argument('variable')
    parser.add_argument('output_filename')

    args = parser.parse_args()

    df = pd.DataFrame()
    row = {"INPUT": args.input_filename, "VARIABLE": args.variable, "OUTPUT": args.output_filename}
    df = pd.concat([df, pd.DataFrame([row])])

    # saving file
    df.to_csv(args.output_filename, sep="\t", index=False)

if __name__ == "__main__":
    main()