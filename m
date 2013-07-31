From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH v3] iptables: Sort table names in ip[6]tables-save
Date: Wed, 31 Jul 2013 13:21:07 -0700
Message-ID: <20130731202107.GA12949@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48441 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab3GaUVM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:21:12 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so1272128pad.8
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 13:21:11 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Depending upon the load order of rules, the output from ip[6]tables-save
will vary, as ip[6]_tables_names is sorted LIFO.  As reported by
Linus van Geuns, this makes comparing output from ip[6]tables-save across
reboots difficult.  Attached are two patches which attempt to fix this.

  1) Sort by default - add 'u' option to unsort
  2) Unsorted by default - add 's' option to sort

Please apply whichever is preferable.

This closes bugzilla #580.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>

---
v2: Add option to disable sorting - feedback from Maciej Żenczykowski
v3: Provide two patches


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipts-sort-default

diff --git a/include/xtables.h b/include/xtables.h
index c35a6e6..dc6e566 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -479,6 +479,8 @@ extern void xtables_ip6parse_any(const char *, struct in6_addr **,
 extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
 	struct in6_addr **, unsigned int *);
 
+extern int stringcmp(const void *, const void *);
+
 /**
  * Print the specified value to standard output, quoting dangerous
  * characters if required.
diff --git a/iptables/ip6tables-save.8 b/iptables/ip6tables-save.8
index 457be82..cc70e43 100644
--- a/iptables/ip6tables-save.8
+++ b/iptables/ip6tables-save.8
@@ -39,6 +39,10 @@ include the current values of all packet and byte counters in the output
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-u\fR, \fB\-\-unsorted\fR
+by default, tables are output in alphabetical order.  This option disables
+sorting, and tables are output in LIFO order.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..3a51fe4 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -9,6 +9,7 @@
 #include <sys/errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
@@ -23,12 +24,14 @@
 #endif
 
 static int show_counters = 0;
+static bool sort_tables = true;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "unsorted", .has_arg = false, .val = 'u'},
 	{NULL},
 };
 
@@ -36,8 +39,9 @@ static const struct option options[] = {
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-	int ret = 1;
+	int i, count = 0, ret = 1;
 	FILE *procfile = NULL;
+	char **tables = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip6_tables_names", "re");
@@ -50,10 +54,18 @@ static int for_each_table(int (*func)(const char *tablename))
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
+		count++;
+		tables = (char **)realloc(tables, sizeof(char*)*count);
+		tables[count-1] = strdup(tablename);
 	}
-
 	fclose(procfile);
+
+	if (sort_tables == true)
+		qsort(tables, count, sizeof(char *), stringcmp);
+	for (i = 0 ; i < count ; i++) {
+		ret &= func(tables[i]);
+	}
+
 	return ret;
 }
 
@@ -141,7 +153,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:u", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -154,6 +166,9 @@ int ip6tables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 'u':
+			sort_tables = false;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/iptables/iptables-save.8 b/iptables/iptables-save.8
index c2e0a94..862fb9d 100644
--- a/iptables/iptables-save.8
+++ b/iptables/iptables-save.8
@@ -39,6 +39,10 @@ include the current values of all packet and byte counters in the output
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-u\fR, \fB\-\-unsorted\fR
+by default, tables are output in alphabetical order.  This option disables
+sorting, and tables are output in LIFO order.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHOR
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..c194d9f 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -9,6 +9,7 @@
 #include <sys/errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
@@ -22,20 +23,23 @@
 #endif
 
 static int show_counters = 0;
+static bool sort_tables = true;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "unsorted", .has_arg = false, .val = 'u'},
 	{NULL},
 };
 
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-	int ret = 1;
+	int i, count = 0, ret = 1;
 	FILE *procfile = NULL;
+	char **tables = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip_tables_names", "re");
@@ -48,10 +52,18 @@ static int for_each_table(int (*func)(const char *tablename))
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
+		count++;
+		tables = (char **)realloc(tables, sizeof(char*)*count);
+		tables[count-1] = strdup(tablename);
 	}
-
 	fclose(procfile);
+
+	if (sort_tables == true)
+		qsort(tables, count, sizeof(char *), stringcmp);
+	for (i = 0 ; i < count ; i++) {
+		ret &= func(tables[i]);
+	}
+
 	return ret;
 }
 
@@ -140,7 +152,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:u", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -153,6 +165,9 @@ iptables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 'u':
+			sort_tables = false;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ef5bc07..ad6df1c 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1961,3 +1961,10 @@ void get_kernel_version(void)
 	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
 	kernel_version = LINUX_VERSION(x, y, z);
 }
+
+int stringcmp(const void *a, const void *b) 
+{ 
+	const char **ia = (const char **)a;
+	const char **ib = (const char **)b;
+	return strcmp(*ia, *ib);
+} 

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipts-sort-nodefault

diff --git a/include/xtables.h b/include/xtables.h
index c35a6e6..dc6e566 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -479,6 +479,8 @@ extern void xtables_ip6parse_any(const char *, struct in6_addr **,
 extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
 	struct in6_addr **, unsigned int *);
 
+extern int stringcmp(const void *, const void *);
+
 /**
  * Print the specified value to standard output, quoting dangerous
  * characters if required.
diff --git a/iptables/ip6tables-save.8 b/iptables/ip6tables-save.8
index 457be82..0ffc9e1 100644
--- a/iptables/ip6tables-save.8
+++ b/iptables/ip6tables-save.8
@@ -39,6 +39,10 @@ include the current values of all packet and byte counters in the output
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-s\fR, \fB\-\-sorted\fR
+by default, tables are output in LIFO order.  This option enables
+sorting, and tables are output in alphabetical order.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..8e7390c 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -9,6 +9,7 @@
 #include <sys/errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
@@ -23,12 +24,14 @@
 #endif
 
 static int show_counters = 0;
+static bool sort_tables = false;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "sorted",   .has_arg = false, .val = 's'},
 	{NULL},
 };
 
@@ -36,8 +39,9 @@ static const struct option options[] = {
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-	int ret = 1;
+	int i, count = 0, ret = 1;
 	FILE *procfile = NULL;
+	char **tables = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip6_tables_names", "re");
@@ -50,10 +54,18 @@ static int for_each_table(int (*func)(const char *tablename))
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
+		count++;
+		tables = (char **)realloc(tables, sizeof(char*)*count);
+		tables[count-1] = strdup(tablename);
 	}
-
 	fclose(procfile);
+
+	if (sort_tables == true)
+		qsort(tables, count, sizeof(char *), stringcmp);
+	for (i = 0 ; i < count ; i++) {
+		ret &= func(tables[i]);
+	}
+
 	return ret;
 }
 
@@ -141,7 +153,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:s", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -154,6 +166,9 @@ int ip6tables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 's':
+			sort_tables = true;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/iptables/iptables-save.8 b/iptables/iptables-save.8
index c2e0a94..3c02282 100644
--- a/iptables/iptables-save.8
+++ b/iptables/iptables-save.8
@@ -39,6 +39,10 @@ include the current values of all packet and byte counters in the output
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-s\fR, \fB\-\-sorted\fR
+by default, tables are output in LIFO order.  This option enables
+sorting, and tables are output in alphabetical order.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHOR
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..93c865c 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -9,6 +9,7 @@
 #include <sys/errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
@@ -22,20 +23,23 @@
 #endif
 
 static int show_counters = 0;
+static bool sort_tables = false;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "sorted",   .has_arg = false, .val = 's'},
 	{NULL},
 };
 
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-	int ret = 1;
+	int i, count = 0, ret = 1;
 	FILE *procfile = NULL;
+	char **tables = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip_tables_names", "re");
@@ -48,10 +52,18 @@ static int for_each_table(int (*func)(const char *tablename))
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
+		count++;
+		tables = (char **)realloc(tables, sizeof(char*)*count);
+		tables[count-1] = strdup(tablename);
 	}
-
 	fclose(procfile);
+
+	if (sort_tables == true)
+		qsort(tables, count, sizeof(char *), stringcmp);
+	for (i = 0 ; i < count ; i++) {
+		ret &= func(tables[i]);
+	}
+
 	return ret;
 }
 
@@ -140,7 +152,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:s", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -153,6 +165,9 @@ iptables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 's':
+			sort_tables = true;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ef5bc07..ad6df1c 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1961,3 +1961,10 @@ void get_kernel_version(void)
 	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
 	kernel_version = LINUX_VERSION(x, y, z);
 }
+
+int stringcmp(const void *a, const void *b) 
+{ 
+	const char **ia = (const char **)a;
+	const char **ib = (const char **)b;
+	return strcmp(*ia, *ib);
+} 

--ZPt4rx8FFjLCG7dd--
