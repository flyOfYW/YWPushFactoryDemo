# YWPushFactoryDemo
工厂模式封装极光推送和友盟推送，简洁方便

仅需2步就可以使用极光和友盟：
1.修改appkey，在YWPush.h里面修改
2.在appdelegate的didFinishLaunchingWithOptions方法里，写如下代码：

FactoryManager *manager = [FactoryManager new];

manager.delegate = self;


//    需要极光推送，把此注释打开，然后把友盟推送的代码注释掉，其余均不用操作
//    _factory = [manager getJPushFactory:launchOptions];


//    友盟推送
_factory = [manager getUMessageFactory:launchOptions];

具体详情，请参考demo

