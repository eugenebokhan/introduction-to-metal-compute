import MetalTools

final class Adjustments {
    
    var temperature: Float = .zero
    var tint: Float = .zero
    private let deviceSupportsNonuniformThreadgroups: Bool
    private let pipelineState: MTLComputePipelineState
    
    init(library: MTLLibrary) throws {
        self.deviceSupportsNonuniformThreadgroups = library.device.supports(feature: .nonUniformThreadgroups)
        let constantValues = MTLFunctionConstantValues()
        constantValues.set(self.deviceSupportsNonuniformThreadgroups, at: 0)
        self.pipelineState = try library.computePipelineState(function: "adjustments",
                                                              constants: constantValues)
    }
    
    func encode(source: MTLTexture,
                destination: MTLTexture,
                in commandBuffer: MTLCommandBuffer) {
        commandBuffer.compute { encoder in
            encoder.label = "Adjustments"
            encoder.setTextures(source, destination)
            encoder.setValue(self.temperature, at: 0)
            encoder.setValue(self.tint, at: 1)
            if self.deviceSupportsNonuniformThreadgroups {
                encoder.dispatch2d(state: self.pipelineState,
                                   exactly: destination.size)
            } else {
                encoder.dispatch2d(state: self.pipelineState,
                                   covering: destination.size)
            }
        }
    }
    
}
