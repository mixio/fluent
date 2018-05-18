/// The children relation is one side of a one-to-many database relation.
///
/// The children relation will return all the
/// models that contain a reference to the parent's identifier.
///
/// The opposite side of this relation is called `Parent`.
public struct Children<Parent, Child>
    where Parent: Model, Child: Model, Parent.Database == Child.Database, Parent.Database: QuerySupporting
{
    /// Reference to the parent's ID
    public var parent: Parent

    /// Reference to the foreign key on t(he child.
    private var foreignParentField: Child.Database.Query.Field

    /// Creates a new children relationship.
    fileprivate init(parent: Parent, foreignParentField: Child.Database.Query.Field) {
        self.parent = parent
        self.foreignParentField = foreignParentField
    }

    /// Create a query for all children.
    public func query(on conn: DatabaseConnectable) throws -> QueryBuilder<Child, Child> {
        return try Child.query(on: conn)
            .filter(foreignParentField, .fluentEqual, parent.requireID())
    }
}

// MARK: Model

extension Model {
    /// Create a children relation for this model.
    ///
    /// The `foreignField` should refer to the field
    /// on the child entity that contains the parent's ID.
    public func children<Child>(_ parentForeignIDKey: WritableKeyPath<Child, Self.ID>) -> Children<Self, Child> {
        return Children(
            parent: self,
            foreignParentField: .keyPath(parentForeignIDKey, rootType: Child.self, valueType: Self.ID.self)
        )
    }

    /// Create a children relation for this model.
    ///
    /// The `foreignField` should refer to the field
    /// on the child entity that contains the parent's ID.
    public func children<Child>(_ parentForeignIDKey: WritableKeyPath<Child, Self.ID?>) -> Children<Self, Child> {
        return Children(
            parent: self,
            foreignParentField: .keyPath(parentForeignIDKey, rootType: Child.self, valueType: Self.ID?.self)
        )
    }
}
