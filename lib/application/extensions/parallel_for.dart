import 'dart:async';

extension Parallel<T> on Iterable<T> {
  Future<Iterable<TOut>> parallelMap<TOut>(
      Future<TOut> Function(T input) kernel) async {
    return await Future.wait(map(kernel));
  }

  Future<void> parallelFor(
      Future<void> Function(int index, T input) kernel) async {
    final futures =
        toList().asMap().entries.map((entry) => kernel(entry.key, entry.value));
    await Future.wait(futures);
  }

  Future<void> parallelInvoke(Future<void> Function(T input) kernel) async {
    final futures = map(kernel);
    await Future.wait(futures);
  }
}
