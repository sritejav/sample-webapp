import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [items, setItems] = useState([]);
  const [newItem, setNewItem] = useState("");

  // Fetch items from Python Backend
  const fetchItems = async () => {
    const response = await fetch("http://localhost:8000/items");
    const data = await response.json();
    setItems(data);
  };

  useEffect(() => {
    fetchItems();
  }, []);

  // Add a new item to MongoDB via Backend
  const addItem = async () => {
    await fetch("http://localhost:8000/items", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: newItem })
    });
    setNewItem("");
    fetchItems();
  };

  return (
    <div className="App">
      <h1>FARM Stack: React + Python + NoSQL</h1>
      <input 
        value={newItem} 
        onChange={(e) => setNewItem(e.target.value)} 
        placeholder="Add something..." 
      />
      <button onClick={addItem}>Add to Database</button>

      <ul>
        {items.map((item) => (
          <li key={item._id}>{item.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;