From: Fabrice MARIE <fabrice@netfilter.org>
Subject: [PATCH] time patch update, and possible bug in ./runme script
Date: Tue, 4 May 2004 23:31:05 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405042331.05709.fabrice@netfilter.org>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5c7lAnn2UwGGtq1"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_5c7lAnn2UwGGtq1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hello,

Please find attached a patch to the time match to add support for date matching
(Idea from Fabien COELHO, code rewriten to fit into the time match). I modified the
usage of the match so that it is still backward compatible, and yet allow for all the parameters
to be facultative as requested for a long time by many people.

Have a nice day,

Fabrice.
 
PS: Jozsef, it seems that there is a problem with the current runme script. Although the patch
apply fine, runme doesn't apply the kernel configure help stuff anymore.  I tried to apply both
the time patch and the TTL patch on a 2.6.x kernel, and then checked the help message
while configuring the kernel but the help message is empty for both. In the file:
linux-2.6.5-rc3-bk3/net/ipv4/netfilter/Kconfig I have this at the end. (The help stanza is empty)

config IP_NF_MATCH_TIME
        tristate  'TIME match support'
        depends on IP_NF_IPTABLES
          help

config IP_NF_TARGET_TTL
        tristate  'TTL target support'
        depends on IP_NF_MANGLE
          help

Did I miss out something simple or you reckon it's a bug ? Thanks.

--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown

--Boundary-00=_5c7lAnn2UwGGtq1
Content-Type: text/x-diff;
  charset="us-ascii";
  name="time_date_patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="time_date_patch.diff"

diff -uNr -x CVS netfilter-cvs/iptables/extensions/libipt_time.c netfilter/iptables/extensions/libipt_time.c
--- netfilter-cvs/iptables/extensions/libipt_time.c	2004-01-27 21:15:10.000000000 +0800
+++ netfilter/iptables/extensions/libipt_time.c	2004-05-04 22:18:53.000000000 +0800
@@ -18,10 +18,26 @@
 {
 	printf(
 "TIME v%s options:\n"
-" --timestart value --timestop value --days listofdays\n"
-"          timestart value : HH:MM\n"
-"          timestop  value : HH:MM\n"
-"          listofdays value: a list of days to apply -> ie. Mon,Tue,Wed,Thu,Fri. Case sensitive\n",
+" [ --timestart value ] [ --timestop value] [ --days listofdays ] [ --datestart value ] [ --datestop value ]\n"
+"          timestart value : HH:MM (default 00:00)\n"
+"          timestop  value : HH:MM (default 23:59)\n"
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
 IPTABLES_VERSION);
 }
 
@@ -29,6 +45,8 @@
 	{ "timestart", 1, 0, '1' },
 	{ "timestop", 1, 0, '2' },
 	{ "days", 1, 0, '3'},
+	{ "datestart", 1, 0, '4' },
+	{ "datestop", 1, 0, '5' },
 	{0}
 };
 
@@ -36,9 +54,18 @@
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
+	struct ipt_time_info *info = (struct ipt_time_info *)m->data;
+	globaldays = 0;
 	/* caching not yet implemented */
         *nfcache |= NFC_UNKNOWN;
-	globaldays = 0;
+        /* By default, we match on everyday */
+	info->days_match = 127;
+	/* By default, we match on every hour:min of the day */
+	info->time_start = 0;
+	info->time_stop  = 1439;  /* (23*60+59 = 1439 */
+	/* By default, we don't have any date-begin or date-end boundaries */
+	info->date_start = 0;
+	info->date_stop  = LONG_MAX;
 }
 
 /**
@@ -78,36 +105,45 @@
 	return 1;
 }
 
+static int
+parse_number(char *str, int num_min, int num_max, int *number)
+{
+	/* if the number starts with 0, replace it with a space else
+	string_to_number() will interpret it as octal !! */
+	if (strlen(str) == 0)
+		return 0;
+
+	if ((str[0] == '0') && (str[1] != '\0'))
+		str[0] = ' ';
+
+	return string_to_number(str, num_min, num_max, number);
+}
+
 static void
