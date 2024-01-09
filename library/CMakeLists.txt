add_library(
    mylibrary 
    mylibrary.h 
    mylibrary.c
    )   

target_include_directories(mylibrary PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")

find_package(Doxygen)
option(BUILD_DOCUMENTATION "Create and install the HTML based API        
documentation (requires Doxygen)" ${DOXYGEN_FOUND})

if(BUILD_DOCUMENTATION)
    if(NOT DOXYGEN_FOUND)
         message(FATAL_ERROR "Doxygen is needed to build the documentation.")
    endif()
    doxygen_add_docs(doc
        ${CMAKE_CURRENT_SOURCE_DIR}
    )

endif()

# find_package(Doxygen)
# option(BUILD_DOCUMENTATION "Create and install the HTML based API        
# documentation (requires Doxygen)" ${DOXYGEN_FOUND})

# if(BUILD_DOCUMENTATION)
#     if(NOT DOXYGEN_FOUND)
#          message(FATAL_ERROR "Doxygen is needed to build the documentation.")
#     endif()

#     set(doxyfile_in ${CMAKE_CURRENT_SOURCE_DIR}/../doc/Doxyfile)
#     set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/doxyfile)

#     configure_file(${doxyfile_in} ${doxyfile} @ONLY)

#     message("Doxygen build started.")

#     add_custom_target(doc
#                       COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile_in}
#                       WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../doc
#                       COMMENT "Generating API documentation with Doxygen"
#                       VERBATIM)

#     #    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html DESTINATION     share/doc)
# endif()