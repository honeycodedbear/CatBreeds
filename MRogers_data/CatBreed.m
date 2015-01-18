//
//  CatBreed.m
//  MRogers_data
//
//  Created by Max Rogers on 11/11/14.
//  Copyright (c) 2014 Max Rogers. All rights reserved.
//

#import "CatBreed.h"

@implementation CatBreed
static NSString *databasePath;
static sqlite3 *contactDB;

- (id)init{
    self = [super init];
    if (self)
    {
        _name = @"American Shorthair";
        _blurb = @"The American Shorthair is a breed of domestic cat believed to be descended from European cats brought to North America by early settlers to protect valuable cargo from mice and rats.";
        _type = @"Short";
        _origin = @"USA";
        //[self createDatabase];
        //[self saveData];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name Blurb:(NSString *)blurb Type:(NSString *)type Origin:(NSString *)origin Id:(int) sqliteId{
    self = [super init];
    if (self)
    {
        _name = name;
        _blurb = blurb;
        _type = type;
        _origin = origin;
        _sqliteId = sqliteId;
        //[self createDatabase];
        //[self saveData];
    }
    
    return self;
}
-(void) updateSelf{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"UPDATE cat SET name = \'%@\', blurb = \'%@\', type = \'%@\', origin = \'%@\' WHERE id= %d",
                               _name, _blurb, _type, _origin, _sqliteId];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Success");
            NSLog(@"%@",[CatBreed sqlite3StmtToString: statement]);

        } else {
            NSLog(@"Failed to update cat");
            NSLog(@"%@",[CatBreed sqlite3StmtToString: statement]);

        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}
+(void) deleteCat:(CatBreed *)cat{
    NSLog(@"DELETE KITTY");
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"DELETE FROM CAT WHERE id= %d",cat.sqliteId];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Success");
            NSLog(@"%@",[self sqlite3StmtToString: statement]);
        } else {
            NSLog(@"Failed to delete cat");
            NSLog(@"%@",[self sqlite3StmtToString: statement]);
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}


-(NSString *)description{
   return [self print];
}
-(NSString *)print{
    return [NSString stringWithFormat:@"\n%@:%@:%@:%@\n",_name, _blurb, _type, _origin];
}

+(NSMutableString*) sqlite3StmtToString:(sqlite3_stmt*) statement
{
    NSMutableString *s = [NSMutableString new];
    [s appendString:@"{\"statement\":["];
    for (int c = 0; c < sqlite3_column_count(statement); c++){
        [s appendFormat:@"{\"column\":\"%@\",\"value\":\"%@\"}",[NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, c)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, c)]];
        if (c < sqlite3_column_count(statement) - 1)
            [s appendString:@","];
    }
    [s appendString:@"]}"];
    return s;
}

+(CatBreed*)sqlite3StmtToCatBreed:(sqlite3_stmt*) statement{
    return [[CatBreed alloc] initWithName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)]
                            Blurb:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]
                            Type:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]
                            Origin:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]
                                       Id: sqlite3_column_int(statement, 4)];
}

+ (CatBreed *)getCat:(int) sqliteId{
    CatBreed *cat = nil;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT name, blurb, type, origin, id FROM cat WHERE id='%d'", sqliteId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"%@",[self sqlite3StmtToString:statement]);
                cat = [[CatBreed alloc]
                        initWithName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)]
                        Blurb:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]
                        Type:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]
                        Origin:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]
                        Id:sqlite3_column_int(statement, 4)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }else{
        NSLog(@"Couldn't Find Database");
    }
    return cat;
}

+(NSMutableArray *)getAll{
    NSMutableArray *result = nil;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT name, blurb, type, origin, id FROM cat "];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            result = [NSMutableArray array];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //NSLog(@"%@",[self sqlite3StmtToString:statement]);
                [result addObject:[CatBreed sqlite3StmtToCatBreed:statement]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }else{
        NSLog(@"Couldn't Find Database");
    }
    return result;
}

- (void)saveData{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CAT (name, origin, type, blurb) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
                               _name, _origin, _type, _blurb];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Success");
        } else {
            NSLog(@"Failed to add cat");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

-(void) createDatabase{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"cats.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //check if database already exists
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CAT (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ORIGIN TEXT, TYPE TEXT, BLURB TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog( @"Failed to create table");
            }
            sqlite3_close(contactDB);
        } else {
            NSLog( @"Failed to open/create database");
        }
    }
}

+(void) createDatabase{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"cats.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //check if database already exists
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CAT (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ORIGIN TEXT, TYPE TEXT, BLURB TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog( @"Failed to create table");
            }
            sqlite3_close(contactDB);
        } else {
            NSLog( @"Failed to open/create database");
        }
        
        
    }
}
@end
