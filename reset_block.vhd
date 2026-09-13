library IEEE;
use IEEE.std_logic_1164.all;

entity reset_block is
    port (
        clk   : in  std_logic; -- System clock
        rst_n : in  std_logic; -- External, active-low asynchronous reset input
        rst   : out std_logic  -- Internal, active-high synchronized reset output
    );
end reset_block;

architecture rtl of reset_block is
    -- A 2-stage shift register (Flip-Flops) used for synchronization
    signal rst_reg : std_logic_vector(1 downto 0) := (others => '1');
begin

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            -- Immediate, asynchronous assertion when the button is pressed
            rst_reg <= (others => '1');
        elsif rising_edge(clk) then
            -- Synchronized, safe de-assertion when the button is released.
            -- The '0' travels through 2 clock edges to clear metastability.
            rst_reg(0) <= '0';
            rst_reg(1) <= rst_reg(0);
        end if;
    end process;

    -- Drive the output. When rst_reg(1) is '1', the internal 'rst' is active ('1')
    rst <= rst_reg(1);

end architecture rtl;