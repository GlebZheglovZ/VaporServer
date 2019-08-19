import Vapor
import Leaf
import FluentPostgreSQL

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Регистрируем LeafProvider
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    // Регистрируем FluentPostgreSQLProvider
    try services.register(FluentPostgreSQLProvider())
    
    // Задаем конфигурацию нашей БД
    let postgresConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "postgres", database: nil, password: "password", transport: .cleartext)
    // Создаем нашу БД на основе созданной конфигурации
    let postgresql = PostgreSQLDatabase(config: postgresConfig)
    
    var databasesConfig = DatabasesConfig()
    
    // Подключаем нашу БД
    databasesConfig.add(database: postgresql, as: .psql)
    
    // Регистрируем databasesConfig
    services.register(databasesConfig)
    
    var migrationConfig = MigrationConfig()
    
    migrationConfig.add(model: Category.self, database: .psql)
    migrationConfig.add(model: CategoryWord.self, database: .psql)
    
    services.register(migrationConfig)
    
    // Configure the rest of your application here
}
