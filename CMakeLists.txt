#use the following commands in directory build 
#cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake ..
#make

cmake_minimum_required(VERSION 3.5.0)
project(
    STM32_helloworld 
    VERSION 1.0.0 
    DESCRIPTION "Hello world cmake project for STM32"
    LANGUAGES C)


#message(CPP_compiler="${CMAKE_CXX_COMPILER}")
#message(C_compiler="${CMAKE_C_COMPILER}")

add_subdirectory(library)
# Enable testing functionality
enable_testing()

# Disable pthreads in Google Test
set(gtest_disable_pthreads ON)

# Add googletest subdirectory
add_subdirectory(googletest)

# Indicate where to find the headers for the test
include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

add_subdirectory(testprogram)



