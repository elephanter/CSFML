include(CMakeParseArguments)

# add a new target which is a CSFML library
# ex: csfml_add_library(csfml-graphics
#                       SOURCES sprite.cpp image.cpp ...
#                       DEPENDS sfml-window sfml-system)
macro(csfml_add_library target)

    # parse the arguments
    cmake_parse_arguments(THIS "" "" "SOURCES;DEPENDS;EXTERNAL_LIBS" ${ARGN})
    set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/Modules/")
    # create the target
    add_library(${target} ${THIS_SOURCES})

    # define the export symbol of the module
    string(REPLACE "-" "_" NAME_UPPER "${target}")
    string(TOUPPER "${NAME_UPPER}" NAME_UPPER)
    set_target_properties(${target} PROPERTIES DEFINE_SYMBOL ${NAME_UPPER}_EXPORTS)

    if(SFML_OS_WINDOWS)
        # include the major version number in Windows shared library names (but not import library names)
        set_target_properties(${target} PROPERTIES DEBUG_POSTFIX -d)
        set_target_properties(${target} PROPERTIES SUFFIX "-${VERSION_MAJOR}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    else()
        set_target_properties(${target} PROPERTIES DEBUG_POSTFIX -d)
    endif()
    if (SFML_OS_WINDOWS AND SFML_COMPILER_GCC)
        # on Windows/gcc get rid of "lib" prefix for shared libraries,
        # and transform the ".dll.a" suffix into ".a" for import libraries
        set_target_properties(${target} PROPERTIES PREFIX "")
        set_target_properties(${target} PROPERTIES IMPORT_SUFFIX ".a")
    endif()

    if(NOT SFML_OS_ANDROID)
    	# set the version and soversion of the target (for compatible systems -- mostly Linuxes)
    	set_target_properties(${target} PROPERTIES SOVERSION ${VERSION_MAJOR}.${VERSION_MINOR})
    	set_target_properties(${target} PROPERTIES VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

    endif()

    # set the target's folder (for IDEs that support it, e.g. Visual Studio)
    set_target_properties(${target} PROPERTIES FOLDER "CSFML")

    # for gcc >= 4.0 on Windows, apply the SFML_USE_STATIC_STD_LIBS option if it is enabled
    if(SFML_OS_WINDOWS AND SFML_COMPILER_GCC AND NOT SFML_GCC_VERSION VERSION_LESS "4")
        if(SFML_USE_STATIC_STD_LIBS AND NOT SFML_COMPILER_GCC_TDM)
            set_target_properties(${target} PROPERTIES LINK_FLAGS "-static-libgcc -static-libstdc++")
        elseif(NOT SFML_USE_STATIC_STD_LIBS AND SFML_COMPILER_GCC_TDM)
            set_target_properties(${target} PROPERTIES LINK_FLAGS "-shared-libgcc -shared-libstdc++")
        endif()
    endif()

    # if using gcc >= 4.0 or clang >= 3.0 on a non-Windows platform, we must hide public symbols by default
    # (exported ones are explicitely marked)
    if(NOT SFML_OS_WINDOWS AND ((SFML_COMPILER_GCC AND NOT SFML_GCC_VERSION VERSION_LESS "4") OR (SFML_COMPILER_CLANG AND NOT SFML_CLANG_VERSION VERSION_LESS "3")))
        set_target_properties(${target} PROPERTIES COMPILE_FLAGS -fvisibility=hidden)
    endif()

    # link the target to its external dependencies (C++ SFML libraries)
    target_link_libraries(${target} ${THIS_DEPENDS})

    # build dylibs
    if(SFML_OS_MACOSX AND BUILD_SHARED_LIBS)
        # adapt install directory to allow distributing dylibs in user’s application bundle
        set_target_properties(${target} PROPERTIES
                              BUILD_WITH_INSTALL_RPATH 1
                              INSTALL_NAME_DIR "@rpath")
    endif()

    # add the install rule
    install(TARGETS ${target} EXPORT SFMLConfigExport
            RUNTIME DESTINATION bin COMPONENT bin
            LIBRARY DESTINATION lib${LIB_SUFFIX} COMPONENT bin 
            ARCHIVE DESTINATION lib${LIB_SUFFIX} COMPONENT devel)
    target_include_directories(${target}
                               PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                               PRIVATE ${PROJECT_SOURCE_DIR}/src)
    if (CSFML_BUILD_FRAMEWORKS)
        target_include_directories(${target} INTERFACE $<INSTALL_INTERFACE:SFML.framework>)
    else()
        target_include_directories(${target} INTERFACE $<INSTALL_INTERFACE:include>)
    endif()

    # define SFML_STATIC if the build type is not set to 'shared'
    if(NOT BUILD_SHARED_LIBS)
        target_compile_definitions(${target} PUBLIC "SFML_STATIC")
    endif()


endmacro()

# Generate a SFMLConfig.cmake file (and associated files) from the targets registered against
# the EXPORT name "SFMLConfigExport" (EXPORT parameter of install(TARGETS))
function(sfml_export_targets)
    # CMAKE_CURRENT_LIST_DIR or CMAKE_CURRENT_SOURCE_DIR not usable for files that are to be included like this one
    set(CURRENT_DIR "${PROJECT_SOURCE_DIR}/cmake")

    include(CMakePackageConfigHelpers)
    write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/CSFMLConfigVersion.cmake"
                                     VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}
                                     COMPATIBILITY SameMajorVersion)

    if (BUILD_SHARED_LIBS)
        set(config_name "Shared")
    else()
        set(config_name "Static")
    endif()
    set(targets_config_filename "CSFML${config_name}Targets.cmake")

    export(EXPORT SFMLConfigExport
           FILE "${CMAKE_CURRENT_BINARY_DIR}/${targets_config_filename}")

    if (CSFML_BUILD_FRAMEWORKS)
	    set(config_package_location "CSFML.framework/Resources/CMake")
    else()
	    set(config_package_location lib${LIB_SUFFIX}/cmake/CSFML)
    endif()
    configure_package_config_file("${CURRENT_DIR}/CSFMLConfig.cmake.in" "${CMAKE_CURRENT_BINARY_DIR}/CSFMLConfig.cmake"
        INSTALL_DESTINATION "${config_package_location}")

    install(EXPORT SFMLConfigExport
            FILE ${targets_config_filename}
            DESTINATION ${config_package_location})

    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/CSFMLConfig.cmake"
	    "${CMAKE_CURRENT_BINARY_DIR}/CSFMLConfigVersion.cmake"
            DESTINATION ${config_package_location}
            COMPONENT devel)
endfunction()

