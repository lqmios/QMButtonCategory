//
//  UIControl+QMButtonClickDelay.m
//  QMButtonCategory
//
//  Created by Match on 2017/11/7.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "UIControl+QMButtonClickDelay.h"
#import <objc/runtime.h>

@interface UIControl ()

/**是否忽略点击*/
@property (nonatomic,assign) BOOL qm_ignoreEvent;

@end

@implementation UIControl (QMButtonClickDelay)

/**在load方法里面进行方法交换*/
+ (void)load
{
 /**
  class_getInstanceMethod       得到类的 实例方法
  class_getClassMethod          得到类的 类方法

  */
    /**获取方法*/
    Method qmSys_Method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method qmAdd_Method = class_getInstanceMethod(self, @selector(qm_sendAction:to:forEvent:));
    /**方法交换*/
    method_exchangeImplementations(qmSys_Method, qmAdd_Method);
    
}

- (void)qm_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.qm_ignoreEvent) {
        return;
    }
    if (self.qm_acceptEventInterval > 0) {
        self.qm_ignoreEvent = YES;
        /**延迟函数*/
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.qm_acceptEventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.qm_ignoreEvent = NO;
        });
    }
    [self qm_sendAction:action to:target forEvent:event];
    
}


#pragma mark --手动实现setter getter方法

- (void)setQm_acceptEventInterval:(NSTimeInterval)qm_acceptEventInterval
{
    /**这四个后面的参数分别表示:源对象，关键字，关联的对象和一个关联策略。
     
     
     id object 表示关联者，是一个对象，变量名理所当然也是object
     id value 表示被关联者，我们可以看到它的变量名是value，我们这里一定要理解这个value最后是要关联到object上的。
     objc_setAssociatedObject(<#id  _Nonnull object#>, <#const void * _Nonnull key#>, <#id  _Nullable value#>, <#objc_AssociationPolicy policy#>)
     */
 
    objc_setAssociatedObject(self, @selector(qm_acceptEventInterval), @(qm_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)qm_acceptEventInterval
{
    return [objc_getAssociatedObject(self,_cmd) doubleValue];
}

- (void)setQm_ignoreEvent:(BOOL)qm_ignoreEvent
{
    
    objc_setAssociatedObject(self, @selector(qm_ignoreEvent), @(qm_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)qm_ignoreEvent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

























