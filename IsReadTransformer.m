//
//  IsReadTransformer.m
//


#import "IsReadTransformer.h"


@implementation IsReadTransformer


+ (Class)transformedValueClass
{
    return [NSImage class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (NSImage *)unreadImage
{
    static NSImage *image = nil;
    
    if(image == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"unread" ofType:@"png"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    return image;
}

- (id)transformedValue:(id)value
{
    BOOL inputValue = YES;
    NSImage *image  = nil;
    
    if (!value) 
    {
        return nil;
    }
    
    if ([value respondsToSelector:@selector(boolValue)])
    {
        inputValue = [value boolValue];
    }
    else
    {
        [NSException raise:NSInternalInconsistencyException format:@"Value %@ doesn't respond to -(BOOL)boolValue", [value class]];
    }

    if (!inputValue)
    {
        image = [IsReadTransformer unreadImage];
    }
    
    return image;
}

@end
