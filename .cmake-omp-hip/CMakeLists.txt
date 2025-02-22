cmake_minimum_required(VERSION 3.14 FATAL_ERROR)
project(wire-cell-gen-openmp CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS Off)

#include_directories(SYSTEM $ENV{BOOST_INC})

set(BOOST_ROOT $ENV{BOOST_DIR})
#set(BOOST_INCLUDEDIR $ENV{BOOST_INC})
#set(BOOST_LIBRARYDIR $ENV{BOOST_LIB})
set(Boost_USE_MULTITHREADED ON)

find_package(Boost REQUIRED COMPONENTS)

file(GLOB all_files ${PROJECT_SOURCE_DIR}/../src/*.cxx)



string(APPEND CMAKE_CXX_FLAGS "-g -O3 -pedantic -Wall -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx906 -DOPENMP_ENABLE_HIP -DARCH_HIP -D__HIP_PLATFORM_AMD__")
string(APPEND CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined")

add_library(WireCellGenOpenMP SHARED ${all_files})

list(APPEND CMAKE_PREFIX_PATH /opt/rocm )
find_package(rocrand)
find_package(hipfft)

target_include_directories(WireCellGenOpenMP
  PRIVATE
    ${PROJECT_SOURCE_DIR}/../inc
    $ENV{OMPRNG}
    $ENV{HIP_DIR}/include
    $ENV{HIPFFT_INC}
    $ENV{EIGEN_INC}
    $ENV{JSONCPP_INC}
    $ENV{JSONNET_INC}
    $ENV{SPDLOG_INC}
    $ENV{WIRECELL_INC}
)
set_target_properties(WireCellGenOpenMP
	PROPERTIES COMPILE_OPTIONS "-DEIGEN_NO_CUDA;-DEIGEN_DONT_VECTORIZE")

target_link_directories(WireCellGenOpenMP PRIVATE  $ENV{JSONCPP_LIB} $ENV{WIRECELL_LIB} $ENV{HIP_DIR}/lib)
target_link_libraries(WireCellGenOpenMP PRIVATE  jsoncpp WireCellIface WireCellUtil Boost::headers roc::rocrand hip::hipfft)

#add_subdirectory(test)
