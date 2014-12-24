//
//  UIView+UITableViewCell.m
//  Lesson33-HomeWork
//
//  Created by Nick Bibikov on 12/22/14.
//  Copyright (c) 2014 Nick Bibikov. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (UITableViewCell*) superCell {
    
    if ([self.superview isEqual:nil]) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
    
}

@end
