/// MARK: Field convenience

extension SchemaBuilder where Model.Database: ReferenceSupporting {
    /// Adds a field to the schema and creates a reference.
    /// T : T
    public func field<T, Other>(for base: KeyPath<Model, T>, referenced: KeyPath<Other, T>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try field(for: base)
        try addReference(from: base, to: referenced, actions: actions)
    }

    /// Adds a field to the schema and creates a reference.
    /// T : T?
    public func field<T, Other>(for base: KeyPath<Model, T>, referenced: KeyPath<Other, T?>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try field(for: base)
        try addReference(from: base, to: referenced, actions: actions)
    }

    /// Adds a field to the schema and creates a reference.
    /// T? : T
    public func field<T, Other>(for base: KeyPath<Model, T?>, referenced: KeyPath<Other, T>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try field(for: base)
        try addReference(from: base, to: referenced, actions: actions)
    }

    /// Adds a field to the schema and creates a reference.
    /// T? : T?
    public func field<T, Other>(for base: KeyPath<Model, T?>, referenced: KeyPath<Other, T?>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try field(for: base)
        try addReference(from: base, to: referenced, actions: actions)
    }
}

/// MARK: Add

extension SchemaBuilder where Model.Database: ReferenceSupporting {
    /// Adds a reference.
    /// T : T
    public func addReference<T, Other>(from base: KeyPath<Model, T>, to referenced: KeyPath<Other, T>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try _addReference(from: base, to: referenced, actions: actions)
    }

    /// Adds a reference.
    /// T? : T
    public func addReference<T, Other>(from base: KeyPath<Model, T?>, to referenced: KeyPath<Other, T>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try _addReference(from: base, to: referenced, actions: actions)
    }

    /// Adds a reference.
    /// T : T?
    public func addReference<T, Other>(from base: KeyPath<Model, T>, to referenced: KeyPath<Other, T?>, actions: ReferentialActions = .default) throws
        where Other: Fluent.Model
    {
        try _addReference(from: base, to: referenced, actions: actions)
    }

    /// Internal add reference. Does not verify types match.
    private func _addReference<T, U, Other>(from base: KeyPath<Model, T>, to referenced: KeyPath<Other, U>, actions: ReferentialActions) throws
        where Other: Fluent.Model
    {
        let reference = try SchemaReference<Model.Database>(
            base: base.makeQueryField(),
            referenced: referenced.makeQueryField(),
            actions: actions
        )
        schema.addReferences.append(reference)
    }
}

/// MARK: Remove

extension SchemaBuilder where Model.Database: ReferenceSupporting {
    /// Removes a reference.
    /// T : T
    public func removeReference<T, Other>(from base: KeyPath<Model, T>, to referenced: KeyPath<Other, T>) throws
        where Other: Fluent.Model
    {
        try _removeReference(from: base, to: referenced)
    }

    /// Removes a reference.
    /// T? : T
    public func removeReference<T, Other>(from base: KeyPath<Model, T?>, to referenced: KeyPath<Other, T>) throws
        where Other: Fluent.Model
    {
        try _removeReference(from: base, to: referenced)
    }

    /// Removes a reference.
    /// T : T?
    public func removeReference<T, Other>(from base: KeyPath<Model, T>, to referenced: KeyPath<Other, T?>) throws
        where Other: Fluent.Model
    {
        try _removeReference(from: base, to: referenced)
    }

    /// Internal remove reference. Does not verify types match.
    private func _removeReference<T, U, Other>(from base: KeyPath<Model, T>, to referenced: KeyPath<Other, U>) throws
        where Other: Fluent.Model
    {
        let reference = try SchemaReference<Model.Database>(
            base: base.makeQueryField(),
            referenced: referenced.makeQueryField(),
            actions: .default
        )
        schema.removeReferences.append(reference)
    }
}