-parse_time_string(unsigned int *hour, unsigned int *minute, const char *time)
+parse_time_string(int *hour, int *minute, const char *time)
 {
 	char *hours;
 	char *minutes;
-
 	hours = (char *)malloc(3);
 	minutes = (char *)malloc(3);
-	bzero((void *)hours, 3);
-	bzero((void *)minutes, 3);
+	memset(hours, 0, 3);
+	memset(minutes, 0, 3);
 
-	if (split_time(&hours, &minutes, time) == 1)
+	if (split_time((char **)&hours, (char **)&minutes, time) == 1)
 	{
-                /* if the number starts with 0, replace it with a space else
-                   this string_to_number will interpret it as octal !! */
-                if ((hours[0] == '0') && (hours[1] != '\0'))
-			hours[0] = ' ';
-		if ((minutes[0] == '0') && (minutes[1] != '\0'))
-			minutes[0] = ' ';
-
-		if((string_to_number(hours, 0, 23, hour) == -1) ||
-			(string_to_number(minutes, 0, 59, minute) == -1)) {
-			*hour = *minute = (-1);
+		*hour = 0;
+		*minute = 0;
+		if ((parse_number((char *)hours, 0, 23, hour) != -1) &&
+		    (parse_number((char *)minutes, 0, 59, minute) != -1))
+		{
+			free(hours);
+			free(minutes);
+			return;
 		}
 	}
-	if ((*hour != (-1)) && (*minute != (-1))) {
-		free(hours);
-		free(minutes);
-		return;
-	}
+
+	free(hours);
+	free(minutes);
 
 	/* If we are here, there was a problem ..*/
 	exit_error(PARAMETER_PROBLEM,
@@ -161,10 +197,139 @@
 	}
 }
 
+static int
+parse_date_field(const char *str_to_parse, int str_to_parse_s, int start_pos,
+                 char *dest, int *next_pos)
+{
+	unsigned char found_value = 0;
+	unsigned char found_column = 0;
+	int i;
+
+	for (i=0; i<2; i++)
+	{
+		if ((i+start_pos) >= str_to_parse_s) /* don't exit boundaries of the string..  */
+			break;
+		if (str_to_parse[i+start_pos] == ':')
+			found_column = 1;
+		else
+		{
+			found_value = 1;
+			dest[i] = str_to_parse[i+start_pos];
+		}
+	}
+	if (found_value == 0)
+		return 0;
+	*next_pos = i + start_pos;
+	if (found_column == 0)
+		++(*next_pos);
+	return 1;
+}
+
+static int
+split_date(char *year, char *month,  char *day,
+           char *hour, char *minute, char *second,
+           const char *str_to_parse)
+{
+        int i;
+        unsigned char found_column = 0;
+	int str_to_parse_s = strlen(str_to_parse);
+
+        /* Check the length of the string */
+        if ((str_to_parse_s > 19) ||  /* YYYY:MM:DD:HH:MM:SS */
+            (str_to_parse_s < 4))     /* YYYY*/
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
+	for (i=0; i<5; i++)
+	{
+		if (i >= str_to_parse_s)
+			break;
+		if (str_to_parse[i] == ':')
+		{
+			found_column = 1;
+			break;
+		}
+		else
+			year[i] = str_to_parse[i];
+	}
+	if (found_column == 1)
+		++i;
+
+	/* parse the month if it exists */
+	if (! parse_date_field(str_to_parse, str_to_parse_s, i, month, &i))
+		return 1;
+
+	if (! parse_date_field(str_to_parse, str_to_parse_s, i, day, &i))
+		return 1;
+
+	if (! parse_date_field(str_to_parse, str_to_parse_s, i, hour, &i))
+		return 1;
+
+	if (! parse_date_field(str_to_parse, str_to_parse_s, i, minute, &i))
+		return 1;
+
+	parse_date_field(str_to_parse, str_to_parse_s, i, second, &i);
+
+        /* if we are here, format should be ok. */
+        return 1;
+}
+
+static time_t
+parse_date_string(const char *str_to_parse)
+{
+	char year[5];
+	char month[3];
+	char day[3];
+	char hour[3];
+	char minute[3];
+	char second[3];
+	struct tm t;
+	time_t temp_time;
+
+	memset(year, 0, 5);
+	memset(month, 0, 3);
+	memset(day, 0, 3);
+	memset(hour, 0, 3);
+	memset(minute, 0, 3);
+	memset(second, 0, 3);
+
+        if (split_date(year, month, day, hour, minute, second, str_to_parse) == 1)
+        {
+		memset((void *)&t, 0, sizeof(struct tm));
+		t.tm_isdst = -1;
+		t.tm_mday = 1;
+		if (!((parse_number(year, 1900, 2037, &(t.tm_year)) == -1) ||
+		      (parse_number(month, 1, 12, &(t.tm_mon)) == -1) ||
+		      (parse_number(day, 1, 31, &(t.tm_mday)) == -1) ||
+		      (parse_number(hour, 0, 9999, &(t.tm_hour)) == -1) ||
+		      (parse_number(minute, 0, 59, &(t.tm_min)) == -1) ||
+		      (parse_number(second, 0, 59, &(t.tm_sec)) == -1)))
+		{
+			t.tm_year -= 1900;
+			--(t.tm_mon);
+			temp_time = mktime(&t);
+			if (temp_time != -1)
+				return temp_time;
+		}
+	}
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid date `%s' specified, should be YYYY[:MM[:DD[:hh[:mm[:ss]]]]] format", str_to_parse);
+}
+
 #define IPT_TIME_START 0x01
 #define IPT_TIME_STOP  0x02
 #define IPT_TIME_DAYS  0x04
-
+#define IPT_DATE_START 0x08
+#define IPT_DATE_STOP  0x10
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -176,6 +341,7 @@
 {
 	struct ipt_time_info *timeinfo = (struct ipt_time_info *)(*match)->data;
 	int hours, minutes;
+	time_t temp_date;
 
 	switch (c)
 	{
@@ -216,19 +382,43 @@
 		timeinfo->days_match = globaldays;
 		*flags |= IPT_TIME_DAYS;
 		break;
+
+		/* datestart */
+	case '4':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --datestart");
+		if (*flags & IPT_DATE_START)
+			exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --datestart twice");
+		temp_date = parse_date_string(optarg);
+		timeinfo->date_start = temp_date;
+		*flags |= IPT_DATE_START;
+		break;
+
+		/* datestop*/
+	case '5':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+                                   "unexpected '!' with --datestop");
+		if (*flags & IPT_DATE_STOP)
+			exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --datestop twice");
+		temp_date = parse_date_string(optarg);
+		timeinfo->date_stop = temp_date;
+		*flags |= IPT_DATE_STOP;
+		break;
 	default:
 		return 0;
 	}
 	return 1;
 }
 
-/* Final check; must have specified --timestart --timestop --days. */
+/* Final check */
 static void
 final_check(unsigned int flags)
 {
-	if (flags != (IPT_TIME_START | IPT_TIME_STOP | IPT_TIME_DAYS))
-		exit_error(PARAMETER_PROBLEM,
-			   "TIME match: You must specify `--timestart --timestop and --days'");
+	/* Nothing to do */
 }
 
 
@@ -249,6 +439,7 @@
 			++nbdays;
 		}
 	}
