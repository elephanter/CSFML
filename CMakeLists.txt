
cmake_minimum_required(VERSION 2.8.3)

# define a macro that helps defining an option
macro(csfml_set_option var default type docstring)
    if(NOT DEFINED ${var})
        set(${var} ${default})
    endif()
    set(${var} ${${var}} CACHE ${type} ${docstring} FORCE)
endmacro()

# set a default build type if none was provided
# this has to be done before the project() instruction!
csfml_set_option(CMAKE_BUILD_TYPE Release STRING "Choose the type of build (Debug or Release)")

# project name
project(CSFML)

# include the configuration file
include(${CMAKE_SOURCE_DIR}/cmake/Config.cmake)

# setup version numbers
set(VERSION_MAJOR 2)
set(VERSION_MINOR 5)
set(VERSION_PATCH 0)

# add the CSFML header path
include_directories(${CMAKE_SOURCE_DIR}/include)

# add an option for choosing the build type (shared or static)
if(NOT (SFML_OS_IOS OR SFML_OS_ANDROID))
    csfml_set_option(BUILD_SHARED_LIBS TRUE BOOL "TRUE to build SFML as shared libraries, FALSE to build it as static libraries")
else()
    if(SFML_OS_IOS)
        set(BUILD_SHARED_LIBS FALSE)
    elseif(SFML_OS_ANDROID)
        set(BUILD_SHARED_LIBS TRUE)
    endif()
endif()

# add an option for building the API documentation
csfml_set_option(CSFML_BUILD_DOC FALSE BOOL "TRUE to generate the API documentation, FALSE to ignore it")

# Android options
if(SFML_OS_ANDROID)
	set(CMAKE_INSTALL_PREFIX ${CMAKE_ANDROID_NDK}/sources/third_party/csfml)
	# we install libs in a subdirectory named after the ABI (lib/mips/*.so)
	set(LIB_SUFFIX "/${CMAKE_ANDROID_ARCH_ABI}")
	    # pass shared STL configuration (if any)
    	if (CMAKE_ANDROID_STL_TYPE MATCHES "_shared")
        	add_definitions("-DSTL_LIBRARY=${CMAKE_ANDROID_STL_TYPE}")
    	#    if(NOT CMAKE_ANDROID_STL_TYPE MATCHES "c\\+\\+_shared")
    	#        message("Android: Using ${CMAKE_ANDROID_STL_TYPE} as STL. Set CMAKE_ANDROID_STL_TYPE to c++_shared, if there are any issues.")
    	#    endif()
    	else()
    	#    message(WARNING "Android: You're using a static STL (${CMAKE_ANDROID_STL_TYPE}). Set CMAKE_ANDROID_STL_TYPE to c++_shared, if there are any issues.")
    	endif()

		    # let the user switch ABIs
    	set(ANDROID_ABI "armeabi-v7a" CACHE STRING "Look at the NDK docs for currently supported ABIs")

    	# this is a workaround to compile sfml-activity without the stl library as a dependency
    	# we save the original compilation command line to restore it later in Macro.cmake
    	set(CMAKE_CXX_CREATE_SHARED_LIBRARY_WITH_STL ${CMAKE_CXX_CREATE_SHARED_LIBRARY})
    	set(CMAKE_CXX_CREATE_SHARED_LIBRARY_WITHOUT_STL "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")

endif()
# add an option for linking to sfml either statically or dynamically
# default on windows to static and on other platforms to dynamic
if(SFML_OS_WINDOWS)
    set(LINK_STATICALLY_DEFAULT TRUE)
else()
    set(LINK_STATICALLY_DEFAULT FALSE)
endif()
csfml_set_option(CSFML_LINK_SFML_STATICALLY ${LINK_STATICALLY_DEFAULT} BOOL "TRUE to link to a static version of SFML, FALSE to link dynamically")

# disable the rpath stuff
set(CMAKE_SKIP_BUILD_RPATH TRUE)

# Install directories
# For miscellaneous files
if(SFML_OS_WINDOWS OR SFML_OS_IOS)
    set(DEFAULT_INSTALL_MISC_DIR .)
elseif(SFML_OS_LINUX OR SFML_OS_FREEBSD OR SFML_OS_OPENBSD)
    set(DEFAULT_INSTALL_MISC_DIR share/SFML)
elseif(SFML_OS_MACOSX)
	set(DEFAULT_INSTALL_MISC_DIR /usr/local/share/CSFML)
elseif(SFML_OS_ANDROID)
    set(DEFAULT_INSTALL_MISC_DIR ${CMAKE_ANDROID_NDK}/sources/third_party/sfml)
endif()
csfml_set_option(SFML_MISC_INSTALL_PREFIX "${DEFAULT_INSTALL_MISC_DIR}" PATH "Prefix installation path for miscellaneous files")


# define an option for choosing between static and dynamic C runtime (Windows only)
if(SFML_OS_WINDOWS)
    set(STATIC_STD_LIBS FALSE CACHE BOOL "TRUE to statically link to the standard libraries, FALSE to use them as DLLs")

    # for VC++, we can apply it globally by modifying the compiler flags
    if(SFML_COMPILER_MSVC AND STATIC_STD_LIBS)
        foreach(flag
                CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
            if(${flag} MATCHES "/MD")
                string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
            endif()
        endforeach()
    endif()
endif()

# add the subdirectories
add_subdirectory(src/SFML)
if(CSFML_BUILD_DOC)
    add_subdirectory(doc)
endif()

if(SFML_OS_ANDROID)

    # install Android.mk so the NDK knows how to set up SFML
    install(FILES src/SFML/Android.mk DESTINATION .)

endif()

# setup the install rules
#install(DIRECTORY include
#        DESTINATION .
#        COMPONENT devel
#        PATTERN ".svn" EXCLUDE)
install(FILES license.txt DESTINATION .)
install(FILES readme.txt DESTINATION .)
sfml_export_targets()
