-- module from https://vhdlwhiz.com/generate-statement/
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_debouncer_block is
  generic (
    switch_count : positive;
    timeout_cycles : positive
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    switches : in std_logic_vector(switch_count - 1 downto 0);
    switches_debounced : out std_logic_vector(switch_count - 1 downto 0)
  );
end multi_debouncer_block;

/*
The for loop (generate) runs at compile time and generates one instance of the debouncer module for each iteration.
But because the “i” constant will be different for each iteration,
we can use it to map the inputs and outputs of the debouncers to individual bits on the switches vectors
*/

architecture rtl of multi_debouncer_block is
begin
  
  DB_GEN : for i in 0 to switch_count - 1 generate
  
    DEBOUNCER : entity work.debouncer_block(rtl)
    generic map (
      timeout_cycles => timeout_cycles
    )
    port map (
      clk => clk,
      rst => rst,
      switch => switches(i),
      switch_debounced => switches_debounced(i)
    );
  
  end generate;
  
end architecture;