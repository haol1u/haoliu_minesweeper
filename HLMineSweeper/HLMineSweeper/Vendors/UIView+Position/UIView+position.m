//
//  UIView+position.m
//
//  Apache license
//
//  Created by Tyler Neylon on 3/19/10 (http://bynomial.com/blog/?p=24)
//  Copyleft 2010 Bynomial.
//

#import "UIView+position.h"


@implementation UIView (position)

- (CGPoint)frameOrigin {
  return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
  self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
  return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          newSize.width, newSize.height);
}

- (CGFloat)frameX {
  return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
  self.frame = CGRectMake(newX, self.frame.origin.y,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
  return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
  self.frame = CGRectMake(self.frame.origin.x, newY,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
  self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
  self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
  return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
  return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          self.frame.size.width, newHeight);
}

- (void)addCenteredSubview:(UIView *)subview {
    subview.frameX = (int)((self.bounds.size.width - subview.frame.size.width) / 2);
    subview.frameY = (int)((self.bounds.size.height - subview.frame.size.height) / 2);
    [self addSubview:subview];
}

- (void)moveToCenterOfSuperview {
    if (!self.superview)
        NSLog(@"Trying to move view inside superview before attaching. Expect weird stuff.");

    self.frameX = (int)((self.superview.bounds.size.width - self.frame.size.width) / 2);
    self.frameY = (int)((self.superview.bounds.size.height - self.frame.size.height) / 2);
}

- (void)centerVerticallyInSuperview
{
    if (!self.superview)
        NSLog(@"Trying to move view inside superview before attaching. Expect weird stuff.");

    self.frameY = (int)((self.superview.bounds.size.height - self.frame.size.height) / 2);
}

- (void)centerHorizontallyInSuperview
{
    if (!self.superview)
        NSLog(@"Trying to move view inside superview before attaching. Expect weird stuff.");

    self.frameX = (int)((self.superview.bounds.size.width - self.frame.size.width) / 2);
}

@end
