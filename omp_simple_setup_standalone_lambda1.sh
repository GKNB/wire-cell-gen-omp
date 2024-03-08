. spack/share/spack/setup-env.sh
which spack

#module use /work/software/modulefiles
#module load llvm-openmp-dev
#module load llvm-13.0.1
#module load llvm-openmp-16
#module load llvm-sycl-20220425
#module load llvm-sycl-dev

module use /work/twang/modulefiles
module load openmp-llvm-clang-17

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/work/software/src/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/hwloc-2.6.0-vkkajirlhcoyh67h7uslng2obsws33p4/lib


#For CPU
#export WC_BUILD_DIR=/work/twang/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-15-dev/CPU

#For GPU
#export WC_BUILD_DIR=/work/twang/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-15-dev/NVIDIA-GPU
#export WC_BUILD_DIR=/work/twang/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-13/NVIDIA-GPU
export WC_BUILD_DIR=/work/twang/wire-cell-gen-porting/build-wcg-standalone/openmp/clang-17-lambda1/NVIDIA-GPU

rm -r $WC_BUILD_DIR

export WC_OMP_SRC_DIR=${PWD}/wire-cell-gen-omp
export RANDOM123=${PWD}/random123/include
export OMPRNG=${PWD}/omprng

#This is boost/1.73
#spack load wire-cell-toolkit@0.20.0/chcuefg    
#This is boost/1.82, lambda1
spack load wire-cell-toolkit@0.20.0/vryvl6a


#This is boost/1.73
#export WIRECELL_DIR=$(spack find -p wire-cell-toolkit@0.20.0/chcuefg |grep wire |awk '{print $2}')
#This is boost/1.82, lambda1
export WIRECELL_DIR=$(spack find -p wire-cell-toolkit@0.20.0/vryvl6a |grep wire |awk '{print $2}')

export WIRECELL_INC=${WIRECELL_DIR}/include
export WIRECELL_LIB=${WIRECELL_DIR}/lib

export JSONNET_DIR=$(spack find -p go-jsonnet@0.19.1/gyxj72r6yx7j4lripuad3riwszudza4o |grep go-jsonnet|awk '{print $2}')
export JSONNET_INC=${JSONNET_DIR}/include

################### CPU ################
#cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=clang++ $WC_OMP_SRC_DIR/.cmake-omp-cpu
#make -C ${WC_BUILD_DIR} -j 10

################### NVIDIA GPU ################
cmake -B ${WC_BUILD_DIR} -DCMAKE_CXX_COMPILER=clang++ $WC_OMP_SRC_DIR/.cmake-omp-cuda
make -C ${WC_BUILD_DIR} -j 10

export WIRECELL_PATH=/work/twang/wire-cell-gen-porting/wire-cell-toolkit/cfg #  main CFG
export WIRECELL_PATH=/work/twang/wire-cell-gen-porting/wire-cell-data:$WIRECELL_PATH # data
export WIRECELL_PATH=$WC_OMP_SRC_DIR/cfg:$WIRECELL_PATH # gen-omp
export LD_LIBRARY_PATH=${WC_BUILD_DIR}:$LD_LIBRARY_PATH

echo "Running command for wcg is " 
echo 'wire-cell -l stdout -L debug -V input="depos.tar.bz2" -V output="frames.tar.bz2" -c wire-cell-gen-omp/example/wct-sim.jsonnet'




#If see the following error:
#/work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/stacktrace/safe_dump_to.hpp:64:5: error: use of undeclared identifier 'noinline'; did you mean 'inline'?
#   64 |     BOOST_NOINLINE static std::size_t safe_dump_to_impl(T file, std::size_t skip, std::size_t max_depth) BOOST_NOEXCEPT {
#      |     ^
#/work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/config/detail/suffix.hpp:655:46: note: expanded from macro 'BOOST_NOINLINE'
#  655 | #      define BOOST_NOINLINE __attribute__ ((__noinline__))
#      |                                              ^
#/usr/include/crt/host_defines.h:83:24: note: expanded from macro '__noinline__'
#   83 |         __attribute__((noinline))
#      |                        ^
#In file included from /work/twang/wire-cell-gen-porting/wire-cell-gen-omp/src/DepoTransform.cxx:42:
#In file included from /work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/wire-cell-toolkit-0.20.0-vryvl6acbkivxxq2mrwbtg3tpyw3mozw/include/WireCellUtil/NamedFactory.h:10:
#In file included from /work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/wire-cell-toolkit-0.20.0-vryvl6acbkivxxq2mrwbtg3tpyw3mozw/include/WireCellUtil/Exceptions.h:22:
#In file included from /work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/stacktrace.hpp:15:
#In file included from /work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/stacktrace/frame.hpp:20:
#/work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/stacktrace/safe_dump_to.hpp:64:5: error: type name does not allow function specifier to be specified
#/work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/config/detail/suffix.hpp:655:46: note: expanded from macro 'BOOST_NOINLINE'
#  655 | #      define BOOST_NOINLINE __attribute__ ((__noinline__))
#      |                                              ^
#/usr/include/crt/host_defines.h:83:24: note: expanded from macro '__noinline__'
#   83 |         __attribute__((noinline))
#This is a conflict between noinline defined in boost and that defined in CUDA, don't why but it is not fixed in clang+omp offloading. What I currently did is to hack into the source code of boost, and did the following modification:
#In /work/twang/wire-cell-gen-porting/spack/opt/spack/linux-ubuntu20.04-x86_64/gcc-9.3.0/boost-1.82.0-v4il3dbvlmvibpjhktdk5bky2wqedos7/include/boost/config/detail/suffix.hpp:
#Line 655: change __noinline__ into noinline
