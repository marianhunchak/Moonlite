//
//  MGBookListCell.h
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@protocol MGBookListCellDelegate <NSObject>

- (void) bookListCellDelegateTappedOnBook:(Book *) book;

@end

@interface MGBookListCell : UITableViewCell

@property(strong, nonatomic) NSArray *booksArray;
@property(weak, nonatomic) id <MGBookListCellDelegate> delegate;

@end
