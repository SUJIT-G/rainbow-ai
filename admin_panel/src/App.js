import React, { useEffect, useState } from 'react';

function App() {
  const [history, setHistory] = useState([]);

  useEffect(() => {
    fetch('https://rainbow-ai-api.yourname.workers.dev/api/history')
      .then(res => res.json())
      .then(data => setHistory(data));
  }, []);

  return (
    <div style={{ padding: 20 }}>
      <h1>Rainbow AI Admin Dashboard</h1>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10 }}>
        {history.map(item => (
          <div key={item.id} style={{ border: '1px solid #ccc' }}>
            <p>Prompt: {item.prompt}</p>
            <p>User: {item.user_id}</p>
            {/* Note: You'd need a public URL for R2 images to show them here */}
          </div>
        ))}
      </div>
    </div>
  );
}
export default App;
