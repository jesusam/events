//
//  Event.m
//  Events
//
//  Created by Jesus Morales on 5/8/13.
//  Copyright (c) 2013 Jesus Morales. All rights reserved.
//

#import "Event.h"

@implementation Event

//JM synthesizing the properties declared in Event.h
@synthesize title = _title;
@synthesize startTime = _startTime;
@synthesize venueName = _venueName;

//JM description method implemented in case Event objects are ever output to the console
- (NSString *) description
{
    return [NSString stringWithFormat:@"%@ - %@", _title, _venueName];
}

@end
