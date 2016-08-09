//
//  Book.m
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "Book.h"
#import "NSDictionary+Accessors.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Book

+ (Book *)initWithDict:(NSDictionary *)dict {
    
    Book *existingBook = [Book MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"id_ == %@", [dict numberForKey:@"id"]]];
    
    if (existingBook) {
        return existingBook;
    }
    
    Book *lBook = [Book MR_createEntity];
    
    lBook.id_ = [dict numberForKey:@"id"];
    lBook.name = [dict stringForKey:@"name"];
    lBook.pictureURL = [dict[@"picture"] stringForKey:@"url"];
    lBook.fileURL = [dict[@"file"] stringForKey:@"url"];
    lBook.updateNumber = [dict numberForKey:@"update_number"];
    
    return lBook;
}

@end
