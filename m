From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] xtables: Add an interval option for xtables lock wait
Date: Fri, 1 Jul 2016 15:29:01 +0200
Message-ID: <20160701132216.GA3252@salvia>
References: <1466729046-3070-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tjCHc7DPkfUGtrlw"
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52567 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbcGAN3M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 09:29:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5E4541B1DF0
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:29:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 40AECFAB4E
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:29:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B5892FAB53
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:29:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466729046-3070-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Subash,

On Thu, Jun 23, 2016 at 06:44:06PM -0600, Subash Abhinov Kasiviswanathan wrote:
> ip[6]tables currently waits for 1 second for the xtables lock to be
> freed if the -w option is used. We have seen that the lock is held
> much less than that resulting in unnecessary delay when trying to
> acquire the lock. This problem is even severe in case of latency
> sensitive applications.
> 
> Introduce a new option 'W' to specify the wait interval in decimal
> format [seconds.microseconds]. If this option is not specified,
> the command sleeps for 1 second by default.

I'm attaching a patch that applies on top of this.

That I can remember, you only needed to reduce the wait interval, not
to make it ever larger, so I'm simplifying this so -W only takes
microseconds.

I have only included some missing error check in case -W is specified
but -w is not.

I can collapse this patch to yours, unless you have any concern.

--tjCHc7DPkfUGtrlw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iptables-revisit-new-W-option.patch"

>From 4644aaabdffaafc488c80b7b81b6be45a297e9e9 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 1 Jul 2016 12:11:59 +0200
Subject: [PATCH] iptables: revisit new -W option

* Simplify -W so it only takes the interval wait in microseconds.
* Bail out if -W is specific but -w is not.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/ip6tables.c | 35 +++++++++++++++++++-------------
 iptables/iptables.c  | 37 +++++++++++++++++++---------------
 iptables/xshared.c   | 57 +++++++++++++++++++++++++++++++++++++---------------
 iptables/xshared.h   |  4 +++-
 iptables/xtables.c   | 32 ++++++++++++++++-------------
 5 files changed, 104 insertions(+), 61 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 9629403..66df8e9 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -260,8 +260,8 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
-"  --wait	-w [seconds]	wait for the xtables lock\n"
-"  --wait-interval	-W [seconds.microseconds]\n"
+"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
+"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
 "				interval to wait for xtables lock\n"
 "				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
@@ -1329,7 +1329,10 @@ int do_command6(int argc, char *argv[], char **table,
 
 	int verbose = 0;
 	int wait = 0;
-	double wait_interval = 1;
+	struct timeval wait_interval = {
+		.tv_sec	= 1,
+	};
+	bool wait_interval_set = false;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1365,7 +1368,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvwW::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvw::W::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1627,15 +1630,15 @@ int do_command6(int argc, char *argv[], char **table,
 					      "You cannot use `-W' from "
 					      "ip6tables-restore");
 			}
