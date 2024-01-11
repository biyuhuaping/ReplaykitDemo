//
//  SampleHandler.swift
//  ReplaykitExt
//
//  Created by 苏金劲 on 2021/6/14.
//

import ReplayKit
import SKReplaykit

class SampleHandler: RPBroadcastSampleHandler {
    
    let processor = SKRExtensionProcessor(type: .writeFile, info: SKRSharedInfo(bundleId: "com.yes.GanodermaDiagnosis"))

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
//        print("broadcastStarted")
        self.processor.onStart()
        print("广播已开始")
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        print("广播暂停")
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        print("广播恢复")
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        self.processor.onFinished()
        print("广播已完成")
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        self.processor.onOutputSampleBuffer(buffer: sampleBuffer, type: sampleBufferType)
        if sampleBufferType == .video {
            // 获取视频帧数据
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                // 将图像数据转换为CIImage或者其他格式
                let ciImage = CIImage(cvPixelBuffer: imageBuffer)
                
                // 在这里可以进行进一步的处理或者打印图像信息
                print("视频帧数据：\(ciImage)")
            }
        } else if sampleBufferType == .audioApp {
            // 处理音频样本缓冲区，你可以在这里处理音频数据
            print("音频数据")
        }
        
        print("------------------------")
    }
}
