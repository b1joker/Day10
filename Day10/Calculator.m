//
//  Calculator.m
//  Day10
//
//  Created by Gin on 7/12/14.
//  Copyright (c) 2014 Nguyễn Huỳnh Lâm. All rights reserved.
//

#import "Calculator.h"
//#import "DDMathParser/DDMathParser.h"

@interface Calculator ()
{
    __weak IBOutlet UILabel *result;
    NSString* str;
    BOOL percent,minus,plus,divide,multiply,comma,tapFunction,operation,per;
    double number,number2;
}

@end

@implementation Calculator

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    str = @"";
    [self rsOperation];
    tapFunction = NO;
    operation = NO;comma = NO;
    per = NO;

}
- (IBAction)reset:(id)sender { // trạng thái YES là đã kích hoạt
    result.text = @"0";
    str = @"";
    tapFunction = NO;
    operation = NO;
    comma = NO;
    number = 0.0;
    per = NO;
}

- (IBAction)numberTap:(id)sender {
    tapFunction = NO;

    NSString *button = [(UIButton*)sender currentTitle];
    
    if(str.length < 10)
    {
        str = [str stringByAppendingString: button];
        result.text = str;
    }
}
- (IBAction)comma:(id)sender {
    if(comma == NO)
    {
        str = [str stringByAppendingString: @"."];

        comma = YES;
        result.text = str;

    }
}

-(void) rsOperation
{
    str = @"";
    multiply = NO;divide = NO;
    minus = NO;plus = NO;
    comma = NO;

}

- (IBAction)functionTap:(id)sender {
    
    NSString *button = [(UIButton*)sender currentTitle]; // lấy title name button
    
    comma = NO;per = NO;
    if(tapFunction == NO)// tránh trường hợp ấn phép tính > 2 lần bị lỗi
    {
        if(operation == NO) // chỉ lưu số ở lần đầu tiên, lần sau ghi nhớ number = kết quả lần trước, dùng khi ấn phép tính liên tục (a + b - c * d...)
        {
            number = [result.text doubleValue];
            operation = YES; // đã có phép tính thì ko lưu nữa, để hàm solve rồi xử lí (
        }
        
        if(multiply == YES || divide == YES || plus == YES || minus == YES) //  có phép tính trước đấy
            [self solve];
        
        str = @"";
        
        tapFunction = YES;
    }
    
        
    if([button isEqualToString: @"X"]) // tránh trường hợp ấn nhiều phép toán
    {
        [self rsOperation];
        multiply = YES;
    }
    if([button isEqualToString: @"/"])
    {
        [self rsOperation];
        divide = YES;
    }
    if([button isEqualToString: @"+"])
    {
        [self rsOperation];
        plus = YES;
    }
    if([button isEqualToString: @"-"])
    {
        [self rsOperation];
        minus = YES;
    }
}

- (IBAction)showResult:(id)sender { // thiếu trường hợp phép tính tiếp
    [self solve];
    operation = NO;
}

-(void) solve
{
    number2 =  [result.text doubleValue];
    
    double dbRe = 0.0;
    
    if(divide == YES) // chia 0
    {
        if(number2 == 0)
            result.text = @"Syntax Error";
        else
            dbRe = number/number2;
    }
    if(multiply == YES)
        dbRe = number*number2;
    if(plus == YES)
        dbRe = number + number2;
    if(minus == YES)
        dbRe = number - number2;
    
    if(multiply == YES || divide == YES || plus == YES || minus == YES) //  có phép tính trước đấy
        result.text = [NSString stringWithFormat:@"%g", dbRe];
    else // Trường hợp ấn nút = nhiều lần ==> vẫn hiện giá trị cũ
            result.text = [NSString stringWithFormat:@"%g", [result.text doubleValue]];

    number = dbRe;
    
    [self rsOperation];
    
}
- (IBAction)tive:(id)sender {

    double t = [result.text doubleValue];
    str = @"";
    result.text = [NSString stringWithFormat:@"%g", t*-1];
    

}
- (IBAction)percent:(id)sender {
    double t = [result.text doubleValue];
    
    if(per == NO)
    {
        per = YES;
        str = @"";
        result.text = [NSString stringWithFormat:@"%g", t/100.0];
    }
}

@end
