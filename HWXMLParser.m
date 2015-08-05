//
//  HWXMLParser.m
//  XML解析
//
//  Created by 黄伟 on 15/1/21.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "HWXMLParser.h"

@interface HWXMLParser ()<NSXMLParserDelegate>

//数组里存的字典
@property(nonatomic,strong) NSMutableDictionary *dict;

//临时数组
@property(nonatomic,strong) NSMutableArray *arrayTemp;

//结果数组
@property(nonatomic,strong) NSArray *result;

//内容字符串部分，用于拼接
@property(nonatomic,copy)NSMutableString *elementSub;

@end

//根元素
static NSString *unit;

//元素
static NSString *subUnit;

@implementation HWXMLParser

//data的setter方法，通过给data赋值，进行对xml解析
-(void)setData:(NSData *)data{
    _data = data;
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    [parser parse];
}

#pragma mark -xmlArray的getter方法
-(NSArray *)xmlArray{
    
    //不给data 的话就没有结果
    if (!self.data) {
        return nil;
    }
    return self.result;
}

#pragma mark -懒加载
-(NSMutableString *)elementSub{
    if (_elementSub == nil) {
        _elementSub = [NSMutableString string];
    }
    return _elementSub;
}


-(NSMutableArray *)arrayTemp{
    if (_arrayTemp == nil) {
        _arrayTemp = [NSMutableArray array];
    }
    return _arrayTemp;
}
-(NSMutableDictionary *)dict{
    if (_dict == nil) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}


#pragma mark -NSXMLParser delegate
//打开文档，开始解析
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    [self.arrayTemp removeAllObjects];
}

//遇到元素的开始标签，开始解析元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    if (unit == nil) {//获得根元素名
        unit = elementName;
    }else{
        if (subUnit == nil) {//获得元素名
            subUnit = elementName;
        }
        if ([elementName isEqualToString:subUnit]) {
            
            //有属性的话，就把属性及其值也作为键值存到字典里
            if (self.attribute) {
                 self.dict[self.attribute] = attributeDict[self.attribute];
            }
        }else{
            self.elementSub.string = @"";
        }
    }
  
}

//遇到元素的内容
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.elementSub appendString:string];
    
}

//遇到元素的结束标签
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:subUnit]) {
        if (self.dict) {
            [self.arrayTemp addObject:self.dict];
            self.dict = nil;
        }
    }else if ([elementName isEqualToString:unit]){
        
    }else{
        
        self.dict[elementName] = [self.elementSub copy];
    }
}

//结束文档
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    self.result = self.arrayTemp;
}

//出错
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",parseError);
}
@end
