//
//  MGBookListCell.m
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGBookListCell.h"
#import "UIImageView+AFNetworking.h"
#import "Book.h"

@interface MGBookListCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewsArray;


@end

@implementation MGBookListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBooksArray:(NSArray *)booksArray {
    
    _booksArray = booksArray;

    NSInteger count = 0;
    
    for (Book *lBook in _booksArray) {
        
        UIImageView *lImageView = _imageViewsArray[count];
        
        [lImageView setImageWithURL:[NSURL URLWithString:lBook.pictureURL] placeholderImage:nil];
        
        lImageView.hidden = NO;
        
        count++;
    }
    
}

#pragma mark - Actions

- (IBAction)tappedOnImageView:(UIButton *)sender {
    
    if (sender.tag < _booksArray.count) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(bookListCellDelegateTappedOnBook:)]) {
            [self.delegate bookListCellDelegateTappedOnBook:_booksArray[sender.tag]];
        }
    }
}


@end
