#!/usr/bin/env python
from distutils.core import setup
from Cython.Build import cythonize
import os
import re


files = [{% for file in code.requestedFiles %}"{{file.filename}}",{% endfor %}]

for f in files:
  cpp_file = f + '.cpp'
  if not os.path.exists(cpp_file):
    if not os.path.exists(f + '.c++'):
      raise RuntimeError("You need to run `capnp compile -oc++` in addition to `-ocython` first.")
    os.rename(f + '.c++', cpp_file)

    with open(f + '.h', "r") as file:
        lines = file.readlines()
    with open(f + '.h', "w") as file:
        for line in lines:
            file.write(re.sub(r'Builder\(\)\s*=\s*delete;', 'Builder() = default;', line))

setup(
    name="{{code.requestedFiles[0] | replace('.', '_')}}",
    ext_modules=cythonize('*_capnp_cython.pyx', language="c++")
)
