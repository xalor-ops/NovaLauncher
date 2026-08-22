#import <WebKit/WebKit.h>
#import "LauncherMenuViewController.h"
#import "LauncherNewsViewController.h"
#import "LauncherPreferencesViewController.h"
#import "LauncherProfilesViewController.h"
#import "LauncherNavigationController.h"
#import "LauncherPreferences.h"
#import "utils.h"

@interface LauncherNewsViewController ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIStackView *stackView;
@property(nonatomic, strong) UILabel *statusLabel;
@end

@implementation LauncherNewsViewController

- (id)init {
    self = [super init];
    self.title = @"Nova Home";
    return self;
}

- (NSString *)imageName {
    return @"house.fill";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.rightBarButtonItem = [sidebarViewController drawAccountButton];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];

    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 18;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.stackView];
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor constant:20],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-28],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.leadingAnchor constant:20],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.trailingAnchor constant:-20]
    ]];

    [self buildNovaHome];
}

- (UILabel *)label:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = font;
    label.textColor = color ?: UIColor.labelColor;
    label.numberOfLines = 0;
    return label;
}

- (UIView *)cardWithBackground:(UIColor *)background {
    UIView *card = [UIView new];
    card.backgroundColor = background;
    card.layer.cornerRadius = 22;
    card.layer.cornerCurve = kCACornerCurveContinuous;
    card.layer.masksToBounds = YES;
    card.translatesAutoresizingMaskIntoConstraints = NO;
    return card;
}

- (UIButton *)novaButton:(NSString *)title symbol:(NSString *)symbol primary:(BOOL)primary action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) [button setImage:[UIImage systemImageNamed:symbol] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.layer.cornerRadius = 15;
    button.layer.cornerCurve = kCACornerCurveContinuous;
    button.configuration = nil;
    button.contentEdgeInsets = UIEdgeInsetsMake(13, 18, 13, 18);
    button.backgroundColor = primary ? UIColor.systemIndigoColor : UIColor.secondarySystemGroupedBackgroundColor;
    button.tintColor = primary ? UIColor.whiteColor : UIColor.labelColor;
    button.titleLabel.textColor = primary ? UIColor.whiteColor : UIColor.labelColor;
    [button addTarget:self action:action forControlEvents:UIControlEventPrimaryActionTriggered];
    return button;
}

