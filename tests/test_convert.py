import os
from pytest import skip

from ocrd_fileformat.processor import FileformatTransform
from ocrd import run_processor
from ocrd_utils import MIMETYPE_PAGE

MIMETYPE_ALTO = '//text/xml|application/alto[+]xml'

def test_convert(processor_kwargs):
    ws = processor_kwargs['workspace']
    pages = processor_kwargs['page_id'].split(',')
    if ws.name == 'sbb':
        pages.remove('PHYS_0005') # not in all fileGrps
    page1 = pages[0]
    file1 = next(reversed(list(ws.find_files(page_id=page1, mimetype=MIMETYPE_PAGE))), None)
    if file1 is None:
        file1 = next(reversed(list(ws.find_files(page_id=page1, mimetype=MIMETYPE_ALTO))), None)
        if file1 is None:
            skip(f"workspace asset {ws.name} has neither PAGE nor ALTO files")
    input_file_grp = file1.fileGrp
    if file1.mimetype == MIMETYPE_PAGE:
        from_to1 = 'page alto'
        from_to2 = 'alto2.1 hocr'
        mimetype1 = 'application/alto+xml'
        mimetype2 = 'text/vnd.hocr+html'
    else:
        from_to1 = 'alto page'
        from_to2 = 'page hocr'
        mimetype1 = MIMETYPE_PAGE
        mimetype2 = 'text/vnd.hocr+html'
    run_processor(FileformatTransform,
                  input_file_grp=input_file_grp,
                  output_file_grp='OUT1',
                  parameter={'from-to': from_to1},
                  **processor_kwargs
    )
    assert os.path.isdir(os.path.join(ws.directory, 'OUT1'))
    results = list(ws.find_files(file_grp='OUT1'))
    assert len(results), "found no output files"
    assert len(results) == len(pages)
    assert results[0].mimetype == mimetype1
    run_processor(FileformatTransform,
                  input_file_grp='OUT1',
                  output_file_grp='OUT2',
                  parameter={'from-to': from_to2},
                  **processor_kwargs,
    )
    ws.save_mets()
    assert os.path.isdir(os.path.join(ws.directory, 'OUT2'))
    results = list(ws.find_files(file_grp='OUT2'))
    assert len(results), "found no output files"
    assert len(results) == len(pages)
    assert results[0].mimetype == mimetype2

