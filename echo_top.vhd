library ieee;
use ieee.std_logic_1164.all;

entity echo_top is 
    port (
        clk, BTN0, TXD : in std_logic;
        RXD, CTS, RTS : out std_logic
    );
end echo_top;

architecture top of echo_top is
 
    component uart
        port (
            clk, en, send, rx, rst : in std_logic;
            charSend : in std_logic_vector (7 downto 0);
            ready, tx, newChar : out std_logic;
            charRec : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component uart_clk
        port (
            clk : in std_logic;
            div : out std_logic
        );
    end component;
    
    component echo
        port (
            clk, en, newChar, ready : in std_logic;
            send : out std_logic;
            cin : in std_logic_vector (7 downto 0);
            cout: out std_logic_vector (7 downto 0)
        );
    end component;
    
    component debounce
        port (
            clk   : in std_logic;
            btn   : in std_logic;
            dbnc  : out std_logic 
        );
    end component;

    signal rst, div, send, ready, newChar : std_logic;
    signal charSend, charRec : std_logic_vector(7 downto 0);

begin

    CTS <= '0';
    RTS <= '0';
    
    db: debounce port map(
        clk => clk,
        btn => BTN0,
        dbnc => rst);    
        
    en: uart_clk port map(
        clk => clk,
        div => div);
        
	transrec: uart port map(
    	clk => clk,
    	en => div,
        send => send,
        rx => TXD,
        rst => rst,
        charSend => charSend,
        ready => ready,
        tx => RXD,
        newChar => newChar,
        charRec => charRec);
        
    eho: echo port map(
        clk => clk,
        en => div,
        newChar => newChar,
        ready => ready,
        send => send,
        cin => charRec,
        cout => charSend);

end top;