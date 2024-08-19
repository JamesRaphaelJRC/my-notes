extension Filter<T> on Stream<List<T>> {
  /// Allows filter a Stream of List an object of any type
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
