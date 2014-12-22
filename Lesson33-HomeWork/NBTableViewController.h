//
//  NBTableViewController.h
//  Lesson33-HomeWork
//
//  Created by Nick Bibikov on 12/19/14.
//  Copyright (c) 2014 Nick Bibikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBTableViewController : UITableViewController

@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSArray* content;


- (IBAction)buttonDetail:(UIButton *)sender;
- (IBAction)buttonAdd:(UIBarButtonItem *)sender;


- (id) initWIthPaht:(NSString*) path;

@end
