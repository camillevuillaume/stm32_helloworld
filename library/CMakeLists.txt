add_library(
    mylibrary 
    mylibrary.h 
    mylibrary.c
    )   

target_include_directories(mylibrary PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
