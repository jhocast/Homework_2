//
//  main.m
//  Homework_2
//
//  Created by Jhon Castrillon on 9/7/14.
//  Copyright (c) 2014 Jhonny Castrillon. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSDate *startTime = [NSDate date];
        NSFileManager *filemgr;
        
        filemgr = [NSFileManager defaultManager];
        NSString *path = @"/Users/jhoncastrillon/Desktop/CS411/Homework_2/Homework_2/words";
        if ([filemgr fileExistsAtPath: path ] == YES) {
        
            NSError *error;
            NSArray *listItems = [[NSString stringWithContentsOfFile: path
                                                            encoding: NSUTF8StringEncoding
                                                               error: &error] componentsSeparatedByString:@"\n"];
            if (listItems == nil) {
                NSLog(@"Error reading file at %@\n%@", path, [error localizedFailureReason]);
            } else {
                //prepare Dictionaries to hold datasets
                NSMutableDictionary *wordList = [NSMutableDictionary dictionary];
                NSMutableDictionary *distinctWords = [NSMutableDictionary dictionary];
                int startVal = 1;
                NSNumber *recs =[NSNumber numberWithInt:startVal];
                
                for (NSString *wordItem in listItems) {
                    //sort chars within wordItem to create lookup keys
                    NSMutableArray *wordArray = [[NSMutableArray alloc] initWithCapacity:[wordItem length]];
                    for (int i=0; i < [wordItem length]; i++){
                        NSString *wordChar = [NSString stringWithFormat:@"%c", [wordItem characterAtIndex:i]];
                        [wordArray addObject:wordChar];
                    }
                    NSArray *sortedWordArray = [wordArray sortedArrayUsingComparator:
                        ^NSComparisonResult(id obj1, id obj2) {
                            return [obj1 caseInsensitiveCompare:obj2];
                    }];
                    NSString *wordKey = [[sortedWordArray componentsJoinedByString:@""] lowercaseString];
                    
                    if (wordList[wordKey] != nil) {
                        startVal = [wordList[wordKey] intValue] + 1;
                        [wordList setObject:[NSNumber numberWithInt:startVal] forKey:wordKey];
                    } else //new record entry
                        [wordList addEntriesFromDictionary:@{ wordKey : recs}];
                    //get array of distinct keys
                    [distinctWords addEntriesFromDictionary:@{wordItem : wordKey}];
                }
                NSArray *keys = [wordList keysSortedByValueUsingComparator:
                    ^NSComparisonResult(id obj1, id obj2) {
                        return [obj2 compare:obj1]; //descending by value
                }];
                NSLog(@"Key for the largest anagram count is:%@\nTotal Count:%@",keys[0],[wordList objectForKey:keys[0]]);
                NSArray *anagrams = [distinctWords allKeysForObject:keys[0]];
                NSLog(@"Largest anagram list%@", anagrams);
            }
        }
        else
            NSLog (@"File not found");
        
        NSDate *endTime = [NSDate date];
        //NSTimeInterval diff = [endTime timeIntervalSinceDate:startTime];
        NSLog(@"start time is: %@f End Time is %@f", startTime, endTime);
        NSLog(@"%f Time Difference in seconds is: ", [endTime timeIntervalSinceDate:startTime]);
    }
    return 0;
}


