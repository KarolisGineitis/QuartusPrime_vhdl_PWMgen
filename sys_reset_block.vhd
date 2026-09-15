library IEEE;
use IEEE.std_logic_1164.all;

entity sys_reset_block is
    port (
        clk   : in  std_logic; 		-- System clock
		  rst_pll : in std_logic; 		-- the 50MHz reset, active-high
		  pll_locked : in std_logic; 	-- is PLL locked? signal
        sys_rst   : out std_logic  	-- System active-high PLL synchronized reset
    );
end sys_reset_block;

architecture rtl of sys_reset_block is
    -- A 2-stage shift register (Flip-Flops) used for synchronization
	 signal sys_rst_reg   : std_logic_vector(1 downto 0) := (others => '1');
	 
begin
	 
    process(clk, rst_pll, pll_locked)
    begin
        if rst_pll = '1' or pll_locked = '0' then
				sys_rst_reg <= (others => '1');
        elsif rising_edge(clk) then
            -- Synchronized, safe de-assertion when the button is released.
            -- The '0' travels through 2 clock edges to clear metastability.
            sys_rst_reg(0) <= '0';
            sys_rst_reg(1) <= sys_rst_reg(0);
        end if;
    end process;

    -- When sys_rst_reg(1) is '1', the system 'sys_rst' is active ('1')
    sys_rst <= sys_rst_reg(1);

end architecture rtl;