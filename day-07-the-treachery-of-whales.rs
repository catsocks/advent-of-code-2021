use std::env;
use std::fs;

fn main() {
    let input = get_input();

    let (min, max) = (*input.iter().min().unwrap(), *input.iter().max().unwrap());

    let (fuel, position) = (min..=max)
        .map(|p1| (input.iter().fold(0, |fuel, p2| fuel + (p1 - p2).abs()), p1))
        .min_by(|x, y| x.0.cmp(&y.0))
        .unwrap();

    println!(
        "The crabs would spend {} fuel to align at position {}, burning fuel at a constant rate.",
        fuel, position
    );

    let fuel_cost: Vec<i32> = (0..=max).map(|p| (1..=p).sum()).collect();

    let (fuel, position) = (min..=max)
        .map(|p1| {
            (
                input
                    .iter()
                    .fold(0, |fuel, p2| fuel + fuel_cost[(p1 - *p2).abs() as usize]),
                p1,
            )
        })
        .min_by(|x, y| x.0.cmp(&y.0))
        .unwrap();

    println!(
        "The crabs would spend {} fuel to align at position {}, burning fuel at a variable rate.",
        fuel, position
    );
}

fn get_input() -> Vec<i32> {
    let path = env::args()
        .nth(1)
        .expect("Missing path to input file as command-line argument");

    let contents = fs::read_to_string(path).expect("Something went wrong while reading the file");

    contents
        .trim()
        .split(',')
        .map(|str| {
            str.parse()
                .expect("Something went wrong while parsing the input")
        })
        .collect()
}
