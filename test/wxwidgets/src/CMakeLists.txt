cmake_minimum_required(VERSION 2.6)
project(wxcmaketest)

# Enable Unicode
ADD_DEFINITIONS(-D_UNICODE -DUNICODE)

# wxWidgets

message("wxWidgets_LIB_DIR = ${wxWidgets_LIB_DIR}")

#SET(wxWidgets_ROOT_DIR F:/Projects/wxMSW-2.8.12)
#IF(CMAKE_COMPILER_IS_GNUCC)
#	SET(wxWidgets_LIB_DIR F:/Projects/wxMSW-2.8.12/lib/gcc_lib)
#ELSE(CMAKE_COMPILER_IS_GNUCC)
#	SET(wxWidgets_LIB_DIR F:/Projects/wxMSW-2.8.12/lib/vc_lib)
#ENDIF(CMAKE_COMPILER_IS_GNUCC)
IF(CMAKE_BUILD_TYPE="Debug")
	SET(wxWidgets_CONFIGURATION mswud)
ELSE()
	SET(wxWidgets_CONFIGURATION mswu)
	ADD_DEFINITIONS(-DwxDEBUG_LEVEL=0)
ENDIF()
FIND_PACKAGE(wxWidgets REQUIRED net gl core base)
INCLUDE(${wxWidgets_USE_FILE})

message("wxWidgets_LIBRARIES = ${wxWidgets_LIBRARIES}")

IF(CMAKE_COMPILER_IS_GNUCC)
	SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
ENDIF(CMAKE_COMPILER_IS_GNUCC)


# TIFF
FIND_PACKAGE(TIFF REQUIRED)
INCLUDE_DIRECTORIES(${TIFF_INCLUDE_DIR})

# PNG
FIND_PACKAGE(PNG REQUIRED)
INCLUDE_DIRECTORIES(${PNG_INCLUDE_DIRS})

# ZLIB
FIND_PACKAGE(ZLIB REQUIRED)
INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_DIR})

IF(NOT MSVC)
	# LibLZMA
	find_package(LibLZMA REQUIRED)
	include_directories(${LIBLZMA_INCLUDE_DIR})
ENDIF(NOT MSVC)

# JPEG
FIND_PACKAGE(JPEG REQUIRED)
INCLUDE_DIRECTORIES(${JPEG_INCLUDE_DIR})
#IF(ABIC_HAVE_BOOLEAN)
#	ADD_DEFINITIONS(-DHAVE_BOOLEAN)
#ENDIF(ABIC_HAVE_BOOLEAN)

add_executable(wxcmaketest WIN32 wxcmaketestapp.cpp)

TARGET_LINK_LIBRARIES(wxcmaketest ${wxWidgets_LIBRARIES} ${TIFF_LIBRARIES} ${PNG_LIBRARIES} ${JPEG_LIBRARIES} ${ZLIB_LIBRARY})

#IF(NOT MSVC)
#	SET(ABIC_LINK_LIBRARIES ${ABIC_LINK_LIBRARIES}
#		${JASPER_LIBRARIES} ${LIBLZMA_LIBRARY})
#ENDIF(NOT MSVC)