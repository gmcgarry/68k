#include <stdio.h>

typedef void (*timer_callback)(void);

extern void _timer_on(timer_callback _cb);
extern void _timer_off();

extern void _putchar(int _ch);
extern int _kbhit();

volatile int counter;
volatile int seconds;

void
_callback()
{
	if (counter++ >= 64) {
		counter = 0;
		seconds++;
	}
}

int
main()
{
	printf("\nTimer tester...\n");

	_timer_on(_callback);

	while (!_kbhit())
		;

	_timer_off();

	printf("counter=%d, seconds=%d\n", counter, seconds);

	return 0;
}
