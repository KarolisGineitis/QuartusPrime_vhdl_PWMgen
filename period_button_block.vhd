library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity period_button_block is
	generic (
		period_default : positive range 100 to 1000 
	);
  port (
		clk : in std_logic;
		rst : in std_logic;
		btn : in std_logic;
		pwm_period : out positive range 100 to 1000
  );
end period_button_block;

architecture rtl of period_button_block is

	-- DUTY button module internal signals
		signal period : positive range 100 to 1000 := period_default;
		signal btn_last : std_logic := '1';

begin

	btn_press_proc : process(clk,rst)
	begin
		if rst = '1' then
			period <= period_default;
		else
		  if rising_edge(clk) then
				btn_last <= btn;
				if btn = '1' and btn_last = '0' then
					if period >= 1000 then
						period <= 100;
					else
						period <= period + 100;
					end if;
				end if;		  
		  end if;
	  end if;
	end process;
	
	pwm_period <= period;

end rtl;