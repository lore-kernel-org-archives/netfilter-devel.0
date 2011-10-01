From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] ip6tables-save: Allow chain selection
Date: Sat,  1 Oct 2011 17:19:30 +0200
Message-ID: <1317482370-14982-3-git-send-email-richard@nod.at>
References: <1317482370-14982-1-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:33113 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1JAPTh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:19:37 -0400
In-Reply-To: <1317482370-14982-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows an user to select the chain he wants to save.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 iptables/ip6tables-save.8 |    4 ++
 iptables/ip6tables-save.c |   75 +++++++++++++++++++++++++++-----------------
 2 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/iptables/ip6tables-save.8 b/iptables/ip6tables-save.8
index 457be82..420b10d 100644
--- a/iptables/ip6tables-save.8
+++ b/iptables/ip6tables-save.8
@@ -39,6 +39,10 @@ include the current values of all packet and byte counters in the output
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-C\fR, \fB\-\-chain\fR \fIchainname\fP
+restrict output to only one chain. If not specified, output includes all
+available chains.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..1bc21c1 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -23,11 +23,13 @@
 #endif
 
 static int show_counters = 0;
+static char *selected_chain;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
+	{.name = "chain",    .has_arg = true,  .val = 'C'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
 	{NULL},
 };
@@ -57,6 +59,30 @@ static int for_each_table(int (*func)(const char *tablename))
 	return ret;
 }
 
+static void print_chain(const char *chain, struct xtc_handle *h)
+{
+	printf(":%s ", chain);
+	if (ip6tc_builtin(chain, h)) {
+		struct xt_counters count;
+		printf("%s ",
+		       ip6tc_get_policy(chain, &count, h));
+		printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+	} else {
+		printf("- [0:0]\n");
+	}
+}
+
+static void print_chain_rules(const char *chain, struct xtc_handle *h)
+{
+	const struct ip6t_entry *e;
+
+	/* Dump out rules */
+	e = ip6tc_first_rule(chain, h);
+	while(e) {
+		print_rule6(e, h, chain, show_counters);
+		e = ip6tc_next_rule(e, h);
+	}
+}
 
 static int do_output(const char *tablename)
 {
@@ -81,34 +107,21 @@ static int do_output(const char *tablename)
 	       IPTABLES_VERSION, ctime(&now));
 	printf("*%s\n", tablename);
 
-	/* Dump out chain names first,
-	 * thereby preventing dependency conflicts */
-	for (chain = ip6tc_first_chain(h);
-	     chain;
-	     chain = ip6tc_next_chain(h)) {
-
-		printf(":%s ", chain);
-		if (ip6tc_builtin(chain, h)) {
-			struct xt_counters count;
-			printf("%s ",
-			       ip6tc_get_policy(chain, &count, h));
-			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
-		} else {
-			printf("- [0:0]\n");
-		}
-	}
-
-	for (chain = ip6tc_first_chain(h);
-	     chain;
-	     chain = ip6tc_next_chain(h)) {
-		const struct ip6t_entry *e;
-
-		/* Dump out rules */
-		e = ip6tc_first_rule(chain, h);
-		while(e) {
-			print_rule6(e, h, chain, show_counters);
-			e = ip6tc_next_rule(e, h);
-		}
+	if (selected_chain) {
+		print_chain(selected_chain, h);
+		print_chain_rules(selected_chain, h);
+	} else {
+		/* Dump out chain names first,
+		 * thereby preventing dependency conflicts */
+		for (chain = ip6tc_first_chain(h);
+			chain;
+			chain = ip6tc_next_chain(h))
+			print_chain(chain, h);
+
+		for (chain = ip6tc_first_chain(h);
+			chain;
+			chain = ip6tc_next_chain(h))
+			print_chain_rules(chain, h);
 	}
 
 	now = time(NULL);
@@ -141,7 +154,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:C:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -151,6 +164,10 @@ int ip6tables_save_main(int argc, char *argv[])
 			/* Select specific table. */
 			tablename = optarg;
 			break;
+		case 'C':
+			/* Select specific chain. */
+			selected_chain = optarg;
+			break;
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
-- 
1.7.6.4

