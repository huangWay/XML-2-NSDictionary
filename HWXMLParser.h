//
//  HWXMLParser.h
//  XML解析
//
//  Created by 黄伟 on 15/7/21.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWXMLParser : NSObject

//最终结果，返回的是将xml格式转化成存着字典的数组
@property(nonatomic,strong) NSArray *xmlArray;

//如果标签有属性，就要设置
@property(nonatomic,copy)NSString *attribute;

//xml格式的数据
@property(nonatomic,strong) NSData *data;

@end
