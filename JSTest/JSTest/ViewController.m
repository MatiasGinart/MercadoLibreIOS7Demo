//
//  ViewController.m
//  JSTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AmazingPoint.h"

@interface ViewController ()
@property (nonatomic, strong) JSContext* context;
@property (nonatomic, strong) UIView* testView;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Creamos una Virtual Machine
        JSVirtualMachine* virtualMachine = [[JSVirtualMachine alloc] init];
        // Creamos un contexto en esa virtual machine
        self.context = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
        // Matchear mi clase AmazingPoint de objective-c con un objecto del tipo GreatPoint en js
        self.context[@"GreatPoint"] = [AmazingPoint class];

        // Cargar el js y tirarselo para que el contexto lo morfe
        NSString* jsFilePath = [[NSBundle mainBundle] pathForResource:@"PointCalculator" ofType:@"js"];
        NSString* jsFileContents = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:NULL];
        [self.context evaluateScript:jsFileContents];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Creo la vista que va a ser movida en el test
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.testView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (void)runJavascriptFunction:(NSString*)functionName {
    // Creo 2 puntos con los inputs de la demo
    AmazingPoint* firstPoint = [AmazingPoint pointWithX:[self.textfield1X.text integerValue] andY:[self.textfield1Y.text integerValue]];
    AmazingPoint* secondPoint = [AmazingPoint pointWithX:[self.textfield2X.text integerValue] andY:[self.textfield2Y.text integerValue]];

    // Le pido al contexto la funcion js que quiero correr
    JSValue* function = self.context[functionName];
    // Corro la funcion js y con los 2 puntos anteriormente creados
    JSValue* result = [function callWithArguments:@[firstPoint, secondPoint]];
    // Como AmazingPoint se adhiere al protocolo JSPointProtocol, puedo pasar el JSValue a un AmazingPoint
    AmazingPoint* resultPoint = [result toObject];

    // Solo queda mover la vista con el nuevo centro
    [UIView animateWithDuration:0.4 animations:^{
        self.testView.center = [resultPoint point];
    }];
}

- (IBAction)createPointWithExport {
    // Llamo a mi metodo con el nombre de la funcion
    [self runJavascriptFunction:@"middlePointBetween"];
}

- (IBAction)createPointWithBlock {
    // Voy a crear un bloque que puede ser llamado desde mi javascript
    self.context[@"createNewPointWithXY"] = ^(CGFloat x, CGFloat y) {
        return [AmazingPoint pointWithX:x andY:y];
    };

    // Llamo a mi metodo con el nombre de la funcion
    [self runJavascriptFunction:@"middlePointBetweenWithBlocks"];
}

@end
