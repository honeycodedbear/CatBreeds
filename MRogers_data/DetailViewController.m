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
        [self getImageFromURL:@"http://imgstocks.com/wp-content/uploads/2013/11/10-friendly-cat-breeds-for-houses-list-visit.jpg"];
    }
}

-(void) getImageFromURL:(NSString *)fileURL {
    //UIImage * result;
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileURL]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    //result = [UIImage imageWithData:_responseData];
   // NSLog(@"%@",data);
   // return result;
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
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    [self.imageView setImage: [UIImage imageWithData:_responseData]];
    NSLog(@"LOL");
    //NSLog(@"%@",_responseData);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
