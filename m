From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/10] libxt_cpu: use guided option parser
Date: Wed,  6 Apr 2011 13:31:15 +0200
Message-ID: <1302089478-15022-9-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46504 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab1DFLb3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:29 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_cpu.c |   65 ++++++++++++------------------------------------
 1 files changed, 16 insertions(+), 49 deletions(-)

diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index 77efec7..404a6a6 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -1,13 +1,11 @@
-/* Shared library add-on to iptables to add CPU match support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_cpu.h>
 
+enum {
+	O_CPU = 0,
+};
+
 static void cpu_help(void)
 {
 	printf(
@@ -15,50 +13,20 @@ static void cpu_help(void)
 "[!] --cpu number   Match CPU number\n");
 }
 
-static const struct option cpu_opts[] = {
-	{.name = "cpu", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry cpu_opts[] = {
+	{.name = "cpu", .id = O_CPU, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_MAND | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_cpu_info, cpu)},
+	XTOPT_TABLEEND,
 };
 
-static void
-parse_cpu(const char *s, struct xt_cpu_info *info)
+static void cpu_parse(struct xt_option_call *cb)
 {
-	unsigned int cpu;
-	char *end;
-
-	if (!xtables_strtoui(s, &end, &cpu, 0, UINT32_MAX))
-		xtables_param_act(XTF_BAD_VALUE, "cpu", "--cpu", s);
-
-	if (*end != '\0')
-		xtables_param_act(XTF_BAD_VALUE, "cpu", "--cpu", s);
-
-	info->cpu = cpu;
-}
+	struct xt_cpu_info *cpuinfo = cb->data;
 
-static int
-cpu_parse(int c, char **argv, int invert, unsigned int *flags,
-          const void *entry, struct xt_entry_match **match)
-{
-	struct xt_cpu_info *cpuinfo = (struct xt_cpu_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_cpu(optarg, cpuinfo);
-		if (invert)
-			cpuinfo->invert = 1;
-		*flags = 1;
-		break;
-	}
-
-	return 1;
-}
-
-static void cpu_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			      "You must specify `--cpu'");
+	xtables_option_parse(cb);
+	if (cb->invert)
+		cpuinfo->invert = true;
 }
 
 static void
@@ -83,11 +51,10 @@ static struct xtables_match cpu_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_cpu_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_cpu_info)),
 	.help		= cpu_help,
-	.parse		= cpu_parse,
-	.final_check	= cpu_check,
 	.print		= cpu_print,
 	.save		= cpu_save,
-	.extra_opts	= cpu_opts,
+	.x6_parse	= cpu_parse,
+	.x6_options	= cpu_opts,
 };
 
 void _init(void)
-- 
1.7.1

