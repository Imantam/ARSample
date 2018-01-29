//
//  TrackingState.swift
//  ARSampleApplication
//
//  Created by Yuya Imagawa on 2018/01/17.
//  Copyright © 2018年 Tobila Systems. All rights reserved.
//

import ARKit

extension ARCamera.TrackingState {
    public var description: String {
        switch self {
        case .notAvailable:
            return "利用できません。"
        case .normal:
            return "正常です。"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "端末を高速で動かさないでください。"
            case .insufficientFeatures:
                return "画像の識別ができません。"
            case .initializing:
                return "初期化中です。"
            }
        }
    }
}
