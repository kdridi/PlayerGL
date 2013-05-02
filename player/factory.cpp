//
//  factory.cpp
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#include <player/factory.h>
#include <player/engine/shader.h>

std::unique_ptr<player::commons::engine> player::factory::create() {
    return std::move(std::unique_ptr<player::commons::engine>(new player::engine::shader("8418.1", true)));
}
