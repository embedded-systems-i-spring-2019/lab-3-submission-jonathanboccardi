library ieee;
use ieee.std_logic_1164.all;

entity sender_top is 
    port (
        BTN1, clk, BTN0, TXD : in std_logic;
        RXD, CTS, RTS : out std_logic
    );
end sender_top;

architecture top of sender_top is
 
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
    
    component sender
        port (
            clk, rst, button, ready, en : in std_logic;
            send : out std_logic;
            char : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component debounce
        port (
            clk   : in std_logic;
            btn   : in std_logic;
            dbnc  : out std_logic 
        );
    end component;

    signal button, rst, div, send, ready, newChar : std_logic;
    signal charSend, charRec : std_logic_vector(7 downto 0);

begin

    CTS <= '0';
    RTS <= '0';

    db1: debounce port map(
        clk => clk,
        btn => BTN1,
        dbnc => button);
    
    db2: debounce port map(
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
        
    sendr: sender port map(
        clk => clk,
        rst => rst,
        button => button,
        ready => ready,
        en => div,
        send => send,
        char => charSend);

end top;