-			if (optarg) {
-				if (sscanf(optarg, "%lf", &wait_interval) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait interval not numeric");
-			} else if (optind < argc && argv[optind][0] != '-'
-						 && argv[optind][0] != '!')
-				if (sscanf(argv[optind++], "%lf", &wait_interval) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait interval not numeric");
+			if (optarg)
+				parse_wait_interval(optarg, &wait_interval);
+			else if (optind < argc &&
+				argv[optind][0] != '-' &&
+				argv[optind][0] != '!')
+				parse_wait_interval(argv[optind++],
+						    &wait_interval);
+
+			wait_interval_set = true;
 			break;
 
 		case 'm':
@@ -1742,6 +1745,10 @@ int do_command6(int argc, char *argv[], char **table,
 		cs.invert = FALSE;
 	}
 
+	if (!wait && wait_interval_set)
+		xtables_error(PARAMETER_PROBLEM,
+			      "--wait-interval only makes sense with --wait\n");
+
 	if (strcmp(*table, "nat") == 0 &&
 	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
 	    (cs.jumpto != NULL && strcmp(cs.jumpto, "DROP") == 0)))
@@ -1792,7 +1799,7 @@ int do_command6(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && !xtables_lock(wait, wait_interval)) {
+	if (!restore && !xtables_lock(wait, &wait_interval)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. ");
 		if (wait == 0)
 			fprintf(stderr, "Perhaps you want to use the -w option?\n");
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 1b26d61..540d111 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -254,9 +254,8 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
-"  --wait	-w [seconds]	wait for the xtables lock\n"
-"  --wait-interval	-W [seconds.microseconds]\n"
-"				interval to wait for xtables lock\n"
+"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
+"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
 "				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
@@ -1322,10 +1321,12 @@ int do_command4(int argc, char *argv[], char **table,
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *smasks = NULL;
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
-
+	struct timeval wait_interval = {
+		.tv_sec = 1,
+	};
+	bool wait_interval_set = false;
 	int verbose = 0;
 	int wait = 0;
-	double wait_interval = 1;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1360,7 +1361,7 @@ int do_command4(int argc, char *argv[], char **table,
 	opterr = 0;
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwW::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvw::W::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
@@ -1620,15 +1621,15 @@ int do_command4(int argc, char *argv[], char **table,
 					      "You cannot use `-W' from "
 					      "iptables-restore");
 			}
-			if (optarg) {
-				if (sscanf(optarg, "%lf", &wait_interval) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait interval not numeric");
-			} else if (optind < argc && argv[optind][0] != '-'
-						 && argv[optind][0] != '!')
-				if (sscanf(argv[optind++], "%lf", &wait_interval) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait interval not numeric");
+			if (optarg)
+				parse_wait_interval(optarg, &wait_interval);
+			else if (optind < argc &&
+				 argv[optind][0] != '-' &&
+				 argv[optind][0] != '!')
+				parse_wait_interval(argv[optind++],
+						    &wait_interval);
+
+			wait_interval_set = true;
 			break;
 
 		case 'm':
@@ -1731,6 +1732,10 @@ int do_command4(int argc, char *argv[], char **table,
 		cs.invert = FALSE;
 	}
 
+	if (!wait && wait_interval_set)
+		xtables_error(PARAMETER_PROBLEM,
+			      "--wait-interval only makes sense with --wait\n");
+
 	if (strcmp(*table, "nat") == 0 &&
 	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
 	    (cs.jumpto != NULL && strcmp(cs.jumpto, "DROP") == 0)))
@@ -1781,7 +1786,7 @@ int do_command4(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && !xtables_lock(wait, wait_interval)) {
+	if (!restore && !xtables_lock(wait, &wait_interval)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. ");
 		if (wait == 0)
 			fprintf(stderr, "Perhaps you want to use the -w option?\n");
diff --git a/iptables/xshared.c b/iptables/xshared.c
index d810c98..cccb8ae 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -247,15 +247,13 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-bool xtables_lock(int wait, double wait_interval)
+bool xtables_lock(int wait, struct timeval *wait_interval)
 {
+	struct timeval time_left, wait_time, waited_time;
 	int fd, i = 0;
-	double wait_int, wait_fract;
-	struct timeval total_time, wait_time, waited_time;
 
-	wait_fract = modf(wait_interval, &wait_int);
-	total_time.tv_sec = wait;
-	total_time.tv_usec = 0;
+	time_left.tv_sec = wait;
+	time_left.tv_usec = 0;
 	waited_time.tv_sec = 0;
 	waited_time.tv_usec = 0;
 
@@ -266,16 +264,43 @@ bool xtables_lock(int wait, double wait_interval)
 	while (1) {
 		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
 			return true;
-		if (++i % 10 == 0)
-			fprintf(stderr, "Another app is currently holding the xtables lock; "
-				"waiting (%lds %ldus) for it to exit...\n", waited_time.tv_sec, waited_time.tv_usec);
-		wait_time.tv_sec = wait_int;
-		wait_time.tv_usec = wait_fract*BASE_MICROSECONDS;
-		if (wait != -1)
-			timersub(&total_time, &wait_time, &total_time);
-		timeradd(&waited_time, &wait_time, &waited_time);
-		if (!timerisset(&total_time))
-			return false;
+		if (++i % 10 == 0) {
+			if (wait != -1)
+				fprintf(stderr, "Another app is currently holding the xtables lock; "
+					"still %lds %ldus time ahead to have a chance to grab the lock...\n",
+					time_left.tv_sec, time_left.tv_usec);
+			else
+				fprintf(stderr, "Another app is currently holding the xtables lock; "
+						"waiting for it to exit...\n");
+		}
+
+		wait_time = *wait_interval;
 		select(0, NULL, NULL, NULL, &wait_time);
+		if (wait == -1)
+			continue;
+
+		timeradd(&waited_time, wait_interval, &waited_time);
+		timersub(&time_left, wait_interval, &time_left);
+		if (!timerisset(&time_left))
+			return false;
+	}
+}
+
+void parse_wait_interval(const char *str, struct timeval *wait_interval)
+{
+	unsigned int usec;
+	int ret;
+
+	ret = sscanf(str, "%u", &usec);
+	if (ret == 1) {
+		if (usec > 999999)
+			xtables_error(PARAMETER_PROBLEM,
+				      "too long usec wait %u > 999999 usec",
+				      usec);
+
+		wait_interval->tv_sec = 0;
+		wait_interval->tv_usec = usec;
+		return;
 	}
+	xtables_error(PARAMETER_PROBLEM, "wait interval not numeric");
 }
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 964cd4c..6eb8eb8 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -85,7 +85,9 @@ extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
-bool xtables_lock(int wait, double wait_interval);
+bool xtables_lock(int wait, struct timeval *wait_interval);
+
+void parse_wait_interval(const char *str, struct timeval *wait_interval);
 
 extern const struct xtables_afinfo *afinfo;
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 84f9efd..15a84a6 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -240,9 +240,8 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
-"  --wait	-w [seconds]	wait for the xtables lock\n"
-"  --wait-interval	-W [seconds.microseconds]\n"
-"				interval to wait for xtables lock\n"
+"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
+"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
 "				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
@@ -690,9 +689,10 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 {
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
+	bool wait_interval_set = false;
+	struct timeval wait_interval;
 	struct xtables_target *t;
 	int wait = 0;
-	double wait_interval = 1;
 
 	memset(cs, 0, sizeof(*cs));
 	cs->jumpto = "";
@@ -722,7 +722,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 	opts = xt_params->orig_opts;
 	while ((cs->c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwW::nt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvw::W::nt:m:xc:g:46",
 					   opts, NULL)) != -1) {
 		switch (cs->c) {
 			/*
@@ -1032,15 +1032,15 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					      "You cannot use `-W' from "
 					      "iptables-restore");
 			}
-			if (optarg) {
-				if (sscanf(optarg, "%lf", &wait_interval) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait interval not numeric");
-			} else if (optind < argc && argv[optind][0] != '-'
-						 && argv[optind][0] != '!')
-				if (sscanf(argv[optind++], "%lf", &wait_interval) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait interval not numeric");
+			if (optarg)
+				parse_wait_interval(optarg, &wait_interval);
+			else if (optind < argc &&
+				   argv[optind][0] != '-' &&
+				   argv[optind][0] != '!')
+				parse_wait_interval(argv[optind++],
+						    &wait_interval);
+
+			wait_interval_set = true;
 			break;
 
 		case '0':
@@ -1125,6 +1125,10 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			"\nThe \"nat\" table is not intended for filtering, "
 			"the use of DROP is therefore inhibited.\n\n");
 
+	if (!wait && wait_interval_set)
+		xtables_error(PARAMETER_PROBLEM,
+			      "--wait-interval only makes sense with --wait\n");
+
 	for (matchp = cs->matches; matchp; matchp = matchp->next)
 		xtables_option_mfcall(matchp->match);
 	if (cs->target != NULL)
-- 
2.1.4


--tjCHc7DPkfUGtrlw--
