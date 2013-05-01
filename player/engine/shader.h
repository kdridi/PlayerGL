//
//  shader.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __PlayerGL__shader__
#define __PlayerGL__shader__

#include <player/commons/engine.h>
#include <player/commons/shader/program.h>

namespace player {
    namespace engine {
        class shader : public player::commons::engine {
            player::commons::shader::program program;
            const std::string name;
        public:
            shader(const char* name);
            virtual ~shader();
            virtual void initialize(void);
            virtual void reshape(float width, float height);
            virtual void mouse(float x, float y);
            virtual void update(float dt);
            virtual void draw(void);
        };
    }
}

#endif /* defined(__PlayerGL__shader__) */
