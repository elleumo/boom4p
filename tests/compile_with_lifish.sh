#!/bin/bash
# COMPILE LIFISH FIRST!
${CXX:-g++} -std=c++17 -Isrc -Isrc/core -Isrc/core/collisions -Isrc/core/components -Isrc/core/cutscenes -Isrc/core/entities -Isrc/core/input -Isrc/ui -Isrc/lifish -Isrc/lifish/entities -Isrc/lifish/components -Isrc/lifish/level -Isrc/third_party $1 \
build/CMakeFiles/lifish.dir/src/core/*.o \
build/CMakeFiles/lifish.dir/src/core/collisions/*.o \
build/CMakeFiles/lifish.dir/src/core/components/*.o \
build/CMakeFiles/lifish.dir/src/core/entities/*.o \
build/CMakeFiles/lifish.dir/src/core/input/*.o \
build/CMakeFiles/lifish.dir/src/lifish/*.o \
build/CMakeFiles/lifish.dir/src/lifish/entities/*.o \
build/CMakeFiles/lifish.dir/src/lifish/components/*.o \
build/CMakeFiles/lifish.dir/src/lifish/level/*.o \
build/CMakeFiles/lifish.dir/src/lifish/conf/*.o \
build/CMakeFiles/lifish.dir/src/third_party/*.o \
build/CMakeFiles/lifish.dir/src/ui/ControlsScreen.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/HighScoreScreen.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/LoadScreen.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/PreferencesScreen.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/SaveDataBrowser.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/SaveScreen.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/Screen.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/ScreenBuilder.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/SidePanel.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/UI.cpp.o \
build/CMakeFiles/lifish.dir/src/ui/screen_callbacks.cpp.o \
-lsfml-system -lsfml-graphics -lsfml-window -lsfml-audio -o ${1%.cpp}.x
