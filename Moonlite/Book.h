//
//  Book.h
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSManagedObject

+ (Book *)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

#import "Book+CoreDataProperties.h"
