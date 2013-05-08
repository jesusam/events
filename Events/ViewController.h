//
//  ViewController.h
//  Events
//
//  Created by Jesus Morales on 5/8/13.
//  Copyright (c) 2013 Jesus Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

//JM changed UIViewController to UITableViewController because the default starting ViewController was changed to a TableViewController and implemented NSXMLParserDelegate protocol
@interface ViewController : UITableViewController <NSXMLParserDelegate>

//JM added NSXMLParser property as the main parser for the XML data to be retrieved
@property (nonatomic, strong) NSXMLParser *xmlParser;
//JM added Event property so that Event objects can be created and used from ViewController.m
@property (nonatomic, strong) Event *currentEvent;
//JM added currentString property to keep track of the string the parser is currently parsing
@property (nonatomic, strong) NSMutableString *currentString;
//JM added storeCharacters property in order to keep track of whether or not the characters the parser is running across should be store in the currentString property
//JM assign is used for scalar types
@property (nonatomic, assign) BOOL storeCharacters;
//JM added dateFormatter which will be used to format the date given in hte XML file
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
//JM added eventsArray which will keep track of the events the parser has come across and completed
@property (nonatomic, strong) NSMutableArray *eventsArray;

- (void) finishedCurrentEvent: (Event *)event;

@end
