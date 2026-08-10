set(TARGET_NAME qt5_01_base)

add_executable(${TARGET_NAME}
    src/backend.cpp
    src/backend.h
    src/main.cpp
    resources/qml.qrc
)

target_link_libraries(${TARGET_NAME} PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
)

if(BUILD_TESTING)
    add_test(
        NAME 01.base.smoke
        COMMAND ${TARGET_NAME} --smoke-test
    )
    set_tests_properties(01.base.smoke PROPERTIES
        ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
        TIMEOUT 10
    )
endif()
