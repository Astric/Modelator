//
//  ViewController.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ViewController.h"
#import "ObjCClassParser.h"
#import "ImportViewController.h"
#import "ModuleManager.h"
#import "ModelatorClass.h"
#import "ModelatorProperty.h"
#import "PropertyView.h"
#import "PreviewView.h"
#import <WebKit/WebKit.h>
#import "ModelatorExporter.h"

@interface ViewController()<NSOutlineViewDelegate, NSOutlineViewDataSource, ImportViewControllerDelegate, NSTableViewDelegate, NSTableViewDataSource, NSSplitViewDelegate>

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSView *previewContainerView;
@property (nonatomic, strong) ObjCClassParser *classParser;
@property (nonatomic, weak) id importViewController;
@property (nonatomic, strong) NSURL *selectedFileURL;
@property (weak) IBOutlet NSSplitView *horizontalSplitView;
@property (weak) PreviewView *previewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self.previewContainerView setWantsLayer:YES];
    [self.previewContainerView.layer setBackgroundColor:[[NSColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1] CGColor]];
    [self.containerView setWantsLayer:YES];
    [self.containerView.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.

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
    self.classParser = [[ObjCClassParser alloc] initWithJSON:json rootClassName:rootClass];
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
    [self.outlineView reloadData];
}
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ImporterSegue"]) {
        ((ImportViewController *)segue.destinationController).delegate = self;
        self.importViewController = segue.destinationController;
    }
    
}
- (void)loadPreviewView {
    NSArray *arr = nil;
    [[NSBundle mainBundle] loadNibNamed:@"PreviewView" owner:self topLevelObjects:&arr];
    for (id topLevelObject in arr) {
        if ([topLevelObject isKindOfClass:[NSView class]]) {
            self.previewView = topLevelObject;
            break;
        }
    }
    self.previewView.frame = self.previewContainerView.bounds;
    self.previewView.autoresizingMask = NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin;
    [self.previewContainerView addSubview:self.previewView];

}

- (void)updateCodeForClass:(ModelatorClass *)mClass {
    dispatch_queue_t searchdQueue = dispatch_queue_create("com.olivesoft.modelator", NULL);
    dispatch_async(searchdQueue, ^{
        ModelatorExporter *exporter = [[ModelatorExporter alloc] init];
        NSString *text = [exporter codeFromClass:mClass module:[[ModuleManager sharedManager] selectedModule]][0];
        dispatch_async(dispatch_get_main_queue(), ^{
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
    [self presentPropertyViewForItem:selectedItem];
    if (selectedItem) {
        if ([selectedItem isKindOfClass:[ModelatorClass class]]) {
            [self updateCodeForClass:selectedItem] ;
        } else {
            
        }
    }
}

- (void)presentPropertyViewForItem:(id)item {
    [[self.containerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([item isKindOfClass:[ModelatorProperty class]]) {
        NSString *viewClassName = [[[ModuleManager sharedManager] selectedModule] propertyViewClassName];
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
#pragma mark - splitview delegate
//- (void)splitViewWillResizeSubviews:(NSNotification *)notification {
//    [self.horizontalSplitView adjustSubviews];
//}
@end
