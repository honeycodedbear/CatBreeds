//
//  CatBreed.h
//  MRogers_data
//
//  Created by Max Rogers on 11/11/14.
//  Copyright (c) 2014 Max Rogers. All rights reserved.
//
#import <sqlite3.h>
#import <Foundation/Foundation.h>

@interface CatBreed : NSObject
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

@property NSString *name;
@property NSString *type;
@property NSString *origin;
@property NSString *blurb;
@property int sqliteId;

- (void) createDatabase;
- (void)saveData;
+ (NSMutableArray *)getAll;

-(NSString *)print;
- (id)initWithName:(NSString *)name Blurb:(NSString *)blurb Type:(NSString *)type Origin:(NSString *)origin Id:(int) sqliteId;

+ (void) createDatabase;
+ (CatBreed *)getCat:(int) sqliteId;
+ (void)saveCat:(CatBreed *)cat;
- (void)saveSelf;

+(void) updateCat:(CatBreed *)cat;
-(void) updateSelf;
+(void) deleteCat:(CatBreed *)cat;
-(void) deleteSelfFromTable;
-(NSString *) description;
@end


//Static Methods
//Create Database
//Get All CatBreeds
//Get CatBreed from Database
//Get CatBreed from Database use ID
//Save CatBreed into Database

//InstanceMethods
//Save Self in Database
