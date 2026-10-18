cmake_minimum_required(VERSION 2.8)

set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

project(tfs)

list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

if(NOT MSVC)
    include(cotire)
endif()

if(MSVC)
    # Standard x64 baseline (no AVX/AVX2) for full Intel Core i3-530 compatibility
    add_compile_options(/MP /W3 /bigobj)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_WINSOCK_DEPRECATED_NO_WARNINGS)
else()
    add_compile_options(-Wall -pipe -fvisibility=hidden)
    if (CMAKE_COMPILER_IS_GNUCXX)
        add_compile_options(-fno-strict-aliasing)
    endif()
endif()

include(FindCXX11)

# Find packages.
find_package(GMP REQUIRED)
find_package(PugiXML REQUIRED)
find_package(LuaJIT)
find_package(SQLite3 REQUIRED)
find_package(Threads)

option(USE_LUAJIT "Use LuaJIT" ${LUAJIT_FOUND})

if(USE_LUAJIT)
    find_package(LuaJIT REQUIRED)
    if(APPLE)
      set(CMAKE_EXE_LINKER_FLAGS "-pagezero_size 10000 -image_base 100000000")
    endif()
else()
    find_package(Lua)
endif()

find_package(Boost 1.53.0 COMPONENTS system REQUIRED)

include(src/CMakeLists.txt)
add_executable(tfs ${tfs_SRC})

include_directories(${SQLite3_INCLUDE_DIRS} ${LUA_INCLUDE_DIR} ${Boost_INCLUDE_DIRS} ${PUGIXML_INCLUDE_DIR} ${GMP_INCLUDE_DIR})
target_link_libraries(tfs ${SQLite3_LIBRARIES} ${LUA_LIBRARIES} ${Boost_LIBRARIES} ${PUGIXML_LIBRARIES} ${GMP_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

if(WIN32)
    target_link_libraries(tfs ws2_32)
endif()

if(NOT MSVC)
    set_target_properties(tfs PROPERTIES COTIRE_CXX_PREFIX_HEADER_INIT "src/otpch.h")
    set_target_properties(tfs PROPERTIES COTIRE_ADD_UNITY_BUILD FALSE)
    cotire(tfs)
endif()
