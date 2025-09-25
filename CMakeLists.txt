cmake_minimum_required(VERSION 3.20)
project(ollvm-pass)

option(BUILD_ANDROID_NDK "Build for Android NDK" OFF)
option(BUILD_OHOS_NDK "Build for OHOS NDK" OFF)


message(STATUS "BUILD_ANDROID_NDK: ${BUILD_ANDROID_NDK}")
message(STATUS "BUILD_OHOS_NDK: ${BUILD_OHOS_NDK}")

if(BUILD_ANDROID_NDK OR BUILD_OHOS_NDK)
    message(STATUS "LLVM_DIR: ${LLVM_DIR}")
    set(CMAKE_C_COMPILER ${LLVM_DIR}/bin/clang)
    set(CMAKE_CXX_COMPILER ${LLVM_DIR}/bin/clang++)
    list(APPEND CMAKE_PREFIX_PATH "${LLVM_DIR}/lib/cmake/llvm")
endif()

find_package(LLVM REQUIRED CONFIG)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

set(CMAKE_CXX_STANDARD 17)

if(BUILD_ANDROID_NDK OR BUILD_OHOS_NDK)
  add_definitions(${LLVM_DEFINITIONS})
  include_directories(${LLVM_INCLUDE_DIRS})
  link_directories(${LLVM_LIBRARY_DIRS})
else()

endif()

add_subdirectory(llvm-project/llvm/lib/Passes)