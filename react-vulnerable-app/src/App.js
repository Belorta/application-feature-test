import logo from './logo.svg';
import './App.css';

function App() {
  const [input, setInput] = useState('');

  // Example of React2Shell vulnerability (React + eval)
  const handleSubmit = () => {
    eval(input);  // Danger! Don't use eval with untrusted input
  };

  return (
    <div>
      <input 
        type="text" 
        value={input} 
        onChange={(e) => setInput(e.target.value)} 
      />
      <button onClick={handleSubmit}>Submit</button>
    </div>
  );
}

export default App;
