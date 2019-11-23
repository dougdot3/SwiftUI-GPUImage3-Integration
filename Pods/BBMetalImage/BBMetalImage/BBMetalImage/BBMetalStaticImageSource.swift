//
//  BBMetalStaticImageSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import MetalKit

/// An image source providing static image texture
public class BBMetalStaticImageSource {
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        lock.wait()
        let c = _consumers
        lock.signal()
        return c
    }
    private var _consumers: [BBMetalImageConsumer] = []
    
    /// Texture from static image
    public var texture: MTLTexture? {
        lock.wait()
        let t = _texture
        lock.signal()
        return t
    }
    private var _texture: MTLTexture?
    
    private var currentTexture: MTLTexture? {
        if let texture = image?.bb_metalTexture { return texture }
        if let texture = cgimage?.bb_metalTexture { return texture }
        if let texture = imageData?.bb_metalTexture { return texture }
        return nil
    }
    
    private var image: UIImage?
    private var cgimage: CGImage?
    private var imageData: Data?
    
    private let lock = DispatchSemaphore(value: 1)
    
    public init(image: UIImage) { self.image = image }
    public init(cgimage: CGImage) { self.cgimage = cgimage }
    public init(imageData: Data) { self.imageData = imageData }
    public init(texture: MTLTexture) { _texture = texture }
    
    /// Transmit texture to image consumers
    public func transmitTexture() {
        lock.wait()
        if _texture == nil { _texture = currentTexture }
        guard let texture = _texture else {
            lock.signal()
            return
        }
        let consumers = _consumers
        lock.signal()
        let output = BBMetalDefaultTexture(metalTexture: texture)
        for consumer in consumers { consumer.newTextureAvailable(output, from: self) }
    }
}

extension BBMetalStaticImageSource: BBMetalImageSource {
    @discardableResult
    public func add<T: BBMetalImageConsumer>(consumer: T) -> T {
        lock.wait()
        _consumers.append(consumer)
        lock.signal()
        consumer.add(source: self)
        return consumer
    }
    
    public func add(consumer: BBMetalImageConsumer, at index: Int) {
        lock.wait()
        _consumers.insert(consumer, at: index)
        lock.signal()
        consumer.add(source: self)
    }
    
    public func remove(consumer: BBMetalImageConsumer) {
        lock.wait()
        if let index = _consumers.firstIndex(where: { $0 === consumer }) {
            _consumers.remove(at: index)
            lock.signal()
            consumer.remove(source: self)
        } else {
            lock.signal()
        }
    }
    
    public func removeAllConsumers() {
        lock.wait()
        let consumers = _consumers
        _consumers.removeAll()
        lock.signal()
        for consumer in consumers {
            consumer.remove(source: self)
        }
    }
}

public extension UIImage {
    var bb_metalTexture: MTLTexture? {
        if let cgimage = cgImage { return cgimage.bb_metalTexture }
        return nil
    }
}

public extension CGImage {
    var bb_metalTexture: MTLTexture? {
        let loader = MTKTextureLoader(device: BBMetalDevice.sharedDevice)
        if let texture = try? loader.newTexture(cgImage: self, options: [MTKTextureLoader.Option.SRGB : false]) {
            return texture
        }
        // Texture loader can not load image data to create texture
        // Draw image and create texture
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.width = width
        descriptor.height = height
        descriptor.usage = .shaderRead
        let bytesPerRow: Int = width * 4
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        if let currentTexture = BBMetalDevice.sharedDevice.makeTexture(descriptor: descriptor),
            let context = CGContext(data: nil,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: bytesPerRow,
                                    space: BBMetalDevice.sharedColorSpace,
                                    bitmapInfo: bitmapInfo) {
            
            context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            if let data = context.data {
                currentTexture.replace(region: MTLRegionMake3D(0, 0, 0, width, height, 1),
                                       mipmapLevel: 0,
                                       withBytes: data,
                                       bytesPerRow: bytesPerRow)
                
                return currentTexture
            }
        }
        return nil
    }
}

public extension Data {
    var bb_metalTexture: MTLTexture? {
        let loader = MTKTextureLoader(device: BBMetalDevice.sharedDevice)
        return try? loader.newTexture(data: self, options: [MTKTextureLoader.Option.SRGB : false])
    }
}

public extension MTLTexture {
    var bb_cgimage: CGImage? {
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = width * bytesPerPixel
        var data = [UInt8](repeating: 0, count: Int(width * height * bytesPerPixel))
        getBytes(&data, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        if let context = CGContext(data: &data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: bytesPerRow,
                                   space: BBMetalDevice.sharedColorSpace,
                                   bitmapInfo: bitmapInfo) {
            return context.makeImage()
        }
        return nil
    }
    
    var bb_image: UIImage? {
        if let sourceImage = bb_cgimage {
            return UIImage(cgImage: sourceImage)
        }
        return nil
    }
}
