//
//  http.cpp
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#include <player/commons/http.h>

#include <map>

#include <boost/assert.hpp>


std::string player::commons::http::read(const char* name)
{
    static std::map<const std::string, std::string> cache;
    if (cache.find(name) == cache.end()) {
        NSError* error;
        NSString* content = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s", name]]
                                                     encoding:NSUTF8StringEncoding error:&error];
        assert(error == nil);
        cache[name] = content.UTF8String;
    }
    
    return cache[name];
}

#include <json/json.h>

std::string player::commons::http::readJSONByKey(const char* name, const char* key)
{
    std::string result(read(name));
    
    json_object* object = json_tokener_parse(result.c_str());
    BOOST_ASSERT(object != nullptr);
    {
        json_object* jvalue = json_object_object_get(object, key);
        BOOST_ASSERT(jvalue != nullptr);
        {
            const char* value = json_object_get_string(jvalue);
            BOOST_ASSERT(value != nullptr);
            result = value;
        }
        json_object_put(jvalue);
    }
    json_object_put(object);
    
    NSLog(@"[%s]", result.c_str());
    return result;
}


#include <libxml/HTMLparser.h>
#include <libxml/tree.h>
#include <libxml/xpath.h>

std::string player::commons::http::readXMLById(const char* name, const char* id)
{
    std::string result = read(name);
    
    htmlParserCtxtPtr ctxt = htmlCreateMemoryParserCtxt(result.c_str(), static_cast<int>(result.size()));
    BOOST_ASSERT(ctxt != nullptr);
    {
        int value = htmlParseDocument(ctxt);
        printf("value = %d", value);
        
        xmlXPathContextPtr ctx = xmlXPathNewContext(ctxt->myDoc);
        BOOST_ASSERT(ctx != nullptr);
        {
            char expression[1024];
            sprintf(expression, "id('%s')", id);
            
            xmlXPathObjectPtr ptr = xmlXPathEval(reinterpret_cast<xmlChar*>(expression), ctx);
            BOOST_ASSERT(ptr != nullptr);
            {
                BOOST_ASSERT(ptr->nodesetval->nodeNr == 1);
                xmlNodePtr cur = ptr->nodesetval->nodeTab[0];
                result = reinterpret_cast<char*>(xmlNodeGetContent(cur));
            }
            xmlXPathFreeNodeSetList(ptr);
        }
        
        xmlXPathFreeContext(ctx);
    }
    htmlFreeParserCtxt(ctxt);
    
    NSLog(@"[%s]", result.c_str());
    return result;
}
