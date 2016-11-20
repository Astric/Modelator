//
//  ModelatorExporter.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 20/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelatorClass.h"
#import "ModelatorModule.h"

@interface ModelatorExporter : NSObject

- (id)codeFromClass:(ModelatorClass *)mClass module:(ModelatorModule *)module;

@end
