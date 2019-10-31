//
//  SJViewController6.m
//  SJVideoPlayer_Example
//
//  Created by 畅三江 on 2019/7/13.
//  Copyright © 2019 changsanjiang. All rights reserved.
//

#import "SJViewController6.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <Masonry/Masonry.h>
#import <SJUIKit/SJUIKit.h>
#import "SJSourceURLs.h"
#import "SJPopPromptCustomView.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJViewController6 ()
@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation SJViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)show:(id)sender {
    static NSArray<NSString *> *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@"悲哀化身-内蒙专区", @"车迟国@最终幻想-剑侠风骨", @"老虎222-天竺国", @"今朝醉-云中殿", @"杀手阿七-五明宫", @"浅墨淋雨桥-剑胆琴心"];
    });
    
    NSAttributedString *text = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(arr[arc4random() % arr.count]);
        make.textColor(UIColor.whiteColor);
    }];
    
    NSTimeInterval duration = arc4random() % 10 + 2;
    
    ///
    /// 显示富文本提示
    ///
    [_player.popPromptController show:text duration:duration];
}

///
/// 清空所有提示
///
- (IBAction)clear:(id)sender {
    [_player.popPromptController clear];
}

///
/// 显示自定义视图
///
- (IBAction)showCustomView:(id)sender {
    [_player.popPromptController showCustomView:SJPopPromptCustomView.new duration:3];
}

#pragma mark -

- (void)_setupViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    [_playerContainerView addSubview:self.player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    __weak typeof(self) _self = self;
    _player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ^(id<SJControlLayerAppearManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        if ( mgr.isAppeared ) {
            self.player.popPromptController.bottomMargin = self.player.defaultEdgeControlLayer.bottomContainerView.bounds.size.height + 8;
        }
        else {
            self.player.popPromptController.bottomMargin = 16;
        }
    };
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end
NS_ASSUME_NONNULL_END

#import <SJRouter/SJRouter.h>
@interface SJViewController6 (RouteHandler)<SJRouteHandler>

@end

@implementation SJViewController6 (RouteHandler)

+ (NSString *)routePath {
    return @"demo/prompt1";
}

+ (void)handleRequest:(SJRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:[[SJViewController6 alloc] initWithNibName:@"SJViewController6" bundle:nil] animated:YES];
}

@end