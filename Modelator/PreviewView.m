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
    NSString *url = [@"file://" stringByAppendingString:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/highlight/"]];
    NSString *html = [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, user-scalable=no initial-scale=1.0' /><body style='margin:0'><link rel='stylesheet' href='%@styles/atom-one-dark.css'><script src='%@highlight.pack.js'></script><script>hljs.initHighlightingOnLoad();</script><script>function setCodeText(txt) { document.getElementById('code').textContent = txt;hljs.highlightBlock(code) }</script><pre><code style='overflow:visible;font-family: Ubuntu Mono;font-size: 12px;' class='objectivec' id='code'></code></pre></body>",url,url];
    [[self.webView mainFrame] loadHTMLString:html baseURL:nil];
    
}

- (void)setText:(NSString *)text {
    _text = text;
    [[self.webView windowScriptObject] callWebScriptMethod:@"setCodeText" withArguments:@[text]];
}
@end
