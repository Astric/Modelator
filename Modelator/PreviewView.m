//
//  PreviewView.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 14/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "PreviewView.h"
#import <WebKit/WebKit.h>

@interface PreviewView ()
@property (weak) IBOutlet WebView *webView;

@end

@implementation PreviewView

- (void)awakeFromNib {
    NSString *html = [NSString stringWithFormat:@"<link rel='stylesheet' href='styles/xcode.css'><script src='highlight.pack.js'></script><script>hljs.initHighlightingOnLoad();</script><pre><code class='objectivec'>%@</code></pre>",@"//hello world!"];
    [[self.webView mainFrame] loadHTMLString:html baseURL:nil];
}

@end
