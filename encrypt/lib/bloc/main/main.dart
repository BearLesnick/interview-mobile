import 'dart:async';

import 'package:encrypt/bloc/main/facade.dart';
import 'package:encrypt/bloc/main/key_pair.dart';
import 'package:encrypt/meta/bloc.dart';
import 'package:rxdart/rxdart.dart';

class MainPageBloc {
  final MainBlocFacade _facade;

  final BehaviorSubject<MainPageBlocState> _stateSubject =
      BehaviorSubject<MainPageBlocState>();

  Stream<MainPageBlocState> get stateStream => _stateSubject.stream;
  StreamSubscription<MainPageEvent> _eventSubscription;

  final BehaviorSubject<MainPageEvent> _eventSubject =
      BehaviorSubject<MainPageEvent>();

  Sink<MainPageEvent> get _eventSink => _eventSubject.sink;

  MainPageBloc(this._facade) {
    _eventSubscription = _eventSubject.stream.listen((MainPageEvent event) {
      _stateSubject.value = event.reduce(_stateSubject.value);
    });
    _eventSink.add(_InitialEvent(_eventSink, _facade.getStoredKeyPair));
  }

  void dispose() {
    _stateSubject?.close();
    _eventSubject?.close();
    _eventSubscription?.cancel();
  }

  void generateKeyPair() {
    _eventSink.add(_GeneratePairEvent(_eventSink, _facade));
  }

  void viewPrivateKey() => _eventSink.add(_ShowPrivateKeyEvent());

  void viewPublicKey() => _eventSink.add(_ShowPublicKeyEvent());

  void makeRecord(String text) {
    _eventSink.add(_MakeRecordEvent(_facade, _eventSink, text));
  }
}

abstract class MainPageEvent {
  MainPageBlocState reduce(MainPageBlocState state);
}

class _MakeRecordEvent implements MainPageEvent {
  final MainBlocFacade _facade;
  final Sink<MainPageEvent> _eventSink;
  final String plainText;

  _MakeRecordEvent(this._facade, this._eventSink, this.plainText);

  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    if (plainText != null && plainText.isNotEmpty) {
      _facade.encryptMessage(plainText, state.keyPair.publicKey).then(
          (String cipherText) =>
              _eventSink.add(_MessageAddedEvent(cipherText)));
      return state.copyWith(status: BlocStatus.loading);
    }
    return state;
  }
}

class _MessageAddedEvent implements MainPageEvent {
  final String cipherText;

  _MessageAddedEvent(this.cipherText);

  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    return state.copyWith(
        status: BlocStatus.idle, records: state.records..add(cipherText));
  }
}

class _PairGenerationErrorEvent implements MainPageEvent {
  final Object error;

  _PairGenerationErrorEvent(this.error);

  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    return state.copyWith(error: error, status: BlocStatus.idle);
  }
}

class _InitialEvent implements MainPageEvent {
  final Future<KeyPair> Function() getKeyPair;
  final Sink<MainPageEvent> _eventSink;

  _InitialEvent(this._eventSink, this.getKeyPair);

  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    getKeyPair()
        .then((KeyPair value) =>
            _eventSink.add(_KeyPairReceivedStoreEvent(value)))
        .catchError(
            (Object error) => _eventSink.add(_KeyPairReceivedStoreEvent(null)));
    return MainPageBlocState.initial();
  }
}

class _ShowPrivateKeyEvent implements MainPageEvent {
  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    return state.copyWith(
        records: state.records..add(state.keyPair.privateKey));
  }
}

class _ShowPublicKeyEvent implements MainPageEvent {
  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    return state.copyWith(records: state.records..add(state.keyPair.publicKey));
  }
}

class _GeneratePairEvent implements MainPageEvent {
  final MainBlocFacade _facade;
  final Sink<MainPageEvent> _eventSink;

  _GeneratePairEvent(this._eventSink, this._facade);

  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    if (state.keyPair == null) {
      _facade
          .generateKeyPair()
          .then((KeyPair pair) =>
              _eventSink.add(_KeyPairReceivedStoreEvent(pair)))
          .catchError((Object error) =>
              _eventSink.add(_PairGenerationErrorEvent(error)));
      return state.copyWith(status: BlocStatus.loading);
    }

    return state;
  }
}

class _KeyPairReceivedStoreEvent implements MainPageEvent {
  final KeyPair pair;

  _KeyPairReceivedStoreEvent(this.pair);

  @override
  MainPageBlocState reduce(MainPageBlocState state) {
    return state.copyWith(keyPair: pair, status: BlocStatus.idle);
  }
}

class MainPageBlocState {
  final List<String> records;

  final KeyPair keyPair;

  final Object error;
  final BlocStatus status;

  MainPageBlocState._(
    this.records,
    this.error,
    this.status,
    this.keyPair,
  );

  MainPageBlocState copyWith({
    KeyPair keyPair,
    List<String> records,
    Object error,
    BlocStatus status,
  }) =>
      MainPageBlocState._(records ?? this.records, error ?? this.error,
          status ?? this.status, keyPair ?? this.keyPair);

  MainPageBlocState.initial()
      : this._(
          <String>[],
          null,
          BlocStatus.loading,
          null,
        );

  bool get hasKeyPair => keyPair != null;

  bool get isLoading => status == BlocStatus.loading;

  bool get hasError => error != null;
}
