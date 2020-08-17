import 'package:encrypt/bloc/main/key_pair.dart';
import 'package:encrypt/bloc/main/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'backbone.dart';
import 'mock.dart';

void main() {
  final MockMainBlocFacade mockFacade = MockMainBlocFacade();

  setUp(() {
    mockFacade.givesNothing();
  });

  tearDown(() {
    reset(mockFacade);
  });
  MainPageBloc createTestSubject() => MainPageBloc(mockFacade);
  group("Creating", () {
    test("Assert that initial state emitted", () {
      final MainPageBloc subject = createTestSubject();
      expect(subject.stateStream,
          emits(predicate((MainPageBlocState state) => state.isLoading)));
    });

    test("Assert that facade was called for stored key pair", () async {
      createTestSubject();
      await reschedule(times: 1);
      verify(mockFacade.getStoredKeyPair());
    });
    test("Assert that stored key is set to state if facade gives it", () async {
      final KeyPair givenKeyPair =
          KeyPair(publicKey: "publicKey", privateKey: "privateKey");
      mockFacade.givesStored(givenKeyPair);
      final MainPageBloc bloc = createTestSubject();
      await reschedule(times: 3);
      expect(
          bloc.stateStream,
          emits(predicate(
              (MainPageBlocState state) => state.keyPair == givenKeyPair)));
    });
  });
  group('Generation', () {
    test(
        "Assert that generate method of facade"
        " was called after bloc generate method was called", () async {
      final MainPageBloc bloc = createTestSubject();
      await reschedule(times: 1);
      bloc.generateKeyPair();
      await reschedule(times: 1);
      verify(mockFacade.generateKeyPair());
    });
    test("Assert that generated key  pair is set to state", () async {
      final KeyPair givenKeyPair =
          KeyPair(publicKey: "publicKey", privateKey: "privateKey");
      mockFacade.generatesKeyPair(givenKeyPair);
      final MainPageBloc bloc = createTestSubject();
      await reschedule(times: 1);
      bloc.generateKeyPair();
      await reschedule(times: 3);
      expect(
          bloc.stateStream,
          emits(predicate(
              (MainPageBlocState state) => state.keyPair == givenKeyPair)));
    });
    test("Assert that error is added to state if generate method gives error",
        () async {
      final Exception givenException = Exception();
      mockFacade.generationGivesError(givenException);
      final MainPageBloc bloc = createTestSubject();
      await reschedule(times: 1);
      bloc.generateKeyPair();
      await reschedule(times: 3);
      expect(
          bloc.stateStream,
          emits(predicate(
              (MainPageBlocState state) => state.error == givenException)));
    });
  });
  group("Add record", () {
    test("Assert that private key is added to record if it exists in state",
        () async {
      final KeyPair givenKeyPair =
          KeyPair(publicKey: "publicKey", privateKey: "privateKey");
      mockFacade.generatesKeyPair(givenKeyPair);
      final MainPageBloc bloc = createTestSubject();
      bloc.generateKeyPair();
      await reschedule(times: 3);
      bloc.viewPrivateKey();
      await reschedule(times: 3);
      expect(
          bloc.stateStream,
          emits(predicate((MainPageBlocState state) =>
              state.records.contains(givenKeyPair.privateKey))));
    });
    test("Assert that private key is added to record if it exists in state",
        () async {
      final KeyPair givenKeyPair =
          KeyPair(publicKey: "publicKey", privateKey: "privateKey");
      mockFacade.generatesKeyPair(givenKeyPair);
      final MainPageBloc bloc = createTestSubject();
      bloc.generateKeyPair();
      await reschedule(times: 3);
      bloc.viewPublicKey();
      await reschedule(times: 3);
      expect(
          bloc.stateStream,
          emits(predicate((MainPageBlocState state) =>
              state.records.contains(givenKeyPair.publicKey))));
    });
    test("Assert that encrypt method called on text record add", () async {
      final KeyPair givenKeyPair =
          KeyPair(publicKey: "publicKey", privateKey: "privateKey");
      const String givenText = "givenText";
      mockFacade.generatesKeyPair(givenKeyPair);
      final MainPageBloc bloc = createTestSubject();
      bloc.generateKeyPair();
      await reschedule(times: 3);
      bloc.makeRecord(givenText);
      await reschedule(times: 2);
      verify(mockFacade.encryptMessage(givenText, givenKeyPair.publicKey));
    });
  });
}

extension _EmptyResultsFixture on MockMainBlocFacade {
  void givesNothing() {
    when(getStoredKeyPair()).thenAnswer((_) => Future<KeyPair>.value(null));
    when(generateKeyPair()).thenAnswer((_) => Future<KeyPair>.value(null));
    when(encryptMessage(any, any))
        .thenAnswer((_) => Future<String>.value(null));
  }

  void generatesKeyPair(KeyPair pair) {
    when(generateKeyPair()).thenAnswer((_) => Future<KeyPair>.value(pair));
  }

  void givesStored(KeyPair pair) {
    when(getStoredKeyPair()).thenAnswer((_) => Future<KeyPair>.value(pair));
  }

  void generationGivesError(Object exception) => when(generateKeyPair())
      .thenAnswer((_) => Future<KeyPair>.error(exception));
}
