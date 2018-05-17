/// Types conforming to this protocol can be registered with `MigrationConfig`
/// to prepare the database before your application runs. Each migration can also
/// declare an optional `revert(...)` method that undoes the migration.
///
/// Most often, the `Migration` protocol will be added to a `Model`. The default
/// conformance will create a table for the model with a field for each of the `Model`'s properties.
///
///     final class User: Model { ... }
///     extension User: Migration { }
///
/// If a field is later added to the `Model`, the previous migration can be reverted either
/// using Fluent's revert mechanism or by clearing the database (if in a dev environment).
///
/// `Migration` conformance can also be declared on non-`Model` types. This is useful for seeding
/// data into a database or for adding properties to a `Model` in a production database.
///
///     struct AddAgeProperty: Migration {
///         typealias Database = PostgreSQLDatabase
///
///         static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
///             return Database.update(User.self, on: conn) { builder in
///                 builder.field(for: \.age)
///             }
///         }
///
///         static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
///             return Database.update(User.self, on: conn) { builder in
///                 builder.removeField(for: \.age)
///             }
///         }
///     }
///
/// See `MigrationConfig` for more information on configuring migrations.
///
///     var migrations = MigrationConfig()
///     migrations.add(model: User.self, database: .psql)
///     migrations.add(migration: AddAgeProperty.self, database: .psql)
///     services.register(migrations)
///
public protocol Migration {
    /// The type of database this migration will run on.
    /// Migrations require at least a `QuerySupporting` database as they must be able to query the `MigrationLog` model.
    associatedtype Database: Fluent.Database

    /// Runs this migration's changes on the database.
    /// This is usually creating a table, or updating an existing one. You may also save new entries
    /// into an existing table.
    ///
    ///     static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
    ///         return Database.update(User.self, on: conn) { builder in
    ///             builder.field(for: \.age)
    ///         }
    ///     }
    ///
    /// - parameters:
    ///     - conn: Database connection to perform the preparation on.
    /// - returns: A `Future` that should complete when the migration has finished.
    ///            The next migration (if one exists) will start when this future completes.
    static func prepare(on connection: Database.Connection) -> Future<Void>

    /// Reverts this migration's changes on the database.
    /// This is usually dropping a created table. If it is not possible
    /// to revert the changes from this migration, complete the future with an error.
    ///
    ///     static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
    ///         return Database.update(User.self, on: conn) { builder in
    ///             builder.removeField(for: \.age)
    ///         }
    ///     }
    ///
    /// - parameters:
    ///     - conn: Database connection to perform the revert on.
    /// - returns: A `Future` that should complete when the revert has finished.
    ///            The next revert (if one exists) will start when this future completes.
    static func revert(on connection: Database.Connection) -> Future<Void>
}
