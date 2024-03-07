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


string(APPEND CMAKE_CXX_FLAGS "-g -O3 -pedantic -Wall -fopenmp -DUSE_RANDOM123")
#string(APPEND CMAKE_CXX_FLAGS "-g -O3 -pedantic -Wall -fopenmp")
string(APPEND CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined -ldl")

add_library(WireCellGenOpenMP SHARED ${all_files})

target_include_directories(WireCellGenOpenMP
  PRIVATE
    ${PROJECT_SOURCE_DIR}/../inc
    $ENV{OMPRNG}
    $ENV{RANDOM123}
    ${JSON_INC_PATH}
#    $ENV{FFTW_INC}
#    $ENV{EIGEN_INC}
#    $ENV{JSONCPP_INC}
    $ENV{JSONNET_INC}
#    $ENV{SPDLOG_INC}
    $ENV{WIRECELL_INC}
)

#set_target_properties(WireCellGenOpenMP
#	PROPERTIES COMPILE_OPTIONS "-DEIGEN_NO_CUDA;-DEIGEN_FFTW_DEFAULT=1;-DEIGEN_DONT_VECTORIZE")

target_link_directories(WireCellGenOpenMP PRIVATE $ENV{WIRECELL_LIB})
target_link_libraries(WireCellGenOpenMP PRIVATE WireCellIface WireCellUtil WireCellAux Eigen3::Eigen jsoncpp_lib PkgConfig::FFTW spdlog::spdlog Boost::headers)

#add_subdirectory(test)
