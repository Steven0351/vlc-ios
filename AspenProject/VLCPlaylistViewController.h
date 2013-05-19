//
//  VLCMasterViewController.h
//  AspenProject
//
//  Created by Felix Paul Kühne on 27.02.13.
//  Copyright (c) 2013 VideoLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@class VLCMovieViewController;
@class VLCAboutViewController;
@class VLCPasscodeLockViewController;
@class VLCAddMediaViewController;

@interface VLCPlaylistViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UIPopoverControllerDelegate>
{
    BOOL _editMode;
}

@property (nonatomic, retain) NSDate *nextPasscodeCheckDate;
@property (nonatomic) BOOL passcodeValidated;

@property (nonatomic, strong) VLCMovieViewController *movieViewController;
@property (nonatomic, strong) VLCAboutViewController *aboutViewController;
@property (nonatomic, strong) VLCPasscodeLockViewController *passcodeLockViewController;
@property (nonatomic, strong) VLCAddMediaViewController *addMediaViewController;

@property (nonatomic, strong) UIPopoverController *addMediaPopoverController;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet AQGridView *gridView;

@property (nonatomic, strong) IBOutlet UIView *emptyLibraryView;
@property (nonatomic, strong) IBOutlet UILabel *emptyLibraryLabel;
@property (nonatomic, strong) IBOutlet UILabel *emptyLibraryLongDescriptionLabel;

- (IBAction)leftButtonAction:(id)sender;

- (void)validatePasscode;
- (void)updateViewContents;
- (void)openMovieFromURL:(NSURL *)url;
- (void)removeMediaObject:(MLFile *)mediaObject;

@end
