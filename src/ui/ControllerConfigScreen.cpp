#include <SFML/Graphics.hpp>
#include <SFML/Window.hpp>
#include <fstream>
#include <nlohmann/json.hpp> // usa https://github.com/nlohmann/json (o il tuo parser JSON)

struct PlayerConfig {
    std::string type; // "keyboard" o "joystick"
    int id;           // id joystick (0-7), -1 se tastiera
};

int main() {
    sf::RenderWindow window(sf::VideoMode(640, 480), "Controller Config");

    sf::Font font;
    font.loadFromFile("assets/fonts/pf_tempesta_seven_condensed.ttf");

    // Config iniziale: tutti tastiera
    PlayerConfig configs[4];
    for (int i = 0; i < 4; ++i) {
        configs[i].type = "keyboard";
        configs[i].id = -1;
    }

    int selected = 0;

    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed)
                window.close();

            if (event.type == sf::Event::KeyPressed) {
                if (event.key.code == sf::Keyboard::Down)
                    selected = (selected + 1) % 4;
                else if (event.key.code == sf::Keyboard::Up)
                    selected = (selected + 3) % 4;
                else if (event.key.code == sf::Keyboard::Right) {
                    // Passa a joystick
                    for (int jid = 0; jid < sf::Joystick::Count; ++jid) {
                        if (sf::Joystick::isConnected(jid)) {
                            configs[selected].type = "joystick";
                            configs[selected].id = jid;
                            break;
                        }
                    }
                } else if (event.key.code == sf::Keyboard::Left) {
                    // Torna a tastiera
                    configs[selected].type = "keyboard";
                    configs[selected].id = -1;
                } else if (event.key.code == sf::Keyboard::Enter) {
                    // Salva in lif_prefs.json
                    nlohmann::json j;
                    j["controls"] = nlohmann::json::array();
                    for (int i = 0; i < 4; ++i) {
                        nlohmann::json pj;
                        pj["type"] = configs[i].type;
                        pj["id"] = configs[i].id;
                        j["controls"].push_back(pj);
                    }
                    std::ofstream ofs("lif_prefs.json");
                    ofs << j.dump(4);
                    ofs.close();
                    window.close();
                }
            }
        }

        window.clear(sf::Color::Black);

        for (int i = 0; i < 4; ++i) {
            sf::Text text;
            std::string label = "Player " + std::to_string(i + 1) + ": " + configs[i].type;
            if (configs[i].type == "joystick")
                label += " " + std::to_string(configs[i].id);

            text.setFont(font);
            text.setString(label);
            text.setCharacterSize(20);
            text.setPosition(50, 50 + i * 40);
            if (i == selected) text.setFillColor(sf::Color::Yellow);
            else text.setFillColor(sf::Color::White);

            window.draw(text);
        }

        window.display();
    }

    return 0;
}
