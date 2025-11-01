import * as esbuild from 'esbuild'

const entryPoints = [{path:'src/forms/contactForm.ts',out:'dist/contactForm.js'}]

entryPoints.forEach(async entry=>{
  await esbuild.build({
  entryPoints: [entry.path],
  bundle: true,
  outfile: entry.out,
  });
});
