//
//  ViewController.m
//  DynamicTest
//
//  Created by Matías Ginart on 04/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "ViewController.h"

// Flag para saber que tipo de attachment estoy insertando en el animator
typedef enum  {
    AttachmentTypeNone = 0,
    AttachmentTypeNormal,
    AttachmentTypeString
} AttachmentType;

@interface ViewController () <UIDynamicAnimatorDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollisionBehaviorDelegate>

// Vista a animar
@property (nonatomic, strong) UIView* viewToAnimate;
// Animador
@property (nonatomic, strong) UIDynamicAnimator* animator;
// String con los tipos de animacion a mostrar
@property (nonatomic, strong) NSArray* pickerKeys;
// Picker
@property (nonatomic, strong) UIPickerView* pickerView;

@property (nonatomic) AttachmentType attachmentType;
@property (nonatomic, strong) UIAttachmentBehavior* attachmentBehaviour;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.pickerKeys = @[@"Normal", @"Gravity", @"LeftInverseGravity", @"Snap", @"CollisionWithBoundary", @"Push", @"Attachment", @"StringAttachment"];
        self.attachmentType = AttachmentTypeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Creo el animador con la vista referente
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
    self.animator.delegate = self;

    // Creo la vista a animar
    self.viewToAnimate = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    self.viewToAnimate.backgroundColor = [UIColor cyanColor];
    // Importante, agregarla en la vista de referencia donde se animara todo! Sino crash al intentar animar
    [self.referenceView addSubview:self.viewToAnimate];

    // Creo el picker
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 300, self.view.frame.size.width, 180)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}

// Muestro el picker y cambio el boton
- (IBAction)showPicker {
    [self.pickerButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton setTitle:@"Hide Picker" forState:UIControlStateNormal];

    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerView.center = CGPointMake(self.pickerView.center.x, self.view.frame.size.height - self.pickerView.frame.size.height/2);
    }];
}

// Escondo el picker y cambio el boton
- (void)hidePicker {
    [self.pickerButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton setTitle:@"Show Picker" forState:UIControlStateNormal];

    [UIView animateWithDuration:0.4 animations:^{
        self.pickerView.center = CGPointMake(self.pickerView.center.x, self.view.frame.size.height + self.pickerView.frame.size.height/2);
    }];
}

#pragma mark - Behabiours

- (void)showNormal {
    // Remuevo todos los behaviours del animador
    [self.animator removeAllBehaviors];

    // Elimino el attachment behaviour
    self.attachmentType = AttachmentTypeNone;
    self.attachmentBehaviour = nil;
    self.diagonalLineView.alpha = 0;

    // Vuelvo la vista a animar al estado inicial
    self.viewToAnimate.frame = CGRectMake(100, 100, 20, 20);
}

- (void)showGravity {
    // Creo el behaviour de gravedad
    UIGravityBehavior* gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.viewToAnimate]];
    [self.animator addBehavior:gravityBehaviour];

    // Creo un behaviour de colision con la vista de referencia, para que no se me vaya la vista de pantalla
    UICollisionBehavior* referenceCollision = [[UICollisionBehavior alloc] initWithItems:@[self.viewToAnimate]];
    referenceCollision.translatesReferenceBoundsIntoBoundary = YES;
    referenceCollision.collisionMode = UICollisionBehaviorModeBoundaries;
    [self.animator addBehavior:referenceCollision];
}

- (void)showLeftInverseGravity {
    // Creo el behabiour de gravedad, pero el vector de gravedad apunta a un lugar custom
    UIGravityBehavior* gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.viewToAnimate]];
    gravityBehaviour.gravityDirection = CGVectorMake(-1, -1);
    [self.animator addBehavior:gravityBehaviour];

    // Creo un behaviour de colision con la vista de referencia, para que no se me vaya la vista de pantalla
    UICollisionBehavior* referenceCollision = [[UICollisionBehavior alloc] initWithItems:@[self.viewToAnimate]];
    referenceCollision.translatesReferenceBoundsIntoBoundary = YES;
    referenceCollision.collisionMode = UICollisionBehaviorModeBoundaries;
    [self.animator addBehavior:referenceCollision];
}

- (void)showSnap {
    // Creo un snap behaviour indicandole adonde tiene que ir la vista
    UISnapBehavior* snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.viewToAnimate snapToPoint:CGPointMake(250, 400)];
    [self.animator addBehavior:snapBehaviour];
}

