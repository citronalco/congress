# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-congress

CONFIG += sailfishapp

SOURCES += src/harbour-congress.cpp

DISTFILES += qml/harbour-congress.qml \
    qml/components/CongressHandlerPython.qml \
    qml/components/DayList.qml \
    qml/components/EventListItem.qml \
    qml/components/SelectDockedPanel.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/DayPage.qml \
    qml/pages/EventPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-congress.changes.in \
    rpm/harbour-congress.changes.run.in \
    rpm/harbour-congress.spec \
    rpm/harbour-congress.yaml \
    translations/*.ts \
    harbour-congress.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-congress-de.ts

images.path += /usr/share/harbour-congress/images
images.files = images/*

INSTALLS += images

