//
//  http.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __player_commons_http__
#define __player_commons_http__

#include <string>

namespace player {
    namespace commons {
        class http {
        public:
            static std::string read(const char* url);
            static std::string readXMLById(const char* url, const char* id);
            static std::string readJSONByKey(const char* url, const char* id);
        };
    }
}

#endif /* defined(__player_commons_http__) */
