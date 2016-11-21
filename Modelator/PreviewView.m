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
    
    [self.webView setDrawsBackground:NO];

}

- (void)setText:(NSString *)text {
    _text = text;
    text = [[text stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
            stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
    NSString *url = [@"file://" stringByAppendingString:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/highlight/"]];
    NSString *html = [NSString stringWithFormat:@"<body style='margin:0'><link rel='stylesheet' href='%@styles/atom-one-dark.css'><script src='%@highlight.pack.js'></script><script>hljs.initHighlightingOnLoad();</script><pre><code style='font-family: Menlo;font-size: 11px;' class='objectivec'>%@</code></pre></body>",url,url,text];
    [[self.webView mainFrame] loadHTMLString:html baseURL:nil];
}
@end
