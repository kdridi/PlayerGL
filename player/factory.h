//
//  factory.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __player_factory__
#define __player_factory__

#include <player/commons/engine.h>

#include <memory>

namespace player {
    class factory {
    public:
        static std::unique_ptr<player::commons::engine> create();
    };
}

#endif /* defined(__player_factory__) */
