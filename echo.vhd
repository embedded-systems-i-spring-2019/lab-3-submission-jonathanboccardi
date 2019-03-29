library ieee;
use ieee.std_logic_1164.all;

entity echo is
    port(
        clk, en, newChar, ready : in std_logic;
        send : out std_logic;
        cin : in std_logic_vector (7 downto 0);
        cout: out std_logic_vector (7 downto 0)
    );
end echo;

architecture ech of echo is
    type state is (idle, busyA, busyB, busyC);
	signal curr : state := idle;
begin
    process(clk) begin
        if (rising_edge(clk) and en = '1') then
            case (curr) is
                when idle =>
                    if (newChar = '1') then
                        send <= '1';
                        curr <= busyA;
                        cout <= cin;
                    end if;
                when busyA =>
                   curr <= busyB;
                when busyB =>
                   send <= '0';
                   curr <= busyC;
                when busyC =>
                   if (ready = '1') then
                       curr <= idle;
                   end if;
                when others =>
                   curr <= idle;
            end case;
		end if;
	end process;
end ech;