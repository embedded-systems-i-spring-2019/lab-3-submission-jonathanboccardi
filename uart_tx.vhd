library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uart_tx is
    port (
        clk, en, send, rst  : in std_logic;
        char                : in std_logic_vector(7 downto 0);
        ready, tx           : out std_logic
    );
end uart_tx;

architecture fsm of uart_tx is
    type state is (idle, start, data);
    signal curr : state := idle;
    signal d    : std_logic_vector(7 downto 0);
    signal count: std_logic_vector(2 downto 0);
begin
    
    process(clk) begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr <= idle;
                count <= "000";
                d <= "00000000";
                tx <= '1';
                ready <= '1';
            elsif (en = '1') then
                case curr is
                    when idle =>
                        if (send = '1') then
                            ready <= '0';
                            d <= char;
                            curr <= start;
                            tx <= '0';
                        else
                            tx <= '1';
                            ready <= '1';
                        end if;
                    when start =>
                        count <= "000";
                        curr <= data;
                        tx <= d(0);
                        d <= '0' & d(7 downto 1);
                    when data =>
                        if (unsigned(count) < 7) then
                            count <= std_logic_vector(unsigned(count) + 1);
                            tx <= d(0);
                            d <= '0' & d(7 downto 1);
                        else
                            tx <= '1';
                            curr <= idle;
                        end if;
                    when others =>
                        curr <= idle;
                end case;
            end if;
        end if;
    end process;

end fsm;
