//
//  SourceEditorCommand.m
//  SourceEditorPlugin
//
//  Created by Pan on 2017/5/15.
//  Copyright © 2017年 Sheng Pan. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "AccessCodeGenerator.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // get selected String
    NSMutableArray *selections = [NSMutableArray array];
    for ( XCSourceTextRange *range in invocation.buffer.selections )
    {
        NSInteger startLine = range.start.line;
        // make user select line easier
        NSInteger endLine = range.end.column > 0 ? range.end.line + 1 : range.end.line;
        
        for ( NSInteger i = startLine; i < endLine ; i++)
        {
            [selections addObject:invocation.buffer.lines[i]];
        }
    }
    NSString *selectedString = [selections componentsJoinedByString:@""];
    
    // find the insert location
    NSString *interface = [self interfaceContainerInBuffer:invocation.buffer
                                               initialLine:invocation.buffer.selections.firstObject.start.line];
    NSInteger insertIndex = [self endLineOfImplementationForInterface:interface buffer:invocation.buffer];
    insertIndex = (insertIndex == NSNotFound)
    ? invocation.buffer.selections.lastObject.end.line + 1
    : insertIndex;
    
    // do something for each command
    if ([invocation.commandIdentifier isEqualToString:@"net.shengpan.CodeGenerator.SourceEditorPlugin.SourceEditorCommand"])
    {
        NSArray *getter = [AccessCodeGenerator lazyGetterForString:selectedString];
        for (NSInteger i = 0; i < getter.count; i++)
        {
            [invocation.buffer.lines insertObject:getter[i] atIndex:insertIndex];
        }
    } else if ([invocation.commandIdentifier isEqualToString:@"net.shengpan.CodeGenerator.SourceEditorPlugin.Setter"]) {

        NSArray *setter = [AccessCodeGenerator setterForString:selectedString];
        for (NSInteger i = 0; i < setter.count; i++)
        {
            [invocation.buffer.lines insertObject:setter[i] atIndex:insertIndex];
        }
    }

    completionHandler(nil);
}


- (NSString *)interfaceContainerInBuffer:(XCSourceTextBuffer *)buffer initialLine:(NSInteger)line
{
    NSString *interfaceString = nil;
    while (line >= 0 && ![interfaceString containsString:@"@interface"])
    {
        interfaceString = buffer.lines[line];
        line--;
    }
    if (!interfaceString) {
        return nil;
    }
    
    NSArray *components = [interfaceString componentsSeparatedByString:@" "];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != ''"];
    return [components filteredArrayUsingPredicate:predicate][1];
}

- (NSInteger)endLineOfImplementationForInterface:(NSString *)interface buffer:(XCSourceTextBuffer *)buffer
{
    NSInteger result = NSNotFound;
    BOOL foundImplementation = NO;
    for (NSInteger i = 0; i < buffer.lines.count; i++)
    {
        NSString *lineContent = buffer.lines[i];
        if (foundImplementation
            && [lineContent containsString:@"@end"]) {
            result = i;
            break;
        }
        
        if ([lineContent containsString:@"@implementation"]
            && [lineContent containsString:interface]) {
            foundImplementation = YES;
        }
        
    }
    return result;
}


@end
