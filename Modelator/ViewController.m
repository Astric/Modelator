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

@interface ViewController()<NSOutlineViewDelegate, NSOutlineViewDataSource, ImportViewControllerDelegate, NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSView *containerView;


@property (nonatomic, strong) ObjCClassParser *classParser;
@property (nonatomic, weak) id importViewController;
@property (nonatomic, strong) NSURL *selectedFileURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
}

- (void)presentPropertyViewForItem:(id)item {
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
            [[self.containerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.containerView addSubview:view];
        }
    }
}
@end
