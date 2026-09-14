library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_simple_block is
  port (
		clk : in std_logic;
		rst : in std_logic;
		threshold : in integer range 0 to 1000 := 30;
		clk_cnt_len : in positive range 100 to 1000 := 100;
		pwm_out : out std_logic
		);
end pwm_simple_block;

architecture rtl of pwm_simple_block is
	-- PWM module internal signals
	signal thrsh_sync : integer range 0 to 1000 := 30; -- this threshold is "synchronized" to the main counter - helps avoid spurrious pulses after thrsh recalculation
	signal clk_cnt : integer range 0 to 1000 := 0;
	
begin
	
	CLK_CNT_PROC : process(clk) -- clk_cnt acts like a sawtooth waveform
	begin
	  if rising_edge(clk) then
		 if rst = '1' then
			clk_cnt <= 0;
			  
		 else
			if clk_cnt < clk_cnt_len - 1 then
			  clk_cnt <= clk_cnt + 1;
			else
			  clk_cnt <= 0;
			  thrsh_sync <= threshold;
			end if;
			  
		 end if;
	  end if;
	end process;

	PWM_PROC : process(clk)	-- this compares the clk_cnt against a threshold that determines duty cycle
	begin
	  if rising_edge(clk) then
		 if rst = '1' then
			pwm_out <= '0';
		  
		 else
			if clk_cnt < thrsh_sync then
				pwm_out <= '1';
	  
			else
				pwm_out <= '0';
	  
			end if;
		 end if;
	  end if;
	end process;

end rtl;