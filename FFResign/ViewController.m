//
//  ViewController.m
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import "ViewController.h"
#import "FFFileTools.h"
#import "FFDateFormatterTools.h"

@interface ViewController ()<NSComboBoxDataSource,NSComboBoxDelegate>

/** ipa or app inpute path */
@property (weak) IBOutlet NSTextField *ipaPathField;
/** ipa out put path */
@property (weak) IBOutlet NSTextField *outPutPathField;

/** certificate combo box */
@property (weak) IBOutlet NSComboBox    *certificateComboBox;
/** provisioning combo box */
@property (weak) IBOutlet NSComboBox    *provisioningComboBox;

/** change app name */
@property (weak) IBOutlet NSTextField *changeAppNameTextFiled;

/** change bundle ID */
@property (weak) IBOutlet NSTextField *changeBundleIDTextField;



/** log text field */
@property IBOutlet NSTextView *logField;


@end

@implementation ViewController {
    NSFileManager *fileManager;

    NSArray *provisioningArray;
    NSArray *certificatesArray;

    BOOL useMobileprovisionBundleID;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    fileManager = [NSFileManager defaultManager];

    self.provisioningComboBox.delegate = self;
    self.provisioningComboBox.dataSource = self;

    NSArray *lackSupportUtility = [[FFFileTools sharedTools] lackSupportUtility];
    if ([lackSupportUtility count] == 0) {
        //获取本机证书
        [self addLog:@"start get certificates" withColor:[NSColor greenColor]];
        [self getCertificates];
        //获取本级描述文件
        [self addLog:@"start get provisioning profiles" withColor:[NSColor greenColor]];
        [self getProvisioningProfiles];
    } else {
        for (NSString *path in lackSupportUtility) {
            [self addLog:[NSString stringWithFormat:@"This command requires the support of %@", path] withColor:[NSColor redColor]];
        }
    }
}

#pragma mark - mehtod
- (void)getCertificates {
    [[FFFileTools sharedTools] getCertificatesSuccess:^(NSArray *array) {
        [self addLog:@"get certificates success" withColor:[NSColor blueColor]];
        certificatesArray = array;
        [self.certificateComboBox reloadData];
    } error:^(NSString *error) {
        [self addLog:error withColor:[NSColor redColor]];
    }];
}

- (void)getProvisioningProfiles {
    provisioningArray = [[FFFileTools sharedTools] getProvisioningProfiles];
    if (provisioningArray.count == 0) {
        [self addLog:@"provisioning array error" withColor:[NSColor redColor]];
    } else {
        [self addLog:@"get provisioning profiles success" withColor:[NSColor blueColor]];
    }

    [self.provisioningComboBox reloadData];
}


#pragma mark - responds Action
/** inpute browse */
- (IBAction)ipaBrowse:(NSButton *)sender {
    // 作为第一响应
    [self.view.window makeFirstResponder:nil];
    // 浏览 ipa 文件
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:YES];
    [openDlg setAllowsOtherFileTypes:NO];
    [openDlg setAllowedFileTypes:@[@"IPA",@"APP"]];
    if ([openDlg runModal] == NSModalResponseOK) {

        NSString *fileNameOpened = [[[openDlg URLs] objectAtIndex:0] path];
        NSLog(@"open url === %@",fileNameOpened);
        self.ipaPathField.stringValue = fileNameOpened;
//        if ([self.destinationPathField.stringValue isEqualToString:@""]) {
//            self.destinationPathField.stringValue = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
//        }
//
//        // 移除之前包的解压文件
//        if (self.package.workPath) [fileManager removeItemAtPath:self.package.workPath error:nil];
//
//        NSString* fileNameOpened        = [[[openDlg URLs] objectAtIndex:0] path];
//        self.ipaPathField.stringValue   = fileNameOpened;
//
//        self.package = [[IDAppPackageHandler alloc] initWithPackagePath:fileNameOpened];
//
//        [self unzipIpa];
    }
}
- (IBAction)outPutPath:(id)sender {


}

- (IBAction)refreshCerButton:(NSButton *)sender {
    [self getCertificates];
}

- (IBAction)refreshProButton:(id)sender {
    [self getProvisioningProfiles];
}

- (IBAction)selectBundleIDButton:(id)sender {
    NSButton *button = sender;
    if (button.tag == 10086 && button.state == 1) {
        // 用文本框里面的 BundleID
        useMobileprovisionBundleID = NO;
        self.changeBundleIDTextField.stringValue = @"???????????";
    } else if (button.tag == 10087 && button.state == 1) {
        // 使用 mobileprovision 中的 BundleID
        self.changeBundleIDTextField.stringValue = @"!!!!!!!!!!!!!!!";
        useMobileprovisionBundleID = YES;
    }
}

- (IBAction)resignButton:(id)sender {
    [self addLog:@"start resign" withColor:[NSColor redColor]];
}

- (IBAction)clearButton:(id)sender {
    [self addLog:@"Clear window" withColor:[NSColor redColor]];
}

#pragma mark - NSComboBox
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    NSInteger count = 0;

    if ([comboBox isEqual:self.provisioningComboBox])
        count = [provisioningArray count];
    else if ([comboBox isEqual:self.certificateComboBox])
        count = [certificatesArray count];

    return count;
}

- (nullable id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index; {
    id item = nil;

    if ([comboBox isEqual:self.provisioningComboBox]) {
        id profile = provisioningArray[index];
        item = [NSString stringWithFormat:@"%@ (%@)", [profile valueForKey:@"name"], [profile valueForKey:@"bundleIdentifier"]];
    } else if ([comboBox isEqual:self.certificateComboBox]) {
        item = certificatesArray[index];
    }

    return item;
}


#pragma mark - LogField
- (void)addLog:(NSString *)log withColor:(NSColor *)color {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 添加时间
        NSString *dateString = [[FFDateFormatterTools sharedFormatter] MMddHHmmssSSSForDate:[NSDate date]];
        NSAttributedString *dateAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]", dateString] attributes:@{NSForegroundColorAttributeName: [NSColor grayColor]}];

        // 添加log
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@\n", log] attributes:@{NSForegroundColorAttributeName: color}];

        [[self.logField textStorage] appendAttributedString:dateAttributedString];
        [[self.logField textStorage] appendAttributedString:attributedString];
        [self.logField scrollRangeToVisible:NSMakeRange([[self.logField string] length], 0)];
    });
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
