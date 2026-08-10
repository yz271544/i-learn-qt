set(APP_TARGET qt5_05_grid_widget)

add_executable(${APP_TARGET}
    src/image_loader.cpp
    src/image_loader.h
    src/main.cpp
    resources/qml.qrc
)
target_include_directories(${APP_TARGET} PRIVATE src)
target_link_libraries(${APP_TARGET} PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
)

if(BUILD_TESTING)
    add_test(
        NAME 05.grid-widget.smoke
        COMMAND ${APP_TARGET} --smoke-test
    )
    set_tests_properties(05.grid-widget.smoke PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 10
    )

    find_package(Qt5 5.12 REQUIRED COMPONENTS Test)

    set(TEST_TARGET qt5_05_grid_widget_tests)
    add_executable(${TEST_TARGET}
        tests/tst_grid_widget.cpp
        src/image_loader.cpp
        src/image_loader.h
        resources/qml.qrc
    )
    target_include_directories(${TEST_TARGET} PRIVATE src)
    target_link_libraries(${TEST_TARGET} PRIVATE
        Qt5::Core
        Qt5::Gui
        Qt5::Qml
        Qt5::Quick
        Qt5::Test
    )

    add_test(
        NAME 05.grid-widget.loader-and-model
        COMMAND ${TEST_TARGET}
    )
    set_tests_properties(05.grid-widget.loader-and-model PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 15
    )
endif()
