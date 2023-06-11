cmake_minimum_required(VERSION 3.15)
project(optiks CUDA)

# Set the C++17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

# Find the X11 library
find_package(X11 REQUIRED)

# Set the source files for your program
set(SOURCES
    hello.cu
    # Add additional source files here
)

# Create the executable target
add_executable(${PROJECT_NAME} ${SOURCES})

# Link against the X11 library
target_link_libraries(${PROJECT_NAME} ${X11_LIBRARIES})

# Set the output directory to the 'build' folder
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/build
)