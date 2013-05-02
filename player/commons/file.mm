//
//  file.cpp
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#include <player/commons/file.h>

std::string player::commons::file::read(const char* name, const char* extension)
{
    auto nsstring = [](const char* value) -> NSString*
    {
        return value == nullptr ? nil : [NSString stringWithFormat:@"%s", value];
    };
    NSError* error;
    NSString* content = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:nsstring(name)
                                                                                  withExtension:nsstring(extension)]
                                                 encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    return content.UTF8String;
}
