//
//  DetailViewController.h
//  MRogers_data
//
//  Created by Max Rogers on 11/11/14.
//  Copyright (c) 2014 Max Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatBreed.h"
@interface DetailViewController : UIViewController <NSURLConnectionDelegate>{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *originLabel;
@property IBOutlet UILabel *typeLabel;
@property IBOutlet UILabel *blurbLabel;
@property IBOutlet UIBarButtonItem *editBtn;
@property IBOutlet UITextField *nameField;
@property IBOutlet UITextField *originField;
@property IBOutlet UITextField *typeField;
@property IBOutlet UITextField *blurbField;
@property IBOutlet UIImageView *imageView;
-(IBAction)edit:(id)sender;
@end

