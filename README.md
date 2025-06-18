🛠 Tehnologii Utilizate
Frontend: React, Vite

Containerizare: Docker, Nginx, envsubst

Manager de Pachete: pnpm (sau npm)

🚀 Pornire Rapidă cu Docker și Variabile de Mediu
Această configurație permite construirea imaginii Docker o singură dată și furnizarea variabilelor de mediu la rularea containerului, fără a necesita reconstruirea imaginii pentru fiecare mediu.

Creați public/env.template.js:
Acest fișier trebuie să conțină placeholder-uri pentru variabilele dvs. de mediu (ex: __VITE_APP_API_URL__).

window.ENV = {
  VITE_APP_API_URL: '__VITE_APP_API_URL__',
  VITE_APP_ANALYTICS_KEY: '__VITE_APP_ANALYTICS_KEY__',
  // Adăugați mai multe variabile dacă este necesar
};

Asigurați-vă că public/index.html încarcă env.js:
Adăugați <script src="/env.js"></script> în index.html înainte de scriptul principal al aplicației React.

<body>
    <div id="root"></div>
    <script src="/env.js"></script>
    <script type="module" src="/src/main.jsx"></script>
</body>

Construiți imaginea Docker:

docker build -t my-web-app:latest .

Rulați containerul Docker cu variabile de mediu:
Variabilele transmise cu -e vor fi substituite în env.js la pornirea containerului.

docker run -p 80:80 -d \
  -e VITE_APP_API_URL=https://api.production.example.com \
  -e VITE_APP_ANALYTICS_KEY=prod_analytics_123 \
  my-web-app:latest

Consumarea Variabilelor în Aplicația Dvs. React
Variabilele vor fi disponibile pe obiectul global window.ENV odată ce env.js este încărcat.

// Exemplu într-o componentă React
function MyComponent() {
  const apiUrl = window.ENV.VITE_APP_API_URL;
  // ...
}

📦 Structura Proiectului
.
├── public/                 # Active statice
│   └── env.template.js     # Șablon pentru variabile de mediu
│   └── index.html          # Fișier HTML principal
├── src/                    # Cod sursă React
├── Dockerfile              # Instrucțiuni Docker
├── entrypoint.sh           # Script de pornire container
└── ...                     # Alte fișiere proiect
