From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] iptables: add optional [seconds] argument to -w
Date: Thu, 22 May 2014 19:09:31 +0200
Message-ID: <1400778571-1482-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaEVRJj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 13:09:39 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4MH9dvS001237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2014 13:09:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds an optional numeric argument
to -w option which can be used to specify
how long to wait for an exclusive lock.

If the value isn't specified it works as before,
i.e. program waits indefinitely.

If user specifies it, program exits after
the given time interval passes.

Signed-off-by: Jiri Popelka <jpopelka@redhat.com>
---
 iptables/ip6tables.c   | 24 ++++++++++++++++++------
 iptables/iptables.8.in |  5 +++--
 iptables/iptables.c    | 25 ++++++++++++++++++-------
 iptables/xshared.c     |  8 +++++---
 iptables/xshared.h     |  2 +-
 5 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 2ebfd6c..154ba64 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -102,7 +102,7 @@ static struct option original_opts[] = {
 	{.name = "numeric",       .has_arg = 0, .val = 'n'},
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
-	{.name = "wait",          .has_arg = 0, .val = 'w'},
+	{.name = "wait",          .has_arg = 2, .val = 'w'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "help",          .has_arg = 2, .val = 'h'},
@@ -259,7 +259,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
-"  --wait	-w		wait for the xtables lock\n"
+"  --wait	-w [seconds]	wait for the xtables lock\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
@@ -1323,7 +1323,7 @@ int do_command6(int argc, char *argv[], char **table,
 	struct in6_addr *smasks = NULL, *dmasks = NULL;
 
 	int verbose = 0;
-	bool wait = false;
+	int wait = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1603,7 +1603,16 @@ int do_command6(int argc, char *argv[], char **table,
 					      "You cannot use `-w' from "
 					      "ip6tables-restore");
 			}
-			wait = true;
+			wait = -1;
+			if (optarg) {
+				if (sscanf(optarg, "%i", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%i", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
 			break;
 
 		case 'm':
@@ -1754,8 +1763,11 @@ int do_command6(int argc, char *argv[], char **table,
 
 	/* Attempt to acquire the xtables lock */
 	if (!restore && !xtables_lock(wait)) {
-		fprintf(stderr, "Another app is currently holding the xtables lock. "
-			"Perhaps you want to use the -w option?\n");
+		fprintf(stderr, "Another app is currently holding the xtables lock. ");
+		if (wait == 0)
+			fprintf(stderr, "Perhaps you want to use the -w option?\n");
+		else
+			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
 		xtables_free_opts(1);
 		exit(RESOURCE_PROBLEM);
 	}
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 8ef222e..ceba5dc 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -359,12 +359,13 @@ For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed. \fB\-v\fP may be
 specified multiple times to possibly emit more detailed debug statements.
 .TP
-\fB\-w\fP, \fB\-\-wait\fP
+\fB\-w\fP, \fB\-\-wait\fP [\fIseconds\fP]
 Wait for the xtables lock.
 To prevent multiple instances of the program from running concurrently,
 an attempt will be made to obtain an exclusive lock at launch.  By default,
 the program will exit if the lock cannot be obtained.  This option will
-make the program wait until the exclusive lock can be obtained.
+make the program wait (indefinitely or for optional \fIseconds\fP) until
+the exclusive lock can be obtained.
 .TP
 \fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 471bff0..93f892a 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -99,7 +99,7 @@ static struct option original_opts[] = {
 	{.name = "numeric",       .has_arg = 0, .val = 'n'},
 	{.name = "out-interface", .has_arg = 1, .val = 'o'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
-	{.name = "wait",          .has_arg = 0, .val = 'w'},
+	{.name = "wait",          .has_arg = 2, .val = 'w'},
 	{.name = "exact",         .has_arg = 0, .val = 'x'},
 	{.name = "fragments",     .has_arg = 0, .val = 'f'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
@@ -253,7 +253,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
-"  --wait	-w		wait for the xtables lock\n"
+"  --wait	-w [seconds]	wait for the xtables lock\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
@@ -1319,7 +1319,7 @@ int do_command4(int argc, char *argv[], char **table,
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
 
 	int verbose = 0;
-	bool wait = false;
+	int wait = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1352,7 +1352,6 @@ int do_command4(int argc, char *argv[], char **table,
 	/* Suppress error messages: we may add new options if we
            demand-load a protocol. */
 	opterr = 0;
-
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
 	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwnt:m:xc:g:46",
@@ -1597,7 +1596,16 @@ int do_command4(int argc, char *argv[], char **table,
 					      "You cannot use `-w' from "
 					      "iptables-restore");
 			}
-			wait = true;
+			wait = -1;
+			if (optarg) {
+				if (sscanf(optarg, "%i", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+						 && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%i", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						"wait seconds not numeric");
 			break;
 
 		case 'm':
@@ -1751,8 +1759,11 @@ int do_command4(int argc, char *argv[], char **table,
 
 	/* Attempt to acquire the xtables lock */
 	if (!restore && !xtables_lock(wait)) {
-		fprintf(stderr, "Another app is currently holding the xtables lock. "
-			"Perhaps you want to use the -w option?\n");
+		fprintf(stderr, "Another app is currently holding the xtables lock. ");
+		if (wait == 0)
+			fprintf(stderr, "Perhaps you want to use the -w option?\n");
+		else
+			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
 		xtables_free_opts(1);
 		exit(RESOURCE_PROBLEM);
 	}
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 6c9992e..b18022e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -243,10 +243,11 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-bool xtables_lock(bool wait)
+bool xtables_lock(int wait)
 {
 	int i = 0, ret, xt_socket;
 	struct sockaddr_un xt_addr;
+	int waited = 0;
 
 	memset(&xt_addr, 0, sizeof(xt_addr));
 	xt_addr.sun_family = AF_UNIX;
@@ -261,11 +262,12 @@ bool xtables_lock(bool wait)
 			   offsetof(struct sockaddr_un, sun_path)+XT_SOCKET_LEN);
 		if (ret == 0)
 			return true;
-		else if (wait == false)
+		else if (wait >= 0 && waited >= wait)
 			return false;
 		if (++i % 2 == 0)
 			fprintf(stderr, "Another app is currently holding the xtables lock; "
-				"waiting for it to exit...\n");
+				"waiting (%ds) for it to exit...\n", waited);
+		waited++;
 		sleep(1);
 	}
 }
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 27c5b78..40dd915 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -85,7 +85,7 @@ extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
-extern bool xtables_lock(bool wait);
+extern bool xtables_lock(int wait);
 
 extern const struct xtables_afinfo *afinfo;
 
-- 
1.9.0

