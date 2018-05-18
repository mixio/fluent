extension Model where Self.Database: QuerySupporting {
    /// Saves the model, calling either `create(...)` or `update(...)` depending on whether
    /// the model already has an ID.
    ///
    /// If you need to create a model with a pre-existing ID, call `create` instead.
    ///
    ///     let user = User(...)
    ///     user.save(on: req)
    ///
    /// - parameters:
    ///     - conn: Database connection to use.
    /// - returns: Future containing the saved model.
    public func save(on conn: DatabaseConnectable) -> Future<Self> {
        return query(on: conn).save(self)
    }

    /// Saves this model as a new item in the database.
    /// This method can auto-generate an ID depending on ID type.
    ///
    ///     let user = User(...)
    ///     user.create(on: req)
    ///
    /// - parameters:
    ///     - conn: Database connection to use.
    /// - returns: Future containing the created model.
    public func create(on conn: DatabaseConnectable) -> Future<Self> {
        return query(on: conn).create(self)
    }

    /// Updates the model. This requires that the model has its ID set.
    ///
    ///     user.update(on: req, originalID: 42)
    ///
    /// - parameters:
    ///     - conn: Database connection to use.
    ///     - originalID: Specify the original ID if the ID has changed.
    /// - returns: Future containing the updated model.
    public func update(on conn: DatabaseConnectable, originalID: ID? = nil) -> Future<Self> {
        return query(on: conn).update(self, originalID: originalID)
    }

    /// Deletes this model from the database. This requires that the model has its ID set.
    ///
    ///     user.delete(on: req)
    ///
    /// - parameters:
    ///     - conn: Database connection to use.
    /// - returns: Future that will be completed when the delete is done.
    public func delete(on conn: DatabaseConnectable) -> Future<Void> {
        return query(on: conn).delete(self)
    }
}

/// MARK: Future + CRUD

extension Future where T: Model, T.Database: QuerySupporting {
    /// See `Model`.
    public func save(on connectable: DatabaseConnectable) -> Future<T> {
        return self.flatMap(to: T.self) { (model) in
            return model.save(on: connectable).transform(to: model)
        }
    }

    /// See `Model`.
    public func create(on connectable: DatabaseConnectable) -> Future<T> {
        return self.flatMap(to: T.self) { (model) in
            return model.create(on: connectable).transform(to: model)
        }
    }

    /// See `Model`.
    public func update(on connectable: DatabaseConnectable) -> Future<T> {
        return self.flatMap(to: T.self) { (model) in
            return model.update(on: connectable).transform(to: model)
        }
    }

    /// See `Model`.
    public func delete(on connectable: DatabaseConnectable) -> Future<T> {
        return self.flatMap(to: T.self) { (model) in
            return model.delete(on: connectable).transform(to: model)
        }
    }
}
