-- module from https://vhdlwhiz.com/generate-statement/
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer_block is
  generic (
    timeout_cycles : positive
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    switch : in std_logic;
    switch_debounced : out std_logic
  );
end debouncer_block;

architecture rtl of debouncer_block is
  
  signal debounced : std_logic := '1'; --internal shadow signal of switch_debounced that can be read locally
  signal counter : integer range 0 to timeout_cycles - 1;
  
begin
  
  -- Copy internal signal to output
  switch_debounced <= debounced;
  
  DEBOUNCE_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        counter <= 0;
        debounced <= switch;
          
      else
          
        if counter < timeout_cycles - 1 then
          counter <= counter + 1;
        elsif switch /= debounced then
          counter <= 0;
          debounced <= switch;
        end if;
  
      end if;
    end if;
  end process;
  
end architecture;