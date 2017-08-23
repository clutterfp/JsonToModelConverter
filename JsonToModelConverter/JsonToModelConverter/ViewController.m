//
//  ViewController.m
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import "ViewController.h"
#import "NSString+JsonToObject.h"
#import "ConvertHelper.h"

@interface ViewController () <NSTextFieldDelegate>

@property (nonatomic, strong) NSTextField *isJsonText;
@property (nonatomic, strong) NSTextField *modelNameText;
@property (nonatomic, strong) NSTextField *jsonText;
@property (nonatomic, strong) NSComboBox *comboBox;
@property (nonatomic, strong) NSButton *clearButton;
@property (nonatomic, strong) NSButton *convertButton;

@property (nonatomic, strong) NSArray *comboBoxTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initUI];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Init Methods
- (void)initData {
    self.comboBoxTitles = @[@"MJExtension"];
}

- (void)initUI {
    self.view.frame = CGRectMake(0, 0, 641, 411);
    
    self.isJsonText = [[NSTextField alloc] initWithFrame:CGRectMake(18, 374, 96, 17)];
    self.isJsonText.bezeled = NO;
    self.isJsonText.drawsBackground = NO;
    self.isJsonText.editable = NO;
    [self.view addSubview:self.isJsonText];
    
    NSTextField *modelText = [[NSTextField alloc] initWithFrame:CGRectMake(394, 374, 77, 17)];
    modelText.bezeled = NO;
    modelText.drawsBackground = NO;
    modelText.editable = NO;
    modelText.stringValue = @"ModelName";
    [self.view addSubview:modelText];
    
    self.modelNameText = [[NSTextField alloc] initWithFrame:CGRectMake(483, 371, 138, 22)];
    self.modelNameText.delegate = self;
    [self.view addSubview:self.modelNameText];
    
    self.jsonText = [[NSTextField alloc] initWithFrame:CGRectMake(20, 67, 601, 291)];
    self.jsonText.delegate = self;
    [self.view addSubview:self.jsonText];
    
    self.comboBox = [[NSComboBox alloc] initWithFrame:CGRectMake(20, 24, 138, 26)];
    [self.comboBox addItemsWithObjectValues:self.comboBoxTitles];
    [self.comboBox selectItemWithObjectValue:@"MJExtension"];
    self.comboBox.editable = NO;
    [self.view addSubview:self.comboBox];
    
    self.clearButton = [[NSButton alloc] initWithFrame:CGRectMake(394, 25, 97, 25)];
    self.clearButton.title = @"Clear";
    self.clearButton.target = self;
    self.clearButton.action = @selector(clearAction:);
    [self.view addSubview:self.clearButton];
    
    self.convertButton = [[NSButton alloc] initWithFrame:CGRectMake(524, 25, 97, 25)];
    self.convertButton.title = @"Convert";
    self.convertButton.target = self;
    self.convertButton.action = @selector(convertAction:);
    [self.view addSubview:self.convertButton];
    
    [self invalidJson];
    [self canNotConvert];
}

#pragma mark - Button Actions
- (void)clearAction:(NSButton *)button {
    self.jsonText.stringValue = @"";
    [self invalidJson];
    [self canNotConvert];
}

- (void)convertAction:(NSButton *)button {
    if ([[self.jsonText.stringValue jsonToDictionary] isKindOfClass:[NSDictionary class]]) {
        [ConvertHelper convertWithModelName:self.modelNameText.stringValue dictionary:[self.jsonText.stringValue jsonToDictionary] type:self.comboBox.indexOfSelectedItem];
    }else {
        [ConvertHelper convertWithModelName:self.modelNameText.stringValue array:[self.jsonText.stringValue jsonToArray]  type:self.comboBox.indexOfSelectedItem];
    }
}

#pragma mark - Private Methods
- (void)invalidJson {
    self.isJsonText.stringValue = @"Invalid Json";
    self.isJsonText.textColor = [NSColor redColor];
}

- (void)validJson {
    self.isJsonText.stringValue = @"Valid Json";
    self.isJsonText.textColor = [NSColor greenColor];
}

- (void)canConvert {
    self.convertButton.enabled = YES;
}

- (void)canNotConvert {
    self.convertButton.enabled = NO;
}

#pragma mark - NSTextFieldDelegate
- (void)controlTextDidChange:(NSNotification *)obj {
    if ([self.jsonText.stringValue jsonToDictionary] || [self.jsonText.stringValue jsonToArray]) {
        [self validJson];
        [self canConvert];
    }else {
        [self invalidJson];
        [self canNotConvert];
    }
    
    if (self.modelNameText.stringValue.length == 0) {
        [self canNotConvert];
    }
}
@end
