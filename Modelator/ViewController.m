//
//  ViewController.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ViewController.h"
#import "ImportViewController.h"
#import "ModuleManager.h"
#import "ModelatorClass.h"
#import "ModelatorProperty.h"
#import "PropertyView.h"
#import "PreviewView.h"
#import <WebKit/WebKit.h>
#import "ModelatorExporter.h"
#import "BasicClassParser.h"

@interface ViewController()<NSOutlineViewDelegate, NSOutlineViewDataSource, ImportViewControllerDelegate, NSTableViewDelegate, NSTableViewDataSource, NSSplitViewDelegate, NSTextViewDelegate>

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSView *previewContainerView;
@property (nonatomic, strong) id classParser;
@property (nonatomic, weak) id importViewController;
@property (nonatomic, strong) NSURL *selectedFileURL;
@property (weak) IBOutlet NSSplitView *horizontalSplitView;
@property (weak) PreviewView *previewView;
@property (weak) IBOutlet NSView *topView;
@property (weak) IBOutlet NSTextField *lblName;
@property (weak) IBOutlet NSTextField *txtName;
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *lblSelect;
@property (weak) IBOutlet NSView *tabContainerView;
@property (strong) IBOutlet NSMenu *popup;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(propertySettingsChanged:) name:@"modelator.PropertyChangeNotification" object:nil];
    self.segmentedControl.hidden = YES;
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self.previewContainerView setWantsLayer:YES];
    [self.previewContainerView.layer setBackgroundColor:[[NSColor colorWithRed:0.16 green:0.17 blue:0.20 alpha:1] CGColor]];
    [self.containerView setWantsLayer:YES];
    [self.containerView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    [self.topView setWantsLayer:YES];
    [self.topView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    [self.toolBarView setWantsLayer:YES];
    [self.toolBarView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Classes" attributes:@{ NSFontAttributeName:[NSFont fontWithName:@"Ubuntu" size:11] }];
    [self.outlineView.tableColumns[0].headerCell setAttributedStringValue:str];
    [self.tabContainerView setWantsLayer:YES];
    [self.tabContainerView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
//    [self.segmentedControl setFont:[NSFont fontWithName:@"Ubuntu" size:11]];
//    [self.segmentedControl setSelectedSegmentBezelColor:[NSColor redColor]];
}
- (IBAction)menuButtonClicked:(id)sender {
        [self.popup popUpMenuPositioningItem:self.popup.itemArray[0] atLocation:NSMakePoint(0, 0) inView:self.toolBarView];
}
- (IBAction)segmentClicked:(id)sender {
    [self updateCode];
}
- (void)updateCode {
    id selectedItem = [_outlineView itemAtRow:[_outlineView selectedRow]];
    if (selectedItem) {
        if ([selectedItem isKindOfClass:[ModelatorClass class]]) {
            [self updateCodeForClass:selectedItem] ;
        } else {
            [self updateCodeForClass:[_outlineView parentForItem:selectedItem]];
        }
    }
}
- (void)openDocument:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel beginSheetModalForWindow:[NSApp mainWindow] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *selectedFileName = [panel URL];
            self.selectedFileURL = selectedFileName;
            [self performSegueWithIdentifier:@"ImporterSegue" sender:self];
        }
    }];
}

- (void)parseJson:(NSURL *)jsonURL {
    NSData *data = [[NSData alloc] initWithContentsOfURL:jsonURL];
    NSError *error = nil;
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        [self showErrorWithText:@"Unable to parse the file"];
        return;
    }
    NSString *rootClass = [[[jsonURL absoluteString] lastPathComponent] stringByDeletingPathExtension];
    ModelatorModule *module = [[ModuleManager sharedManager] selectedModule];
    self.classParser = [[module.parserClass alloc] initWithJSON:json rootClassName:rootClass];
    [self displayConversionResults];
    [self loadPreviewView];
}

- (void)showErrorWithText:(NSString *)text {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"JSON error";
    [alert setInformativeText:text];
    [alert runModal];
}

- (void)displayConversionResults {
    for (NSView *v in [self.containerView subviews]) {
        if (![v isKindOfClass:[NSTextField class]]) {
            [v removeFromSuperview];
        }
    }
    self.lblSelect.hidden = NO;
    [self.outlineView reloadData];
}
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ImporterSegue"]) {
        ((ImportViewController *)segue.destinationController).delegate = self;
        self.importViewController = segue.destinationController;
    }
    
}
- (void)loadPreviewView {
    [[self.previewContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *arr = nil;
    [[NSBundle mainBundle] loadNibNamed:@"PreviewView" owner:self topLevelObjects:&arr];
    for (id topLevelObject in arr) {
        if ([topLevelObject isKindOfClass:[NSView class]]) {
            self.previewView = topLevelObject;
            break;
        }
    }
    self.previewView.frame = self.previewContainerView.bounds;
    self.previewView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.previewContainerView addSubview:self.previewView];
    [self loadPreviewSegments];
}

- (void)loadPreviewSegments {
    ModelatorModule *module = [[ModuleManager sharedManager] selectedModule];
    [self.segmentedControl setSegmentCount:[module.templateFiles count]];
    for (NSInteger i = 0;i < [module.moduleTitles count];i++) {
        NSString *str = module.moduleTitles[i];
        [self.segmentedControl setLabel:str forSegment:i];
    }
    self.segmentedControl.hidden = NO;
}

- (void)updateCodeForClass:(ModelatorClass *)mClass {
    dispatch_queue_t searchdQueue = dispatch_queue_create("com.olivesoft.modelator", NULL);
    dispatch_async(searchdQueue, ^{
        ModelatorExporter *exporter = [[ModelatorExporter alloc] init];
        NSString *text = [exporter codeFromClass:mClass module:[[ModuleManager sharedManager] selectedModule]][self.segmentedControl.selectedSegment];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.previewView.highlightLanguage = [[ModuleManager sharedManager] selectedModule].highlightLanguageName;
            self.previewView.text = text;
        });
    });
}
#pragma mark - ImportViewControllerDelegate

