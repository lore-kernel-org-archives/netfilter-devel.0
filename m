From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH v4] xtables: Add locking to prevent concurrent instances
Date: Fri, 31 May 2013 09:07:04 -0400
Message-ID: <20130531130704.GA20357@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gg0-f170.google.com ([209.85.161.170]:53349 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3EaNMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 May 2013 09:12:51 -0400
Received: by mail-gg0-f170.google.com with SMTP id s5so343503ggc.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2013 06:12:51 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There have been numerous complaints and bug reports over the years when admins
attempt to run more than one instance of iptables simultaneously.  Currently
open bug reports which are related:

325: Parallel execution of the iptables is impossible
758: Retry iptables command on transient failure
764: Doing -Z twice in parallel breaks counters
822: iptables shows negative or other bad packet/byte counts

As Patrick notes in 325:  "Since this has been a problem people keep running
into, I'd suggest to simply add some locking to iptables to catch the most
common case."

I started looking into alternatives to add locking, and of course the most
common/obvious solution is to use a pidfile.  But this has various downsides,
such as if the application is terminated abnormally and the pidfile isn't
cleaned up.  And this also requires a writable filesystem.  Using a UNIX domain
socket file (e.g. in /var/run) has similar issues.

Starting in 2.2, Linux added support for abstract sockets.  These sockets
require no filesystem, and automatically disappear once the application
terminates.  This is the locking solution I chose to implement in ip[6]tables.
As an added bonus, since each network namespace has its own socket pool, an
ip[6]tables instance running in one namespace will not lock out an ip[6]tables
instance running in another namespace.  A filesystem approach would have
to recognize and handle multiple network namespaces.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>

---

v2: Addressed Patrick's comments - locking attempts will be made indefinitely until successful
v3: Update warning message to more closely resemble locking output from yum
v4: Move lock to ip[6]tables only.  Add -w option to wait for lock - default is to only try once then exit


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xtables-lock

diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 8634854..f9d3db1 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -363,6 +363,13 @@ For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed. \fB\-v\fP may be
 specified multiple times to possibly emit more detailed debug statements.
 .TP
+\fB\-w\fP, \fB\-\-wait\fP
+Wait for the xtables lock.
+To prevent multiple instances of the program from running concurrently,
+an attempt will be made to obtain an exclusive lock at launch.  By default,
+the program will exit if the lock cannot be obtained.  This option will
+make the program wait until the exclusive lock can be obtained.
+.TP
 \fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c8d34e2..3877d2f 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -102,6 +102,7 @@ static struct option original_opts[] = {
 	{.name = "numeric",       .has_arg = 0, .val = 'n'},
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
+	{.name = "wait",          .has_arg = 0, .val = 'w'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "help",          .has_arg = 2, .val = 'h'},
@@ -257,6 +258,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
+"  --wait	-w		wait for the xtables lock\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
@@ -1293,6 +1295,7 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 	struct in6_addr *smasks = NULL, *dmasks = NULL;
 
 	int verbose = 0;
+	bool wait = false;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1328,7 +1331,7 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvwnt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1573,6 +1576,10 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			verbose++;
 			break;
 
+		case 'w':
+			wait = true;
+			break;
+
 		case 'm':
 			command_match(&cs);
 			break;
@@ -1724,6 +1731,14 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			   "chain name `%s' too long (must be under %u chars)",
 			   chain, XT_EXTENSION_MAXNAMELEN);
 
+	/* Attempt to acquire the xtables lock */
+	if (!xtables_lock(wait)) {
+		fprintf(stderr, "Another app is currently holding the xtables lock. "
+			"Perhaps you want to use the -w option?\n");
+		xtables_free_opts(1);
+		exit(1);
+	}
+
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
 		*handle = ip6tc_init(*table);
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 9643705..cec204f 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -351,6 +351,13 @@ For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed. \fB\-v\fP may be
 specified multiple times to possibly emit more detailed debug statements.
 .TP
+\fB\-w\fP, \fB\-\-wait\fP
+Wait for the xtables lock.
+To prevent multiple instances of the program from running concurrently,
+an attempt will be made to obtain an exclusive lock at launch.  By default,
+the program will exit if the lock cannot be obtained.  This option will
+make the program wait until the exclusive lock can be obtained.
+.TP
 \fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 79fa37b..787c145 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -99,6 +99,7 @@ static struct option original_opts[] = {
 	{.name = "numeric",       .has_arg = 0, .val = 'n'},
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
+	{.name = "wait",          .has_arg = 0, .val = 'w'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "fragments",     .has_arg = 0, .val = 'f'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
@@ -251,6 +252,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
+"  --wait	-w		wait for the xtables lock\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
@@ -1289,6 +1291,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
 
 	int verbose = 0;
+	bool wait = false;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1324,7 +1327,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwnt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1567,6 +1570,10 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			verbose++;
 			break;
 
+		case 'w':
+			wait = true;
+			break;
+
 		case 'm':
 			command_match(&cs);
 			break;
@@ -1721,6 +1728,14 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			   "chain name `%s' too long (must be under %u chars)",
 			   chain, XT_EXTENSION_MAXNAMELEN);
 
+	/* Attempt to acquire the xtables lock */
+	if (!xtables_lock(wait)) {
+		fprintf(stderr, "Another app is currently holding the xtables lock. "
+			"Perhaps you want to use the -w option?\n");
+		xtables_free_opts(1);
+		exit(1);
+	}
+
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
 		*handle = iptc_init(*table);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index e61c28c..48f93fc 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -6,9 +6,15 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <unistd.h>
 #include <xtables.h>
 #include "xshared.h"
 
+#define XT_SOCKET_NAME "xtables"
+#define XT_SOCKET_LEN 8
+
 /*
  * Print out any special helps. A user might like to be able to add a --help
  * to the commandline, and see expected results. So we call help for all
@@ -236,3 +242,31 @@ void xs_init_match(struct xtables_match *match)
 	if (match->init != NULL)
 		match->init(match->m);
 }
+
+bool xtables_lock(bool wait)
+{
+	int i = 0, ret, xt_socket;
+	struct sockaddr_un xt_addr;
+
+	memset(&xt_addr, 0, sizeof(xt_addr));
+	xt_addr.sun_family = AF_UNIX;
+	strcpy(xt_addr.sun_path+1, XT_SOCKET_NAME);
+	xt_socket = socket(AF_UNIX, SOCK_STREAM, 0);
+	/* If we can't even create a socket, fall back to prior (lockless) behavior */
+	if (xt_socket < 0)
+		return true;
+
+	while (1) {
+		ret = bind(xt_socket, (struct sockaddr*)&xt_addr,
+			   offsetof(struct sockaddr_un, sun_path)+XT_SOCKET_LEN);
+		if (ret == 0)
+			return true;
+		else if (wait == false)
+			return false;
+		if (++i % 2 == 0)
+			fprintf(stderr, "Another app is currently holding the xtables lock; "
+				"waiting for it to exit...\n");
+		sleep(1);
+	}
+
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index b804aaf..1e2b9b8 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -2,6 +2,7 @@
 #define IPTABLES_XSHARED_H 1
 
 #include <limits.h>
+#include <stdbool.h>
 #include <stdint.h>
 #include <netinet/in.h>
 #include <net/if.h>
@@ -83,6 +84,7 @@ extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
+extern bool xtables_lock(bool wait);
 
 extern const struct xtables_afinfo *afinfo;
 

--M9NhX3UHpAaciwkO--
