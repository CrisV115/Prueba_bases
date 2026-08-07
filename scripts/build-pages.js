const fs = require('fs');
const path = require('path');

const rootDir = process.cwd();
const distDir = path.join(rootDir, 'dist');
const staticFiles = [
  'formulario1.html',
  'formulario2.html',
  'style.css',
  'form-handler.js'
];

const missingFiles = staticFiles.filter((file) => !fs.existsSync(path.join(rootDir, file)));

if (missingFiles.length > 0) {
  console.error(`Faltan archivos requeridos para GitHub Pages: ${missingFiles.join(', ')}`);
  process.exit(1);
}

fs.rmSync(distDir, { recursive: true, force: true });
fs.mkdirSync(distDir, { recursive: true });

for (const file of staticFiles) {
  fs.copyFileSync(path.join(rootDir, file), path.join(distDir, file));
}

fs.copyFileSync(path.join(rootDir, 'formulario1.html'), path.join(distDir, 'index.html'));
console.log('Sitio estático listo para GitHub Pages en dist/. index.html generado desde formulario1.html.');
