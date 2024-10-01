from os import chdir, getcwd
from json import dumps

from pytest import fixture, main
from tests.assets import assets

from ocrd import Resolver
from ocrd.processor.helpers import run_cli

@fixture
def resolver():
    return Resolver()

@fixture
def sample_workspace(resolver):
    workspace = resolver.workspace_from_url(assets.path_to('kant_aufklaerung_1784/data/mets.xml'))
    oldpwd = getcwd()
    chdir(workspace.directory)
    yield workspace
    chdir(oldpwd)

# TODO any assertions about the transformation
def test_page_to_alto(resolver, sample_workspace):
    code = run_cli(
        'ocrd-fileformat-transform',
        resolver=resolver,
        overwrite=True,
        input_file_grp='OCR-D-GT-PAGE',
        output_file_grp='OUT',
        mets_url='mets.xml',
        parameter=dumps({'from-to': 'page alto'})
    )
    assert not code

if __name__ == '__main__':
    main([__file__])