- (void)importViewControllerDidConfirmSelectionWithModuleIndex:(NSInteger)moduleIndex {
    [ModuleManager sharedManager].selectedModuleIndex = moduleIndex;
    [self dismissViewController:self.importViewController];
    [self parseJson:self.selectedFileURL];
}
#pragma mark - outline datasource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item {
    if ([item isKindOfClass:[ModelatorClass class]]) {
        return [[(ModelatorClass *)item properties] count];
    } else if ([item isKindOfClass:[ModelatorProperty class]]) {
        return 0;
    }
    return [[self.classParser classes] count];
    
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item {
    if ([item isKindOfClass:[ModelatorClass class]]) {
        return [(ModelatorClass *)item properties][index];
    }
    return [self.classParser classes][index];
    
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return [item isKindOfClass:[ModelatorClass class]];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"Cell" owner:self];
    if ([item isKindOfClass:[ModelatorClass class]]) {
        [cell.textField setStringValue:[item name]];
    } else {
        [cell.textField setStringValue:[item propertyName]];
    }
    return cell;
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    id selectedItem = [_outlineView itemAtRow:[_outlineView selectedRow]];
    self.txtName.hidden = selectedItem == nil;
    self.lblName.hidden = selectedItem == nil;
    [self presentPropertyViewForItem:selectedItem];
    if (selectedItem) {
        if ([selectedItem isKindOfClass:[ModelatorClass class]]) {
            [self updateCodeForClass:selectedItem] ;
            self.txtName.stringValue = ((ModelatorClass *)selectedItem).name;
        } else {
            [self updateCodeForClass:[_outlineView parentForItem:selectedItem]];
            self.txtName.stringValue = ((ModelatorProperty *)selectedItem).propertyName;
        }
    } else {
        self.previewView.text = @"";
    }
}

- (void)presentPropertyViewForItem:(id)item {
    for (NSView *v in [self.containerView subviews]) {
        if (![v isKindOfClass:[NSTextField class]]) {
            [v removeFromSuperview];
        }
    }
    self.lblSelect.hidden = NO;
    if ([item isKindOfClass:[ModelatorProperty class]]) {
        NSString *viewClassName = [[[ModuleManager sharedManager] selectedModule] propertyViewClassName];
        self.lblSelect.hidden = YES;
        NSArray *arr = nil;
        [[NSBundle mainBundle] loadNibNamed:viewClassName owner:self topLevelObjects:&arr];
        NSView *view = nil;
        for (id topLevelObject in arr) {
            if ([topLevelObject isKindOfClass:[NSView class]]) {
                view = topLevelObject;
                break;
            }
        }
        if (view) {
            [(id)view setAssocciatedProperty:item];
            view.frame = self.containerView.bounds;
            view.autoresizingMask = NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin;
            [self.containerView addSubview:view];
        }
    }
}
#pragma mark - TextView delegate

- (void)controlTextDidChange:(NSNotification *)obj {
    id selectedItem = [_outlineView itemAtRow:[_outlineView selectedRow]];
    if (selectedItem) {
        if ([selectedItem isKindOfClass:[ModelatorClass class]]) {
            ((ModelatorClass *)selectedItem).name = self.txtName.stringValue;
            [self updateCodeForClass:selectedItem] ;
        } else {
            ((ModelatorProperty *)selectedItem).propertyName = self.txtName.stringValue;
            [self updateCodeForClass:[_outlineView parentForItem:selectedItem]];
        }
    }
    [_outlineView reloadItem:selectedItem];
}

- (void)propertySettingsChanged:(NSNotification *)notification {
    [self updateCode];

}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if (menuItem.tag  == 10) {
        return self.classParser != nil;
    }
    return YES;
}
- (void)saveAllDocuments:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:[NSApp mainWindow] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            
            for (ModelatorClass *mClass in [self.classParser classes]) {
                ModelatorExporter *exporter = [[ModelatorExporter alloc] init];
                ModelatorModule *module = [[ModuleManager sharedManager] selectedModule];
                for (NSInteger i = 0;i < [[module exportFileExtensions] count];i++) {

                    NSArray *arr = [exporter codeFromClass:mClass module:module];
                    NSInteger k = 0;
                    for (NSString *str in arr) {
                        NSURL *selectedPath = [[panel URL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",mClass.name,module.exportFileExtensions[k++]] isDirectory:NO];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        [data writeToURL:selectedPath atomically:YES];
                    }
                }
            }
            
        }
    }];
}

@end
