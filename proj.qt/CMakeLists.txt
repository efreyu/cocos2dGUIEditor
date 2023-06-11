cmake_minimum_required(VERSION 3.5)

set(APP_NAME cocos2dGUIEditor) # cocos2dGUIEditor
project(${APP_NAME} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets Core Gui Widgets Network LinguistTools)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets Core Gui Widgets Network LinguistTools)

set(APP_HEADER)
set(APP_SOURCE)
set(APP_UI)
set(APP_TRANSLATION)

file(GLOB_RECURSE APP_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h)
file(GLOB_RECURSE APP_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
file(GLOB_RECURSE APP_UI ${CMAKE_CURRENT_SOURCE_DIR}/ui/*.ui)
file(GLOB_RECURSE APP_TRANSLATION ${CMAKE_CURRENT_SOURCE_DIR}/translation/*.ts)

set(PROJECT_SOURCES
        ${APP_HEADER}
        ${APP_SOURCE}
        ${APP_UI}
        ${APP_TRANSLATION}
        )

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${APP_NAME}
            MANUAL_FINALIZATION
            ${PROJECT_SOURCES}
            )
    # Define target properties for Android with Qt 6 as:
    #    set_property(TARGET ${APP_NAME} APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
    #                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
    # For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${APP_TRANSLATION})
else()
    if(ANDROID)
        add_library(${APP_NAME} SHARED
                ${PROJECT_SOURCES}
                )
        # Define properties for Android with Qt 5 after find_package() calls as:
        #    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(${APP_NAME}
                ${PROJECT_SOURCES}
                )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${APP_TRANSLATION})
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
