//
//  PlatformInitializer.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 15.12.2022.
//

import SDWebImage

func initializePlatform() {
    let cache = SDImageCache(namespace: "test_pixabay_cache")
    cache.config.maxMemoryCost = 100 * 1024 * 1024 // 100Mb memory
    cache.config.maxDiskSize = 100 * 1024 * 1024 // 100Mb disk
    cache.config.maxDiskAge = 60 * 60 * 24 // 60s disk age
    SDImageCachesManager.shared.addCache(cache)
}
