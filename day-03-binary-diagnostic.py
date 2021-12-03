import fileinput
from functools import reduce
from operator import add


def bits_to_int(bits):
    return int("".join(map(str, bits)), 2)


diagnostic = fileinput.input("day-03-binary-diagnostic/diagnostic.txt")
binary_numbers = [list(map(int, line.strip())) for line in diagnostic]

# Part 1

bit_sums = reduce(lambda x, y: map(add, x, y), binary_numbers)

most_common_bits = [int(sum > len(binary_numbers) / 2) for sum in bit_sums]

gamma_rate = bits_to_int(most_common_bits)
epsilon_rate = bits_to_int([bit ^ 1 for bit in most_common_bits])

print(f"The power consumption of the submarine is {gamma_rate * epsilon_rate}.")

# Part 2


def get_rating(numbers, by_most_common_bit):
    bit_idx = 0
    while len(numbers) > 1:
        bit_sum = sum([bits[bit_idx] for bits in numbers])
        numbers_half_length = len(numbers) / 2
        if bit_sum == numbers_half_length:
            filter_bit = 1 if by_most_common_bit else 0
        else:
            most_common_bit = int(bit_sum > numbers_half_length)
            filter_bit = most_common_bit if by_most_common_bit else most_common_bit ^ 1

        numbers = list(filter(lambda bits: bits[bit_idx] == filter_bit, numbers))
        bit_idx += 1

    if numbers:
        return numbers[0]


oxygen_generator_rating = bits_to_int(get_rating(binary_numbers, True))
co2_scrubber_rating = bits_to_int(get_rating(binary_numbers, False))
life_support_rating = oxygen_generator_rating * co2_scrubber_rating

print(f"The life support rating of the submarine is {life_support_rating}.")
