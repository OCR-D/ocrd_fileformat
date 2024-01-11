Change Log
==========

Versioned according to [Semantic Versioning](http://semver.org/).

## Unreleased

## [0.10.0] - 2024-01-11

Changed:

  * Update [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat/commits/master):
    * Add CodeQL workflow for GitHub code scanning by @lgtm-com in UB-Mannheim/ocr-fileformat#155
    * gcv__page: use -source-json instead of -source-xml by @bertsky in UB-Mannheim/ocr-fileformat#156
    * make install: use newline in sed c cmd by @bertsky in UB-Mannheim/ocr-fileformat#158
    * Add textract2page by @bertsky in UB-Mannheim/ocr-fileformat#160
    * ensure venv for Python tools by @bertsky in UB-Mannheim/ocr-fileformat#162
    * add PRImA converter for GCV→ALTO by @bertsky in UB-Mannheim/ocr-fileformat#163
    * Update Makefile to support macOS by @stweil in UB-Mannheim/ocr-fileformat#165
    * update textract2page, hOCR-to-ALTO and alto-schema by @kba in UB-Mannheim/ocr-fileformat#166
    * Fix two issues reported by CodeQL CI by @stweil in UB-Mannheim/ocr-fileformat#161
    * Fix broken conversions from hOCR to ALTO by @stweil in UB-Mannheim/ocr-fileformat#167
    * Replace broken Travis CI by GitHub action by @stweil in UB-Mannheim/ocr-fileformat#168
    * Use first bash from PATH (allows running on macOS) by @stweil in UB-Mannheim/ocr-fileformat#169
    * Update page-to-alto to v1.3.0 by @kba in UB-Mannheim/ocr-fileformat#172

## [0.9.1] - 2023-10-20

Fixed:

  * require OCR-D/core >= 2.58.1, #49

## [0.9.0] - 2023-10-20

Added:

  * Support for `--mets-server-url`, #48

Fixed:

  * Use `local_filename` not `url`, #48, OCR-D/core#1079

## [0.8.0] - 2023-10-13

Changed:

  * Update [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat/commits/master):
    * Fix broken conversions from hOCR to ALTO
    * update textract2page, hOCR-to-ALTO and alto-schema
    * add PRImA converter for GCV→ALTO
    * add ALTO 4.2 → 2.1

## [0.7.0] - 2023-03-16

Changed:

  * Update [ocr-fileformat](https://github.com/UB-Mannheim/ocr-fileformat/commits/master):
    * Support for conversion from Amazon Textract
    * `weight/height` parameters for Google Cloud Vision converter

## [0.6.2] - 2023-03-16

Fixed:

  * `make deps` should not update `ocrd`, #43, #44

## [0.6.1] - 2022-11-10

Fixed:

  * re-use METS basename for output, #40, #41

## [0.6.0] - 2022-11-08

Changed:

  * PAGE-to-ALTO: Improved ordering of lines by index, kba/page-to-alto#29 kba/page-to-alto#32
  * Update ocr-fileformat to [v0.5.0](https://github.com/UB-Mannheim/ocr-fileformat/tree/v0.5.0), fixes page-to-alto, page-to-text rewrite, updates Saxon

## [0.5.0] - 2022-04-06

Fixed:

  * Allow all transforms currently supported by ocr-fileformat to `from-to`
  * Speed up main loop, and run (mildly) parallel

## [0.4.1] - 2022-03-30

Fixed:

  * Do not fail for unset variables like `COLORTERM`, #37, #38

## [0.4.0] - 2022-01-26

Changed:

  * Update ocr-fileformat to include UB-Mannheim/ocr-fileformat#142 (Pass arguments to page-to-alto)


## [0.3.0] - 2021-08-16

Changed:

  * Update ocr-fileformat to include UB-Mannheim/ocr-fileformat#134

## [0.2.1] - 2021-02-16

Changed:

  * update upstream ocr-fileformat to include UB-Mannheim/ocr-fileformat#132, #28

## [0.2.0] - 2021-02-02

Changed:

  * Update to current ocr-fileformat master, including UB-Mannheim/ocr-fileformat#131 and UB-Mannheim/ocr-fileformat#130
  * Handle output file not being written as an error, #25, #27

## [0.1.2] - 2020-12-18

Fixed:

  * Log transformation errors, #23

## [0.1.1] - 2020-10-22

Fixed:

  * Properly handle `--overwrite`, #16, #20

## [0.1.0] - 2020-09-22

Changed:

  * correct extension is derived from media type by default, #19

## [0.0.7] - 2020-09-21

Changed:

  * ocr-fileformat -> 0.4.0 with enhancements to PAGEConverter, #18

## [0.0.6] - 2020-09-08

Fixed:

  * Upgrade ocr-fileformat

## [0.0.5] - 2020-09-07

Fixed:

  * errors in transformation will be logged but no files are added, #10, #13

## [0.0.4] - 2020-07-15

Fixed:

  * Support --page-id CLI option, #9
  * Require ocrd >= 2.11.0
  * Logging with ocrd log not ocrd__log



## [0.0.3] - 2020-06-14

Fixed:

  * `$script_args` passed correctly now, #4
  * Require ocrd >= 2.10.2

## [0.0.2] - 2020-06-13

Fixed:

  * Require ocrd >= 2.10.1, logging, OCR-D/core#511

## [0.0.1] - 2020-06-03

Fixed:

  * Pass on `script-args` to ocr-transform, fix #4
  * Improved README, ht, #6
  * ocrd-tool: add `steps` and `categories`

<!-- link-labels -->
[0.10.0]: ../../compare/v0.10.0...v0.9.1
[0.9.1]: ../../compare/v0.9.1...v0.9.0
[0.9.0]: ../../compare/v0.9.0...v0.8.0
[0.8.0]: ../../compare/v0.8.0...v0.7.0
[0.7.0]: ../../compare/v0.7.0...v0.6.2
[0.6.2]: ../../compare/v0.6.2...v0.6.1
[0.6.1]: ../../compare/v0.6.1...v0.6.0
[0.6.0]: ../../compare/v0.6.0...v0.5.0
[0.5.0]: ../../compare/v0.5.0...v0.4.1
[0.4.1]: ../../compare/v0.4.1...v0.4.0
[0.4.0]: ../../compare/v0.4.0...v0.3.0
[0.3.0]: ../../compare/v0.3.0...v0.2.1
[0.2.1]: ../../compare/v0.2.1...v0.2.0
[0.2.0]: ../../compare/v0.2.0...v0.1.2
[0.1.1]: ../../compare/v0.1.1...v0.1.0
[0.1.0]: ../../compare/v0.1.0...v0.0.7
[0.0.7]: ../../compare/v0.0.7...v0.0.6
[0.0.6]: ../../compare/v0.0.6...v0.0.5
[0.0.5]: ../../compare/v0.0.5...v0.0.4
[0.0.4]: ../../compare/v0.0.4...v0.0.3
[0.0.3]: ../../compare/v0.0.3...v0.0.2
[0.0.2]: ../../compare/v0.0.2...v0.0.1
[0.0.1]: ../../compare/HEAD...v0.0.1
