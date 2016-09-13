//
//  MHealthResponse+CoreDataProperties.h
//  
//
//  Created by DangLV on 13/07/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MHealthResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHealthResponse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *requestDate;
@property (nullable, nonatomic, retain) NSNumber *requestStatus;
@property (nullable, nonatomic, retain) id response;

@end

NS_ASSUME_NONNULL_END
