library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_gen is
		generic 
		(
			switch_count 	: positive := 2;
			duty_default 	: integer range 0 to 100   := 30;		-- default duty with available range
			period_default : positive range 100 to 1000   := 100	-- default period with available range
		);
		port 
		(
			clk_50 	: in  std_logic;  -- external hardware clock (50MHz)
			rst_n  	: in  std_logic;  -- hardware reset button (active-low)
			btns 		: in std_logic_vector(switch_count - 1 downto 0);
			pwm_out 	: out std_logic;
			led_lock : out std_logic

		);
end pwm_gen;

architecture str of pwm_gen is

	-- PLL signals
		signal clk   : std_logic;
		signal pll_locked : std_logic;
		signal rst : std_logic;
	-- Button debounce signals
		constant timeout_cycles : integer := 1000000; 
		signal btns_clean : std_logic_vector(switch_count - 1 downto 0) := (others =>'1');
	-- PWM signals
		signal duty : integer range 0 to 100 := duty_default;
		signal pwm_period : positive range 100 to 1000 := period_default;
		signal thrsh : integer range 0 to 1000 := (duty_default * period_default) / 100;

begin
		
		led_lock <= not pll_locked;

    -- Instatiations of modules
		PLL_block_inst : entity work.PLL_block(SYN)
			port map (
				inclk0 => clk_50,   	-- Connect the external clock pin
				areset => rst,  		-- Connect the converted active-high reset
				c0     => clk,   
				locked => pll_locked  -- High when the clock is stable
			);
		RESET_inst : entity work.reset_block(rtl)
			port map (
				clk => clk_50,
				rst_n => rst_n,
				rst => rst
			);
		DEBOUNCE_block_inst : entity work.multi_debouncer_block(rtl)
			generic map (
				switch_count => switch_count,
				timeout_cycles => timeout_cycles
			)
			port map (
				clk => clk,
				rst => rst,
				switches => btns,
				switches_debounced => btns_clean
			);
		PWM_inst : entity work.pwm_simple_block(rtl)
			port map (
				clk => clk,
				rst => rst,
				pwm_out => pwm_out,
				threshold => thrsh,
				clk_cnt_len => pwm_period
			);
		DUTY_inst : entity work.duty_button_block(rtl)
			generic map (
				duty_default => duty_default,
				period_default => period_default
			)
			port map (
				clk => clk,
				rst => rst,
				btn => btns_clean(0),
				pwm_period => pwm_period,
				thrsh => thrsh
			);		
		PERIOD_inst : entity work.period_button_block(rtl)
			generic map (
				period_default => period_default
			)
			port map (
				clk => clk,
				rst => rst,
				btn => btns_clean(1),
				pwm_period => pwm_period
			);	

end str;