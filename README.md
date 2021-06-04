解压缩后直接运行AppleStoreTopApplications.xcworkspace来运行测试项目

项目的一些说明:
1.项目的架构及项目开发的简单说明: 简单的运用MVVM设计模式来进行项目的开发, 简单的对AFNetworking二次封装并适配进ViewModel类, 简单的对FMDB进行二次多线程组操作数据库封装及暴露相应所需接口
2.项目的功能:
    1.根据提供的api展示推荐类的10个app
    2.根据提供的api展示免费类的app,实现10个为1页的分页加载
    3.所有数据存储数据库并提供数据库有数据时首先从数据库加载流程
    4.支持模糊匹配app名字,app描述,app开发者的实时数据库搜索并展示相应结果
3.项目运用到的一些常见第三方库有:
    1.刷新类:MJRefresh 
    2.图片加载类:SDWebImage
    3.布局类:Masonry
    4.网络请求类:AFNetworking
    5.数据库类:FMDB
4.项目中遇到的一点小问题:
    1.因apple提供的查询接口https://itunes.apple.com/hk/rss/topfreeapplications 是没有我们所需的评论数及评分等级的,需要二次在https://itunes.apple.com/hk/lookup?id= 接口处获取到所需数据, 所以相应的ViewModel里运用GCD多并发线程对每一个app数据的单独获取操作处理
    
总结:项目的完成度大致满足了需求,因时间有限只能在空闲时间来抽空完成,一些可以优化地方及瑕疵还没仔细处理. 感谢贵公司提供的这次面试及测试机会,让我也收获到了一些知识点,最后祝愿贵公司蓬勃发展,日胜一日!
