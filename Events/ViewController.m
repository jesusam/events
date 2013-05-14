//
//  ViewController.m
//  Events
//
//  Created by Jesus Morales on 5/8/13.
//  Copyright (c) 2013 Jesus Morales. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//JM sythesized properties found in ViewController.h (must use _[property name] to avoid compiler confusion)
@synthesize xmlParser = _xmlParser;
@synthesize currentEvent = _currentEvent;
@synthesize currentString = _currentString;
@synthesize storeCharacters = _storeCharacters;
@synthesize dateFormatter = _dateFormatter;
@synthesize eventsArray = _eventsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	//JM initializing instance of xmlParser using initWithContentsOfURL initializer then creating the NSURL on site using URLWithString convenience constructor
    self.xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.eventful.com/rest/events/search?app_key=RzM7Hh3TZQdBcS5m&location=32801&category=music&date=future"]];
    //JM setting the NSXMLParserDelegate to the xmlParser
    self.xmlParser.delegate = self;
    
    //JM initializing the eventsArray and currentString so that they are not null when accessed
    self.eventsArray = [NSMutableArray array];
    self.currentString = [NSMutableString string];
    
    //JM initializing the dateFormatter and giving it a template to follow
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [NSLocale currentLocale];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //JM parsing the XML data stored in the xmlParser object and checking to make sure the data is succesfully parsed
    if ( [self.xmlParser parse])
        NSLog(@"XML parsed");
    else
        NSLog(@"Failed to parse");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//JM returns the amount of rows in a given section but this app only has one section so the amount of sections method is not necessary. The amount of rows is simply the amount of arrays the parser has come across and stored in the eventsArray
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventsArray count];
}

//JM commonly used tableView:cellForRowAtIndexPath: method
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //JM this CellIdentifier has to be copied into the Reuse Identifier section in the attributes of the cellView in storyboard
    static NSString *CellIdentifier = @"EventTableViewCell";
    
    //JM attempts to retrieve a reusable cell that is no longer in use
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //JM if there was no cell available for reuse, the method will have returned nil so create a new cell with the reuse identifier CellIdentifier
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //JM creates and event which is a copy of the event in eventsArray with the same index as the new cell will have
    Event *event = [self.eventsArray objectAtIndex:indexPath.row];
    NSLog(@"%@", event);
    
    //JM assigns the text and detailtext to the title of the event and the venue name respectively
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.venueName;
    
    return cell;
}

//JM creating static strings so that these strings, which will be needed almost every time the parser:didStartElement:.. method is called, do not need to have new instances of them created every time they are needed
static NSString *kName_Event = @"event";
static NSString *kName_Title = @"title";
static NSString *kName_StartTime = @"start_time";
static NSString *kName_VenueName = @"venue_name";

//JM implementing parser:didStartElement:... method to give instructions for when the parser runs across a new element
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //JM checking if the elementName of element is equal to "event" (if it is an event) and creating a new Event object in which the information pertaining to the event will be stored. It also sets storeCharacters to NO so that the nonsense id is not stored in the current string
    if ( [elementName isEqualToString:kName_Event] )
    {
        self.currentEvent = [[Event alloc] init];
        self.storeCharacters = NO;
    }
    //JM if the elementName is not equal to "event" but is equal to one of the other properties we are looking for it starts a new string to store the information in and sets storeCharacters to YES so that we have a record of what the element is
    else if ( [elementName isEqualToString:kName_Title] || [elementName isEqualToString:kName_StartTime] || [elementName isEqualToString:kName_VenueName])
    {
        [self.currentString setString:@""];
        self.storeCharacters = YES;
    }
}

//JM this method runs when the parser finds characters within an element in the XML data. If the storeCharacters property is set to YES, the method will store these characters in the currentString property
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ( self.storeCharacters )
    {
        [self.currentString appendString:string];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ( [elementName isEqualToString:kName_Title] )
    {
        self.currentEvent.title = _currentString;
    }
    else if ( [elementName isEqualToString:kName_VenueName])
    {
        self.currentEvent.venueName = _currentString;
    }
    else if ( [elementName isEqualToString:kName_StartTime])
    {
        self.currentEvent.startTime = [self.dateFormatter dateFromString: _currentString];
    }
    if ( [elementName isEqualToString:kName_Event] )
    {
        [self finishedCurrentEvent: _currentEvent];
    }
    //JM setting store characters to NO because the current element has been finished. Start a new string next
    self.storeCharacters = NO;
}

//JM when the parser:didEndElement:.. method finishes an event it calls this function and sends the event that just finished. This event is then added to the eventsArray property which the view
- (void) finishedCurrentEvent:(Event *)event
{
    [self.eventsArray addObject:event];
    self.currentEvent = nil;
}

//JM used to handle errors
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //handle errors as necessary
}

//JM this is called when the parser finishes the document. It prints out the amount of events added to the eventsArray and refreshes the tableView
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"%d", self.eventsArray.count);
    [self.tableView reloadData];
}

@end
