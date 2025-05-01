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
Usage: ocrd-fileformat-transform [worker|server] [OPTIONS]

  Convert between OCR file formats

  > Transform pages with ocr-fileformat

  > For each page, download input file, pass it to ``ocr-transform``
  > with `from-to` format specifier and optionally `script-args` for
  > conversion. Then add the resulting file to the output file group.

  > Handle output MIME type and file name suffix according to target
  > format.

Subcommands:
    worker      Start a processing worker rather than do local processing
    server      Start a processor server rather than do local processing

Options for processing:
  -m, --mets URL-PATH             URL or file path of METS to process [./mets.xml]
  -w, --working-dir PATH          Working directory of local workspace [dirname(URL-PATH)]
  -I, --input-file-grp USE        File group(s) used as input
  -O, --output-file-grp USE       File group(s) used as output
  -g, --page-id ID                Physical page ID(s) to process instead of full document []
  --overwrite                     Remove existing output pages/images
                                  (with "--page-id", remove only those).
                                  Short-hand for OCRD_EXISTING_OUTPUT=OVERWRITE
  --debug                         Abort on any errors with full stack trace.
                                  Short-hand for OCRD_MISSING_OUTPUT=ABORT
  --profile                       Enable profiling
  --profile-file PROF-PATH        Write cProfile stats to PROF-PATH. Implies "--profile"
  -p, --parameter JSON-PATH       Parameters, either verbatim JSON string
                                  or JSON file path
  -P, --param-override KEY VAL    Override a single JSON object key-value pair,
                                  taking precedence over --parameter
  -U, --mets-server-url URL       URL of a METS Server for parallel incremental access to METS
                                  If URL starts with http:// start an HTTP server there,
                                  otherwise URL is a path to an on-demand-created unix socket
  -l, --log-level [OFF|ERROR|WARN|INFO|DEBUG|TRACE]
                                  Override log level globally [INFO]
  --log-filename LOG-PATH         File to redirect stderr logging to (overriding ocrd_logging.conf).

Options for information:
  -C, --show-resource RESNAME     Dump the content of processor resource RESNAME
  -L, --list-resources            List names of processor resources
  -J, --dump-json                 Dump tool description as JSON
  -D, --dump-module-dir           Show the 'module' resource location path for this processor
  -h, --help                      Show this message
  -V, --version                   Show version

Parameters:
   "from-to" [string - "page alto"]
    Transformation scenario, see ocr-fileformat -L
    Possible values: ["abbyy hocr", "abbyy page", "alto2.0 alto3.0",
    "alto2.0 alto3.1", "alto2.0 hocr", "alto2.1 alto3.0", "alto2.1
    alto3.1", "alto2.1 hocr", "alto page", "alto text", "gcv hocr", "gcv
    page", "hocr alto2.0", "hocr alto2.1", "hocr page", "hocr text",
    "page alto", "page alto_legacy", "page hocr", "page page2019", "page
    text", "tei hocr", "textract page"]
   "ext" [string - ""]
    Output extension. Set to empty string to derive extension from the
    media type.
   "script-args" [string - ""]
    Arguments to Saxon (for XSLT transformations) or to transformation
    script


</pre>
</details>

With this [OCR-D](https://ocr-d.de/en/spec/intro) [CLI](https://ocr-d.de/en/spec/cli) wrapper,
the `ocr-fileformat` converter integrates fluently into OCR-D tool [workflows](https://ocr-d.de/en/workflows).

For example, given a previous step which produced PAGE-XML under the file group `OCR`,
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