- (void)buildNovaHome {
    UILabel *eyebrow = [self label:@"NOVA 2.0" font:[UIFont systemFontOfSize:13 weight:UIFontWeightBold] color:UIColor.secondaryLabelColor];
    [self.stackView addArrangedSubview:eyebrow];

    UIView *hero = [self cardWithBackground:UIColor.systemIndigoColor];
    UIStackView *heroStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    heroStack.axis = UILayoutConstraintAxisVertical;
    heroStack.spacing = 10;
    heroStack.translatesAutoresizingMaskIntoConstraints = NO;
    [hero addSubview:heroStack];
    [NSLayoutConstraint activateConstraints:@[
        [heroStack.topAnchor constraintEqualToAnchor:hero.topAnchor constant:22],
        [heroStack.leadingAnchor constraintEqualToAnchor:hero.leadingAnchor constant:22],
        [heroStack.trailingAnchor constraintEqualToAnchor:hero.trailingAnchor constant:-22],
        [heroStack.bottomAnchor constraintEqualToAnchor:hero.bottomAnchor constant:-22]
    ]];
    [heroStack addArrangedSubview:[self label:@"Ready to play?" font:[UIFont systemFontOfSize:28 weight:UIFontWeightBold] color:UIColor.whiteColor]];
    [heroStack addArrangedSubview:[self label:@"Launch your selected Minecraft profile with the same trusted Amethyst engine underneath." font:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] color:[UIColor.whiteColor colorWithAlphaComponent:0.86]]];
    UIButton *play = [self novaButton:@"Play Minecraft" symbol:@"play.fill" primary:YES action:@selector(novaPlay:)];
    play.backgroundColor = UIColor.whiteColor;
    play.tintColor = UIColor.systemIndigoColor;
    [heroStack addArrangedSubview:play];
    [self.stackView addArrangedSubview:hero];

    UILabel *quickTitle = [self label:@"Quick actions" font:[UIFont systemFontOfSize:22 weight:UIFontWeightBold] color:nil];
    [self.stackView addArrangedSubview:quickTitle];

    UIStackView *row1 = [[UIStackView alloc] initWithFrame:CGRectZero];
    row1.axis = UILayoutConstraintAxisHorizontal;
    row1.spacing = 12;
    row1.distribution = UIStackViewDistributionFillEqually;
    [row1 addArrangedSubview:[self novaButton:@"Instances" symbol:@"square.stack.3d.up" primary:NO action:@selector(novaInstances:)]];
    [row1 addArrangedSubview:[self novaButton:@"Mods" symbol:@"puzzlepiece.extension" primary:NO action:@selector(novaMods:)]];
    [self.stackView addArrangedSubview:row1];

    UIStackView *row2 = [[UIStackView alloc] initWithFrame:CGRectZero];
    row2.axis = UILayoutConstraintAxisHorizontal;
    row2.spacing = 12;
    row2.distribution = UIStackViewDistributionFillEqually;
    [row2 addArrangedSubview:[self novaButton:@"Settings" symbol:@"gearshape.fill" primary:NO action:@selector(novaSettings:)]];
    [row2 addArrangedSubview:[self novaButton:@"JAR Installer" symbol:@"shippingbox.fill" primary:NO action:@selector(novaJar:)]];
    [self.stackView addArrangedSubview:row2];

    UIView *info = [self cardWithBackground:UIColor.secondarySystemGroupedBackgroundColor];
    UIStackView *infoStack = [[UIStackView alloc] initWithFrame:CGRectZero];
    infoStack.axis = UILayoutConstraintAxisVertical;
    infoStack.spacing = 7;
    infoStack.translatesAutoresizingMaskIntoConstraints = NO;
    [info addSubview:infoStack];
    [NSLayoutConstraint activateConstraints:@[
        [infoStack.topAnchor constraintEqualToAnchor:info.topAnchor constant:18],
        [infoStack.leadingAnchor constraintEqualToAnchor:info.leadingAnchor constant:18],
        [infoStack.trailingAnchor constraintEqualToAnchor:info.trailingAnchor constant:-18],
        [infoStack.bottomAnchor constraintEqualToAnchor:info.bottomAnchor constant:-18]
    ]];
    [infoStack addArrangedSubview:[self label:@"Nova Performance" font:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold] color:nil]];
    NSString *memory = [NSString stringWithFormat:@"%@ • %@ • JIT %@", UIDevice.currentDevice.model, UIDevice.currentDevice.systemVersion, isJITEnabled(false) ? @"Ready" : @"Unavailable"];
    [infoStack addArrangedSubview:[self label:memory font:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] color:UIColor.secondaryLabelColor]];
    [self.stackView addArrangedSubview:info];

    UILabel *newsTitle = [self label:@"Latest news" font:[UIFont systemFontOfSize:22 weight:UIFontWeightBold] color:nil];
    [self.stackView addArrangedSubview:newsTitle];
    UIButton *news = [self novaButton:@"Open Nova changelog" symbol:@"newspaper.fill" primary:NO action:@selector(novaNews:)];
    [self.stackView addArrangedSubview:news];
}

- (LauncherNavigationController *)novaContentNavigationController {
    if (![self.splitViewController.viewControllers[1] isKindOfClass:LauncherNavigationController.class]) return nil;
    return (LauncherNavigationController *)self.splitViewController.viewControllers[1];
}

- (void)novaPlay:(id)sender {
    LauncherNavigationController *nav = [self novaContentNavigationController];
    if (nav) [nav performSelector:NSSelectorFromString(@"performInstallOrShowDetails:") withObject:nil];
}

- (void)novaInstances:(id)sender {
    LauncherNavigationController *nav = [self novaContentNavigationController];
    if (nav) [nav setViewControllers:@[[LauncherProfilesViewController new]] animated:YES];
}

- (void)novaSettings:(id)sender {
    LauncherNavigationController *nav = [self novaContentNavigationController];
    if (nav) [nav setViewControllers:@[[LauncherPreferencesViewController new]] animated:YES];
}

- (void)novaJar:(id)sender {
    LauncherNavigationController *nav = [self novaContentNavigationController];
    if (nav) [nav performSelector:@selector(enterModInstaller)];
}

- (void)novaMods:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.curseforge.com/minecraft/search?class=mc-mods"];
    openLink(self, url);
}

- (void)novaNews:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://wiki.angelauramc.dev/patchnotes/changelogs/IOS.html"];
    openLink(self, url);
}

@end
