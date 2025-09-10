#include "controls.hpp"

// Ordine controlli: UP, DOWN, LEFT, RIGHT, BOMB
// P1 e P2 = tastiera, P3 e P4 = joystick
std::array<sf::Keyboard::Key, lif::controls::CONTROLS_NUM>
lif::controls::players[lif::MAX_PLAYERS] = {
    // P1 (tastiera - WASD + Space)
    { sf::Keyboard::W,  sf::Keyboard::S,  sf::Keyboard::A,  sf::Keyboard::D,  sf::Keyboard::Space },
    // P2 (tastiera - frecce + Right Ctrl)
    { sf::Keyboard::Up, sf::Keyboard::Down, sf::Keyboard::Left, sf::Keyboard::Right, sf::Keyboard::RControl },
    // P3 (joystick: i tasti tastiera qui NON contano perché useremo il joystick)
    { sf::Keyboard::T,  sf::Keyboard::G,  sf::Keyboard::F,  sf::Keyboard::H,  sf::Keyboard::RShift },
    // P4 (joystick)
    { sf::Keyboard::I,  sf::Keyboard::K,  sf::Keyboard::J,  sf::Keyboard::L,  sf::Keyboard::Enter }
};

// Pulsante “bomba” per ogni giocatore quando usa il joystick.
// Di default metto il bottone 0 (spesso è il tasto A/X). Cambialo se serve.
std::array<unsigned, lif::MAX_PLAYERS> lif::controls::joystickBombKey = {{ 0, 0, 0, 0 }};

// Quale joystick usa ciascun player: -1 = tastiera, 0 = joystick #0, 1 = joystick #1, ecc.
std::array<short, lif::MAX_PLAYERS> lif::controls::useJoystick = {{
    -1,  // P1 su tastiera
    -1,  // P2 su tastiera
     0,  // P3 su joystick #0
     1   // P4 su joystick #1
}};
