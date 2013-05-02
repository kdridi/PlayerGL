//
//  file.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __player_commons_file__
#define __player_commons_file__

#include <string>

namespace player {
    namespace commons {
        class file {
        public:
            static std::string read(const char* name, const char* extension = nullptr);
        };
    }
}

#endif /* defined(__player_commons_file__) */
