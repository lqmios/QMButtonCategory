//
//  ViewController.m
//  QMButtonCategory
//
//  Created by Match on 2017/11/7.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+QMButtonClickDelay.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *normolButton;
@property (weak, nonatomic) IBOutlet UIButton *delayButton;

@property (weak, nonatomic) IBOutlet UITextView *qmTextView;
/** 打印文字 */
@property(nonatomic, strong)NSString *logTextString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logTextString = @"";
    self.qmTextView.text = self.logTextString;
    
    [self.normolButton addTarget:self action:@selector(normolButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.delayButton addTarget:self action:@selector(delayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    /**延迟两秒执行*/
    self.delayButton.qm_acceptEventInterval = 10.0f;
    
}
- (void)normolButtonAction:(UIButton *)sender
{
    NSLog(@"正常button");
    self.logTextString = [self.logTextString stringByAppendingString:[NSString stringWithFormat:@"\n%@", @"正常按钮点击"]];
    self.qmTextView.attributedText = [self getAttrString];
}

- (void)delayButtonAction:(UIButton *)sender

{
    NSLog(@"延迟1秒执行");
    self.logTextString = [self.logTextString stringByAppendingString:[NSString stringWithFormat:@"\n%@", @"延迟按钮点击"]];
    self.qmTextView.attributedText = [self getAttrString];
    
}

- (NSAttributedString *)getAttrString
{
    NSString *pattern = @"延迟按钮点击";
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc]initWithString:self.logTextString attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray<NSTextCheckingResult *> * results = [regular matchesInString:self.logTextString options:NSMatchingReportProgress range:NSMakeRange(0, self.logTextString.length)];
    for (NSTextCheckingResult *result in results) {
        
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"延迟按钮点击" attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
        [attrStringM replaceCharactersInRange:result.range withAttributedString:attr];
    }
    return [attrStringM copy];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
