
const { test, before, beforeEach, after } = require('node:test');
const fs = require('node:fs');
const path = require('node:path');

const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');

let testEnv;

const validReport = {
  reportType: 'Lipid Profile',
  reportName: 'Lipid Profile',
  reportDate: '2026-10-17T00:00:00.000',
  measurements: [
    {
      name: 'Total Cholesterol',
      value: 185,
      unit: 'mg/dL',
    },
  ],
};

// Load the rules from the Flutter project root.
before(async () => {
  const rulesPath = path.join(
    __dirname,
    '..',
    'firestore.rules',
  );

  testEnv = await initializeTestEnvironment({
    projectId: 'nutriguard-18dbd',
    firestore: {
      host: '127.0.0.1',
      port: 8080,
      rules: fs.readFileSync(rulesPath, 'utf8'),
    },
  });
});

// Start each test with an empty local database.
beforeEach(async () => {
  await testEnv.clearFirestore();
});

after(async () => {
  if (testEnv) {
    await testEnv.cleanup();
  }
});

test('User A can create their own report', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc('users/userA/healthReports/report1');

  await assertSucceeds(report.set(validReport));
});

test('User A can read their own report', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc('users/userA/healthReports/report1');

  await assertSucceeds(report.get());
});

test('User A cannot read User B report', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc('users/userB/healthReports/report1');

  await assertFails(report.get());
});

test('User A cannot write User B report', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc('users/userB/healthReports/report1');

  await assertFails(report.set(validReport));
});

test('Signed-out users cannot read reports', async () => {
  const db = testEnv.unauthenticatedContext().firestore();

  const report = db.doc('users/userA/healthReports/report1');

  await assertFails(report.get());
});

test('Missing required fields are rejected', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc('users/userA/healthReports/report1');

  await assertFails(
    report.set({
      reportName: 'Lipid Profile',
    }),
  );
});

test('Empty measurements are rejected', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc('users/userA/healthReports/report1');

  await assertFails(
    report.set({
      ...validReport,
      measurements: [],
    }),
  );
});

test('Other collections remain inaccessible', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const document = db.doc('adminSettings/config');

  await assertFails(document.get());
});



test('Invalid measurement values are rejected', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc(
    'users/userA/healthReports/invalidMeasurement'
  );

  await assertFails(
    report.set({
      ...validReport,
      measurements: [
        {
          name: 'Creatinine',
          value: 'hello',
          unit: 'mg/dL',
        },
      ],
    }),
  );
});



test('Invalid second measurement is rejected', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc(
    'users/userA/healthReports/invalidSecondMeasurement'
  );

  await assertFails(
    report.set({
      ...validReport,
      measurements: [
        {
          name: 'Total Cholesterol',
          value: 185,
          unit: 'mg/dL',
        },
        {
          name: 'LDL Cholesterol',
          value: 'invalid',
          unit: 'mg/dL',
        },
      ],
    }),
  );
});

test('More than 10 measurements are rejected', async () => {
  const db = testEnv.authenticatedContext('userA').firestore();

  const report = db.doc(
    'users/userA/healthReports/tooManyMeasurements'
  );

  const measurements = Array.from(
    { length: 11 },
    (_, index) => ({
      name: `Measurement ${index + 1}`,
      value: 10 + index,
      unit: 'mg/dL',
    }),
  );

  await assertFails(
    report.set({
      ...validReport,
      measurements,
    }),
  );
});
