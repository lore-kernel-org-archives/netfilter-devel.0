From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH v3] xtables: Add a smaller delay option when waiting for xtables lock
Date: Thu,  2 Jun 2016 18:46:34 -0600
Message-ID: <1464914794-21787-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
	Liping Zhang <zlpnobody@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48298 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbcFCArI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 20:47:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip[6]tables currently waits for 1 second for the xtables lock to be
freed if the -w option is used. We have seen that the lock is held
much less than that resulting in unnecessary delay when trying to
acquire the lock. This problem is even severe in case of latency
sensitive applications.

Introduce a new option 'W' with 10ms granularity (experimentally
determined) by specifying the delay in [seconds.milliseconds].
If milliseconds are not specified, the command sleeps for 1 second
similar to option 'w'.

v1->v2: Change behavior to take millisecond sleep as an argument to
-w as suggested by Pablo. Also maintain current behavior for -w to
sleep for 1 second as mentioned by Liping.

v2->v3: Move the millisecond behavior to a new option as suggested
by Pablo.

Cc: Liping Zhang <zlpnobody@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 iptables/ip6tables.c | 28 +++++++++++++++++++++++++---
 iptables/iptables.c  | 28 +++++++++++++++++++++++++---
 iptables/xshared.c   | 27 ++++++++++++++++++++-------
 iptables/xshared.h   |  2 +-
 iptables/xtables.c   | 27 +++++++++++++++++++++++++--
 5 files changed, 96 insertions(+), 16 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 2731209..c0f481f 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -103,6 +103,7 @@ static struct option original_opts[] = {
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
 	{.name = "wait",          .has_arg = 2, .val = 'w'},
+	{.name = "wait-ms",       .has_arg = 2, .val = 'W'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "help",          .has_arg = 2, .val = 'h'},
@@ -260,6 +261,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w [seconds]	wait for the xtables lock\n"
+"  --wait-ms	-W [seconds.milliseconds]\n"
+"				wait for the xtables lock\n"
+"				10ms is the minimum millisecond resolution\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
@@ -1324,7 +1328,7 @@ int do_command6(int argc, char *argv[], char **table,
 	struct in6_addr *smasks = NULL, *dmasks = NULL;
 
 	int verbose = 0;
-	int wait = 0;
+	double wait = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1360,7 +1364,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvw::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvwW::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1616,6 +1620,24 @@ int do_command6(int argc, char *argv[], char **table,
 						"wait seconds not numeric");
 			break;
 
+		case 'W':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-W' from "
+					      "ip6tables-restore");
+			}
+			wait = -1;
+			if (optarg) {
+				if (sscanf(optarg, "%lf", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%lf", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
+			break;
+
 		case 'm':
 			command_match(&cs);
 			break;
@@ -1768,7 +1790,7 @@ int do_command6(int argc, char *argv[], char **table,
 		if (wait == 0)
 			fprintf(stderr, "Perhaps you want to use the -w option?\n");
 		else
-			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
+			fprintf(stderr, "Stopped waiting after %fs.\n", wait);
 		xtables_free_opts(1);
 		exit(RESOURCE_PROBLEM);
 	}
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 91617c2..4e0197b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -100,6 +100,7 @@ static struct option original_opts[] = {
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
 	{.name = "wait",          .has_arg = 2, .val = 'w'},
+	{.name = "wait-ms",       .has_arg = 2, .val = 'W'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "fragments",     .has_arg = 0, .val = 'f'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
@@ -254,6 +255,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w [seconds]	wait for the xtables lock\n"
+"  --wait-ms	-W [seconds.milliseconds]\n"
+"				wait for the xtables lock\n"
+"				10ms is the minimum millisecond resolution\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
@@ -1320,7 +1324,7 @@ int do_command4(int argc, char *argv[], char **table,
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
 
 	int verbose = 0;
-	int wait = 0;
+	double wait = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1355,7 +1359,7 @@ int do_command4(int argc, char *argv[], char **table,
 	opterr = 0;
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvw::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwW::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1609,6 +1613,24 @@ int do_command4(int argc, char *argv[], char **table,
 						"wait seconds not numeric");
 			break;
 
+		case 'W':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-W' from "
+					      "iptables-restore");
+			}
+			wait = -1;
+			if (optarg) {
+				if (sscanf(optarg, "%lf", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%lf", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
+			break;
+
 		case 'm':
 			command_match(&cs);
 			break;
@@ -1764,7 +1786,7 @@ int do_command4(int argc, char *argv[], char **table,
 		if (wait == 0)
 			fprintf(stderr, "Perhaps you want to use the -w option?\n");
 		else
-			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
+			fprintf(stderr, "Stopped waiting after %fs.\n", wait);
 		xtables_free_opts(1);
 		exit(RESOURCE_PROBLEM);
 	}
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 81c2581..2aeb8b8 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -15,6 +15,8 @@
 #include "xshared.h"
 
 #define XT_LOCK_NAME	"/run/xtables.lock"
+#define BASE_MICROSECOND_WAIT	10000
+#define WAIT_PRECISION	100
 
 /*
  * Print out any special helps. A user might like to be able to add a --help
@@ -244,9 +246,11 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-bool xtables_lock(int wait)
+bool xtables_lock(double wait)
 {
-	int fd, waited = 0, i = 0;
+	int fd, waited = 0, i = 0, us_wait = 0, us_waited = 0;
+
+	us_wait = (((int)(wait*WAIT_PRECISION))%WAIT_PRECISION)*BASE_MICROSECOND_WAIT;
 
 	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
 	if (fd < 0)
@@ -255,12 +259,21 @@ bool xtables_lock(int wait)
 	while (1) {
 		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
 			return true;
-		else if (wait >= 0 && waited >= wait)
+		else if (wait >= 0 && waited >= (int)wait && us_waited >= us_wait)
 			return false;
-		if (++i % 2 == 0)
+		if ((++i % 2 == 0 && !us_wait) || (++i % 10 == 0))
 			fprintf(stderr, "Another app is currently holding the xtables lock; "
-				"waiting (%ds) for it to exit...\n", waited);
-		waited++;
-		sleep(1);
+				"waiting (%ds %dms) for it to exit...\n", waited, us_waited/1000);
+		if (us_wait) {
+			us_waited += BASE_MICROSECOND_WAIT;
+			usleep(BASE_MICROSECOND_WAIT);
+			if (us_waited == 1000000) {
+				waited++;
+				us_waited = 0;
+			}
+		} else {
+			waited++;
+			sleep(1);
+		}
 	}
 }
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 40dd915..de4ae99 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -85,7 +85,7 @@ extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
-extern bool xtables_lock(int wait);
+extern bool xtables_lock(double wait);
 
 extern const struct xtables_afinfo *afinfo;
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index ecd577c..445b140 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -86,6 +86,7 @@ static struct option original_opts[] = {
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",	  .has_arg = 0, .val = 'v'},
 	{.name = "wait",	  .has_arg = 2, .val = 'w'},
+	{.name = "wait-ms",	  .has_arg = 2, .val = 'W'},
 	{.name = "exact",	  .has_arg = 0, .val = 'x'},
 	{.name = "fragments",	  .has_arg = 0, .val = 'f'},
 	{.name = "version",	  .has_arg = 0, .val = 'V'},
@@ -239,6 +240,11 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
+"  --wait	-w [seconds]	wait for the xtables lock\n"
+"  --wait-ms	-W [seconds.milliseconds]\n"
+"				wait for the xtables lock\n"
+"				10ms is the minimum millisecond resolution\n"
+
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
@@ -686,7 +692,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
-	int wait = 0;
+	double wait = 0;
 
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
+				if (sscanf(optarg, "%lf", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						      "wait seconds not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+				   && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%lf", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						      "wait seconds not numeric");
+			break;
+
 		case '0':
 			set_option(&cs->options, OPT_LINENUMBERS,
 				   &args->invflags, cs->invert);
-- 
1.8.2.1

