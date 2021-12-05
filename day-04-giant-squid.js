const fs = require("fs");

const input = fs
  .readFileSync("day-04-giant-squid/input.txt")
  .toString()
  .trim()
  .split("\n\n");

const numbers = input[0].split(",").map((s) => parseInt(s));

let boards = input.slice(1).map((line) =>
  line
    .trim()
    .split(/\s+/)
    .map((line) => parseInt(line))
);

let first_winning_board_score;
let last_winning_board_score;

for (const number of numbers) {
  boards = boards.filter((board) => {
    // Mark with true.
    for (const [i, num] of board.entries()) {
      board[i] = num === number ? true : num;
    }

    let winner = false;
    for (let i = 0; i < 5; i++) {
      // Check for a complete row.
      const indexes = [0, 1, 2, 3, 4];
      if (indexes.map((j) => board[j + i * 5]).every((num) => num === true)) {
        winner = true;
        break;
      }

      // Check for a complete column.
      if (indexes.map((j) => board[i + j * 5]).every((num) => num === true)) {
        winner = true;
        break;
      }
    }

    if (!winner) {
      return true;
    }

    const unmarked_sum = board
      .filter(Number.isInteger)
      .reduce((a, b) => a + b, 0);
    const final_score = unmarked_sum * number;

    if (first_winning_board_score === undefined) {
      first_winning_board_score = final_score;
    } else {
      last_winning_board_score = final_score;
    }

    return false;
  });
}

console.log(
  `The score of the first winning board is ${first_winning_board_score}.`
);
console.log(
  `The score of the last winning board is ${last_winning_board_score}.`
);
