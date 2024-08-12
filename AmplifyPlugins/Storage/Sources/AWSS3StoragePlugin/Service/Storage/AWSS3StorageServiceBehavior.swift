//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify
import AWSS3

protocol AWSS3StorageServiceBehavior {
    typealias StorageServiceDownloadEventHandler = (StorageServiceDownloadEvent) -> Void
    typealias StorageServiceDownloadEvent =
        StorageEvent<StorageTaskReference, Progress, Data?, StorageError>

    // swiftlint:disable:next type_name
    typealias StorageServiceGetPreSignedURLEventHandler = (StorageServiceGetPreSignedURLEvent) -> Void
    typealias StorageServiceGetPreSignedURLEvent = StorageEvent<Void, Void, URL, StorageError>

    typealias StorageServiceDeleteEventHandler = (StorageServiceDeleteEvent) -> Void
    typealias StorageServiceDeleteEvent = StorageEvent<Void, Void, Void, StorageError>

    typealias StorageServiceListEventHandler = (StorageServiceListEvent) -> Void
    typealias StorageServiceListEvent = StorageEvent<Void, Void, StorageListResult, StorageError>

    typealias StorageServiceUploadEventHandler = (StorageServiceUploadEvent) -> Void
    typealias StorageServiceUploadEvent =
        StorageEvent<StorageTaskReference, Progress, Void, StorageError>

    // swiftlint:disable:next type_name
    typealias StorageServiceMultiPartUploadEventHandler = (StorageServiceMultiPartUploadEvent) -> Void
    typealias StorageServiceMultiPartUploadEvent =
        StorageEvent<StorageTaskReference, Progress, Void, StorageError>


    /// - Tag: AWSS3StorageService.client
    var client: S3ClientProtocol { get }

    var bucket: String! { get }

    func reset()

    func client(forRegion region: String) -> S3Client

    func getEscapeHatch() -> S3Client

    func download(serviceKey: String,
                  bucket: AWSS3Bucket,
                  fileURL: URL?,
                  accelerate: Bool?,
                  onEvent: @escaping StorageServiceDownloadEventHandler)

    func getPreSignedURL(serviceKey: String,
                         bucket: AWSS3Bucket,
                         signingOperation: AWSS3SigningOperation,
                         metadata: [String: String]?,
                         accelerate: Bool?,
                         expires: Int) async throws -> URL

    func validateObjectExistence(serviceKey: String, bucket: AWSS3Bucket) async throws

    func upload(serviceKey: String,
                bucket: AWSS3Bucket,
                uploadSource: UploadSource,
                contentType: String?,
                metadata: [String: String]?,
                accelerate: Bool?,
                onEvent: @escaping StorageServiceUploadEventHandler)

    func multiPartUpload(serviceKey: String,
                         bucket: AWSS3Bucket,
                         uploadSource: UploadSource,
                         contentType: String?,
                         metadata: [String: String]?,
                         accelerate: Bool?,
                         onEvent: @escaping StorageServiceMultiPartUploadEventHandler)

    @available(*, deprecated, message: "Use `AWSS3StorageListObjectsTask` instead")
    func list(prefix: String,
              bucket: AWSS3Bucket,
              options: StorageListRequest.Options) async throws -> StorageListResult

    @available(*, deprecated, message: "Use `AWSS3StorageRemoveTask` instead")
    func delete(serviceKey: String,
                bucket: AWSS3Bucket,
                onEvent: @escaping StorageServiceDeleteEventHandler)
}
