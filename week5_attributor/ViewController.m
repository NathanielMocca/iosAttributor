//
//  ViewController.m
//  week5_attributor
//
//  Created by Mocca Yang on 2017/4/11.
//  Copyright © 2017年 Mocca Yang. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

@end

@implementation ViewController


- (IBAction)touchColorButton:(UIButton *)sender {
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc] initWithAttributedString:[[self mainTextView] attributedText] ] ;
    NSRange range = [[self mainTextView] selectedRange];
    UIColor *buttonBackgroundColor = [sender backgroundColor];
    [attrStr addAttribute:NSForegroundColorAttributeName value:buttonBackgroundColor range:range];
    
    [[self mainTextView] setAttributedText:attrStr];
}
- (IBAction)touchOutlineButton:(id)sender {
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc] initWithAttributedString:[[self mainTextView] attributedText] ] ;
    NSRange range = [[self mainTextView] selectedRange];
    
    [attrStr addAttributes:@{NSStrokeWidthAttributeName: @-5, NSStrokeColorAttributeName: [UIColor orangeColor]} range:range];
    
    [[self mainTextView] setAttributedText:attrStr];

}
- (IBAction)touchUnoutlineButton:(id)sender {
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc] initWithAttributedString:[[self mainTextView] attributedText]];
    NSRange range = [[self mainTextView] selectedRange];
    
    [attrStr removeAttribute:NSStrokeWidthAttributeName range:range];
    [attrStr removeAttribute:NSStrokeColorAttributeName range:range];
    [[self mainTextView] setAttributedText:attrStr];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    [self clearHightlight];
    NSLog(@"%@",searchText);
    NSRange textRange;
    NSRange searchRange = NSMakeRange(0, [[self mainTextView].text length]);
    
    textRange = [[self mainTextView].text rangeOfString:searchText
                                                options:NSCaseInsensitiveSearch
                                                  range:searchRange];
    
    if ( textRange.location == NSNotFound ) {
        // Not there
    } else {
        [self mainTextView].selectedRange = textRange;
        [[self mainTextView] scrollRangeToVisible:textRange];
        [self hightLightText:searchText];
    }
}

-(void)clearHightlight{
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc] initWithAttributedString:[[self mainTextView] attributedText]];
    NSRange wholeRange = NSMakeRange(0, [[self mainTextView].text length]);
    [attrStr removeAttribute:NSBackgroundColorAttributeName range:wholeRange];
    [[self mainTextView] setAttributedText:attrStr];
}

-(void)hightLightText:(NSString *)srcTxt{
    NSLog(@"highlight");
    unsigned long srcTxtLen = [srcTxt length];
    int idx = 0;
    while (idx<(self.mainTextView.text.length-srcTxtLen)) {
        NSRange srcRange = NSMakeRange(idx, srcTxtLen);
        if ([[self.mainTextView.text substringWithRange:srcRange] isEqualToString:srcTxt]) {
            NSMutableAttributedString *tmpAttrTxt = [[NSMutableAttributedString alloc] initWithAttributedString:self.mainTextView.attributedText];
            [tmpAttrTxt addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:srcRange];
            self.mainTextView.attributedText = tmpAttrTxt;
            idx += srcTxtLen;
        } else {
            idx++;
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc] initWithAttributedString:[[self mainTextView] attributedText]];
    NSRange wholeRange = NSMakeRange(0, [[self mainTextView].text length]);
    [attrStr removeAttribute:NSBackgroundColorAttributeName range:wholeRange];
    [[self mainTextView] setAttributedText:attrStr];
}

-(void)preferFontStleChange:(NSNotification *)notification {
    self.mainTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mySearchBar.delegate = self;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"ShowResult"]) {
        SecondViewController *vc2 = [segue destinationViewController];
        NSAttributedString *attrStr =[[NSMutableAttributedString alloc] initWithAttributedString:[[self mainTextView] attributedText]];
        vc2.passedtext = attrStr;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //新增廣播接收設定變化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferFontStleChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    //刪除廣播
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
