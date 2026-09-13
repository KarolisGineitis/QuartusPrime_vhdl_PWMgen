library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity duty_button_block is
	generic (
		duty_default 	: integer range 0 to 100;
		period_default : positive range 100 to 1000
	);
  port (
		clk : in std_logic;
		rst : in std_logic;
		btn : in std_logic;
		pwm_period : in positive range 100 to 1000;
		thrsh : out integer range 0 to 1000 
  );
end duty_button_block;

architecture rtl of duty_button_block is

	-- DUTY button module internal signals
		signal duty : integer range 0 to 100 := duty_default;
		signal btn_last : std_logic := '1';
		signal pwm_period_reg : positive range 100 to 1000 := period_default;
		signal mult_reg : integer range 0 to 100000 := (period_default * duty_default);

begin

	btn_press_proc : process(clk,rst)
	begin
		if rst = '1' then
			duty <= duty_default;
			pwm_period_reg <= period_default;
			mult_reg       <= period_default * duty_default;
		else
			if rising_edge(clk) then			
				btn_last <= btn;
				pwm_period_reg <= pwm_period;
				if btn = '1' and btn_last = '0' then
					if duty >= 100 then
						duty <= 0;
					else
						duty <= duty + 10;
					end if;
				end if;
				mult_reg <= pwm_period_reg * duty;
				thrsh <= mult_reg / 100;				
		  end if;
		end if;
	end process;
	

end rtl;