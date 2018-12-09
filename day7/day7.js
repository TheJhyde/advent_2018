// var input = `Step C must be finished before step A can begin.
// Step C must be finished before step F can begin.
// Step A must be finished before step B can begin.
// Step A must be finished before step D can begin.
// Step B must be finished before step E can begin.
// Step D must be finished before step E can begin.
// Step F must be finished before step E can begin.`
var input = raw
  .split("\n")
  .map(x => x.match(/Step (\D) must be finished before step (\D) can begin./).slice(1));

var steps = {};
input.forEach((rule) => {
  rule.forEach((step) => {
    if(steps[step] == undefined){
      steps[step] = {allows: [], requires: [], completed: false}
    }
  });
  steps[rule[0]].allows.push(rule[1]);
  steps[rule[1]].requires.push(rule[0]);
});

var assigned = [];
var positions = [];
var i = 0;
while(assigned.length < Object.keys(steps).length){
  positions.push([]);
  var newly_assigned = []
  Object.keys(steps).forEach((key) => {
    if(steps[key].requires.every((n) => assigned.indexOf(n) > -1) && !assigned.includes(key)){
      positions[i].push(key);
      newly_assigned.push(key);
    }
  });
  positions[i].sort();
  assigned = assigned.concat(newly_assigned);
  i++;
}

var canvas_width = 800;
var canvas_height = 500;
var column_width = canvas_width/positions.length;
var offset = canvas_height * 0.05;
for(var i = 0; i < positions.length; i++){
  var x = column_width * i + 10;
  var row_height = (canvas_height)/(positions[i].length + 1) + offset;
  for(var j = 0; j < positions[i].length; j++){
    var key = positions[i][j];
    steps[key].x = x;
    steps[key].y = (row_height) * (j+1) - ((positions[i].length + 1) * offset/2);
  }
}

function setup() {
  createCanvas(canvas_width, canvas_height);

  var id = setInterval(() => {
    var allowed = Object.keys(steps)
      .filter((k) => steps[k].requires.every((n) => sequence.includes(n)) && !sequence.includes(k))
      .sort()[0];
    sequence += allowed;
    steps[allowed].completed = true;
    if(sequence.length == Object.keys(steps).length){
      console.log("We're done! Yay!");
      clearInterval(id);
    }
  }, 1000);
}

var sequence = "";
function draw() {
  background(255);

  strokeWeight(1);
  Object.keys(steps).forEach(key => {
    var start = steps[key]
    start.requires.forEach(r => {
      var end = steps[r];
      if(!start.completed && end.completed){
        stroke(0);
      }else if(start.completed && end.completed){
        stroke(240);
      }else{
        stroke(150);
      }
      line(start.x, start.y, end.x, end.y);
    });
  });

  textSize(12);
  stroke(0);
  strokeWeight(1);
  Object.keys(steps).forEach(key => {
    var step = steps[key]
    if(step.completed){
      fill(255);
    }else if(step.requires.every((n) => sequence.includes(n))){
      fill(200);
    }else{
      fill(120);
    }
    if(step.x != undefined && step.y != undefined){
      ellipse(step.x, step.y, 20, 20);
      fill(0);
      text(key, step.x-5, step.y+5);
    }
  });

  textSize(20)
  text(sequence, width/2-20, 20);
}