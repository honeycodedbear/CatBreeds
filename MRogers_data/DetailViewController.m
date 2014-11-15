//
//  DetailViewController.m
//  MRogers_data
//
//  Created by Max Rogers on 11/11/14.
//  Copyright (c) 2014 Max Rogers. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

-(IBAction)edit:(id)sender{
    if (self.detailItem) {
        //Check if Edit button is Edit
        if([_editBtn.title isEqualToString:@"Edit"]){
            NSLog(@"\nNow in Edit Mode\n");
            _editBtn.title = @"Save";
            [self.nameField setHidden:false];
            [self.originField setHidden:false];
            [self.typeField setHidden:false];
            [self.blurbField setHidden:false];
            [self.nameLabel setHidden:true];
            [self.originLabel setHidden:true];
            [self.typeLabel setHidden:true];
            [self.blurbLabel setHidden:true];
        }else{
            _editBtn.title = @"Edit";
            NSLog(@"\nNow in Save Mode\n");
            [self.nameField setHidden:true];
            [self.originField setHidden:true];
            [self.typeField setHidden:true];
            [self.blurbField setHidden:true];
            [self.nameLabel setHidden:false];
            [self.originLabel setHidden:false];
            [self.typeLabel setHidden:false];
            [self.blurbLabel setHidden:false];
            [self updateCat];
        }
    }
}

-(void)updateCat{
    CatBreed *cat = (CatBreed *)self.detailItem;
    cat.name = self.nameField.text;
    cat.origin = self.originField.text;
    cat.type = self.typeField.text;
    cat.blurb = self.blurbField.text;
    self.nameLabel.text = cat.name;
    self.blurbLabel.text = cat.blurb;
    self.typeLabel.text = cat.type;
    self.originLabel.text = cat.origin;
    self.nameField.text = cat.name;
    self.originField.text = cat.origin;
    self.typeField.text = cat.type;
    self.blurbField.text = cat.blurb;
    [cat updateSelf];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        CatBreed *cat = (CatBreed *)self.detailItem;
        //self.detailDescriptionLabel.text = cat.name;
        self.nameLabel.text = cat.name;
        self.blurbLabel.text = cat.blurb;
        self.typeLabel.text = cat.type;
        self.originLabel.text = cat.origin;
        self.nameField.text = cat.name;
        self.originField.text = cat.origin;
        self.typeField.text = cat.type;
        self.blurbField.text = cat.blurb;
        [self.nameField setHidden:true];
        [self.originField setHidden:true];
        [self.typeField setHidden:true];
        [self.blurbField setHidden:true];
        
        [self asyncFetchImageFromUrl:@"http://imgstocks.com/wp-content/uploads/2013/11/10-friendly-cat-breeds-for-houses-list-visit.jpg" Completion:^(UIImage *img) {
            _imageView.image = img;
        }];
    }
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    //NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

#pragma mark - async queue & async tasks

+(dispatch_queue_t)asyncQueue {
    static dispatch_queue_t sharedQueue = nil;
    if(sharedQueue == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedQueue = dispatch_queue_create("image.worker.queue", NULL);
        });
    }
    return sharedQueue;
}

-(void)asyncFetchImageFromUrl:(NSString *)fileURL Completion:(void (^)(UIImage* img))completion {
    dispatch_async([[self class] asyncQueue], ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion(image);
            }
        });
    });
}

@end
