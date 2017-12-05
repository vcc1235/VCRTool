//
//  VCRLocalXMLParse.h
//  VCRToolFrame
//
//  Created by alete on 2017/7/10.
//  Copyright © 2017年 aletevcc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 地级区 */
@interface VCRLocalRegion : NSObject

@property (nonatomic,strong,readonly) NSString *name ;

@property (nonatomic,strong,readonly) NSString *Code ;

@property (nonatomic,assign,readonly) NSInteger sort ;

@end


/** 地级市 */
@interface VCRLocalCity : NSObject

@property (nonatomic,strong,readonly) NSString *name ;

@property (nonatomic,strong,readonly) NSString *Code ;

@property (nonatomic,assign,readonly) NSInteger sort ;

@property (nonatomic,strong,readonly) NSMutableArray <VCRLocalRegion *> *model ;

@end


/** 省级 */
@interface VCRLocalCountryRegion : NSObject

@property (nonatomic,strong,readonly) NSString *name ;

@property (nonatomic,strong,readonly) NSString *Code ;

@property (nonatomic,assign,readonly) NSInteger sort ;

@property (nonatomic,strong,readonly) NSMutableArray <VCRLocalCity *> *model ;

@end


/** 国家**/
@interface VCRLocalCountry : NSObject


/**
 国名
 */
@property (nonatomic,strong,readonly) NSString *name ;


/**
 编码
 */
@property (nonatomic,strong,readonly) NSString *Code ;

@property (nonatomic,assign,readonly) NSString *sort ;

@property (nonatomic,assign,readonly) NSInteger index ;

/**
 省
 */
@property (nonatomic,strong,readonly) NSMutableArray <VCRLocalCountryRegion *>*model ;

@end



@interface VCRLocalXMLData : NSObject

@property (nonatomic,strong,readonly) NSMutableArray < VCRLocalCountry * > *model ;

@end



@interface VCRLocalXMLParse : NSObject

@property (nonatomic, strong,readonly) NSMutableDictionary <NSString *,VCRLocalXMLData *> *model ;
/**
 初始化单例

 */
+(instancetype)startParserXML;

/**
 根据国家名 获取
 
 @param country <#country description#>
 @return <#return value description#>
 */
-(VCRLocalCountry *)setLocalCountry:(NSString *)country ;


/**
 销毁单例
 */
-(void)unistallLocalXML ;

@end
