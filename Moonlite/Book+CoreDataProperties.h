//
//  Book+CoreDataProperties.h
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fileURL;
@property (nullable, nonatomic, retain) NSNumber *id_;
@property (nullable, nonatomic, retain) NSNumber *updateNumber;
@property (nullable, nonatomic, retain) NSString *pictureURL;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
