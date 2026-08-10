set(APP_TARGET qt5_02_project_layout)

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
        NAME 02.project-layout.smoke
        COMMAND ${APP_TARGET} --smoke-test
    )
    set_tests_properties(02.project-layout.smoke PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 10
    )

    find_package(Qt5 5.12 REQUIRED COMPONENTS Test)

    set(TEST_TARGET qt5_02_project_layout_tests)
    add_executable(${TEST_TARGET}
        tests/tst_project_layout.cpp
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
        NAME 02.project-layout.qml-interaction
        COMMAND ${TEST_TARGET}
    )
    set_tests_properties(02.project-layout.qml-interaction PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 10
    )
endif()
