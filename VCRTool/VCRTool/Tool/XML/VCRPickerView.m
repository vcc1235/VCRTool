//
//  VCRPickerView.m
//  VCRToolFrame
//
//  Created by alete on 2017/7/10.
//  Copyright © 2017年 aletevcc. All rights reserved.
//

#import "VCRPickerView.h"
#import "VCRLocalXMLParse.h"

#define Rect [UIScreen mainScreen].bounds.size

@interface VCRPickerView () < UIPickerViewDelegate , UIPickerViewDataSource >

@property (nonatomic, strong) UIPickerView *pickerView ;

@property (nonatomic, strong) UIToolbar *toolBar ;

@end


@implementation VCRPickerView{
    
    VCRLocalCountry *__country ;
    VCRLocalCountryRegion *__countryRegion ;
    VCRLocalCity *__city ;
    __weak id <VCRPickerViewDelegate> __delegate ;
    
}


-(instancetype)initSetDelegate:(id<VCRPickerViewDelegate>)delegate{
    
    self = [self init];
    
    __delegate = delegate ;
    
    return self ;
}

- (instancetype)init
{
    self = [[VCRPickerView alloc] initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0,Rect.width,200)];
    if (self) {
        
        CGRect rect = self.frame ;
        rect.origin.x = 0 ;
        rect.origin.y = Rect.height ;
        self.frame = rect ;
        
    }
    return self;
}


-(UIPickerView *)pickerView{
    
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 35, Rect.width, 165)];
//        [_pickerView setBackgroundColor:[UIColor redColor]];
        _pickerView.delegate = self ;
        _pickerView.dataSource = self ;
        
        [self addSubview:_pickerView];
        [self toolBar];
    }
    
    return _pickerView ;
}

-(UIToolbar *)toolBar{
    
    if (!_toolBar) {
        
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, Rect.width, 35)];
        [self addSubview:_toolBar];
        UIButton *item1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [item1 setTitle:@"取消" forState:UIControlStateNormal];
        item1.frame = CGRectMake(10, 5, 50, 25);
        [item1 addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [item1 addTarget:__delegate action:@selector(pickerViewDidCancle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item11 = [[UIBarButtonItem alloc]initWithCustomView:item1];
        UIButton *item2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [item2 setTitle:@"完成" forState:UIControlStateNormal];
        item2.frame = CGRectMake(Rect.width-60, 5, 50, 25);
        [item2 addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [item2 addTarget:__delegate action:@selector(pickerViewDidFinish:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item21 = [[UIBarButtonItem alloc]initWithCustomView:item2];
        _toolBar.items = @[item11,item21,item21,item21,item21];
        
    }

    return _toolBar ;
}

-(void)reloadWithCountry:(VCRLocalCountry *)country{
    
    __country = country ;
    
    if (__country.model.count == 1) {
        __countryRegion = [__country.model firstObject];
        NSArray *array = [__countryRegion.model filteredArrayUsingPredicate:[self predicateWithString:self.province]];
        if ([array count]) {
            NSInteger index = [__countryRegion.model indexOfObject:[array firstObject]];
            [[self pickerView]reloadAllComponents];
            [self.pickerView selectRow:index+1 inComponent:0 animated:YES];
        }
        
        return ;
    }
    NSArray *array = [country.model filteredArrayUsingPredicate:[self predicateWithString:self.province]];
    if ([array count]) {
        __countryRegion = [array firstObject];
        NSInteger index = [country.model indexOfObject:__countryRegion];
        [[self pickerView]reloadAllComponents];
        [[self pickerView]selectRow:index+1 inComponent:0 animated:YES];
    }
    
    NSArray *arraya = [__countryRegion.model filteredArrayUsingPredicate:[self predicateWithString:self.country]];
    if ([arraya count]) {
        __city = [arraya firstObject];
        NSInteger index = [__countryRegion.model indexOfObject:__city];
        [[self pickerView]reloadAllComponents];
        [[self pickerView]selectRow:index+1 inComponent:1 animated:YES];
    }else{
        return ;
    }
    
    if (!__city.model.count) {
        return ;
    }
    
    NSArray *arrays = [__city.model filteredArrayUsingPredicate:[self predicateWithString:self.regitry]];
    if ([arrays count]) {
        NSInteger index = [__city.model indexOfObject:[arrays firstObject]];
        [[self pickerView]reloadAllComponents];
        [self.pickerView selectRow:index+1 inComponent:2 animated:YES];
    }

}

-(NSPredicate *)predicateWithString:(NSString *)string{
    return [NSPredicate predicateWithFormat:@"self.name contains %@",string];
}



-(void)show{
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.frame ;
        frame.origin.y = Rect.height- frame.size.height ;
        self.frame = frame ;
    }];
    
}

-(void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.frame ;
        frame.origin.y = Rect.height ;
        self.frame = frame ;
    }];
    
}

-(void)uninstall{
    
    [self.pickerView removeFromSuperview];
    self.pickerView = nil ;
    __country = nil ;
    __countryRegion = nil ;
    __city = nil ;
    __delegate = nil ;
    [self.toolBar removeFromSuperview];
    self.toolBar = nil ;
    
}


#pragma mark - < UIPickerViewDelegate > -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return __country.index ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    if (component == 0) {
        if (__country.model.count == 1) {
            VCRLocalCountryRegion *_region = [__country.model firstObject];
            return _region.model.count ;
        }
        return __country.model.count+1 ;
    }else if (component == 1){
        return __countryRegion.model.count+1 ;
    }else {
        return __city.model.count+1 ;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return Rect.width/__country.index ;
}


-(NSString *)getTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (row==0) {
        return @"----";
    }
    if (component == 0) {
        if ([__country.model count]==1) {
            
            VCRLocalCountryRegion *region = __country.model[0] ;
            VCRLocalCity *city = region.model[row-1];
            return city.name ;
        }
        VCRLocalCountryRegion *region = __country.model[row-1] ;
        return region.name ;
        
    }else if (component == 1){
        
        VCRLocalCity *city = __countryRegion.model[row-1];
        return city.name ;
        
    }else{
        
        VCRLocalRegion *region = __city.model[row-1] ;
        return  region.name ;
        
    }
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:@"Menlo" size:15];
    label.text = [self getTitleForRow:row forComponent:component];
    label.textAlignment = NSTextAlignmentCenter ;
    return label ;
    
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *string = [self getTitleForRow:row forComponent:component];
    
    if (component == 0) {
        if ([__delegate respondsToSelector:@selector(pickerView:WithCountryRegionString:)]) {
            [__delegate pickerView:self WithCountryRegionString:string];
        }
    }else if (component==1){
        if ([__delegate respondsToSelector:@selector(pickerView:WithCityString:)]) {
            [__delegate pickerView:self WithCityString:string];
        }
    }else{
        if ([__delegate respondsToSelector:@selector(pickerView:WithRecoginString:)]) {
            [__delegate pickerView:self WithRecoginString:string];
        }
    }
    
    if (row == 0) {
        if (component == 0) {
            __countryRegion = nil ;
            __city = nil ;
            [self.pickerView reloadAllComponents];
        }else if(component == 1){
           __city = nil ;
            if (__country.index>2) {
                [self.pickerView reloadComponent:2];
            }
        }
        return ;
    }
    if (__country.index == 1) {
        NSLog(@"%@",string);
        return ;
    }
    
    if (component == 0) {
        
        if (__country.index>1) {
            __countryRegion = __country.model[row-1];
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
        }
 
    }else if (component == 1)
    {
        
        
        if (__country.index > 2) {
            __city = __countryRegion.model[row-1];
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
        
    }
    
    
   
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
