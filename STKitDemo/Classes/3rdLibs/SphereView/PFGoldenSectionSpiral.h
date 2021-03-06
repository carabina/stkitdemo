//This file is part of SphereView.
//
//SphereView is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//SphereView is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with SphereView.  If not, see <http://www.gnu.org/licenses/>.

#import <math.h>

#define PFMatrixMaxSize 4

struct PFMatrix {
    NSInteger m;
    NSInteger n;
    
    CGFloat data[PFMatrixMaxSize][PFMatrixMaxSize];
};
typedef struct PFMatrix PFMatrix;


typedef enum {
    PFAxisDirectionNone,
    PFAxisDirectionPositive = 1,
    PFAxisDirectionNegative = -1
} PFAxisDirection;

static CGFloat PFAxisDirectionMinimumDistance = 0.033f;


struct PFPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};
typedef struct PFPoint PFPoint;


@interface PFGoldenSectionSpiral : NSObject {

}

+ (NSArray *)sphere:(NSInteger)n;

@end

typedef CGFloat PFRadian;

extern PFRadian PFRadianMake(CGFloat grades);



extern PFMatrix PFMatrixTransform3DMakeFromPFPoint(PFPoint point);

extern PFMatrix PFMatrixTransform3DMakeTranslation(PFPoint point);

extern PFMatrix PFMatrixTransform3DMakeXRotation(PFRadian angle);

extern PFMatrix PFMatrixTransform3DMakeXRotationOnPoint(PFPoint point, PFRadian angle);
extern PFMatrix PFMatrixTransform3DMakeYRotation(PFRadian angle);

extern PFMatrix PFMatrixTransform3DMakeYRotationOnPoint(PFPoint point, PFRadian angle);

extern PFMatrix PFMatrixTransform3DMakeZRotation(PFRadian angle);

extern PFMatrix PFMatrixTransform3DMakeZRotationOnPoint(PFPoint point, PFRadian angle);


extern PFMatrix PFMatrixMake(NSInteger m, NSInteger n);
extern PFMatrix PFMatrixMakeFromArray(NSInteger m, NSInteger n, CGFloat *data);
extern PFMatrix PFMatrixMakeIdentity(NSInteger m, NSInteger n);
extern PFMatrix PFMatrixMultiply(PFMatrix A, PFMatrix B);
extern NSString *NSStringFromPFMatrix(PFMatrix matrix);


extern PFPoint PFPointMake(CGFloat x, CGFloat y, CGFloat z);
extern PFPoint PFPointMakeFromMatrix(PFMatrix matrix);
extern NSString *NSStringFromPFPoint(PFPoint point);
extern CGPoint CGPointMakeNormalizedPoint(CGPoint point, CGFloat distance);


extern PFAxisDirection PFAxisDirectionMake(CGFloat fromCoordinate, CGFloat toCoordinate, BOOL sensitive);
extern PFAxisDirection PFDirectionMakeXAxis(CGPoint fromPoint, CGPoint toPoint);
extern PFAxisDirection PFDirectionMakeYAxis(CGPoint fromPoint, CGPoint toPoint);
extern PFAxisDirection PFDirectionMakeXAxisSensitive(CGPoint fromPoint, CGPoint toPoint);
extern PFAxisDirection PFDirectionMakeYAxisSensitive(CGPoint fromPoint, CGPoint toPoint);