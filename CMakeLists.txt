cmake_minimum_required(VERSION 3.12)

project(icu-data-youi VERSION 1.0.0)

set(ICU_DATA_YOUI_HEADERS include/minimal.icudt55l.dat.h include/smaller.icudt55l.dat.h)
set(ICU_DATA_YOUI_SOURCE  src/minimal.icudt55l.dat.cpp   src/smaller.icudt55l.dat.cpp)

option(ICUDATA_BUILD_REGULAR "Add the regular ICU data file" ON )
if (ICUDATA_BUILD_REGULAR)
    list(APPEND ICU_DATA_YOUI_SOURCE  src/regular.icudt55l.dat.cpp)
    list(APPEND ICU_DATA_YOUI_HEADERS include/regular.icudt55l.dat.h)
endif()

message(STATUS "Building icu-data-youi with src: ${ICU_DATA_YOUI_SOURCE}")
add_library(icu-data-youi ${ICU_DATA_YOUI_HEADERS} ${ICU_DATA_YOUI_SOURCE})

target_include_directories(icu-data-youi
    PRIVATE include
)

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
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/icu-data-youi)

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