- (void)showCollisionWithBoundary {
    // Muestro la vista con la linea diagonal (donde se hara la colision). Si no hago esto, la vista chocara con algo invisible
    self.diagonalLineView.alpha = 1;

    // Creo el behaviour de colision
    UICollisionBehavior* collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.viewToAnimate]];
    collisionBehaviour.collisionDelegate = self;
    collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    // Agrego el path de colision, en nuestro caso una linea diagonal con un identificador
    [collisionBehaviour addBoundaryWithIdentifier:@"Identifier" fromPoint:CGPointMake(self.diagonalLineView.frame.origin.x, self.diagonalLineView.frame.origin.y) toPoint:CGPointMake(self.diagonalLineView.frame.origin.x + self.diagonalLineView.frame.size.width, self.diagonalLineView.frame.origin.y + self.diagonalLineView.frame.size.height)];
    [self.animator addBehavior:collisionBehaviour];

    // Le doy gravedad para que caiga y choque
    UIGravityBehavior* gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.viewToAnimate]];
    [self.animator addBehavior:gravityBehaviour];
}

- (void)showPush {
    // Creo mi push behaviour con el vector hacia donde empujo la vista
    UIPushBehavior* pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[self.viewToAnimate] mode:UIPushBehaviorModeContinuous];
    pushBehaviour.pushDirection = CGVectorMake(1, 1);
    [self.animator addBehavior:pushBehaviour];

    // Colision con vista de referencia
    UICollisionBehavior* referenceCollision = [[UICollisionBehavior alloc] initWithItems:@[self.viewToAnimate]];
    referenceCollision.translatesReferenceBoundsIntoBoundary = YES;
    referenceCollision.collisionMode = UICollisionBehaviorModeBoundaries;
    [self.animator addBehavior:referenceCollision];
}

// Flagueo, preparandome para crear la colision en los eventos de touch
- (void)showAttachment {
    self.attachmentType = AttachmentTypeNormal;
}

// Flagueo, preparandome para crear la colision en los eventos de touch
- (void)showStringAttachment {
    self.attachmentType = AttachmentTypeString;
}

#pragma mark - UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.attachmentType == AttachmentTypeNormal) {

        // Creo mi attachment, atachando la vista a mover con el touch.
        CGPoint touchPoint = [[touches anyObject] locationInView:self.referenceView];
        self.attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.viewToAnimate attachedToAnchor:touchPoint];
        // Ajusto el tamaño del attachment
        self.attachmentBehaviour.length = 40;
        [self.animator addBehavior:self.attachmentBehaviour];

    } else if (self.attachmentType == AttachmentTypeString) {
       
        // Creo mi attachment, atachando la vista a mover con el touch.
        CGPoint touchPoint = [[touches anyObject] locationInView:self.referenceView];
        self.attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.viewToAnimate attachedToAnchor:touchPoint];
        // Ajusto el tamaño del attachment
        self.attachmentBehaviour.length = 40;
        // Ajusto la frecuencia del movimiento y el rebote
        self.attachmentBehaviour.damping = 0.8f;
        self.attachmentBehaviour.frequency = 0.5f;
        [self.animator addBehavior:self.attachmentBehaviour];

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.attachmentType != AttachmentTypeNone) {
        // Ajusto el punto de anclaje
        CGPoint touchPoint = [[touches anyObject] locationInView:self.referenceView];
        self.attachmentBehaviour.anchorPoint = touchPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Al terminar el touch remuevo el behaviour
    if (self.attachmentType != AttachmentTypeNone) {
        [self.animator removeBehavior:self.attachmentBehaviour];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Al terminar el touch remuevo el behaviour
    if (self.attachmentType != AttachmentTypeNone) {
        [self.animator removeBehavior:self.attachmentBehaviour];
    }
}

#pragma mark - UIDynamicAnimatorDelegate

// Cuando pauso el animator me avisa al delegado
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    self.workingLabel.text = @"Pause";
}

// Cuando resumo el animator me avisa al delegado
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    self.workingLabel.text = @"Working";
}

#pragma mark - UICollisionAnimatorDelegate

// Avisa cuando comienza el contacto con un boundary
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    if (identifier) {
        self.workingLabel.text = @"Began contact with line";
    } else {
        self.workingLabel.text = @"Began contact with view";
    }
}

#pragma mark - Picker

// PICKER!
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerKeys.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerKeys[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString* selectorName = [NSString stringWithFormat:@"show%@", self.pickerKeys[row]];
    [self performSelector:NSSelectorFromString(selectorName) withObject:nil];
}

@end
