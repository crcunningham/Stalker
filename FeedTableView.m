//
//  FeedTableView.m
//


#import "FeedTableView.h"

#import "FeedTableViewDelegate.h"

@implementation FeedTableView

- (void)awakeFromNib
{
    [self setRowHeight:50.0];
    [self setAllowsEmptySelection:YES];
    [self setUsesAlternatingRowBackgroundColors:NO];
    [self setDoubleAction:@selector(handleDoubleAction:)];
}

- (void)handleDoubleAction:(id)sender
{
    if ([[self delegate] conformsToProtocol:@protocol(FeedTableViewDelegate)])
    {
        [(id <FeedTableViewDelegate>)[self delegate] handleDoubleActionForRow:[self clickedRow]];
    }
}
    

@end
