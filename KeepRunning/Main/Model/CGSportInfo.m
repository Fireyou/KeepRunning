//
//  CGSportInfo.m
//  跑跑
//
//  Created by CHENGuo on 21/08/2015.
//  Copyright (c) 2015 CHENGuo. All rights reserved.
//

#import "CGSportInfo.h"

@implementation CGSportInfo
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.runLine forKey:@"runLine"];
    [encoder encodeObject:self.sportDate forKey:@"sportDate"];
    [encoder encodeObject:self.energie forKey:@"energie"];
    [encoder encodeObject:self.runKilometers forKey:@"runKilometers"];
    [encoder encodeObject:self.averageSpeed forKey:@"averageSpeed"];
    [encoder encodeObject:self.saveID forKey:@"saveID"];
    [encoder encodeObject:self.timeUsed forKey:@"timeUsed"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.runLine = [decoder decodeObjectForKey:@"runLine"];
        self.sportDate = [decoder decodeObjectForKey:@"sportDate"];
        self.energie = [decoder decodeObjectForKey:@"energie"];
        self.runKilometers = [decoder decodeObjectForKey:@"runKilometers"];
        self.averageSpeed = [decoder decodeObjectForKey:@"averageSpeed"];
        self.saveID = [decoder decodeObjectForKey:@"saveID"];
        self.timeUsed = [decoder decodeObjectForKey:@"timeUsed"];
    }
    return self;
}


@end
