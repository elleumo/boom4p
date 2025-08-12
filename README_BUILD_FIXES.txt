Lifish - Fix compilazione (MSVC C++17 + due pannelli)

Inclusi:
- CMakeLists.txt                    (forza /std:c++17 su MSVC)
- src/lifish/GameContext.hpp        (leftPanel/rightPanel al posto di sidePanel)
- src/lifish/GameContext.cpp        (inizializza e disegna entrambi i pannelli)

Istruzioni:
1) Estrarre lo zip nella root del progetto 'lifish' (sovrascrivere i file).
2) Pulire la build: eliminare la cartella 'build' se presente.
3) Configurare CMake puntando a SFML 2.6.1:
   cmake -S . -B build -A x64 -DCMAKE_BUILD_TYPE=Release -DSFML_DIR=C:/libs/SFML-2.6.1/lib/cmake/SFML
4) Compilare:
   cmake --build build --config Release -- /m
5) Copiare le DLL di SFML accanto all'eseguibile (una volta sola):
   copy C:\libs\SFML-2.6.1\bin\*.dll C:\Users\Luca\Desktop\lifish\build\Release\
6) Avviare:
   cd build/Release
   lifish.exe
