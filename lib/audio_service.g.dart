// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioServiceHash() => r'1e7c369b54f9bd42309891ad38c49e92164ecf09';

/// Audio service for managing all game sounds
///
/// Copied from [AudioService].
@ProviderFor(AudioService)
final audioServiceProvider = AsyncNotifierProvider<AudioService, bool>.internal(
  AudioService.new,
  name: r'audioServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$audioServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AudioService = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
