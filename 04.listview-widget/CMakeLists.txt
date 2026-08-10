set(APP_TARGET qt5_04_listview_widget)

add_executable(${APP_TARGET}
    src/main.cpp
    resources/qml.qrc
)

target_link_libraries(${APP_TARGET} PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
)

if(BUILD_TESTING)
    add_test(
        NAME 04.listview-widget.smoke
        COMMAND ${APP_TARGET} --smoke-test
    )
    set_tests_properties(04.listview-widget.smoke PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 10
    )

    find_package(Qt5 5.12 REQUIRED COMPONENTS Test)

    set(TEST_TARGET qt5_04_listview_widget_tests)
    add_executable(${TEST_TARGET}
        tests/tst_listview_widget.cpp
        resources/qml.qrc
    )
    target_link_libraries(${TEST_TARGET} PRIVATE
        Qt5::Core
        Qt5::Gui
        Qt5::Qml
        Qt5::Quick
        Qt5::Test
    )

    add_test(
        NAME 04.listview-widget.model-and-interaction
        COMMAND ${TEST_TARGET}
    )
    set_tests_properties(04.listview-widget.model-and-interaction PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 15
    )
endif()
