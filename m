From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_time 20070820 (iptables)
Date: Mon, 20 Aug 2007 21:20:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708202119370.5333@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708201733090.5333@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708201733090.5333@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


iptables part.

---
 extensions/.time-testx     |    2 
 extensions/libxt_time.man  |   16 +
 extensions/libxt_time.c    |  497 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 515 insertions(+)

Index: iptables/extensions/.time-testx
===================================================================
--- /dev/null
+++ iptables/extensions/.time-testx
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f "$KERNEL_DIR/include/linux/netfilter/xt_time.h" ] && echo time
Index: iptables/extensions/libipt_time.man
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_time.man
@@ -0,0 +1,16 @@
+This matches if the packet arrival time/date is within a given range. All options are facultative.
+.TP
+.BI " --timestart " "value"
+Match only if it is after `value' (Inclusive, format: HH:MM ; default 00:00).
+.TP
+.BI "--timestop  " "value"
+Match only if it is before `value' (Inclusive, format: HH:MM ; default 23:59).
+.TP
+.BI "--days " "listofdays"
+Match only if today is one of the given days. (format: Mon,Tue,Wed,Thu,Fri,Sat,Sun ; default everyday)
+.TP
+.BI "--datestart " "date"
+Match only if it is after `date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]] ; h,m,s start from 0 ; default to 1970)
+.TP
+.BI "--datestop " "date"
+Match only if it is before `date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]] ; h,m,s start from 0 ; default to 2037)
Index: iptables/extensions/libxt_time.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_time.c
@@ -0,0 +1,497 @@
+/* Shared library add-on to iptables to add TIME matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stddef.h> /* for 'offsetof' */
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_time.h>
+#include <time.h>
+
+static int globaldays;
+
+/* Function which prints out usage message. */
+static void time_help(void)
+{
+	printf(
+"TIME v%s options:\n"
+" [ --timestart value ] [ --timestop value] [ --days listofdays ] [ --datestart value ] [ --datestop value ]\n"
+"          timestart value : HH:MM (default 00:00)\n"
+"          timestop  value : HH:MM (default 23:59)\n"
+"                            Note: daylight savings time changes are not tracked\n"
+"          listofdays value: a list of days to apply\n"
+"                            from Mon,Tue,Wed,Thu,Fri,Sat,Sun\n"
+"                            Coma speparated, no space, case sensitive.\n"
+"                            Defaults to all days.\n"
+"          datestart value : YYYY[:MM[:DD[:hh[:mm[:ss]]]]]\n"
+"                            If any of month, day, hour, minute or second is\n"
+"                            not specified, then defaults to their smallest\n"
+"                            1900 <= YYYY < 2037\n"
+"                               1 <= MM <= 12\n"
+"                               1 <= DD <= 31\n"
+"                               0 <= hh <= 23\n"
+"                               0 <= mm <= 59\n"
+"                               0 <= ss <= 59\n"
+"          datestop  value : YYYY[:MM[:DD[:hh[:mm[:ss]]]]]\n"
+"                            If the whole option is ommited, default to never stop\n"
+"                            If any of month, day, hour, minute or second is\n"
+"                            not specified, then default to their smallest\n",
+IPTABLES_VERSION);
+}
+
+static const struct option time_opts[] = {
+	{"timestart", 1, NULL, '1'},
+	{"timestop",  1, NULL, '2'},
+	{"days",      1, NULL, '3'},
+	{"datestart", 1, NULL, '4'},
+	{"datestop",  1, NULL, '5'},
+	{NULL},
+};
+
+/* Initialize the match. */
+static void time_init(struct xt_entry_match *m, unsigned int *nfcache)
+{
+	struct xt_time_info *info = (void *)m->data;
+
+	globaldays = 0;
+
+        /* By default, we match on everyday */
+	info->days_match = 127;
+
+	/* By default, we match on every hour:min of the day */
+	info->time_start = 0;
+	info->time_stop  = 24 * 60 - 1; /* 23:59 */
+
+	/* By default, we do not have any date-begin or date-end boundaries */
+	info->date_start = 0;
+	info->date_stop  = LONG_MAX;
+}
+
+/*
+ * @param:	part1, a pointer on a string 2 chars maximum long string,
+ *		that will contain the hours.
+ * @param:	part2, a pointer on a string 2 chars maximum long string,
+ *		that will contain the minutes.
+ * @param:	str_2_parse, the string to parse.
+ *
+ * returns 1 if ok, 0 if error.
+ */
+static int split_time(char *rpart1, char *rpart2, const char *str_2_parse)
+{
+	unsigned int i, j, found_column = 0;
+
+	/* Check the length of the string */
+	if (strlen(str_2_parse) > 5)
+		return 0;
+
+	/* parse the first part until the ':' */
+	for (i = 0; i < 2; ++i) {
+		if (str_2_parse[i] == ':')
+			found_column = 1;
+		else
+			rpart1[i] = str_2_parse[i];
+	}
+	if (!found_column)
+		++i;
+
+	j = i;
+
+	/* parse the second part */
+	for (; i < strlen(str_2_parse); ++i)
+		rpart2[i-j] = str_2_parse[i];
+
+	/* if we are here, format should be ok. */
+	return 1;
+}
+
+static int parse_number(char *str, unsigned int num_min, unsigned int num_max,
+    unsigned int *number)
+{
+	/*
+	 * if the number starts with 0, replace it with a space else
+	 * string_to_number() will interpret it as octal!
+	 */
+	if (strlen(str) == 0)
+		return 0;
+
+	if (str[0] == '0' && str[1] != '\0')
+		str[0] = ' ';
+
+	return string_to_number(str, num_min, num_max, number);
+}
+
+static inline int parse_inumber(char *str, unsigned int num_min,
+    unsigned int num_max, int *number)
+{
+	return parse_number(str, num_min, num_max, (unsigned int *)number);
+}
+
+static void parse_time_string(unsigned int *hour, unsigned int *minute,
+    const char *time)
+{
+	char hours[3]   = {};
+	char minutes[3] = {};
+
+	if (split_time(hours, minutes, time) == 1) {
+		*hour   = 0;
+		*minute = 0;
+		if (parse_number(hours, 0, 23, hour) != -1 &&
+		    parse_number(minutes, 0, 59, minute) != -1)
+			return;
+	}
+
+	/* If we are here, there was a problem ..*/
+	exit_error(PARAMETER_PROBLEM, "invalid time \"%s\" specified, "
+	           "should be HH:MM format", time);
+}
+
+static const char *const days_str[] =
+	{NULL, "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
+static const unsigned char days_of_week[] =
+	{0, XT_TIME_MONDAY, XT_TIME_TUESDAY, XT_TIME_WEDNESDAY,
+	XT_TIME_THURSDAY, XT_TIME_FRIDAY, XT_TIME_SATURDAY,
+	XT_TIME_SUNDAY};
+
+/* return 1->ok, return 0->error */
+static int parse_day(unsigned int *days, unsigned int from, unsigned int to,
+    const char *string)
+{
+	char dayread[4] = {};
+	unsigned int i;
+
+	if (to - from != 3) {
+		free(dayread);
+		return 0;
+	}
+	for (i = from; i < to; ++i)
+		dayread[i - from] = string[i];
+	for (i = 1; i <= 7; ++i)
+		if (strcmp(dayread, days_str[i]) == 0) {
+			*days |= days_of_week[i];
+			return 1;
+		}
+	return 0;
+}
+
+static void parse_days_string(unsigned int *days, const char *daystring)
+{
+	static const char *const err = "invalid days \"%s\" specified, should be Sun,Mon,Tue... format";
+	unsigned int i = 0;
+	unsigned int len;
+
+	len = strlen(daystring);
+	if (len < 3)
+		exit_error(PARAMETER_PROBLEM, err, daystring);
+	for (i = 0; i < len; i += 4) {
+		if (parse_day(days, i, i + 3, daystring) == 0)
+			exit_error(PARAMETER_PROBLEM, err, daystring);
+		i += 4;
+	}
+}
+
+static int parse_date_field(const char *str_to_parse, int str_to_parse_s,
+                            int start_pos, char *dest, int *next_pos)
+{
+	unsigned char found_value = 0;
+	unsigned char found_column = 0;
+	int i;
+
+	for (i = 0; i < 2; ++i) {
+		if (i + start_pos >= str_to_parse_s)
+			/* don't exit boundaries of the string..  */
+			break;
+		if (str_to_parse[i+start_pos] == ':') {
+			found_column = 1;
+		} else {
+			found_value = 1;
+			dest[i] = str_to_parse[i+start_pos];
+		}
+	}
+	if (found_value == 0)
+		return 0;
+	*next_pos = i + start_pos;
+	if (found_column == 0)
+		++*next_pos;
+	return 1;
+}
+
+static int split_date(char *year, char *month, char *day, char *hour,
+                      char *minute, char *second, const char *str_to_parse)
+{
+        int i;
+        unsigned char found_column = 0;
+	int str_to_parse_s = strlen(str_to_parse);
+
+        /* Check the length of the string */
+        if (str_to_parse_s > 19 ||  /* YYYY:MM:DD:HH:MM:SS */
+            str_to_parse_s < 4)     /* YYYY*/
+                return 0;
+
+	/* Clear the buffers */
+        memset(year, 0, 4);
+	memset(month, 0, 2);
+	memset(day, 0, 2);
+	memset(hour, 0, 2);
+	memset(minute, 0, 2);
+	memset(second, 0, 2);
+
+	/* parse the year YYYY */
+	found_column = 0;
+	for (i = 0; i < 5; ++i) {
+		if (i >= str_to_parse_s)
+			break;
+		if (str_to_parse[i] == ':') {
+			found_column = 1;
+			break;
+		} else {
+			year[i] = str_to_parse[i];
+		}
+	}
+	if (found_column == 1)
+		++i;
+
+	/* parse the month if it exists */
+	if (!parse_date_field(str_to_parse, str_to_parse_s, i, month, &i))
+		return 1;
+	if (!parse_date_field(str_to_parse, str_to_parse_s, i, day, &i))
+		return 1;
+	if (!parse_date_field(str_to_parse, str_to_parse_s, i, hour, &i))
+		return 1;
+	if (!parse_date_field(str_to_parse, str_to_parse_s, i, minute, &i))
+		return 1;
+	parse_date_field(str_to_parse, str_to_parse_s, i, second, &i);
+
+        /* if we are here, format should be ok. */
+        return 1;
+}
+
+static time_t parse_date_string(const char *str_to_parse)
+{
+	char year[5] = {}, month[3] = {}, day[3] = {},
+	     hour[3] = {}, minute[3] = {}, second[3] = {};
+	struct tm t;
+	time_t temp_time;
+
+        if (split_date(year, month, day, hour, minute,
+	    second, str_to_parse) == 1) {
+		memset(&t, 0, sizeof(struct tm));
+		t.tm_isdst = -1;
+		t.tm_mday = 1;
+		if (!((parse_inumber(year, 1900, 2037, &t.tm_year) == -1) ||
+		    (parse_inumber(month, 1, 12, &t.tm_mon) == -1) ||
+		    (parse_inumber(day, 1, 31, &t.tm_mday) == -1) ||
+		    (parse_inumber(hour, 0, 9999, &t.tm_hour) == -1) ||
+		    (parse_inumber(minute, 0, 59, &t.tm_min) == -1) ||
+		    (parse_inumber(second, 0, 59, &t.tm_sec) == -1))) {
+			t.tm_year -= 1900;
+			--t.tm_mon;
+			temp_time = mktime(&t);
+			if (temp_time != -1)
+				return temp_time;
+		}
+	}
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid date `%s' specified, should be YYYY[:MM[:DD[:hh[:mm[:ss]]]]] format", str_to_parse);
+}
+
+enum {
+	XT_TIME_START = 1 << 0,
+	XT_TIME_STOP  = 1 << 1,
+	XT_TIME_DAYS  = 1 << 2,
+	XT_DATE_START = 1 << 3,
+	XT_DATE_STOP  = 1 << 4,
+};
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int time_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *entry, unsigned int *nfcache,
+                      struct xt_entry_match **match)
+{
+	struct xt_time_info *timeinfo = (void *)(*match)->data;
+	unsigned int hours, minutes;
+	time_t temp_date;
+
+	switch (c) {
+	case '1': /* timestart */
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --timestart");
+		if (*flags & XT_TIME_START)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --timestart twice");
+		parse_time_string(&hours, &minutes, optarg);
+		timeinfo->time_start = (hours * 60) + minutes;
+		*flags |= XT_TIME_START;
+		break;
+	case '2': /* timestop */
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --timestop");
+		if (*flags & XT_TIME_STOP)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --timestop twice");
+		parse_time_string(&hours, &minutes, optarg);
+		timeinfo->time_stop = (hours * 60) + minutes;
+		*flags |= XT_TIME_STOP;
+		break;
+	case '3': /* days */
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --days");
+		if (*flags & XT_TIME_DAYS)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --days twice");
+		parse_days_string(&globaldays, optarg);
+		timeinfo->days_match = globaldays;
+		*flags |= XT_TIME_DAYS;
+		break;
+	case '4': /* datestart */
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --datestart");
+		if (*flags & XT_DATE_START)
+			exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --datestart twice");
+		temp_date = parse_date_string(optarg);
+		timeinfo->date_start = temp_date;
+		*flags |= XT_DATE_START;
+		break;
+	case '5': /* datestop */
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --datestop");
+		if (*flags & XT_DATE_STOP)
+			exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --datestop twice");
+		temp_date = parse_date_string(optarg);
+		timeinfo->date_stop = temp_date;
+		*flags |= XT_DATE_STOP;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void time_check(unsigned int flags)
+{
+}
+
+static void print_days(int daynum)
+{
+	unsigned int i, nbdays = 0;
+
+	for (i = 1; i <= 7; ++i) {
+		if (daynum & days_of_week[i]) {
+			if (nbdays > 0)
+				printf(",%s", days_str[i]);
+			else
+				printf("%s", days_str[i]);
+			++nbdays;
+		}
+	}
+	printf(" ");
+}
+
+static void divide_time(unsigned int fulltime, unsigned int *hours,
+    unsigned int *minutes)
+{
+	*hours   = fulltime / 60;
+	*minutes = fulltime % 60;
+}
+
+static void print_date(time_t date, char *command)
+{
+	struct tm *t;
+
+	/* If it's default value, don't print..*/
+	if ((date == 0 || date == LONG_MAX) && command != NULL)
+		return;
+	t = localtime(&date);
+	if (command != NULL)
+		printf("%s %d:%d:%d:%d:%d:%d ", command, (t->tm_year + 1900), (t->tm_mon + 1),
+			t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+        else
+        	printf("%d-%d-%d %d:%d:%d ", (t->tm_year + 1900), (t->tm_mon + 1),
+			t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+}
+
+/* Prints out the matchinfo. */
+static void time_print(const void *ip, const struct xt_entry_match *match,
+                       int numeric)
+{
+	struct xt_time_info *time = (void *)match->data;
+	unsigned int hour_start, hour_stop, minute_start, minute_stop;
+
+	divide_time(time->time_start, &hour_start, &minute_start);
+	divide_time(time->time_stop, &hour_stop, &minute_stop);
+	printf("TIME ");
+
+	if (time->time_start != 0)
+		printf("from %02u:%02u ", hour_start, minute_start);
+	if (time->time_stop != 24 * 60 - 1)
+		printf("to %02u:%02u ", hour_stop, minute_stop);
+
+	printf("on ");
+
+	if (time->days_match == 127)
+		printf("all days ");
+	else
+		print_days(time->days_match);
+
+	if (time->date_start != 0) {
+		printf("starting from ");
+		print_date(time->date_start, NULL);
+	}
+	if (time->date_stop != LONG_MAX) {
+		printf("until date ");
+		print_date(time->date_stop, NULL);
+	}
+}
+
+/* Saves the data in parsable form to stdout. */
+static void time_save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_time_info *time = (void *)match->data;
+	unsigned int hour_start, hour_stop, minute_start, minute_stop;
+
+	divide_time(time->time_start, &hour_start, &minute_start);
+	divide_time(time->time_stop, &hour_stop, &minute_stop);
+
+	if (time->time_start != 0)
+		printf("--timestart %02u:%02u ",
+		        hour_start, minute_start);
+	if (time->time_stop != 24 * 60 - 1)
+		printf("--timestop %02u:%02u ",
+		        hour_stop, minute_stop);
+	if (time->days_match != 127) {
+		printf("--days ");
+		print_days(time->days_match);
+		printf(" ");
+	}
+	print_date(time->date_start, "--datestart");
+	print_date(time->date_stop, "--datestop");
+}
+
+static struct xtables_match time_reg = {
+	.name          = "time",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_time_info)),
+	.userspacesize = offsetof(struct xt_time_info, kerneltime),
+	.help          = time_help,
+	.init          = time_init,
+	.parse         = time_parse,
+	.final_check   = time_check,
+	.print         = time_print,
+	.save          = time_save,
+	.extra_opts    = time_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&time_reg);
+}
