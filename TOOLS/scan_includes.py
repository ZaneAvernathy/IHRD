#!/usr/bin/python3

import posixpath
import argparse

include_types = [".include", ".binclude"]
binary_types = [".binary", "binary(", ".crossbank.start *,"]

NOT_FOUND = -1 # For str.find results

# Argparse stuff

description = "Prints 64tass dependencies to stdout. " \
    "Useful for listing dependencies for use with a Makefle."

file_help = "file to scan"

epilog = "This script will also scan any dependencies " \
    "found for additional dependencies."

def get_include(d, s):
    """Tries to find a filename
    after an include directive.
    """
    s = s.replace("'", "\"")
    start, end = s.find("\""), s.rfind("\"")
    if start != end:
        return posixpath.join(d, s[start+1:end])
    return None

def scan(file, scanned):
    """Recursively scan a file
    for includes and print
    included filenames. Keeps
    track of already-scanned files.
    """

    # Issues:
    # Missing/unclosed directives will
    # ruin scanning until nesting level returns
    # to zero.
    # Includes that use variables for their
    # filenames instead of quoted strings will
    # not be caught by this script.

    if not posixpath.isfile(file):
        return

    with open(file, "r", encoding="UTF-8") as i:
        lines = i.readlines()

    d = posixpath.dirname(file)

    comment_nesting_level = 0

    for line in lines:

        comment_pos = line.find(";")
        block_comment_pos = line.find(".comment")

        # If block comment directive exists
        # and is before any possible line comments.

        if block_comment_pos != NOT_FOUND:
            if (comment_pos == NOT_FOUND) or (comment_pos > block_comment_pos):
                comment_nesting_level += 1
                continue

        # If we're in a comment block, scan
        # for the end of the block rather
        # than for includes.

        if comment_nesting_level > 0:
            block_end_pos = line.find(".endc") # .endcomment too

            if block_end_pos != NOT_FOUND:
                if (comment_pos == NOT_FOUND) or (comment_pos > block_end_pos):
                    comment_nesting_level -= 1

            # Line still gets ignored
            continue

        for inc_type in include_types + binary_types:
            inc_pos = line.find(inc_type)

            if inc_pos == NOT_FOUND:
                continue

            # Commented-out includes
            if (comment_pos != NOT_FOUND) and (inc_pos > comment_pos):
                continue

            # Try to get a valid path
            # from include
            p = get_include(d, line[inc_pos:])
            if not p:
                continue

            p = posixpath.normpath(p)

            if p not in scanned:
                scanned.add(p)
                print(p)

                # Check if that file has any
                # includes
                if not (inc_type in binary_types):
                    scan(p, scanned)

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=description, epilog=epilog)
    parser.add_argument("files", nargs="+", metavar="file", help=file_help)
    args = parser.parse_args()

    scanned = set()
    for file in set(args.files):
        scan(file, scanned)
