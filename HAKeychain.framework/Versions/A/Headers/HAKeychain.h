//
//  HAKeychain.h
//  HAKeychain
//
//  Created by Marc Hedlund on 7/23/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HAKeychain : NSObject {
@private
    
}

+ (BOOL)createPassword:(NSString *)password
            forService:(NSString *)service
               account:(NSString *)account
              keychain:(SecKeychainRef)keychain
                 error:(NSError **)error;

+ (NSString *)findPasswordForService:(NSString *)service
                             account:(NSString *)account
                            keychain:(SecKeychainRef)keychain
                               error:(NSError **)error;

+ (BOOL)updatePassword:(NSString *)password
            forService:(NSString *)service
               account:(NSString *)account
              keychain:(SecKeychainRef)keychain
                 error:(NSError **)error;

+ (BOOL)deletePasswordForService:(NSString *)service
                         account:(NSString *)account
                        keychain:(SecKeychainRef)keychain
                           error:(NSError **)error;

@end
