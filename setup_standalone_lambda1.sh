# This is from Zhihua's instruction, see https://github.com/zhihuadong/wire-cell-gen-sycl/tree/wc20
# I am doing that in /work/twang/wire-cell-gen-porting 

##################################### Step 1 ###########################################
git clone -c feature.manyFiles=true https://github.com/spack/spack.git
. spack/share/spack/setup-env.sh
which spack
git clone https://github.com/WireCell/wire-cell-spack.git wct-spack
spack repo add wct-spack
#use your own os, here we use ubuntu20.04 as example
#by default spack will detect your OS and CPU 
#But to avoid a issue of inconsistant arch from different compilers we choose x86_64   
spack install wire-cell-toolkit@0.20.0 arch=linux-ubuntu20.04-x86_64
#spack install wire-cell-toolkit@0.20.0 arch=linux-ubuntu20.04-x86_64 ^boost@1.73.0 ^spdlog@1.8.2
#spack install wire-cell-toolkit arch=linux-ubuntu20.04-x86_64
#spack install wire-cell-toolkit@0.20.0%nvhpc@23.1 arch=linux-ubuntu20.04-x86_64 cppflags="-noswitcherror"

module use /work/software/modulefiles
module load oneapi-for-cuda

##################################### Step 2 ###########################################
git clone https://github.com/zhihuadong/wire-cell-gen-sycl.git
cd wire-cell-gen-sycl; git checkout wc20; cd ..

export WC_BUILD_DIR=/work/twang/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-15-dev/CPU

export WC_SYCL_SRC_DIR=${PWD}/wire-cell-gen-sycl
#dependency code RNG wrapper.
git clone https://github.com/DEShawResearch/random123.git
git clone https://github.com/zhihua/test-benchmark-OpenMP-RNG.git omprng
cd omprng; git checkout chrono; cd ..
export RANDOM123_INC=${PWD}/random123/include
export OMPRNG=${PWD}/omprng

##################################### Step 3 ###########################################
spack load wire-cell-toolkit@0.20.0
export WIRECELL_DIR=$(spack find -p wire-cell-toolkit@0.20.0 |grep wire |awk '{print $2}')
export WIRECELL_INC=${WIRECELL_DIR}/include
export WIRECELL_LIB=${WIRECELL_DIR}/lib
##dependes of OS , above could be
#export WIRECELL_LIB=${WIRECELL_DIR}/lib64

export JSONNET_DIR=$(spack find -p go-jsonnet |grep go-jsonnet|awk '{print $2}')
export JSONNET_INC=${JSONNET_DIR}/include

source /work/software/intel/oneapi-2023.0.0/setvars.sh --include-intel-llvm

##################################### Step 4 ###########################################
# For CPU
cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=icpx $WC_SYCL_SRC_DIR/.cmake-sycl-dpcpp
make -C ${WC_BUILD_DIR} -j 10
# For NVIDIA GPU
cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=$(which clang++) $WC_SYCL_SRC_DIR/.cmake-sycl
make -C ${WC_BUILD_DIR} -j 10


#export WIRECELL_PATH=$WCT_SRC/cfg #  main CFG
export WIRECELL_PATH=/work/twang/wire-cell-gen-porting/wire-cell-toolkit/cfg #  main CFG
#export WIRECELL_PATH=$WIRECELL_DATA_PATH:$WIRECELL_PATH # data
export WIRECELL_PATH=/work/twang/wire-cell-gen-porting/wire-cell-data:$WIRECELL_PATH # data
export WIRECELL_PATH=$WC_OMP_SRC_DIR/cfg:$WIRECELL_PATH # gen-sycl
export LD_LIBRARY_PATH=${WC_BUILD_DIR}:$LD_LIBRARY_PATH

wire-cell -l stdout -L debug -V input="depos.tar.bz2" -V output="frames.tar.bz2" -c wire-cell-gen-omp/example/wct-sim.jsonnet
