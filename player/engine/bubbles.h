//
//  bubbles.h
//  PlayerGL
//
//  Created by Karim DRIDI on 03/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __PlayerGL__bubbles__
#define __PlayerGL__bubbles__

#include <player/commons/engine.h>
#include <player/commons/shader/program.h>

namespace player {
    namespace engine {
        class bubbles : public player::commons::engine {
            player::commons::shader::program program;
        public:
            bubbles();
            virtual ~bubbles();
            virtual void initialize(void);
            virtual void reshape(float width, float height);
            virtual void update(float dt);
            virtual void draw(void);
        };
    }
}

#endif /* defined(__PlayerGL__bubbles__) */
