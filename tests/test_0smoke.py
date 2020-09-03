from pytest import main

from os import environ as ENV
from subprocess import run, PIPE

def test_smoke():
    result = run(['which', 'ocrd-fileformat-transform'], stdout=PIPE, stderr=PIPE, check=True)
    result = run(['ocrd-fileformat-transform', '--help'], stdout=PIPE, stderr=PIPE, check=False)
    print(result.stderr)
    assert result.returncode == 0

if __name__ == '__main__':
    main([__file__])
