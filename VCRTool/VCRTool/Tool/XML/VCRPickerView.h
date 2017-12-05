//
//  VCRPickerView.h
//  VCRToolFrame
//
//  Created by alete on 2017/7/10.
//  Copyright © 2017年 aletevcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCRPickerView ;
@protocol VCRPickerViewDelegate <NSObject>

@required
/**
 完成
 
 @param pickerView <#pickerView description#>
 */
-(void)pickerViewDidFinish:(VCRPickerView *)pickerView ;



/**
 取消
 
 @param pickerView <#pickerView description#>
 */
-(void)pickerViewDidCancle:(VCRPickerView *)pickerView ;


@optional
/** 返回县级 */
-(void)pickerView:(VCRPickerView *)pickerView WithRecoginString:(NSString *)region ;


/** 返回市级 */
-(void)pickerView:(VCRPickerView *)pickerView WithCityString:(NSString *)city ;


/** 返回省级 */
-(void)pickerView:(VCRPickerView *)pickerView WithCountryRegionString:(NSString *)region ;





@end




@class VCRLocalCountry ;
@interface VCRPickerView : UIView

// 省
@property (nonatomic, copy) NSString *province ;
// 市
@property (nonatomic, copy) NSString *country ;
// 区
@property (nonatomic, copy) NSString *regitry ;


/**
 初始化

 @param delegate <#delegate description#>
 @return <#return value description#>
 */
-(instancetype)initSetDelegate:(id<VCRPickerViewDelegate>)delegate ;



/**
 刷新

 @param country <#country description#>
 */
-(void)reloadWithCountry:(VCRLocalCountry *)country ;


/**
 显示
 */
-(void)show ;


/**
 隐藏
 */
-(void)hidden ;


/**
 销毁
 */
-(void)uninstall ;



@end











