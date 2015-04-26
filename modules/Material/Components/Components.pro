TEMPLATE = subdirs

deployment.files += qmldir \
                    *.qml

deployment.path = $$[QT_INSTALL_QML]/Material/Components
INSTALLS += deployment

OTHER_FILES += $$deployment.files
