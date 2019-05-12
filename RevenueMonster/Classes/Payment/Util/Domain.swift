//
//  Domain.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

internal class Domain {
    var env: Env = Env.PRODUCTION;
    var PRODUCTION_PG_URL: String = "https://pg.revenuemonster.my";
    var SANDBOX_PG_URL: String = "https://sb-pg.revenuemonster.my";
    var DEVELOPMENT_PG_URL: String = "https://dev-rm-api.ap.ngrok.io";

    public init(_ env: Env) {
        self.env = env;
    }

    public func getPaymentGatewayURL() -> String {
        switch self.env {
        case .DEVELOPMENT:
            return DEVELOPMENT_PG_URL
        case .SANDBOX:
            return SANDBOX_PG_URL
        default:
            return PRODUCTION_PG_URL;
        }
    }
}
