//
//  FeedEntryCell.m
//

#import "FeedEntryCell.h"
#import "FeedEntry.h"

@interface FeedEntryCell (Private)

- (NSDictionary *)titleAttributes;
- (NSDictionary *)highlightedTitleAttributes;
- (NSDictionary *)descriptionAttributes;
- (NSDictionary *)highlightedDescriptionAttributes;
+ (NSColor *)colorForIndex:(NSInteger)index;

@end

#define WANT_GRADIENT 1

@implementation FeedEntryCell

+ (NSColor *)colorForIndex:(NSInteger)index
{
    if (index < 0 || index > 4)
    {
        return nil;
    }
    
    static NSArray *colors = nil;
    
    if (!colors) 
    {
        colors = [[NSArray alloc] initWithObjects:
                  [NSColor colorWithCalibratedRed:222.0/255.0 green:99.0/255.0 blue:99.0/255 alpha:0.3],    // red
                  [NSColor colorWithCalibratedRed:0/255.0 green:205.0/255.0 blue:102.0/255.0 alpha:0.1],    // green
                  [NSColor colorWithCalibratedRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:0.1],  // orange
                  [NSColor colorWithCalibratedRed:235.0/255.0 green:206.0/255.0 blue:250.9/255.0 alpha:0.8], // brown
                  [NSColor colorWithCalibratedRed:135.0/255.0 green:106.0/255.0 blue:100.9/255.0 alpha:0.8],// purple
                  nil];
    }
    
    return [colors objectAtIndex:index];
}

- (void)drawWithFrame:(NSRect)cellFrame 
			   inView:(NSView *)controlView 
{
 
    FeedEntry *entry = [self objectValue];
    
    
    if ([entry isKindOfClass:[FeedEntry class]]) 
    {

#ifdef WANT_GRADIENT
        if(![self isHighlighted])
        {
            NSColor *backgroundColor = [FeedEntryCell colorForIndex:[entry feedID]];
            
            if(backgroundColor)
            {
                NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:backgroundColor];                
                
                [gradient drawInRect:NSMakeRect(cellFrame.origin.x + cellFrame.size.width - 30.0, cellFrame.origin.y, 30.0, cellFrame.size.height) angle:0.0];
                [gradient release];
            }
        }
#endif
        
        CGFloat oneThirdHeight = cellFrame.size.height/3;
        NSRect titleRect       = NSMakeRect(cellFrame.origin.x, 
                                            cellFrame.origin.y, 
                                            cellFrame.size.width - 71, 
                                            oneThirdHeight);
        
        NSRect dateRect        =  NSMakeRect(cellFrame.origin.x + cellFrame.size.width - 70, 
                                             cellFrame.origin.y + 3.0, 
                                             70, 
                                             oneThirdHeight);
        
        NSRect descriptionRect = NSMakeRect(cellFrame.origin.x, 
                                            cellFrame.origin.y + oneThirdHeight + 3.0, 
                                            cellFrame.size.width, 
                                            2.0*oneThirdHeight); 
        
        
        
        NSAttributedString *title;
        NSAttributedString *date;
        NSAttributedString *description;
        
        if([self isHighlighted])
        {
        
        title = [[NSAttributedString alloc] initWithString:[entry title]
                                                attributes:[self highlightedTitleAttributes]];

        description = [[NSAttributedString alloc] initWithString:[entry description]
                                                                    attributes:[self highlightedDescriptionAttributes]];
        
        date        = [[NSAttributedString alloc] initWithString:[[entry date] descriptionWithCalendarFormat:@"%Y-%m-%d"
                                                                                                                        timeZone:nil
                                                                                                                          locale:nil] attributes:[self highlightedDescriptionAttributes]];
        }
        else 
        {
            title = [[NSAttributedString alloc] initWithString:[entry title]
                                                    attributes:[self titleAttributes]];
            
            description = [[NSAttributedString alloc] initWithString:[entry description]
                                                          attributes:[self descriptionAttributes]];
            
            date        = [[NSAttributedString alloc] initWithString:[[entry date] descriptionWithCalendarFormat:@"%Y-%m-%d"
                                                                                                        timeZone:nil
                                                                                                          locale:nil] attributes:[self descriptionAttributes]];
            
        }

        [title drawWithRect:titleRect options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin];
        [description drawWithRect:descriptionRect options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin];
        [date drawWithRect:dateRect options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin];
    }
    else
    {
        [super drawWithFrame:cellFrame inView:controlView];        
    }
}

- (NSDictionary *)titleAttributes
{
    static NSDictionary *attributes = nil;
    
    if (!attributes) 
    {
        attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSColor blackColor], NSForegroundColorAttributeName,
                      [NSFont fontWithName:@"Lucida Grande" size:13.0f], NSFontAttributeName, 
                      nil];  
    }
    
    return attributes;
}

- (NSDictionary *)highlightedTitleAttributes
{
    static NSDictionary *attributes = nil;
    
    if (!attributes) 
    {
        attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSColor whiteColor], NSForegroundColorAttributeName,
                      [NSFont fontWithName:@"Lucida Grande" size:13.0f], NSFontAttributeName, 
                      nil];  
    }
    
    return attributes;
}

- (NSDictionary *)descriptionAttributes
{
    static NSDictionary *attributes = nil;
    
    if (!attributes) 
    {
        attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSColor darkGrayColor], NSForegroundColorAttributeName,
                      [NSFont fontWithName:@"Lucida Grande" size:10.0f], NSFontAttributeName, 
                      nil];  
    }
    
    return attributes;
}

- (NSDictionary *)highlightedDescriptionAttributes
{
    static NSDictionary *attributes = nil;
    
    if (!attributes) 
    {
        attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSColor whiteColor], NSForegroundColorAttributeName,
                      [NSFont fontWithName:@"Lucida Grande" size:10.0f], NSFontAttributeName, 
                      nil];  
    }
    
    return attributes;
}


@end
