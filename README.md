# ocrd-fileformat

> OCR-D wrapper for [`ocr-fileformat`](https://github.com/UB-Mannheim/ocr-fileformat)

[![CircleCI](https://circleci.com/gh/OCR-D/ocrd_fileformat.svg?style=svg)](https://circleci.com/gh/OCR-D/ocrd_fileformat)

## Installation

### Prerequisities

* GNU-Make
* Python && pip
* OpenJDK (required by submodule)
* optional: Docker CE for building container images 

Clone the repository:

```sh
git clone --recursive git@github.com:OCR-D/ocrd_fileformat.git
```

Step into local clone, build and install `ocr-fileformat` and the `ocrd_fileformat` wrapper:

```sh
cd ocrd_fileformat
make install-fileformat install
```

## Usage

After successful installation type `ocrd-fileformat --help` to get an idea which conversions can be achived.

With the OCR-D-CLI-Wrapper OCR-format conversions integrate fluently into existing OCR-D-Tool-Workflows.

Given a previous step `OCR`, which produces default PAGE-XML, a conversion from PAGE-XML into plain text can be achieved with:

```Makefile
CONVERT = OCR-TXT
$(CONVERT): $(OCR)
$(CONVERT): TOOL = ocrd-fileformat-transform
$(CONVERT): PARAMS = "from-to" : "page text"
```

Since the conversion from PAGE-XML to ALTO-XML (V4.1) is such a common requirement, it is the default value for the parameter `from-to`. Therefore, `PARAMS` can be omitted:

```Makefile
CONVERT = OCR-ALTO
$(CONVERT): $(OCR)
$(CONVERT): TOOL = ocrd-fileformat-transform
```
