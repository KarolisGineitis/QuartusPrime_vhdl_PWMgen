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
		signal btn_last : std_logic := '1';														-- previous state of debounced button
		signal pwm_period_reg : positive range 100 to 1000 := period_default;		-- a buffer for period value - used to stage the value for multiplication/division in this module,
																											--	reducing the requirement that a change in period_button_block module needs to reach this module in one cycle (for timing analysis).																											
		signal mult_reg : integer range 0 to 100000 := (period_default * duty_default); 	-- a buffer for multiplication - explicitly shows that
																													--	multiplication can happen (for timing analysis) in a separate clock cycle from division

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
				if btn = '1' and btn_last = '0' then -- change value only on the rising edge of the button signal (physically release the button)
					if duty >= 100 then
						duty <= 0;
					else
						duty <= duty + 10;
					end if;
				end if;
				mult_reg <= pwm_period_reg * duty;	-- a dedicated cycle for multiplication only
				thrsh <= mult_reg / 100;				-- a dedicated cycle for division only - still takes 3 cycles and produces a warning during timing analysis
		  end if;
		end if;
	end process;
	

end rtl;