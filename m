From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH v5] xtables: Add an interval option for xtables lock wait
Date: Thu, 23 Jun 2016 18:44:06 -0600
Message-ID: <1466729046-3070-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
	Liping Zhang <zlpnobody@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41401 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbcFXAoS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 20:44:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip[6]tables currently waits for 1 second for the xtables lock to be
freed if the -w option is used. We have seen that the lock is held
much less than that resulting in unnecessary delay when trying to
acquire the lock. This problem is even severe in case of latency
sensitive applications.

Introduce a new option 'W' to specify the wait interval in decimal
format [seconds.microseconds]. If this option is not specified,
the command sleeps for 1 second by default.

v1->v2: Change behavior to take millisecond sleep as an argument to
-w as suggested by Pablo. Also maintain current behavior for -w to
sleep for 1 second as mentioned by Liping.

v2->v3: Move the millisecond behavior to a new option as suggested
by Pablo.

v3->v4: Use select instead of usleep. Sleep every iteration for
the time specified in the "-W" argument. Update man page.

v4->v5: Fix compilation error when enabling nftables

Cc: Liping Zhang <zlpnobody@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 iptables/ip6tables.c   | 26 ++++++++++++++++++++++++--
 iptables/iptables.8.in |  7 +++++++
 iptables/iptables.c    | 26 ++++++++++++++++++++++++--
 iptables/xshared.c     | 31 +++++++++++++++++++++++--------
 iptables/xshared.h     |  2 +-
 iptables/xtables.c     | 25 ++++++++++++++++++++++++-
 6 files changed, 103 insertions(+), 14 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c48ddf9..9629403 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -103,6 +103,7 @@ static struct option original_opts[] = {
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
 	{.name = "wait",          .has_arg = 2, .val = 'w'},
+	{.name = "wait-interval", .has_arg = 2, .val = 'W'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "help",          .has_arg = 2, .val = 'h'},
@@ -260,6 +261,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w [seconds]	wait for the xtables lock\n"
+"  --wait-interval	-W [seconds.microseconds]\n"
+"				interval to wait for xtables lock\n"
+"				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
@@ -1325,6 +1329,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	int verbose = 0;
 	int wait = 0;
+	double wait_interval = 1;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1360,7 +1365,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvw::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvwW::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1616,6 +1621,23 @@ int do_command6(int argc, char *argv[], char **table,
 						"wait seconds not numeric");
 			break;
 
+		case 'W':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-W' from "
+					      "ip6tables-restore");
+			}
+			if (optarg) {
+				if (sscanf(optarg, "%lf", &wait_interval) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait interval not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%lf", &wait_interval) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait interval not numeric");
+			break;
+
 		case 'm':
 			command_match(&cs);
 			break;
@@ -1770,7 +1792,7 @@ int do_command6(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && !xtables_lock(wait)) {
+	if (!restore && !xtables_lock(wait, wait_interval)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. ");
 		if (wait == 0)
 			fprintf(stderr, "Perhaps you want to use the -w option?\n");
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 5a8c7ae..adc9fb3 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -370,6 +370,13 @@ the program will exit if the lock cannot be obtained.  This option will
 make the program wait (indefinitely or for optional \fIseconds\fP) until
 the exclusive lock can be obtained.
 .TP
+\fB\-W\fP, \fB\-\-wait-interval\fP [\fIseconds.microseconds\fP]
+Interval to wait per each iteration.
+When running latency sensitive applications, waiting for the xtables lock
+for extended durations may not be acceptable. This option will make each
+iteration take the amount of time specified. The default interval is
+1 second.
+.TP
 \fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 91617c2..1b26d61 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -100,6 +100,7 @@ static struct option original_opts[] = {
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
 	{.name = "wait",          .has_arg = 2, .val = 'w'},
+	{.name = "wait-interval", .has_arg = 2, .val = 'W'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "fragments",     .has_arg = 0, .val = 'f'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
@@ -254,6 +255,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w [seconds]	wait for the xtables lock\n"
+"  --wait-interval	-W [seconds.microseconds]\n"
+"				interval to wait for xtables lock\n"
+"				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
@@ -1321,6 +1325,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 	int verbose = 0;
 	int wait = 0;
+	double wait_interval = 1;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1355,7 +1360,7 @@ int do_command4(int argc, char *argv[], char **table,
 	opterr = 0;
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvw::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwW::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1609,6 +1614,23 @@ int do_command4(int argc, char *argv[], char **table,
 						"wait seconds not numeric");
 			break;
 
+		case 'W':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-W' from "
+					      "iptables-restore");
+			}
+			if (optarg) {
+				if (sscanf(optarg, "%lf", &wait_interval) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait interval not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%lf", &wait_interval) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait interval not numeric");
+			break;
+
 		case 'm':
 			command_match(&cs);
 			break;
@@ -1759,7 +1781,7 @@ int do_command4(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && !xtables_lock(wait)) {
+	if (!restore && !xtables_lock(wait, wait_interval)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. ");
 		if (wait == 0)
 			fprintf(stderr, "Perhaps you want to use the -w option?\n");
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 81c2581..d810c98 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -9,12 +9,15 @@
 #include <sys/file.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <sys/time.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <xtables.h>
+#include <math.h>
 #include "xshared.h"
 
 #define XT_LOCK_NAME	"/run/xtables.lock"
+#define BASE_MICROSECONDS	100000
 
 /*
  * Print out any special helps. A user might like to be able to add a --help
@@ -244,9 +247,17 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-bool xtables_lock(int wait)
+bool xtables_lock(int wait, double wait_interval)
 {
-	int fd, waited = 0, i = 0;
+	int fd, i = 0;
+	double wait_int, wait_fract;
+	struct timeval total_time, wait_time, waited_time;
+
+	wait_fract = modf(wait_interval, &wait_int);
+	total_time.tv_sec = wait;
+	total_time.tv_usec = 0;
+	waited_time.tv_sec = 0;
+	waited_time.tv_usec = 0;
 
 	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
 	if (fd < 0)
@@ -255,12 +266,16 @@ bool xtables_lock(int wait)
 	while (1) {
 		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
 			return true;
-		else if (wait >= 0 && waited >= wait)
-			return false;
-		if (++i % 2 == 0)
+		if (++i % 10 == 0)
 			fprintf(stderr, "Another app is currently holding the xtables lock; "
-				"waiting (%ds) for it to exit...\n", waited);
-		waited++;
-		sleep(1);
+				"waiting (%lds %ldus) for it to exit...\n", waited_time.tv_sec, waited_time.tv_usec);
+		wait_time.tv_sec = wait_int;
+		wait_time.tv_usec = wait_fract*BASE_MICROSECONDS;
+		if (wait != -1)
+			timersub(&total_time, &wait_time, &total_time);
+		timeradd(&waited_time, &wait_time, &waited_time);
+		if (!timerisset(&total_time))
+			return false;
+		select(0, NULL, NULL, NULL, &wait_time);
 	}
 }
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 40dd915..964cd4c 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -85,7 +85,7 @@ extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
-extern bool xtables_lock(int wait);
+bool xtables_lock(int wait, double wait_interval);
 
 extern const struct xtables_afinfo *afinfo;
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index ecd577c..baeb472 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -86,6 +86,7 @@ static struct option original_opts[] = {
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",	  .has_arg = 0, .val = 'v'},
 	{.name = "wait",	  .has_arg = 2, .val = 'w'},
+	{.name = "wait-interval", .has_arg = 2, .val = 'W'},
 	{.name = "exact",	  .has_arg = 0, .val = 'x'},
 	{.name = "fragments",	  .has_arg = 0, .val = 'f'},
 	{.name = "version",	  .has_arg = 0, .val = 'V'},
@@ -239,6 +240,10 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
+"  --wait	-w [seconds]	wait for the xtables lock\n"
+"  --wait-interval	-W [seconds.microseconds]\n"
+"				interval to wait for xtables lock\n"
+"				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
@@ -687,6 +692,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
 	int wait = 0;
+	double wait_interval = 1;
 
 	memset(cs, 0, sizeof(*cs));
 	cs->jumpto = "";
@@ -716,7 +722,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 	opts = xt_params->orig_opts;
 	while ((cs->c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvw::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwW::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs->c) {
 			/*
@@ -1019,6 +1025,23 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 						      "wait seconds not numeric");
 			break;
 
+		case 'W':
+			if (p->restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-W' from "
+					      "iptables-restore");
+			}
+			if (optarg) {
+				if (sscanf(optarg, "%lf", &wait_interval) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait interval not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%lf", &wait_interval) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait interval not numeric");
+			break;
+
 		case '0':
 			set_option(&cs->options, OPT_LINENUMBERS,
 				   &args->invflags, cs->invert);
-- 
1.9.1

