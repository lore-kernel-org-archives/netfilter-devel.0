From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/28] libip[6]t_REJECT: use guided option parser
Date: Tue, 12 Apr 2011 16:23:24 +0200
Message-ID: <1302618224-9449-10-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54646 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1DLOX4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:56 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_REJECT.c |   48 ++++++++++++++++-------------------
 extensions/libipt_REJECT.c  |   58 +++++++++++++++++++-----------------------
 2 files changed, 48 insertions(+), 58 deletions(-)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index f906ab8..8085321 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -5,11 +5,8 @@
  * ported to IPv6 by Harald Welte <laforge@gnumonks.org>
  *
  */
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
@@ -20,6 +17,10 @@ struct reject_names {
 	const char *desc;
 };
 
+enum {
+	O_REJECT_WITH = 0,
+};
+
 static const struct reject_names reject_table[] = {
 	{"icmp6-no-route", "no-route",
 		IP6T_ICMP6_NO_ROUTE, "ICMPv6 no route"},
@@ -61,9 +62,9 @@ static void REJECT_help(void)
 	print_reject_types();
 }
 
-static const struct option REJECT_opts[] = {
-	{.name = "reject-with", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry REJECT_opts[] = {
+	{.name = "reject-with", .id = O_REJECT_WITH, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
 
 static void REJECT_init(struct xt_entry_target *t)
@@ -75,27 +76,22 @@ static void REJECT_init(struct xt_entry_target *t)
 
 }
 
-static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_target **target)
+static void REJECT_parse(struct xt_option_call *cb)
 {
-	struct ip6t_reject_info *reject = 
-		(struct ip6t_reject_info *)(*target)->data;
+	struct ip6t_reject_info *reject = cb->data;
 	unsigned int i;
 
-	switch(c) {
-	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --reject-with");
-		for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
-			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
-			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
-				reject->with = reject_table[i].with;
-				return 1;
-			}
-		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
-	}
-	return 0;
+	xtables_option_parse(cb);
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
+		if (strncasecmp(reject_table[i].name,
+		      cb->arg, strlen(cb->arg)) == 0 ||
+		    strncasecmp(reject_table[i].alias,
+		      cb->arg, strlen(cb->arg)) == 0) {
+			reject->with = reject_table[i].with;
+			return;
+		}
+	xtables_error(PARAMETER_PROBLEM,
+		"unknown reject type \"%s\"", cb->arg);
 }
 
 static void REJECT_print(const void *ip, const struct xt_entry_target *target,
@@ -132,10 +128,10 @@ static struct xtables_target reject_tg6_reg = {
 	.userspacesize 	= XT_ALIGN(sizeof(struct ip6t_reject_info)),
 	.help		= REJECT_help,
 	.init		= REJECT_init,
-	.parse		= REJECT_parse,
 	.print		= REJECT_print,
 	.save		= REJECT_save,
-	.extra_opts	= REJECT_opts,
+	.x6_parse	= REJECT_parse,
+	.x6_options	= REJECT_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 0ed58cb..362c65e 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -2,11 +2,8 @@
  *
  * (C) 2000 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
 #include <linux/version.h>
@@ -27,6 +24,10 @@ struct reject_names {
 	const char *desc;
 };
 
+enum {
+	O_REJECT_WITH = 0,
+};
+
 static const struct reject_names reject_table[] = {
 	{"icmp-net-unreachable", "net-unreach",
 		IPT_ICMP_NET_UNREACHABLE, "ICMP network unreachable"},
@@ -76,9 +77,9 @@ static void REJECT_help(void)
 	printf("(*) See man page or read the INCOMPATIBILITES file for compatibility issues.\n");
 }
 
-static const struct option REJECT_opts[] = {
-	{.name = "reject-with", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry REJECT_opts[] = {
+	{.name = "reject-with", .id = O_REJECT_WITH, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
 
 static void REJECT_init(struct xt_entry_target *t)
@@ -90,34 +91,27 @@ static void REJECT_init(struct xt_entry_target *t)
 
 }
 
-static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_target **target)
+static void REJECT_parse(struct xt_option_call *cb)
 {
-	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
-	static const unsigned int limit = ARRAY_SIZE(reject_table);
+	struct ipt_reject_info *reject = cb->data;
 	unsigned int i;
 
-	switch(c) {
-	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --reject-with");
-		for (i = 0; i < limit; i++) {
-			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
-			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
-				reject->with = reject_table[i].with;
-				return 1;
-			}
+	xtables_option_parse(cb);
+	for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
+		if (strncasecmp(reject_table[i].name,
+		      cb->arg, strlen(cb->arg)) == 0 ||
+		    strncasecmp(reject_table[i].alias,
+		      cb->arg, strlen(cb->arg)) == 0) {
+			reject->with = reject_table[i].with;
+			return;
 		}
-		/* This due to be dropped late in 2.4 pre-release cycle --RR */
-		if (strncasecmp("echo-reply", optarg, strlen(optarg)) == 0
-		    || strncasecmp("echoreply", optarg, strlen(optarg)) == 0)
-			fprintf(stderr, "--reject-with echo-reply no longer"
-				" supported\n");
-		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
-		break;
-	}
-	return 0;
+	/* This due to be dropped late in 2.4 pre-release cycle --RR */
+	if (strncasecmp("echo-reply", cb->arg, strlen(cb->arg)) == 0 ||
+	    strncasecmp("echoreply", cb->arg, strlen(cb->arg)) == 0)
+		fprintf(stderr, "--reject-with echo-reply no longer"
+			" supported\n");
+	xtables_error(PARAMETER_PROBLEM,
+		"unknown reject type \"%s\"", cb->arg);
 }
 
 static void REJECT_print(const void *ip, const struct xt_entry_target *target,
@@ -154,10 +148,10 @@ static struct xtables_target reject_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_reject_info)),
 	.help		= REJECT_help,
 	.init		= REJECT_init,
-	.parse		= REJECT_parse,
 	.print		= REJECT_print,
 	.save		= REJECT_save,
-	.extra_opts	= REJECT_opts,
+	.x6_parse	= REJECT_parse,
+	.x6_options	= REJECT_opts,
 };
 
 void _init(void)
-- 
1.7.1

