cmake_minimum_required(VERSION 3.1)

if(POLICY CMP0074)
    cmake_policy(SET CMP0074 NEW)
endif()

project(icu-data-youi VERSION 1.0.0)

# if(MSVC)
#     #setup pdb info
#     set(pdb_output_dir "${CMAKE_CURRENT_BINARY_DIR}/pdb-files")

#     set(CMAKE_PDB_OUTPUT_DIRECTORY "${pdb_output_dir}")
#     set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY "${pdb_output_dir}")

#     #need to sync pdp files
#     add_compile_options("/FS")
# endif()

# set(IMGUI_IMPL_DEFINES)

set(ICU_DATA_YOUI_HEADERS
    include/minimal.icudt55l.dat.h
    include/smaller.icudt55l.dat.h
    include/regular.icudt55l.dat.h
)

set(ICU_DATA_YOUI_SOURCE
    src/minimal.icudt55l.dat.cpp
    src/smaller.icudt55l.dat.cpp
    src/regular.icudt55l.dat.cpp
)

# include_directories(${CMAKE_CURRENT_LIST_DIR}/include)

add_library(icu-data-youi ${ICU_DATA_YOUI_HEADERS} ${ICU_DATA_YOUI_SOURCE})

target_include_directories(icu-data-youi
    PRIVATE include/
)

# target_compile_definitions(icu-data-youi PUBLIC ${IMGUI_IMPL_DEFINES})

#Install icu-data-youi
# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
include(GNUInstallDirs)

#install config path
set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
set(VERSION_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}ConfigVersion.cmake")
set(PROJECT_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(NAMESPACE "${PROJECT_NAME}::")

#install header files
install(FILES ${ICU_DATA_YOUI_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

#build and install project config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "cmake/Config.cmake.in"
    "${PROJECT_CONFIG}"
    INSTALL_DESTINATION "${INSTALL_CONFIGDIR}"
)

#build config version into bin directory
write_basic_package_version_file(
    "${VERSION_CONFIG}"
    COMPATIBILITY AnyNewerVersion

)

#install target
install(
    TARGETS icu-data-youi
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

#install files
install(
    FILES
        "${VERSION_CONFIG}"
        "${PROJECT_CONFIG}"
    DESTINATION ${INSTALL_CONFIGDIR}
)

install(
    EXPORT "${TARGETS_EXPORT_NAME}"
    NAMESPACE "${NAMESPACE}"
    DESTINATION "${INSTALL_CONFIGDIR}"
)

# if(MSVC)
#     #install pdbs
#     get_cmake_property(is_multi GENERATOR_IS_MULTI_CONFIG)

#     if(is_multi)
#       set(config_suffix "$<CONFIG>")
#     else()
#       set(config_suffix "")
#     endif()

#     if(BUILD_SHARED_LIBS)
#       set(pdb_dst ${CMAKE_INSTALL_BINDIR})
#     else()
#       set(pdb_dst ${CMAKE_INSTALL_LIBDIR})
#     endif()

#     install(
#         DIRECTORY "${pdb_output_dir}/${config_suffix}/"
#         DESTINATION ${pdb_dst}
#     )
# endif()
