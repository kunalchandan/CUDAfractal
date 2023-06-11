cmake_minimum_required(VERSION 3.15)
project(compressor C)

find_package(Raylib REQUIRED)

add_executable(${PROJECT_NAME} hello_raylib.cpp)
target_link_libraries(${PROJECT_NAME} Raylib::Raylib)