+	printf(" ");
 }
 
 static void
@@ -258,6 +449,22 @@
 	*minutes = fulltime % 60;
 }
 
+static void
+print_date(time_t date, char *command)
+{
+	/* If it's default value, don't print..*/
+	if (((date == 0) || (date == LONG_MAX)) && (command != NULL))
+		return;
+	struct tm *t;
+	t = localtime(&date);
+	if (command != NULL)
+		printf("%s %d:%d:%d:%d:%d:%d ", command, (t->tm_year + 1900), (t->tm_mon + 1),
+			t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+        else
+        	printf("%d-%d-%d %d:%d:%d ", (t->tm_year + 1900), (t->tm_mon + 1),
+			t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+}
+
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
@@ -269,11 +476,26 @@
 
 	divide_time(time->time_start, &hour_start, &minute_start);
 	divide_time(time->time_stop, &hour_stop, &minute_stop);
-	printf(" TIME from %d:%d to %d:%d on ",
-	       hour_start, minute_start,
-	       hour_stop, minute_stop);
-	print_days(time->days_match);
-	printf(" ");
+	printf("TIME ");
+	if (time->time_start != 0)
+		printf("from %d:%d ", hour_start, minute_start);
+	if (time->time_stop != 1439) /* 23*60+59 = 1439 */
+		printf("to %d:%d ", hour_stop, minute_stop);
+	printf("on ");
+	if (time->days_match == 127)
+		printf("all days ");
+	else
+		print_days(time->days_match);
+	if (time->date_start != 0)
+	{
+		printf("starting from ");
+		print_date(time->date_start, NULL);
+	}
+	if (time->date_stop != LONG_MAX)
+	{
+		printf("until date ");
+		print_date(time->date_stop, NULL);
+	}
 }
 
 /* Saves the data in parsable form to stdout. */
@@ -285,11 +507,22 @@
 
 	divide_time(time->time_start, &hour_start, &minute_start);
 	divide_time(time->time_stop, &hour_stop, &minute_stop);
-	printf(" --timestart %.2d:%.2d --timestop %.2d:%.2d --days ",
-	       hour_start, minute_start,
-	       hour_stop, minute_stop);
-	print_days(time->days_match);
-	printf(" ");
+	if (time->time_start != 0)
+		printf("--timestart %.2d:%.2d ",
+		        hour_start, minute_start);
+	
+	if (time->time_stop != 1439) /* 23*60+59 = 1439 */
+		printf("--timestop %.2d:%.2d ",
+		        hour_stop, minute_stop);
+	
+	if (time->days_match != 127)
+	{
+		printf("--days ");
+		print_days(time->days_match);
+		printf(" ");
+	}
+	print_date(time->date_start, "--datestart");
+	print_date(time->date_stop, "--datestop");
 }
 
 /* have to use offsetof() instead of IPT_ALIGN(), since kerneltime must not
diff -uNr -x CVS netfilter-cvs/iptables/extensions/libipt_time.man netfilter/iptables/extensions/libipt_time.man
--- netfilter-cvs/iptables/extensions/libipt_time.man	2004-01-22 23:04:25.000000000 +0800
+++ netfilter/iptables/extensions/libipt_time.man	2004-05-04 22:18:53.000000000 +0800
@@ -1,10 +1,16 @@
-This matches if the current time is within a given range.
+This matches if the packet arrival time/date is within a given range. All options are facultative.
 .TP
-.BI "--timestart " "value"
-Match only if it is after `value' (Format: HH:MM).
+.BI " --timestart " "value"
+Match only if it is after `value' (Inclusive, format: HH:MM ; default 00:00).
 .TP
-.BI "--timestop " "value"
-Match only if it is before `value' (Format: HH:MM).
+.BI "--timestop  " "value"
+Match only if it is before `value' (Inclusive, format: HH:MM ; default 23:59).
 .TP
 .BI "--days " "listofdays"
-Match only if today is one of the given days.  (Format: Mon,Tue,Wed,Thu,Fri)
+Match only if today is one of the given days. (format: Mon,Tue,Wed,Thu,Fri,Sat,Sun ; default everyday)
+.TP
+.BI "--datestart " "date"
+Match only if it is after `date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]] ; h,m,s start from 0 ; default to 1970)
+.TP
+.BI "--datestop " "date"
+Match only if it is before `date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]] ; h,m,s start from 0 ; default to 2037)
diff -uNr -x CVS netfilter-cvs/patch-o-matic-ng/time/help netfilter/patch-o-matic-ng/time/help
--- netfilter-cvs/patch-o-matic-ng/time/help	2003-12-19 02:28:45.000000000 +0800
+++ netfilter/patch-o-matic-ng/time/help	2004-05-04 22:24:02.000000000 +0800
@@ -1,25 +1,32 @@
 
 This option adds CONFIG_IP_NF_MATCH_TIME, which supplies a time match module.
-This match allows you to filter based on the packet arrival time
-(arrival time at the machine which the netfilter is running on) or
-departure time (for locally generated packets).
+This match allows you to filter based on the packet arrival time/date
+(arrival time/date at the machine which the netfilter is running on) or
+departure time/date (for locally generated packets).
 
 Supported options are:
---timestart HH:MM
-  The starting point of the time match frame.
+[ --timestart value ]
+    Match only if it is after `value' (Inclusive, format: HH:MM ; default 00:00).
 
---timestop HH:MM
-  The stopping point of the time match frame
+[ --timestop  value ]
+    Match only if it is before `value' (Inclusive, format: HH:MM ; default 23:59).
 
---days Tue,Mon...
-  Days of the week to match separated by a coma, no space
-  (one of Sun,Mon,Tue,Wed,Thu,Fri,Sat)
+[ --days listofdays ]
+    Match only if today is one of the given days. (format: Mon,Tue,Wed,Thu,Fri,Sat,Sun ; default everyday)
+
+[ --datestart date ]
+    Match only if it is after `date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]]
+    h,m,s start from 0 ; default to 1970)
+
+[ --datestop date ]
+    Match only if it is before `date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]]
+    h,m,s start from 0 ; default to 2037)
 
 Example:
   -A INPUT -m time --timestart 8:00 --timestop 18:00 --days Mon,Tue,Wed,Thu,Fri
   will match packets that have an arrival timestamp in the range 8:00->18:00 from Monday
   to Friday.
 
-  -A OUTPUT -m time --timestart 8:00 --timestop 18:00 --Days Mon
+  -A OUTPUT -m time --timestart 8:00 --timestop 18:00 --Days Mon --date-stop 2010
   will match the packets (locally generated) that have a departure timestamp
-  in the range 8:00->18:00 on Monday only.
+  in the range 8:00->18:00 on Monday only, until 2010
diff -uNr -x CVS netfilter-cvs/patch-o-matic-ng/time/info netfilter/patch-o-matic-ng/time/info
--- netfilter-cvs/patch-o-matic-ng/time/info	2004-02-20 07:56:10.000000000 +0800
+++ netfilter/patch-o-matic-ng/time/info	2004-05-04 22:37:59.320059040 +0800
@@ -1,4 +1,4 @@
 Author: Fabrice MARIE <fabrice@netfilter.org>
 Status: It Works For Me.
 Repository: base
-Requires: linux < 2.6.0
+
diff -uNr -x CVS netfilter-cvs/patch-o-matic-ng/time/linux/Documentation/Configure.help.ladd netfilter/patch-o-matic-ng/time/linux/Documentation/Configure.help.ladd
--- netfilter-cvs/patch-o-matic-ng/time/linux/Documentation/Configure.help.ladd	2004-02-19 19:30:10.000000000 +0800
+++ netfilter/patch-o-matic-ng/time/linux/Documentation/Configure.help.ladd	2004-05-04 23:09:39.336212680 +0800
@@ -1,10 +1,10 @@
-CONFIG_IP_NF_MATCH_TOS
+CONFIG_IP_NF_MATCH_LENGTH
 TIME patch support
 CONFIG_IP_NF_MATCH_TIME
   This option adds a `time' match, which allows you
-  to matchbased on the packet arrival time
-  (arrival time at the machine which the netfilter is running on) or
-  departure time (for locally generated packets).
+  to match based on the packet arrival time/date
+  (arrival time/date at the machine which netfilter is running on) or
+  departure time/date (for locally generated packets).
 
   If you say Y here, try iptables -m time --help for more information.
  
diff -uNr -x CVS netfilter-cvs/patch-o-matic-ng/time/linux/include/linux/netfilter_ipv4/ipt_time.h netfilter/patch-o-matic-ng/time/linux/include/linux/netfilter_ipv4/ipt_time.h
--- netfilter-cvs/patch-o-matic-ng/time/linux/include/linux/netfilter_ipv4/ipt_time.h	2003-12-19 02:28:46.000000000 +0800
+++ netfilter/patch-o-matic-ng/time/linux/include/linux/netfilter_ipv4/ipt_time.h	2004-05-04 22:24:02.000000000 +0800
@@ -7,6 +7,8 @@
 	u_int16_t time_start;   /* 0 < time_start < 23*60+59 = 1439             */
 	u_int16_t time_stop;    /* 0:0 < time_stat < 23:59                      */
 	u_int8_t  kerneltime;   /* ignore skb time (and use kerneltime) or not. */
