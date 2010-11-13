//
//  FeedTableViewDelegate.m
//


#import "FeedTableViewDelegate.h"

#import "FeedEntry.h"

@implementation FeedTableViewDelegate

@synthesize tableController;

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    for(id object in [tableController selectedObjects])
    {
        if ([object isKindOfClass:[FeedEntry class]])
        {
            [object setIsRead:YES];
        }
    }
}

- (void)handleDoubleActionForRow:(NSInteger)row
{
    FeedEntry *entry = [[tableController arrangedObjects] objectAtIndex:row];
    
    [[NSWorkspace sharedWorkspace] openURL:[entry url]];
}

@end
