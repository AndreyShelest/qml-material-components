TEMPLATE = app

QT += qml quick widgets xml svg

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/../../../build_root/qml-libs/

# Default rules for deployment.
include(deployment.pri)
