var fs = require('fs');

fs.readFile('A', (err, f1) => {
  if (err) {
    console.error(err);
    return;
  }
  fs.readFile('B', (err, f2) => {
    if (err) {
      console.error(err);
    }
    fs.writeFile('C', f1 + f2, (err) => {
      if (err) {
        console.error(err);
        return;
      }
      console.log("Wrote to C");
    });
  });
});
