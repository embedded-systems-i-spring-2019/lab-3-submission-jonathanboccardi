library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sender is
    port(
        clk, rst, en, button, ready : in std_logic;
        send : out std_logic;
        char : out std_logic_vector (7 downto 0)
    );
end sender;

architecture send of sender is
    type string is array (0 to 5) of std_logic_vector (7 downto 0);
	signal NetID : string := (x"6a", x"6d", x"62", x"37", x"37", x"39");
	type state is (idle, busyA, busyB, busyC);
	signal curr : state := idle;
	signal i : std_logic_vector(2 downto 0) := (others => '0');
begin
    process(clk) begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                i <= (others => '0');
                curr <= idle;
                send <= '0';
                char <= (others => '0');
            elsif (en = '1') then
                case (curr) is
                    when idle =>
                        if (ready = '1' and button = '1') then
                            if (i < std_logic_vector(to_unsigned(6, 3))) then
                                curr <= busyA;
						        send <= '1';
						        char <= NetID(to_integer(unsigned(i)));
						        i <= std_logic_vector(unsigned(i) + 1);
						    else
					        i <= (others => '0');
					        end if;
					    end if;
					when busyA =>
					   curr <= busyB;
					when busyB =>
					   send <= '0';
					   curr <= busyC;
					when busyC =>
					   if (ready = '1' and button = '0') then
					       curr <= idle;
					   end if;
					when others =>
					   curr <= idle;
				end case;
			end if;
		end if;
	end process;
end send;