+	time_t    date_start;
+	time_t    date_stop;
 };
 
 
diff -uNr -x CVS netfilter-cvs/patch-o-matic-ng/time/linux/net/ipv4/netfilter/ipt_time.c netfilter/patch-o-matic-ng/time/linux/net/ipv4/netfilter/ipt_time.c
--- netfilter-cvs/patch-o-matic-ng/time/linux/net/ipv4/netfilter/ipt_time.c	2003-12-19 02:28:46.000000000 +0800
+++ netfilter/patch-o-matic-ng/time/linux/net/ipv4/netfilter/ipt_time.c	2004-05-04 22:26:05.000000000 +0800
@@ -10,6 +10,7 @@
   2001-26-09 Fabrice MARIE <fabrice@netfilter.org> : force the match to be in LOCAL_IN or PRE_ROUTING only.
   2001-30-11 Fabrice : added the possibility to use the match in FORWARD/OUTPUT with a little hack,
      added Nguyen Dang Phuoc Dong <dongnd@tlnet.com.vn> patch to support timezones.
+  2004-05-02 Fabrice : added support for date matching, from an idea of Fabien COELHO.
 */
 
 #include <linux/module.h>
@@ -19,7 +20,7 @@
 #include <linux/time.h>
 
 MODULE_AUTHOR("Fabrice MARIE <fabrice@netfilter.org>");
