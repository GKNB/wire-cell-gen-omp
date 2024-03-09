module load PrgEnv-llvm
clang --version

. spack/share/spack/setup-env.sh
which spack

#For CPU
#export WC_BUILD_DIR=/global/homes/t/tianle/myWork/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-17/CPU
#For GPU
export WC_BUILD_DIR=/global/homes/t/tianle/myWork/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-17/GPU

rm -r $WC_BUILD_DIR

export WC_OMP_SRC_DIR=${PWD}/wire-cell-gen-omp
export RANDOM123=${PWD}/random123/include
export OMPRNG=${PWD}/omprng

spack load wire-cell-toolkit@0.20.0
export WIRECELL_DIR=$(spack find -p wire-cell-toolkit@0.20.0 |grep wire |awk '{print $2}')
export WIRECELL_INC=${WIRECELL_DIR}/include
export WIRECELL_LIB=${WIRECELL_DIR}/lib64

export JSONNET_DIR=$(spack find -p go-jsonnet |grep go-jsonnet|awk '{print $2}')
export JSONNET_INC=${JSONNET_DIR}/include

#For CPU
#cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=clang++ $WC_OMP_SRC_DIR/.cmake-omp-cpu
#For GPU
cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=clang++ $WC_OMP_SRC_DIR/.cmake-omp-cuda

make -C ${WC_BUILD_DIR} -j 10

export WIRECELL_PATH=/global/homes/t/tianle/myWork/wire-cell-gen-porting/wire-cell-toolkit/cfg  #  main CFG
export WIRECELL_PATH=/global/homes/t/tianle/myWork/wire-cell-gen-porting/wire-cell-data/:$WIRECELL_PATH   # data
export WIRECELL_PATH=$WC_OMP_SRC_DIR/cfg:$WIRECELL_PATH
export LD_LIBRARY_PATH=${WC_BUILD_DIR}:$LD_LIBRARY_PATH

echo "Running command for wcg is " 
echo 'wire-cell -l stdout -L debug -V input="depos.tar.bz2" -V output="frames.tar.bz2" -c wire-cell-gen-omp/example/wct-sim.jsonnet'
