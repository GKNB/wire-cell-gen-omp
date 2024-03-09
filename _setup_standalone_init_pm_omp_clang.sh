module load PrgEnv-llvm
clang --version

git clone -c feature.manyFiles=true https://github.com/spack/spack.git
. spack/share/spack/setup-env.sh
which spack
git clone https://github.com/WireCell/wire-cell-spack.git wct-spack
cd wct-spack
git checkout f1a95969c14b7aac737464e8f1888a1ba39fd07b
git switch -c omp
cd ..
spack repo rm wct-spack
spack repo add wct-spack

spack compiler find
spack install wire-cell-toolkit@0.20.0

https://github.com/GKNB/wire-cell-gen-omp.git
cd wire-cell-gen-omp; git checkout -b standalone origin/standalone; cd ..

#For CPU
export WC_BUILD_DIR=/global/homes/t/tianle/myWork/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-17/CPU
#For GPU
#export WC_BUILD_DIR=/global/homes/t/tianle/myWork/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-17/GPU
rm -r $WC_BUILD_DIR

export WC_OMP_SRC_DIR=${PWD}/wire-cell-gen-omp

git clone https://github.com/DEShawResearch/random123.git
export RANDOM123=${PWD}/random123/include

git clone https://github.com/GKNB/test-benchmark-OpenMP-RNG.git omprng
cd omprng; git checkout -b chrono origin/chrono; cd ..
export OMPRNG=${PWD}/omprng

git clone https://github.com/WireCell/wire-cell-toolkit.git
cd wire-cell-toolkit; git checkout c7c832ab95907a30d2b482c7c1d0d2e98f75114a; cd ..

git clone https://github.com/WireCell/wire-cell-data.git
cd wire-cell-data; git checkout f7c7e98b3335fe657c610796198c389d72a1fc24; cd .. 

spack load wire-cell-toolkit@0.20.0
export WIRECELL_DIR=$(spack find -p wire-cell-toolkit@0.20.0 |grep wire |awk '{print $2}')
export WIRECELL_INC=${WIRECELL_DIR}/include
export WIRECELL_LIB=${WIRECELL_DIR}/lib64

export JSONNET_DIR=$(spack find -p go-jsonnet |grep go-jsonnet|awk '{print $2}')
export JSONNET_INC=${JSONNET_DIR}/include

#For CPU
cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=clang++ $WC_OMP_SRC_DIR/.cmake-omp-cpu
#For GPU
#cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=clang++ $WC_OMP_SRC_DIR/.cmake-omp-cuda

make -C ${WC_BUILD_DIR} -j 10

export WIRECELL_PATH=/global/homes/t/tianle/myWork/wire-cell-gen-porting/wire-cell-toolkit/cfg  #  main CFG
export WIRECELL_PATH=/global/homes/t/tianle/myWork/wire-cell-gen-porting/wire-cell-data/:$WIRECELL_PATH   # data
export WIRECELL_PATH=$WC_OMP_SRC_DIR/cfg:$WIRECELL_PATH
export LD_LIBRARY_PATH=${WC_BUILD_DIR}:$LD_LIBRARY_PATH

ln -s wire-cell-gen-omp/example/depos.tar.bz2 depos.tar.bz2