-MODULE_DESCRIPTION("Match arrival timestamp");
+MODULE_DESCRIPTION("Match arrival timestamp/date");
 MODULE_LICENSE("GPL");
 
 struct tm
@@ -67,6 +68,10 @@
 	else
 		packet_local_time = skb->stamp.tv_sec;
 
+	/* First we make sure we are in the date start-stop boundaries */
+	if ((packet_local_time < info->date_start) || (packet_local_time > info->date_stop))
+		return 0; /* We are outside the date boundaries */
+
 	/* Transform the timestamp of the packet, in a human readable form */
 	localtime(&packet_local_time, &currenttime);
 
@@ -92,8 +97,7 @@
 {
 	struct ipt_time_info *info = matchinfo;   /* match info for rule */
 
-	/* First, check that we are in the correct hook */
-	/* PRE_ROUTING, LOCAL_IN or FROWARD */
+	/* First, check that we are in the correct hooks */
 	if (hook_mask
             & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT)))
 	{
@@ -103,7 +107,7 @@
 	/* we use the kerneltime if we are in forward or output */
 	info->kerneltime = 1;
 	if (hook_mask & ~((1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT))) 
-		/* if not, we use the skb time */
+		/* we use the skb time */
 		info->kerneltime = 0;
 
 	/* Check the size */

--Boundary-00=_5c7lAnn2UwGGtq1--
