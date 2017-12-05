//
//  VCRLocalXMLParse.m
//  VCRToolFrame
//
//  Created by alete on 2017/7/10.
//  Copyright © 2017年 aletevcc. All rights reserved.
//

#import "VCRLocalXMLParse.h"

@interface VCRLocalRegion ()

@property (nonatomic,strong) NSString *name ;

@property (nonatomic,strong) NSString *Code ;

@property (nonatomic,assign) NSInteger sort ;

@end

@implementation VCRLocalRegion

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end






@interface VCRLocalCity ()

@property (nonatomic,strong) NSString *name ;

@property (nonatomic,strong) NSString *Code ;

@property (nonatomic,assign) NSInteger sort ;

@property (nonatomic,strong) NSMutableArray <VCRLocalRegion *> *model ;

@end

@implementation VCRLocalCity

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [NSMutableArray array];
    }
    return self;
}

@end

@interface VCRLocalCountryRegion ()

@property (nonatomic,strong) NSString *name ;

@property (nonatomic,strong) NSString *Code ;

@property (nonatomic,assign) NSInteger sort ;

@property (nonatomic,strong) NSMutableArray <VCRLocalCity *> *model ;

@end

@implementation VCRLocalCountryRegion

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [NSMutableArray array];
    }
    return self;
}

@end



@interface VCRLocalCountry ()


/**
 国名
 */
@property (nonatomic,strong) NSString *name ;


/**
 编码
 */
@property (nonatomic,strong) NSString *Code ;

@property (nonatomic,assign) NSString *sort ;

@property (nonatomic,assign) NSInteger index ;

/**
 省
 */
@property (nonatomic,strong) NSMutableArray <VCRLocalCountryRegion *>*model ;

@end

@implementation VCRLocalCountry

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _model = [NSMutableArray array];
        
    }
    return self;
}

-(void)setName:(NSString *)name{
    
    _name = name ;
    
    _sort = [self firstCharactor:name];
    
}


//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    
    NSArray *array = [pinYin componentsSeparatedByString:@" "];
    
    NSMutableString *string = [[NSMutableString alloc]init];
    
    for (NSString *subString in array) {
        [string appendString:[subString substringToIndex:1]];
    }
    
    return string ;
    
}






@end



@interface VCRLocalXMLData ()

@property (nonatomic,strong) NSMutableArray < VCRLocalCountry * > *model ;

@end

@implementation VCRLocalXMLData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _model = [NSMutableArray array];
        
    }
    return self;
}

@end




#pragma mark -- <XMLParse> --

@interface VCRLocalXMLParse () < NSXMLParserDelegate >


/**
 XML 解析器
 */
@property (nonatomic, strong) NSXMLParser *parser ;

@property (nonatomic,strong) VCRLocalCountry *midModel ;

@property (nonatomic, strong) NSMutableDictionary <NSString *,VCRLocalXMLData *> *model ;

@property (nonatomic, strong) NSMutableArray *datalist ;

@end

static NSString *const Location = @"Location" ;
static NSString *const CountryRegion = @"CountryRegion" ;
static NSString *const State = @"State";
static NSString *const City = @"City" ;
static NSString *const Region = @"Region";

VCRLocalXMLParse *__installLoaclXMLParser ;
@implementation VCRLocalXMLParse{
    
    VCRLocalCountry *__LocalCountry ;
    VCRLocalCountryRegion *__localCountryRegion ;
    VCRLocalCity *__localCity ;
    VCRLocalRegion *__localRegion ;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [self.parser parse];

    }
    return self;
}

#define Charactor @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]
-(NSMutableDictionary<NSString *,VCRLocalXMLData *> *)model{
    
    if (!_model) {
        
        _model = [NSMutableDictionary dictionary];
        
        for (NSString *key in Charactor) {
            VCRLocalXMLData *xmldata = [[VCRLocalXMLData alloc]init];
            [_model setObject:xmldata forKey:key];
        }
        
    }
    
    return _model ;
}


