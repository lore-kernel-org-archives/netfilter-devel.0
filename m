From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] iptables-save: Allow chain selection
Date: Sat,  1 Oct 2011 17:19:29 +0200
Message-ID: <1317482370-14982-2-git-send-email-richard@nod.at>
References: <1317482370-14982-1-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:33112 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1JAPTh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:19:37 -0400
In-Reply-To: <1317482370-14982-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows an user to select the chain he wants to save.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 iptables/iptables-save.8 |    4 ++
 iptables/iptables-save.c |   76 ++++++++++++++++++++++++++++-----------------
 2 files changed, 51 insertions(+), 29 deletions(-)

diff --git a/iptables/iptables-save.8 b/iptables/iptables-save.8
index c2e0a94..f7140d1 100644
--- a/iptables/iptables-save.8
+++ b/iptables/iptables-save.8
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
 .SH AUTHOR
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..7aea08f 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -22,11 +22,13 @@
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
@@ -55,6 +57,30 @@ static int for_each_table(int (*func)(const char *tablename))
 	return ret;
 }
 
+static void print_chain(const char *chain, struct iptc_handle *h)
+{
+	printf(":%s ", chain);
+	if (iptc_builtin(chain, h)) {
+		struct xt_counters count;
+		printf("%s ",
+		       iptc_get_policy(chain, &count, h));
+		printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+	} else {
+		printf("- [0:0]\n");
+	}
+}
+
+static void print_chain_rules(const char *chain, struct iptc_handle *h)
+{
+	const struct ipt_entry *e;
+
+	/* Dump out rules */
+	e = iptc_first_rule(chain, h);
+	while(e) {
+		print_rule4(e, h, chain, show_counters);
+		e = iptc_next_rule(e, h);
+	}
+}
 
 static int do_output(const char *tablename)
 {
@@ -79,34 +105,22 @@ static int do_output(const char *tablename)
 	       IPTABLES_VERSION, ctime(&now));
 	printf("*%s\n", tablename);
 
-	/* Dump out chain names first,
-	 * thereby preventing dependency conflicts */
-	for (chain = iptc_first_chain(h);
-	     chain;
-	     chain = iptc_next_chain(h)) {
-
-		printf(":%s ", chain);
-		if (iptc_builtin(chain, h)) {
-			struct xt_counters count;
-			printf("%s ",
-			       iptc_get_policy(chain, &count, h));
-			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
-		} else {
-			printf("- [0:0]\n");
-		}
-	}
-
-	for (chain = iptc_first_chain(h);
-	     chain;
-	     chain = iptc_next_chain(h)) {
-		const struct ipt_entry *e;
-
-		/* Dump out rules */
-		e = iptc_first_rule(chain, h);
-		while(e) {
-			print_rule4(e, h, chain, show_counters);
-			e = iptc_next_rule(e, h);
-		}
+	if (selected_chain) {
+		print_chain(selected_chain, h);
+		print_chain_rules(selected_chain, h);
+	} else {
+		/* Dump out chain names first,
+		 * thereby preventing dependency conflicts */
+		for (chain = iptc_first_chain(h);
+			chain;
+			chain = iptc_next_chain(h))
+			print_chain(chain, h);
+
+
+		for (chain = iptc_first_chain(h);
+			chain;
+			chain = iptc_next_chain(h))
+			print_chain_rules(chain, h);
 	}
 
 	now = time(NULL);
@@ -140,7 +154,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:C:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -150,6 +164,10 @@ iptables_save_main(int argc, char *argv[])
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

