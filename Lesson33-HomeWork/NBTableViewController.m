//
//  NBTableViewController.m
//  Lesson33-HomeWork
//
//  Created by Nick Bibikov on 12/19/14.
//  Copyright (c) 2014 Nick Bibikov. All rights reserved.
//

#import "NBTableViewController.h"
#import "FileCell.h"
#import "UIView+UITableViewCell.h"

@interface NBTableViewController ()

@end

@implementation NBTableViewController


- (id) initWIthPaht:(NSString*) path {
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.path = path;
    }
    
    return self;
}



- (void) setPath:(NSString *)path {
    
    _path = path;
    
    NSError* error = nil;
    
    self.content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSMutableArray* tempArray = [NSMutableArray new];
    
    for (NSString* name in self.content) {
        if (![name hasPrefix:@"."]) {
            [tempArray addObject:name];
        }
    }
    
    self.content = tempArray;
    
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/NBibikov/Documents/GitHub";
    }
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*if ([self.navigationController.viewControllers count] > 1) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Root"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        
        self.navigationItem.rightBarButtonItem = item;
    }*/
}



#pragma mark - Actions

- (IBAction)buttonDetail:(UIButton *)sender {
    
    UITableViewCell* cell = [sender superCell];
    
    if (cell) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
        [[[UIAlertView alloc] initWithTitle:@"Alert"
                                    message:[NSString stringWithFormat:@"Action on section - %d and row - %d", indexPath.section, indexPath.row]
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles: nil] show];
        
    }
}

- (IBAction)buttonAdd:(UIBarButtonItem *)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Folder's name"
                                                      message:@"Enter folder's name"
                                                     delegate:nil
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString* folderName = [NSString stringWithFormat:@"%@", [alertView textFieldAtIndex:0].text];
    NSLog(@"%@", folderName);
    
    NSString* path = [self.path stringByAppendingPathComponent:folderName];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    BOOL fileExist = [fileManager fileExistsAtPath:path];
    
    if (fileExist) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Folder's name"
                                                          message:@"folder with this name already exist. Please enter other name."
                                                         delegate:nil
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"OK", nil];
        
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [message show];
    
    } else {
        
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
        [self setPath:_path];
    }
}

- (void) actionBackToRoot:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*) indexPath {
    
    BOOL isDirectory = NO;
    
    NSString* name = [self.content objectAtIndex:indexPath.row];
    NSString* fullPath = [self.path stringByAppendingPathComponent:name];
    
    [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
    
    return isDirectory;
}



- (NSString*) sizeFileFromValue:(NSString*) path {
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    unsigned long long fileSize = [attributes fileSize];
    
    static NSString* units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int count = 5;
    
    int index = 0;
    
    while (fileSize > 1024 && count > index) {
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%llu %@", fileSize, units[index]];
}


- (NSString*)sizeFolderFromValue:(NSString *)folderPath {
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] fileAttributesAtPath:[folderPath stringByAppendingPathComponent:fileName] traverseLink:YES];
        fileSize += [fileDictionary fileSize];
    }
    
    
    static NSString* units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int count = 5;
    
    int index = 0;
    
    while (fileSize > 1024 && count > index) {
        fileSize /= 1024;
        index++;
    }

    return [NSString stringWithFormat:@"%llu %@", fileSize, units[index]];
}
 


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.content count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifierFolder = @"folderCell";
    static NSString* identifierFile = @"fileCell";
    
    NSString* name = [self.content objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString* path = [self.path stringByAppendingPathComponent:name];
        
        FileCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierFolder];
        
        cell.labelFolderTitle.text = name;
        cell.lableFolderSize.text = [self sizeFolderFromValue:path];
        
        return cell;
        
    } else {
        
        NSString* path = [self.path stringByAppendingPathComponent:name];
        
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        
        FileCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierFile];
        
        cell.labelTitle.text = name;
        cell.lableSize.text = [self sizeFileFromValue:path];
        
        static NSDateFormatter* dateFormatter = nil;
        
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        
        cell.labelDateModified.text = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        
        return cell;
    }
    
    return nil;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString* name = [self.content objectAtIndex:indexPath.row];
        NSString* fullPath = [self.path stringByAppendingPathComponent:name];
        
        NSFileManager* defaultManager = [NSFileManager defaultManager];
        NSError* error = nil;
        
        [defaultManager removeItemAtPath:fullPath error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        self.path = _path;
    }
    
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 60.f;
    
    } else {
        return 80.f;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; //забираємо виділення ячейки
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString* fullName = [self.content objectAtIndex:indexPath.row];
        NSString* fullPath = [self.path stringByAppendingPathComponent:fullName];
        
        NBTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NBTableViewController"];
        vc.path = fullPath;
        [self.navigationController pushViewController:vc animated:YES];
        
        /*self.selectedPath = fullPath;
        
        [self performSegueWithIdentifier:@"segueNBTableViewController" sender:nil];*/
    }
}

@end
