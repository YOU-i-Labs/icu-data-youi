# About

This repository is used to store ICU data files and convert them to a C++ static
library. This library is meant to allow loading only the relevant parts of the ICU
data sets, while avoiding the need for using an actual file (which would require
that file to be extracted at runtime for Android).

# Data files

The repository is composed of ICU data files for ICU 55. One file is the 'regular'
ICU 55 data file, containing all of the available ICU data. Another is a 'minimal'
ICU data file, which allows for ICU text layout as well as NFC unicode
normalization.

# Adding data files

To add a data file, create a new folder under data/ and store the ICU data file into it.

After a data file has been added (or updated), the headers must be regenerated.

# Regenerating headers

To regenerate headers, run the script `generate_headers.rb`. The script has only
been tested on OSX but should also work on Linux so long as the `xxd` utility
is installed.

The script will automatically split header files so that their size does not
exceed ~90MB (and thus can still be committed and pushed to Github). The headers
are recombined in the generated .cpp files.

# Modifying data files

An ICU data file can be modified using the icupkg tool. This tool ships with ICU
itself, as well as can be found in the .hunter directory when building You.i
Engine from source. The scripts under script/ can be used to facilitate unpacking
and repacking ICU data files.
