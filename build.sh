#!/bin/bash

COMMIT=$(git log --oneline -1)
BUILD_DATE=$(date '+%Y-%m-%d %H:%M:%S')

record_build_info() {
    local build_dir=$1
    echo "Built: $BUILD_DATE" >> "./BUILD_INFO-$build_dir"
    echo "Commit: $COMMIT" >> "./BUILD_INFO-$build_dir"
    echo "---"
    cat "./BUILD_INFO-$build_dir"
}

if [[ $1 == "SYCL" ]]; then
    echo "Building for Intel..."
    source /opt/intel/oneapi/setvars.sh
    rm -r ./build-sycl
    mkdir build-sycl
    cmake -B build-sycl -DGGML_RPC=ON -DGGML_SYCL=ON -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_SYCL_F16=ON
    cmake --build build-sycl --config Release -j 8
    record_build_info build-sycl
fi

if [[ $1 == "OPENVINO" ]]; then
    source /opt/intel/openvino/setupvars.sh
    rm -r ./build-openvino
    mkdir build-openvino
    cmake -B build-openvino -G Ninja -DCMAKE_BUILD_TYPE=Release -DGGML_OPENVINO=ON
    cmake --build build-openvino --parallel
    record_build_info build-openvino
fi

if [[ $1 == "VULKAN" ]]; then
    echo "Building for Vulkan..."
    rm -r ./build-vulkan
    mkdir build-vulkan
    cmake -B build-vulkan -DGGML_VULKAN=1 && \
        cmake --build build-vulkan --config Release -j 8
    record_build_info build-vulkan
fi
