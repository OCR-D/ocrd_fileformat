from __future__ import absolute_import

from typing import Optional, get_args
import os
import re
import subprocess
import click

from ocrd import Processor
from ocrd_models.ocrd_file import OcrdFileType
from ocrd_utils import MIMETYPE_PAGE, config, make_file_id
from ocrd.decorators import ocrd_cli_options, ocrd_cli_wrap_processor

class FileformatTransform(Processor):

    @property
    def executable(self):
        return 'ocrd-fileformat-transform'

    def process_page_file(self, *input_files : Optional[OcrdFileType]) -> None:
        """
        Transform pages with ocr-fileformat

        For each page, download input file, pass it to
        ``ocr-transform`` with `from-to` format specifier
        and optionally `script-args` for conversion. Then
        add the resulting file to the output file group.

        Handle output MIME type and file name suffix
        according to target format.
        """
        # from core's ocrd.processor.base
        input_file = input_files[0]
        assert isinstance(input_file, get_args(OcrdFileType))
        page_id = input_file.pageId
        self._base_logger.info("processing page %s", page_id)
        if input_file.mimetype.startswith('image/'):
            self._base_logger.warning("ignoring %s file '%s'", input_file.mimetype, input_file.ID)
            return
        output_file_id = make_file_id(input_file, self.output_file_grp)
        output_file = next(self.workspace.mets.find_files(ID=output_file_id), None)
        if output_file and config.OCRD_EXISTING_OUTPUT != 'OVERWRITE':
            # short-cut avoiding useless computation:
            raise FileExistsError(
                f"A file with ID=={output_file_id} already exists {output_file} and neither force nor ignore are set"
            )
        output_file_ext = '.xml'
        if self.parameter['from-to'].endswith(' hocr'):
            output_mimetype = 'text/vnd.hocr+html'
            output_file_ext = '.html'
        elif self.parameter['from-to'].endswith(' text'):
            output_mimetype = 'text/plain'
            output_file_ext = '.txt'
        elif re.search(' page', self.parameter['from-to']):
            output_mimetype = MIMETYPE_PAGE
        elif re.search(' alto', self.parameter['from-to']):
            output_mimetype = 'application/alto+xml'
        output_file_ext = self.parameter['ext'] or output_file_ext
        output_filename = os.path.join(self.output_file_grp, output_file_id + output_file_ext)
        args = ['ocr-transform']
        args.extend(self.parameter['from-to'].split(' '))
        args.append(input_file.local_filename)
        args.append(output_filename)
        if self.parameter['script-args']:
            args.append('--')
            args.extend(self.parameter['script-args'].split(' '))
        self.logger.debug("Executing: %s", str(args))
        os.makedirs(self.output_file_grp, exist_ok=True)
        result = subprocess.run(args, shell=False, text=True, capture_output=True, encoding='utf-8')
        if result.stdout:
                self.logger.debug("ocr-transform for %s stdout: %s", page_id, result.stdout)
        if result.stderr:
            self.logger.info("ocr-transform for %s stderr: %s", page_id, result.stderr)
        if result.returncode != 0:
            self.logger.error("Command for %s failed: ", page_id)
            raise Exception(result)
        self.workspace.add_file(
            file_id=output_file_id,
            file_grp=self.output_file_grp,
            page_id=page_id,
            local_filename=output_filename,
            mimetype=output_mimetype,
        )

@click.command()
@ocrd_cli_options
def cli(*args, **kwargs):
    return ocrd_cli_wrap_processor(FileformatTransform, *args, **kwargs)
