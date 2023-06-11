cmake_minimum_required(VERSION 3.5)
set(APP_NAME "${APP_NAME}-Editor")
set(APP_VERSION ${APP_VERSION})

project(${APP_NAME} VERSION ${APP_VERSION} LANGUAGES CXX)

# IMPORTANT, this option should be enabled only for Mac/Win build
set(GAME_DEFINITIONS ${GAME_DEFINITIONS} -DQT_EDITOR)
set(GAME_DEFINITIONS ${GAME_DEFINITIONS} -DAX_USE_COMPAT_GL=1) #Only OpenGL is supported in Qt

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets Core Gui Widgets Network LinguistTools)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets Core Gui Widgets Network LinguistTools)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/helpers.cmake) #Helper functions

set(APP_HEADER)
set(APP_SOURCE)
set(APP_UI)
set(APP_TRANSLATION)

file(GLOB_RECURSE APP_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
file(GLOB_RECURSE APP_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
file(GLOB_RECURSE APP_UI ${CMAKE_CURRENT_SOURCE_DIR}/ui/*.ui)
file(GLOB_RECURSE APP_TRANSLATION ${CMAKE_CURRENT_SOURCE_DIR}/translation/*.ts)

#todo continue this
message(FATAL_ERROR ${GAME_DEFINITIONS})

MakeReadableListOfSources(APP_HEADER)
MakeReadableListOfSources(APP_SOURCE)
MakeReadableListOfSources(APP_UI)
MakeReadableListOfSources(APP_TRANSLATION)

set(GAME_HEADER ${GAME_HEADER} "" PARENT_SCOPE)
set(GAME_SOURCE ${GAME_SOURCE} "" PARENT_SCOPE)
set(PROJECT_SOURCES
        ${APP_HEADER}
        ${APP_SOURCE}
        ${APP_UI}
        ${APP_TRANSLATION}
        ${GAME_HEADER}
        ${GAME_SOURCE}
        )
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${APP_NAME}
            MANUAL_FINALIZATION
            ${PROJECT_SOURCES}
            )

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${APP_TRANSLATION})
else()
    message(FATAL_ERROR "This project supports only Qt6 or higher")
endif()
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/Qt-Advanced-Docking-System)
target_include_directories(${APP_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/Qt-Advanced-Docking-System/src")
target_link_libraries(${APP_NAME} PRIVATE qt${QT_VERSION_MAJOR}advanceddocking)
target_link_libraries(${APP_NAME} PRIVATE
        Qt${QT_VERSION_MAJOR}::Widgets
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Network
        )

set_target_properties(${APP_NAME} PROPERTIES
        CXX_STANDARD 17
        MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
        )
target_include_directories(${APP_NAME}
        PRIVATE ${CMAKE_SOURCE_DIR}/src
        PRIVATE ${CMAKE_SOURCE_DIR}/ui
        )

install(TARGETS ${APP_NAME}
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(${APP_NAME})
endif()
