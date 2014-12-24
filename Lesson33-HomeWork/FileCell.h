//
//  FileCell.h
//  Lesson33-HomeWork
//
//  Created by Nick Bibikov on 12/19/14.
//  Copyright (c) 2014 Nick Bibikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *lableSize;
@property (weak, nonatomic) IBOutlet UILabel *labelDateModified;

@property (weak, nonatomic) IBOutlet UILabel *labelFolderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lableFolderSize;


@end
