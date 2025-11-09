#pragma once

#include "EventHandler.hpp"

namespace lif {
    class GameContext;
}

namespace lif {
namespace debug {

class DebugEventHandler : public lif::EventHandler {
public:
	DebugEventHandler(lif::GameContext&) {}
    bool handleEvent(sf::Window&, sf::Event) override {
        return false;
    }
};

}
}
