//
//  ticker.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __player_commons_ticker__
#define __player_commons_ticker__

#include <boost/noncopyable.hpp>

namespace player {
    namespace commons {
        class ticker : public boost::noncopyable {
        public:
            ticker(long interval);
            void reset();
            float tick();
        private:
            unsigned long _interval;
            unsigned long _start;
            unsigned long _elapsed;
            unsigned long _counter;
        };
    }
}

#endif /* defined(__player_commons_ticker__) */
