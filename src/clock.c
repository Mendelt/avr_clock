#include <avr/io.h>
#include <util/delay.h>

#define SEND_PIN 2
#define RECV_PIN 1


int main(void) {
    DDRB |= _BV(SEND_PIN);
    PORTB &= ~_BV(RECV_PIN);

    for(;;) {
	PORTB |= _BV(SEND_PIN);

	_delay_ms(1);

	PORTB &= ~_BV(SEND_PIN);
	
	_delay_ms(1);
    }
    return 1; 
}

