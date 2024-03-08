cmake_minimum_required(VERSION 3.14 FATAL_ERROR)
project(wire-cell-gen-openmp CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS Off)


file(GLOB all_files ${PROJECT_SOURCE_DIR}/../src/*.cxx)


find_package(Boost REQUIRED COMPONENTS)
set(Boost_USE_MULTITHREADED ON)

find_package(spdlog REQUIRED )
find_package (Eigen3  REQUIRED NO_MODULE)

find_package(PkgConfig REQUIRED)
pkg_search_module(FFTW REQUIRED fftw3f IMPORTED_TARGET)

find_package(jsoncpp REQUIRED)
get_target_property(JSON_INC_PATH jsoncpp_lib INTERFACE_INCLUDE_DIRECTORIES)

find_package(CUDA REQUIRED)
find_package(CUDAToolkit REQUIRED)

string(APPEND CMAKE_CXX_FLAGS "-g -O3 -pedantic -Wall -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda -DOPENMP_ENABLE_CUDA -DARCH_CUDA")
string(APPEND CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined -ldl")

add_library(WireCellGenOpenMP SHARED ${all_files})

target_include_directories(WireCellGenOpenMP
  PRIVATE
    ${PROJECT_SOURCE_DIR}/../inc
    $ENV{OMPRNG}
    ${JSON_INC_PATH}
#    $ENV{EIGEN_INC}
#    $ENV{JSONCPP_INC}
    $ENV{JSONNET_INC}
#    $ENV{SPDLOG_INC}
    $ENV{WIRECELL_INC}
)

#set_target_properties(WireCellGenOpenMP
#	PROPERTIES COMPILE_OPTIONS "-DEIGEN_NO_CUDA;-DEIGEN_DONT_VECTORIZE")

target_link_directories(WireCellGenOpenMP PRIVATE $ENV{WIRECELL_LIB} /opt/nvidia/hpc_sdk/Linux_x86_64/23.9/math_libs/12.2/lib64)
target_link_libraries(WireCellGenOpenMP PRIVATE  jsoncpp_lib WireCellIface WireCellUtil Eigen3::Eigen WireCellAux spdlog::spdlog Boost::headers cufft curand)
#target_link_libraries(WireCellGenOpenMP PRIVATE  jsoncpp_lib WireCellIface WireCellUtil Eigen3::Eigen WireCellAux spdlog::spdlog Boost::headers CUDA::cufft CUDA::curand)
#add_subdirectory(test)

#message(STATUS "CUDA_cufft_LIBRARY: ${CUDA_cufft_LIBRARY}")
#message(STATUS "CUDA_curand_LIBRARY: ${CUDA_curand_LIBRARY}")