-(NSXMLParser *)parser{
    
    if (!_parser) {
        _parser = [[NSXMLParser alloc]initWithContentsOfURL:[[NSBundle bundleForClass:self.class] URLForResource:@"world.xml" withExtension:nil]];
        _parser.delegate = self ;
    }
    return _parser ;
    
}

static dispatch_once_t onceToken;

+(instancetype)startParserXML{

    dispatch_once(&onceToken, ^{
        __installLoaclXMLParser = [[VCRLocalXMLParse alloc]init];
    });
    return __installLoaclXMLParser ;
    
}



/**
 <#Description#>

 @param country <#country description#>
 @return <#return value description#>
 */
-(VCRLocalCountry *)setLocalCountry:(NSString *)country {
    
    if (country && country.length) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name==%@",country];
        
        NSArray *array = [self.datalist filteredArrayUsingPredicate:predicate];
        
        if ([array count]) {
           self.midModel = [array firstObject];
        }
        
    }
    return self.midModel ;
    
}


/**
 销毁单例
 */
-(void)unistallLocalXML{
    
    onceToken = 0 ;
    __installLoaclXMLParser = nil ;
    self.parser = nil ;
    
}




#pragma mark - <XMLParser Delegate > -

// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
     _datalist = [NSMutableArray array];
    
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    [self.datalist sortUsingComparator:^NSComparisonResult(VCRLocalCountry * _Nonnull obj1, VCRLocalCountry *  _Nonnull obj2) {
        return [obj1.sort compare:obj2.sort];
    }];
    
    for (VCRLocalCountry *_s in self.datalist) {
        
        NSString *key = [_s.sort substringToIndex:1];
        
        VCRLocalXMLData *data = [self.model objectForKey:key];
        
        [data.model addObject:_s];
        
    }
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{

    //NSLog(@"%s--->(%@--%@--%@)",__func__,elementName,qName,attributeDict);
    
    if ([elementName isEqualToString:Location]) {
        
        
    }else if ([elementName isEqualToString:CountryRegion]){
        
        __LocalCountry = [[VCRLocalCountry alloc]init];
        if ([attributeDict count]) {
            NSString *name = [attributeDict valueForKey:@"Name"];
            NSString *code = [attributeDict valueForKey:@"Code"];
            __LocalCountry.name = name ;
            __LocalCountry.Code = code ;

        }
        __LocalCountry.index = 0 ;
        [self.datalist addObject:__LocalCountry];
        
    }else if([elementName isEqualToString:State]){
        
        __localCountryRegion = [[VCRLocalCountryRegion alloc]init];
        
        if ([attributeDict count]) {
            NSString *name = [attributeDict valueForKey:@"Name"];
            NSString *code = [attributeDict valueForKey:@"Code"];
            __localCountryRegion.name = name ;
            __localCountryRegion.Code = code ;
            
        }
        [__LocalCountry.model addObject:__localCountryRegion];
        if (__LocalCountry.index>0) {
            return ;
        }
        __LocalCountry.index = 1 ;
        
    }else if([elementName isEqualToString:City]){
        
        __localCity = [[VCRLocalCity alloc]init];
        if ([attributeDict count]) {
            NSString *name = [attributeDict valueForKey:@"Name"];
            NSString *code = [attributeDict valueForKey:@"Code"];
            __localCity.name = name ;
            __localCity.Code = code ;
            
        }
        [__localCountryRegion.model addObject:__localCity];
        
        if (__LocalCountry.index>1) {
            return ;
        }
        if (__localCountryRegion.name) {
           __LocalCountry.index = 2 ;
        }
    }else if ([elementName isEqualToString:Region]){
        
        VCRLocalRegion *region = [[VCRLocalRegion alloc]init];
        
        if ([attributeDict count]) {
            NSString *name = [attributeDict valueForKey:@"Name"];
            NSString *code = [attributeDict valueForKey:@"Code"];
            region.name = name ;
            region.Code = code ;
            
        }
        
        [__localCity.model addObject:region];
        
        if (__LocalCountry.index>2) {
            return ;
        }
        __LocalCountry.index = 3 ;
    }
    
}




@end
