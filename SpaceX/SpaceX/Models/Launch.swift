import Foundation

struct Launch: Decodable, Identifiable {
    struct Links: Decodable {
        let patch: Patch
    }

    struct Patch: Decodable {
        let small: URL?
        let large: URL?
    }

    let id: String
    let name: String
    let details: String?
    let rocket: String
    let success: Bool?
    let date_utc: Date?
    let capsules: [String]?
    let payloads: [String]?
    let crew: [Crew]?
    let launchpad: String
    let links: Links

    var patchImage: URL? { links.patch.small }
}

struct Crew: Decodable {
    let crew: String
    let role: String
}
