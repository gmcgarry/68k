#include <assert.h>
#include <stdio.h>
#include <dos.h>

extern int _kbhit();

static char buf[128];

static const char * dateToDay(const struct date* dt);

int
main()
{
	struct date dt;
	struct time ti;
	int rc;

	getdate(&dt);
	gettime(&ti);

	const char *name = dateToDay(&dt);

	printf("\r\nThe current date is: %s %02d/%02d/%04d\n",
		name, dt.da_day, dt.da_mon, dt.da_year);

	printf("Enter new date: (dd-mm-yyyy) ");
	fgets(buf, sizeof(buf), stdin);
	rc = sscanf(buf, "%d-%d-%d", &dt.da_day, &dt.da_mon, &dt.da_year);
	if (rc) 
		setdate(&dt);

	printf("\r\nThe current time is: %d:%02d:%02d\n",
		ti.ti_hour, ti.ti_min, ti.ti_sec);

	printf("Enter the new time: (hh:mm:ss) ");
	fgets(buf, sizeof(buf), stdin);
	rc = sscanf(buf, "%d:%d:%d", &ti.ti_hour, &ti.ti_min, &ti.ti_sec);
	if (rc)
		settime(&ti);

	return 0;
}

static const char *
dateToDay(const struct date* dt)
{
	static char *weekday[7] = { "Sat","Sun","Mon","Tue", "Wed","Thu","Fri" };

	int mon;
	int year = dt->da_year;
	if (dt->da_mon > 2) {
		mon = dt->da_mon;
	} else {
		mon = 12 + dt->da_mon;
		year--;
 	}

	int y = year % 100;
	int c = year / 100; //first two digit
	int w = (dt->da_day + ((13*(mon+1))/5) + y + (y/4) + (c/4) + (5*c));
	w = w % 7;
	return weekday[w];
}
