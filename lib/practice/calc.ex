defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

# if the parsed string has an error (meaning it is not a float)
# write it into {:op (where op stands for operation), string (string being the actual operation)
# else write it into {:num (num = number), and then the first element of the parsed string which is the 
# actual number
  def tag_token(string) do
    case Float.parse(string) do
      :error -> {:op, string}
      _ -> {:num, elem(Float.parse(string), 0)}
    end
  end

  def tag_tokens(strings) do
    Enum.map(strings, &tag_token/1)
  end

# evaulates all the multiplcation and division and keeps the addition and subtraction operations intact
# stores everything in a tuple (acting as a stack) for constant time access instead of linear time with a list
  def evalMultiplyAndDivide(tokens, operations, value) do
    cond do
      [] == tokens -> operations ++ [{:num, value}]
      {:op, "*"} == hd(tokens) -> evalMultiplyAndDivide(tl(tl(tokens)), operations, value * elem(hd(tl(tokens)), 1))
      {:op, "/"} == hd(tokens) -> evalMultiplyAndDivide(tl(tl(tokens)), operations, value / elem(hd(tl(tokens)), 1))
      {:op, "+"} == hd(tokens) -> evalMultiplyAndDivide(tl(tl(tokens)), operations ++ [{:num, value}, hd(tokens)], elem(hd(tl(tokens)), 1))
      {:op, "-"} == hd(tokens) -> evalMultiplyAndDivide(tl(tl(tokens)), operations ++ [{:num, value}, hd(tokens)], elem(hd(tl(tokens)), 1))
    end
  end

# base case for evalMultiplyAndDivide
  def evalMultiplyAndDivide(tokens) do
    evalMultiplyAndDivide(tl(tokens), [], elem(hd(tokens), 1))
  end

# very similar to evalMultiplyAndDivide
  def evalAddAndSub(tokens, value) do
    cond do
      [] == tokens -> value
      {:op, "+"} == hd(tokens) -> evalAddAndSub(tl(tl(tokens)), value + elem(hd(tl(tokens)), 1))
      {:op, "-"} == hd(tokens) -> evalAddAndSub(tl(tl(tokens)), value - elem(hd(tl(tokens)), 1))
    end
  end

# base case for evalAddAndSub
  def evalAddAndSub(tokens) do
    evalAddAndSub(tl(tokens), elem(hd(tokens), 1))
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> evalMultiplyAndDivide
    |> evalAddAndSub

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end

# initialize factor function
# takes in an int
# calls a private helper function that trys 2 as a prime number
# and starts an empty accumulator
  def factor(n) do
    factor(n, 2, [])
  end

# private function that happens when the number being factored
# is smaller than the factor number being checked to see if
# it is a factor of n
# is the base case that returns the accumulator  
  defp factor(n, fact, primeFactors) when n < fact do
    primeFactors
  end

# private function that happens when the remained of the
# number being factored and the factor number being checked is 0
# because we are starting from 2 and going up and we divide
# every time this function is called, it must be a factor
  defp factor(n, fact, pfact) when rem(n, fact) == 0 do
    [fact|factor(div(n, fact), fact, pfact)]
  end

# private function that happens when fact is not 
# divisible into n or smaller than n
  defp factor(n, fact, pfact) do
    factor(n, fact + 1, pfact)
  end
    
  
end
