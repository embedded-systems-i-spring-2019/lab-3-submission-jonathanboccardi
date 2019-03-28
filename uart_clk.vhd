library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_clk is
    port(
        clk : in std_logic;
        div : out std_logic
    );
end uart_clk;

architecture divider of uart_clk is
    signal count : std_logic_vector (11 downto 0) := (others => '0');
begin
    process (clk) begin
        if rising_edge(clk) then
            if unsigned(count) = 1084 then
                count <= (others => '0');
                div <= '1';
            else
                count <= std_logic_vector(unsigned(count) + 1);
                div <= '0';
            end if;
        end if;
    end process;
end divider;