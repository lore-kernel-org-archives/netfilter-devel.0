From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 26/28] libxt_state: use guided option parser
Date: Tue, 12 Apr 2011 16:23:41 +0200
Message-ID: <1302618224-9449-27-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54695 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab1DLOYO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:14 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_state.c |   50 ++++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 9a631aa..3fc747d 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -1,10 +1,5 @@
-/* Shared library add-on to iptables to add state tracking support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/xt_state.h>
@@ -13,6 +8,10 @@
 #define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
 #endif
 
+enum {
+	O_STATE = 0,
+};
+
 static void
 state_help(void)
 {
@@ -22,9 +21,10 @@ state_help(void)
 "				State(s) to match\n");
 }
 
-static const struct option state_opts[] = {
-	{.name = "state", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry state_opts[] = {
+	{.name = "state", .id = O_STATE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
 };
 
 static int
@@ -63,31 +63,14 @@ state_parse_states(const char *arg, struct xt_state_info *sinfo)
 		xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
 }
 
-static int
-state_parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static void state_parse(struct xt_option_call *cb)
 {
-	struct xt_state_info *sinfo = (struct xt_state_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		state_parse_states(optarg, sinfo);
-		if (invert)
-			sinfo->statemask = ~sinfo->statemask;
-		*flags = 1;
-		break;
-	}
+	struct xt_state_info *sinfo = cb->data;
 
-	return 1;
-}
-
-static void state_final_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM, "You must specify \"--state\"");
+	xtables_option_parse(cb);
+	state_parse_states(cb->arg, sinfo);
+	if (cb->invert)
+		sinfo->statemask = ~sinfo->statemask;
 }
 
 static void state_print_state(unsigned int statemask)
@@ -142,11 +125,10 @@ static struct xtables_match state_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
 	.help		= state_help,
-	.parse		= state_parse,
-	.final_check	= state_final_check,
 	.print		= state_print,
 	.save		= state_save,
-	.extra_opts	= state_opts,
+	.x6_parse	= state_parse,
+	.x6_options	= state_opts,
 };
 
 void _init(void)
-- 
1.7.1

