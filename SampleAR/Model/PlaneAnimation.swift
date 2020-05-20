//
//  PlaneAnimation.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

//MARK: - REF
//https://www.appcoda.com/arkit-horizontal-plane/
//https://developer.apple.com/documentation/arkit/detecting_images_in_an_ar_experience
//https://www.appcoda.com/arkit-image-recognition/
//https://medium.com/krootl/arkit-tutorial-image-recognition-and-virtual-content-transform-91484ceaf5d5


import Foundation
import SceneKit

struct PlaneAnimation{
    var startTime: TimeInterval
    var duration: TimeInterval
    var initialModelPosition: simd_float3
    var finalModelPosition: simd_float3
    var initialModelOrientation: simd_quatf
    var finalModelOrientation: simd_quatf
}
