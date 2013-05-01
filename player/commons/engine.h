//
//  engine.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __PlayerGL__engine__
#define __PlayerGL__engine__

namespace player {
    namespace commons {
        class engine {
        public:
            virtual ~engine();
            virtual void initialize(void) = 0;
            virtual void reshape(float width, float height) = 0;
            virtual void mouse(float x, float y) = 0;
            virtual void update(float dt) = 0;
            virtual void draw(void) = 0;
        };
    }
}

#endif /* defined(__PlayerGL__engine__) */
