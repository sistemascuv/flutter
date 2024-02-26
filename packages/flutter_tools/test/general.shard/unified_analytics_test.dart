// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file/memory.dart';
<<<<<<< HEAD
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/reporting/unified_analytics.dart';
import 'package:unified_analytics/src/enums.dart';
=======
import 'package:flutter_tools/src/base/config.dart';
import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/reporting/unified_analytics.dart';
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
import 'package:unified_analytics/unified_analytics.dart';

import '../src/common.dart';
import '../src/fakes.dart';

void main() {
  const String userBranch = 'abc123';
<<<<<<< HEAD
  const String homeDirectoryName = 'home';
  const DashTool tool = DashTool.flutterTool;

  late FileSystem fs;
  late Directory home;
=======
  const String clientIde = 'VSCode';

  late FileSystem fs;
  late Config config;
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
  late FakeAnalytics analyticsOverride;

  setUp(() {
    fs = MemoryFileSystem.test();
<<<<<<< HEAD
    home = fs.directory(homeDirectoryName);

    // Prepare the tests by "onboarding" the tool into the package
    // by invoking the [clientShowedMessage] method for the provided
    // [tool]
    final FakeAnalytics initialAnalytics = FakeAnalytics(
      tool: tool,
      homeDirectory: home,
      dartVersion: '3.0.0',
      platform: DevicePlatform.macos,
      fs: fs,
      surveyHandler: SurveyHandler(
        homeDirectory: home,
        fs: fs,
      ),
    );
    initialAnalytics.clientShowedMessage();

    analyticsOverride = FakeAnalytics(
      tool: tool,
      homeDirectory: home,
      dartVersion: '3.0.0',
      platform: DevicePlatform.macos,
      fs: fs,
      surveyHandler: SurveyHandler(
        homeDirectory: home,
        fs: fs,
      ),
    );
  });

  group('Unit testing getAnalytics', () {
    testWithoutContext('Successfully creates the instance for standard branch', () {
=======
    config = Config.test();

    analyticsOverride = getInitializedFakeAnalyticsInstance(
      fs: fs,
      fakeFlutterVersion: FakeFlutterVersion(
        branch: userBranch,
      ),
      clientIde: clientIde,
    );
  });

  group('Unit testing util:', () {
    test('getEnabledFeatures is null', () {
      final String? enabledFeatures = getEnabledFeatures(config);
      expect(enabledFeatures, isNull);
    });

    testWithoutContext('getEnabledFeatures not null', () {
      config.setValue('cli-animations', true);
      config.setValue('enable-flutter-preview', true);

      final String? enabledFeatures = getEnabledFeatures(config);
      expect(enabledFeatures, isNotNull);
      expect(enabledFeatures!.split(','), unorderedEquals(<String>['enable-flutter-preview', 'cli-animations']));
    });
  });

  group('Unit testing getAnalytics', () {
    testWithoutContext('Successfully creates the instance for standard branch',
        () {
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
      final Analytics analytics = getAnalytics(
        runningOnBot: false,
        flutterVersion: FakeFlutterVersion(),
        environment: const <String, String>{},
        analyticsOverride: analyticsOverride,
<<<<<<< HEAD
=======
        clientIde: clientIde,
        config: config,
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
      );

      expect(analytics.clientId, isNot(NoOpAnalytics.staticClientId),
          reason: 'The CLIENT ID should be a randomly generated id');
      expect(analytics, isNot(isA<NoOpAnalytics>()));
    });

    testWithoutContext('NoOp instance for user branch', () {
      final Analytics analytics = getAnalytics(
        runningOnBot: false,
        flutterVersion: FakeFlutterVersion(
          branch: userBranch,
          frameworkRevision: '3.14.0-14.0.pre.370',
        ),
        environment: const <String, String>{},
        analyticsOverride: analyticsOverride,
<<<<<<< HEAD
=======
        clientIde: clientIde,
        config: config,
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
      );

      expect(
        analytics.clientId,
        NoOpAnalytics.staticClientId,
        reason: 'The client ID should match the NoOp client id',
      );
      expect(analytics, isA<NoOpAnalytics>());
    });

    testWithoutContext('NoOp instance for unknown branch', () {
      final Analytics analytics = getAnalytics(
        runningOnBot: false,
        flutterVersion: FakeFlutterVersion(
          frameworkRevision: 'unknown',
        ),
        environment: const <String, String>{},
        analyticsOverride: analyticsOverride,
<<<<<<< HEAD
=======
        clientIde: clientIde,
        config: config,
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
      );

      expect(
        analytics.clientId,
        NoOpAnalytics.staticClientId,
        reason: 'The client ID should match the NoOp client id',
      );
      expect(analytics, isA<NoOpAnalytics>());
    });

    testWithoutContext('NoOp instance when running on bots', () {
      final Analytics analytics = getAnalytics(
        runningOnBot: true,
        flutterVersion: FakeFlutterVersion(),
        environment: const <String, String>{},
        analyticsOverride: analyticsOverride,
<<<<<<< HEAD
=======
        clientIde: clientIde,
        config: config,
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
      );

      expect(
        analytics.clientId,
        NoOpAnalytics.staticClientId,
        reason: 'The client ID should match the NoOp client id',
      );
      expect(analytics, isA<NoOpAnalytics>());
    });

    testWithoutContext('NoOp instance when suppressing via env variable', () {
      final Analytics analytics = getAnalytics(
<<<<<<< HEAD
        runningOnBot: true,
        flutterVersion: FakeFlutterVersion(),
        environment: const <String, String>{'FLUTTER_SUPPRESS_ANALYTICS': 'true'},
        analyticsOverride: analyticsOverride,
=======
        runningOnBot: false,
        flutterVersion: FakeFlutterVersion(),
        environment: const <String, String>{'FLUTTER_SUPPRESS_ANALYTICS': 'true'},
        analyticsOverride: analyticsOverride,
        clientIde: clientIde,
        config: config,
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
      );

      expect(
        analytics.clientId,
        NoOpAnalytics.staticClientId,
        reason: 'The client ID should match the NoOp client id',
      );
      expect(analytics, isA<NoOpAnalytics>());
    });
<<<<<<< HEAD
=======

    testWithoutContext('Suppression prevents events from being sent', () {
      expect(analyticsOverride.okToSend, true);
      analyticsOverride.send(Event.surveyShown(surveyId: 'surveyId'));
      expect(analyticsOverride.sentEvents, hasLength(1));

      analyticsOverride.suppressTelemetry();
      expect(analyticsOverride.okToSend, false);
      analyticsOverride.send(Event.surveyShown(surveyId: 'surveyId'));

      expect(analyticsOverride.sentEvents, hasLength(1));
    });

    testWithoutContext('Client IDE is passed and found in events', () {
      final Analytics analytics = getAnalytics(
        runningOnBot: false,
        flutterVersion: FakeFlutterVersion(),
        environment: const <String, String>{},
        analyticsOverride: analyticsOverride,
        clientIde: clientIde,
        config: config,
      );
      analytics as FakeAnalytics;

      expect(analytics.userProperty.clientIde, 'VSCode');
    });
>>>>>>> abb292a07e20d696c4568099f918f6c5f330e6b0
  });
}
