//
//  Event.h
//  Events
//
//  Created by Jesus Morales on 5/8/13.
//  Copyright (c) 2013 Jesus Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

//JM added three properties in able to properly display an event
//JM copy means a 
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSString *venueName;

@end
