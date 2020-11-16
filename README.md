# ocrd-fileformat

> OCR-D wrapper for [`ocr-fileformat`](https://github.com/UB-Mannheim/ocr-fileformat)

[![CircleCI](https://circleci.com/gh/OCR-D/ocrd_fileformat.svg?style=svg)](https://circleci.com/gh/OCR-D/ocrd_fileformat)

## Installation

### Prerequisities

* GNU-Make
* Python && pip
* OpenJDK (required by submodule)
* optional: Docker CE for building container images 

Clone the repository and it's submodule recursive:

```sh
git clone --recursive https://github.com/OCR-D/ocrd_fileformat.git
```

Step into local clone, build and install `ocr-fileformat` and the `ocrd_fileformat` wrapper:

```sh
cd ocrd_fileformat
make install-fileformat install
```

## Usage

After successful installation type `ocrd-fileformat --help` to get an idea
which conversions are supported already.

With the OCR-D-CLI-Wrapper OCR-format conversions integrate fluently into
existing OCR-D-Tool-Workflows.

Given a previous step `OCR`, which produces PAGE-XML, a conversion into plain
text and an output group `OCR-TXT` can be achieved with:

<details>
  <summary><code>ocrd-fileformat-transform -I OCR -O OCR-TXT -P from-to "page text"</code></summary>
  <h4>With <a href="https://github.com/bertsky/workflow-configuration">bertsky/workflow-configuration</a></h4>
  <pre>
CONVERT = OCR-TXT
$(CONVERT): $(OCR)
$(CONVERT): TOOL = ocrd-fileformat-transform
$(CONVERT): PARAMS = "from-to" : "page text"
</pre>
</details>

Since the conversion from PAGE-XML to ALTO-XML (V4.1) is such a common
requirement, it is the default value for the parameter `from-to`. Therefore,
`PARAMS` can be omitted completely:

<details>
  <summary><code>ocrd-fileformat-transform -I OCR -O OCR-ALTO</code></summary>
  <h4>With <a href="https://github.com/bertsky/workflow-configuration">bertsky/workflow-configuration</a></h4>
  <pre>
CONVERT = OCR-TXT
$(CONVERT): $(OCR)
$(CONVERT): TOOL = ocrd-fileformat-transform
</pre>
</details>
