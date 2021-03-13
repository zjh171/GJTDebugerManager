//
//  GJTDebugerHomeSectionView.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerHomeSectionView.h"
#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerDefine.h"
#import "GJTDebugerPluginProtocol.h"
#import "UIImage+GJTDebuger.h"
//#import <GJTTracker/GJTTracker.h>

@interface GJTDebugerHomeSectionItemView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDictionary *itemData;

@property (nonatomic, strong) id<GJTDebugerPluginProtocol>  currentPlugin;

@end

@implementation GJTDebugerHomeSectionItemView

- (instancetype)initWithFrame: (CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.gjt_width/2-kDebugerSizeFrom750_Landscape(68)/2, 0, kDebugerSizeFrom750_Landscape(68), kDebugerSizeFrom750_Landscape(68))];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.gjt_bottom+kDebugerSizeFrom750_Landscape(12), self.gjt_width, kDebugerSizeFrom750_Landscape(33))];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = [UIFont systemFontOfSize:kDebugerSizeFrom750_Landscape(24)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)renderUIWithData: (NSDictionary *)data{
    _itemData = data;
    NSString *iconName = data[@"icon"];
    _imageView.image = [UIImage debuger_imageNamed:iconName];
    
    NSString *name = data[@"name"];
    _titleLabel.text = name;
}

- (void)updateUILayout {
    _imageView.frame = CGRectMake(self.gjt_width/2-kDebugerSizeFrom750_Landscape(68)/2, 0, kDebugerSizeFrom750_Landscape(68), kDebugerSizeFrom750_Landscape(68));
    _titleLabel.frame = CGRectMake(0, _imageView.gjt_bottom+kDebugerSizeFrom750_Landscape(12), self.gjt_width, kDebugerSizeFrom750_Landscape(33));
    _titleLabel.font = [UIFont systemFontOfSize:kDebugerSizeFrom750_Landscape(24)];
}

- (void)itemClick{
    NSString *pluginName = _itemData[@"pluginName"];
    
    if(pluginName){
        Class pluginClass = NSClassFromString(pluginName);
        
        id<GJTDebugerPluginProtocol> plugin = [[pluginClass alloc] init];
        self.currentPlugin = plugin;
        
        if ([plugin respondsToSelector:@selector(pluginDidLoad)]) {
            NSString *name = [NSString stringWithFormat:@"%@",_itemData[@"name"]];
//            [GJTTracker trackEventID:@"event_kit_clicked" pageID:@"page_big_helper" type:GJTTrackTypeClick params:@{@"kit_name":name,@"app_name":[self applicationName]}];
            [plugin pluginDidLoad];
        }
        if ([plugin respondsToSelector:@selector(pluginDidLoad:)]) {
            NSString *name = [NSString stringWithFormat:@"%@",_itemData[@"name"]];;
//            [GJTTracker trackEventID:@"event_kit_clicked" pageID:@"page_big_helper" type:GJTTrackTypeClick params:@{@"kit_name":name,@"app_name":[self applicationName]}];
            [plugin pluginDidLoad:(NSDictionary *)_itemData];
        }
        void (^handleBlock)(NSDictionary *itemData) = _itemData[@"handleBlock"];
        if (handleBlock) {
            handleBlock(_itemData);
        }
    }

}

- (NSString *)applicationName {
    static NSString *_appName;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];

        if (!_appName) {
            _appName = [[NSProcessInfo processInfo] processName];
        }

        if (!_appName) {
            _appName = @"";
        }
    });

    return _appName;
}

@end


@interface GJTDebugerHomeSectionView ()


@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation GJTDebugerHomeSectionView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#324456"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:kDebugerSizeFrom750_Landscape(32)];
        [self addSubview:_titleLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kDebugerSizeFrom750_Landscape(8);
    }
    return self;
}

- (void)renderUIWithData:(NSDictionary *)data {
    NSString *moduleName = data[@"moduleName"];
    _titleLabel.text = moduleName;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(kDebugerSizeFrom750_Landscape(32), kDebugerSizeFrom750_Landscape(32), _titleLabel.gjt_width, _titleLabel.gjt_height);
    NSArray *pluginArray = data[@"pluginArray"];
    
    CGFloat offsetX = 0;
    CGFloat offsetY = kDebugerSizeFrom750_Landscape(32+45+32);
    CGFloat itemWidth = self.gjt_width/4;
    CGFloat itemHeight = kDebugerSizeFrom750_Landscape(68+12+33);
    CGFloat itemSpace = kDebugerSizeFrom750_Landscape(32);
    for (int i=0; i<pluginArray.count;i++) {
        NSDictionary *itemData = pluginArray[i];
        
        if (i%4 == 0 && i !=0 ) {
            offsetY += itemHeight + itemSpace;
            offsetX = 0;
        }
        
        GJTDebugerHomeSectionItemView *itemView = [[GJTDebugerHomeSectionItemView alloc] initWithFrame:CGRectMake(offsetX, offsetY, itemWidth, itemHeight)];
        itemView.tag = GJT_debuger_sectionViewTagStartSubscript + i;
        [itemView renderUIWithData:itemData];
        [self addSubview:itemView];
        
        offsetX += itemWidth;
    }
}
 
int GJT_debuger_sectionViewTagStartSubscript = 100;
- (void)updateUILayoutWithData:(NSDictionary *)data {
    _titleLabel.font = [UIFont boldSystemFontOfSize:kDebugerSizeFrom750_Landscape(32)];
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(kDebugerSizeFrom750_Landscape(32), kDebugerSizeFrom750_Landscape(32), _titleLabel.gjt_width, _titleLabel.gjt_height);
    self.layer.cornerRadius = kDebugerSizeFrom750_Landscape(8);
    
    NSArray *pluginArray = data[@"pluginArray"];
    
    CGFloat offsetX = 0;
    CGFloat offsetY = kDebugerSizeFrom750_Landscape(32+45+32);
    CGFloat itemWidth = GJTDebugerScreenWidth/4;
    CGFloat itemHeight = kDebugerSizeFrom750_Landscape(68+12+33);
    CGFloat itemSpace = kDebugerSizeFrom750_Landscape(32);
    
    for (int i = 0; i < pluginArray.count;i++) {
        if (i%4 == 0 && i !=0 ) {
            offsetY += itemHeight + itemSpace;
            offsetX = 0;
        }
        GJTDebugerHomeSectionItemView *itemView = [self viewWithTag:GJT_debuger_sectionViewTagStartSubscript + i];
        itemView.frame = CGRectMake(offsetX, offsetY, itemWidth, itemHeight);
        [itemView updateUILayout];
        offsetX += itemWidth;
    }
}

+ (CGFloat)viewHeightWithData:(NSDictionary *)data{
    CGFloat titleHeight = kDebugerSizeFrom750_Landscape(32+45+32);
    NSArray *pluginArray = data[@"pluginArray"];
    NSInteger count = pluginArray.count;
    NSInteger row = 0;
    if (count%4 == 0) {
        row = count/4;
    }else{
        row = count/4 + 1;
    }
    CGFloat itemHeight = kDebugerSizeFrom750_Landscape(68+12+33);
    CGFloat itemSpace = kDebugerSizeFrom750_Landscape(32);
    CGFloat totalHeight = titleHeight + row*(itemHeight+itemSpace);
    
    return totalHeight;
}

@end
