//
// Copyright (c) 2017 Emarsys. All rights reserved.
//

#import "EMSRequestModelBuilder.h"
#import "EMSTimestampProvider.h"
#import "EMSUUIDProvider.h"

@implementation EMSRequestModelBuilder


- (instancetype)initWithTimestampProvider:(EMSTimestampProvider *)timestampProvider
                             uuidProvider:(EMSUUIDProvider *)uuidProvider {
    if (self = [super init]) {
        _requestId = [[uuidProvider provideUUID] UUIDString];
        _timestamp = [timestampProvider provideTimestamp];
        _requestMethod = @"POST";
        _expiry = DEFAULT_REQUESTMODEL_EXPIRY;
    }
    return self;
}


- (EMSRequestModelBuilder *)setMethod:(HTTPMethod)method {
    switch (method) {
        case HTTPMethodPOST:
            _requestMethod = @"POST";
            break;
        case HTTPMethodGET:
            _requestMethod = @"GET";
            break;
        case HTTPMethodDELETE:
            _requestMethod = @"DELETE";
            break;
    }
    return self;
}

- (EMSRequestModelBuilder *)setUrl:(NSString *)url {
    NSURL *urlToCheck = [NSURL URLWithString:url];
    if (urlToCheck && urlToCheck.scheme && urlToCheck.host) {
        _requestUrl = urlToCheck;
    }
    return self;
}

- (EMSRequestModelBuilder *)setExpiry:(NSTimeInterval)expiry {
    _expiry = expiry;
    return self;
}

- (EMSRequestModelBuilder *)setPayload:(NSDictionary<NSString *, id> *)payload {
    _payload = payload;
    return self;
}

- (EMSRequestModelBuilder *)setHeaders:(NSDictionary<NSString *, NSString *> *)headers {
    _headers = headers;
    return self;
}

- (EMSRequestModelBuilder *)setExtras:(NSDictionary<NSString *, NSString *> *)extras {
    _extras = extras;
    return self;
}

@end