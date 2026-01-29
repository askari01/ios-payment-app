protocol AuthRepository: Sendable {
    func authenticate() async throws -> AuthResponse
}
