//
//  VCRPickerViewController.m
//  VCRTool
//
//  Created by alete on 2017/12/5.
//  Copyright © 2017年 aletevcc. All rights reserved.
//

#import "VCRPickerViewController.h"

#import "VCRPickerView.h"
#import "VCRLocalXMLParse.h"

@interface VCRPickerViewController () < VCRPickerViewDelegate >

@property (weak, nonatomic) IBOutlet UITextField *textField1;

@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UITextField *textField3;

@property (weak, nonatomic) IBOutlet UITextField *textField4;


@property (nonatomic, strong) VCRPickerView *pickerView ;

@end

@implementation VCRPickerViewController
VCRLocalXMLParse *__parser ;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    __parser = [VCRLocalXMLParse startParserXML];
    

    
}


-(VCRPickerView *)pickerView{
    
    if (!_pickerView) {
        _pickerView = [[VCRPickerView alloc]initSetDelegate:self];
        [self.view addSubview:_pickerView];
    }
    return _pickerView ;
    
}


- (IBAction)buttonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    VCRLocalCountry *_s = [__parser setLocalCountry:self.textField1.text];
    
    self.pickerView.province = self.textField2.text;
    
    self.pickerView.country = self.textField3.text;
    
    self.pickerView.regitry = self.textField4.text;
    
    [self.pickerView reloadWithCountry:_s];
    
    [self.pickerView show];
    
}

/**
 完成
 
 @param pickerView <#pickerView description#>
 */
-(void)pickerViewDidFinish:(VCRPickerView *)pickerView {
    
    
}



/**
 取消
 
 @param pickerView <#pickerView description#>
 */
-(void)pickerViewDidCancle:(VCRPickerView *)pickerView {
    
    
    
}

/** 返回县级 */
-(void)pickerView:(VCRPickerView *)pickerView WithRecoginString:(NSString *)region {
    
}


/** 返回市级 */
-(void)pickerView:(VCRPickerView *)pickerView WithCityString:(NSString *)city {
    
}


/** 返回省级 */
-(void)pickerView:(VCRPickerView *)pickerView WithCountryRegionString:(NSString *)region {
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
