#!/bin/bash

EXTERNAL_DATA_LOCATION=~/cvpr2011/pipeline/singleblock/

# Be careful... no trailing spaces!!
EXTERNAL_DATA="alignment_runtime_graph_reference_cpu.dat
alignment_runtime_graph_reference_gpu.dat"

echo "${EXTERNAL_DATA}" | parallel cp -u ${EXTERNAL_DATA_LOCATION}{} ./{}
