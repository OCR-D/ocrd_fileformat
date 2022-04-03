# ocrd-fileformat

> OCR-D wrapper for [`ocr-fileformat`](https://github.com/UB-Mannheim/ocr-fileformat)

[![CircleCI](https://circleci.com/gh/OCR-D/ocrd_fileformat.svg?style=svg)](https://circleci.com/gh/OCR-D/ocrd_fileformat)


## Prerequisities

* GNU make
* Python && pip
* OpenJDK (required by submodule)
* optional: Docker CE for building container images 

## Installation

Clone the repository and it's submodule recursive:

    git clone --recursive https://github.com/OCR-D/ocrd_fileformat.git

Step into local clone, build and install `ocr-fileformat` and the `ocrd_fileformat` [OCR-D](https://ocr-d.de) wrapper:

    make -C ocrd_fileformat install

Alternatively, for the Docker option, just get:

    docker pull ocrd/fileformat


## Usage

After successful installation type `ocrd-fileformat-transform --help` to get an idea
which conversions are supported already:

<details>
  <summary><code>ocrd-fileformat-transform -h</code></summary>
  <pre>
Usage: ocrd-fileformat-transform [OPTIONS]

  Convert between OCR file formats

  &gt; Processor base class and helper functions. A processor is a tool
  &gt; that implements the uniform OCR-D command-line interface for run-
  &gt; time data processing. That is, it executes a single workflow step,
  &gt; or a combination of workflow steps, on the workspace (represented by
  &gt; local METS). It reads input files for all or requested physical
  &gt; pages of the input fileGrp(s), and writes output files for them into
  &gt; the output fileGrp(s). It may take  a number of optional or
  &gt; mandatory parameters. Process the :py:attr:`workspace`  from the
  &gt; given :py:attr:`input_file_grp` to the given
  &gt; :py:attr:`output_file_grp` for the given :py:attr:`page_id` under
  &gt; the given :py:attr:`parameter`.

  &gt; (This contains the main functionality and needs to be overridden by
  &gt; subclasses.)

Options:
  -I, --input-file-grp USE        File group(s) used as input
  -O, --output-file-grp USE       File group(s) used as output
  -g, --page-id ID                Physical page ID(s) to process
  --overwrite                     Remove existing output pages/images
                                  (with --page-id, remove only those)
  -p, --parameter JSON-PATH       Parameters, either verbatim JSON string
                                  or JSON file path
  -P, --param-override KEY VAL    Override a single JSON object key-value pair,
                                  taking precedence over --parameter
  -s, --server HOST PORT WORKERS  Run web server instead of one-shot processing
                                  (shifts mets/working-dir/page-id options to
                                   HTTP request arguments); pass network interface
                                  to bind to, TCP port, number of worker processes
  -m, --mets URL-PATH             URL or file path of METS to process
  -w, --working-dir PATH          Working directory of local workspace
  -l, --log-level [OFF|ERROR|WARN|INFO|DEBUG|TRACE]
                                  Log level
  -C, --show-resource RESNAME     Dump the content of processor resource RESNAME
  -L, --list-resources            List names of processor resources
  -J, --dump-json                 Dump tool description as JSON and exit
  -h, --help                      This help message
  -V, --version                   Show version

Parameters:
   "from-to" [string - "page alto"]
    Transformation scenario, see ocr-fileformat -L
    Possible values: ["abbyy hocr", "abbyy page", "alto2.0 alto3.0",
    "alto2.0 alto3.1", "alto2.0 hocr", "alto2.1 alto3.0", "alto2.1
    alto3.1", "alto2.1 hocr", "alto page", "alto text", "gcv hocr", "gcv
    page", "hocr alto2.0", "hocr alto2.1", "hocr page", "hocr text",
    "page alto", "page hocr", "page page2019", "page text", "tei hocr"]
   "ext" [string - ""]
    Output extension. Set to empty string to derive extension from the
    media type.
   "script-args" [string - ""]
    Arguments to Saxon (for XSLT transformations) or to transformation
    script
</pre>
</details>

With the [OCR-D](https://ocr-d.de/en/spec/intro) [CLI](https://ocr-d.de/en/spec/cli) wrapper
the `ocr-fileformat` converter integrates fluently into existing OCR-D tool [workflows](https://ocr-d.de/en/workflows).

Given a previous step which produces PAGE-XML under the file group `OCR`,
a conversion into plain text under the file group `OCR-TXT` can be achieved with:

<details>
  <summary><code>ocrd-fileformat-transform -I OCR -O OCR-TXT -P from-to "page text"</code></summary>
  <h4>With <a href="https://github.com/bertsky/workflow-configuration">bertsky/workflow-configuration</a></h4>
  <pre>
OCR-TXT: OCR
OCR-TXT: TOOL = ocrd-fileformat-transform
OCR-TXT: PARAMS = "from-to": "page text"
</pre>
</details>

Since the conversion from PAGE-XML to ALTO-XML (V4.1) is such a common
requirement, it is the default value for the parameter `from-to`. Therefore,
parameters can be omitted completely:

<details>
  <summary><code>ocrd-fileformat-transform -I OCR -O OCR-ALTO</code></summary>
  <h4>With <a href="https://github.com/bertsky/workflow-configuration">bertsky/workflow-configuration</a></h4>
  <pre>
OCR-ALTO: OCR
OCR-ALTO: TOOL = ocrd-fileformat-transform
</pre>
</details>

However, typically the ALTO converter itself will require additional parameters
to be able to cope with the kind of annotations present. For example, if you have
no cropping in the workflow, and OCR text is only annotated on the line level,
then you will need to add:

<details>
  <summary><code>ocrd-fileformat-transform -I OCR -O OCR-ALTO -P script-args "--no-check-border --no-check-words --dummy-word"</code></summary>
  <h4>With <a href="https://github.com/bertsky/workflow-configuration">bertsky/workflow-configuration</a></h4>
  <pre>
OCR-ALTO: OCR
OCR-ALTO: TOOL = ocrd-fileformat-transform
OCR-ALTO: PARAMS = "script-args": "--no-check-border --no-check-words --dummy-word"
</pre>
</details>

To run the program via Docker, just spin up a container analogously:

    docker run --rm -v $PWD:/data ocrd/fileformat ocrd-fileformat-transform -I OCR -O OCR-ALTO

