// seed_firestore.js
// Run: node seed_firestore.js
// Seeds Firestore with initial tasks data using Firebase Admin SDK via REST API

const https = require('https');

const PROJECT_ID = 'nayeankh';
const API_KEY = 'AIzaSyAZlv702-mVTEf-gUcdchgvQfn47yA4wuI';

const tasks = [
  {
    id: 'task-1',
    title: 'Virtual English Mentorship',
    description: 'Support high school students from underprivileged backgrounds with conversational English practice.',
    category: 'Education',
    deadlineText: 'Ends in 2 days',
    location: 'Remote, Virtual',
    volunteersCount: 14,
    points: 200,
    peopleEmpowered: 15,
    extendedDescription: 'Join our digital mentorship cohort! Underprivileged high schoolers in UP rural zones require real-time interactive dialogue to master conversational English.',
    instructions: [
      'Download and review the Virtual English module briefing.',
      'Connect with the education lead to coordinate students schedules.',
      'Facilitate the virtual conversational sessions on Zoom/Meet.',
      'Record basic feedback logs for each student after the lesson.'
    ],
    resources: [
      { name: 'Conversational_Module_Eng.pdf', size: '1.8 MB', type: 'pdf' },
      { name: 'Tutorial_Mentorship.mp4', size: '32.1 MB', type: 'video' }
    ]
  },
  {
    id: 'task-2',
    title: 'Local Park Reforestation',
    description: 'Join our weekend drive to plant 500 saplings at the Green Valley Reserve. Tools provided!',
    category: 'Environment',
    deadlineText: 'Oct 24, 2026',
    location: 'Green Valley Reserve',
    volunteersCount: 45,
    points: 150,
    peopleEmpowered: 120,
    extendedDescription: 'In coordination with city forestry experts, we are greening the degraded patches of Green Valley.',
    instructions: [
      'Report to the assembly shelter by 7:30 AM.',
      'Collect standard planting gloves, trowels, and allocated saplings.',
      'Plant at least 8 saplings in accordance with instructions.',
      'Photograph your designated plot with geotags active.'
    ],
    resources: [
      { name: 'Forestry_Guide.pdf', size: '3.4 MB', type: 'pdf' }
    ]
  },
  {
    id: 'task-3',
    title: 'Food Distribution Lead',
    description: 'Coordinating logistics for the weekly community kitchen. Requires organization and empathy.',
    category: 'Community',
    deadlineText: 'Urgent',
    location: 'Lucknow Center, India',
    volunteersCount: 8,
    points: 300,
    peopleEmpowered: 350,
    extendedDescription: 'Be the lead coordinator overseeing distribution arrays at the Lucknow shelter home.',
    instructions: [
      'Arrive 1 hour prior to distribution to certify safety.',
      'Align volunteer servers into designated zones.',
      'Coordinate the guest entry queues systematically.',
      'Record feed counts and residual stock counts.'
    ],
    resources: []
  }
];

// Use Firestore REST API to write documents
function writeDocument(collection, docId, data) {
  return new Promise((resolve, reject) => {
    // Convert JS object to Firestore document format
    function toFirestoreValue(val) {
      if (val === null || val === undefined) return { nullValue: null };
      if (typeof val === 'string') return { stringValue: val };
      if (typeof val === 'number') {
        if (Number.isInteger(val)) return { integerValue: val.toString() };
        return { doubleValue: val };
      }
      if (typeof val === 'boolean') return { booleanValue: val };
      if (Array.isArray(val)) {
        return { arrayValue: { values: val.map(toFirestoreValue) } };
      }
      if (typeof val === 'object') {
        const fields = {};
        for (const key of Object.keys(val)) {
          fields[key] = toFirestoreValue(val[key]);
        }
        return { mapValue: { fields } };
      }
      return { stringValue: String(val) };
    }

    const fields = {};
    for (const key of Object.keys(data)) {
      fields[key] = toFirestoreValue(data[key]);
    }

    const body = JSON.stringify({ fields });
    const path = `/v1/projects/${PROJECT_ID}/databases/(default)/documents/${collection}/${docId}?key=${API_KEY}`;

    const options = {
      hostname: 'firestore.googleapis.com',
      path,
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(body)
      }
    };

    const req = https.request(options, (res) => {
      let responseBody = '';
      res.on('data', chunk => responseBody += chunk);
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          console.log(`✅ Written: ${collection}/${docId}`);
          resolve();
        } else {
          console.error(`❌ Error writing ${collection}/${docId}: ${res.statusCode} ${responseBody}`);
          reject(new Error(responseBody));
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function seedAll() {
  console.log('🌱 Seeding Firestore with initial tasks...\n');
  // NOTE: This uses the public API key — tasks collection writes require auth or open rules.
  // If it fails, tasks can be added via the admin panel in the app after signing in as admin.
  for (const task of tasks) {
    try {
      await writeDocument('tasks', task.id, task);
    } catch (e) {
      console.error(`Failed to seed ${task.id}:`, e.message);
    }
  }
  console.log('\n✅ Seeding complete!');
}

seedAll();
