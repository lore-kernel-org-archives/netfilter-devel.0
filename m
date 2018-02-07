From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/7] netfilter: x_tables: rate limit pr_err warnings
Date: Wed,  7 Feb 2018 14:48:25 +0100
Message-ID: <20180207134828.18691-5-fw@strlen.de>
References: <20180207134828.18691-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754308AbeBGNt6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 08:49:58 -0500
In-Reply-To: <20180207134828.18691-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 70 +++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 2f685ee1f9c8..0f81294dea7b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -434,36 +434,35 @@ int xt_check_match(struct xt_mtchk_param *par,
 		 * ebt_among is exempt from centralized matchsize checking
 		 * because it uses a dynamic-size data set.
 		 */
-		pr_err("%s_tables: %s.%u match: invalid size "
-		       "%u (kernel) != (user) %u\n",
-		       xt_prefix[par->family], par->match->name,
-		       par->match->revision,
-		       XT_ALIGN(par->match->matchsize), size);
+		pr_err_ratelimited("%s_tables: %s.%u match: invalid size %u (kernel) != (user) %u\n",
+				   xt_prefix[par->family], par->match->name,
+				   par->match->revision,
+				   XT_ALIGN(par->match->matchsize), size);
 		return -EINVAL;
 	}
 	if (par->match->table != NULL &&
 	    strcmp(par->match->table, par->table) != 0) {
-		pr_err("%s_tables: %s match: only valid in %s table, not %s\n",
-		       xt_prefix[par->family], par->match->name,
-		       par->match->table, par->table);
+		pr_err_ratelimited("%s_tables: %s match: only valid in %s table, not %s\n",
+				   xt_prefix[par->family], par->match->name,
+				   par->match->table, par->table);
 		return -EINVAL;
 	}
 	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
 		char used[64], allow[64];
 
-		pr_err("%s_tables: %s match: used from hooks %s, but only "
-		       "valid from %s\n",
-		       xt_prefix[par->family], par->match->name,
-		       textify_hooks(used, sizeof(used), par->hook_mask,
-		                     par->family),
-		       textify_hooks(allow, sizeof(allow), par->match->hooks,
-		                     par->family));
+		pr_err_ratelimited("%s_tables: %s match: used from hooks %s, but only valid from %s\n",
+				   xt_prefix[par->family], par->match->name,
+				   textify_hooks(used, sizeof(used),
+						 par->hook_mask, par->family),
+				   textify_hooks(allow, sizeof(allow),
+						 par->match->hooks,
+						 par->family));
 		return -EINVAL;
 	}
 	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
-		pr_err("%s_tables: %s match: only valid for protocol %u\n",
-		       xt_prefix[par->family], par->match->name,
-		       par->match->proto);
+		pr_err_ratelimited("%s_tables: %s match: only valid for protocol %u\n",
+				   xt_prefix[par->family], par->match->name,
+				   par->match->proto);
 		return -EINVAL;
 	}
 	if (par->match->checkentry != NULL) {
@@ -814,36 +813,35 @@ int xt_check_target(struct xt_tgchk_param *par,
 	int ret;
 
 	if (XT_ALIGN(par->target->targetsize) != size) {
-		pr_err("%s_tables: %s.%u target: invalid size "
-		       "%u (kernel) != (user) %u\n",
-		       xt_prefix[par->family], par->target->name,
-		       par->target->revision,
-		       XT_ALIGN(par->target->targetsize), size);
+		pr_err_ratelimited("%s_tables: %s.%u target: invalid size %u (kernel) != (user) %u\n",
+				   xt_prefix[par->family], par->target->name,
+				   par->target->revision,
+				   XT_ALIGN(par->target->targetsize), size);
 		return -EINVAL;
 	}
 	if (par->target->table != NULL &&
 	    strcmp(par->target->table, par->table) != 0) {
-		pr_err("%s_tables: %s target: only valid in %s table, not %s\n",
-		       xt_prefix[par->family], par->target->name,
-		       par->target->table, par->table);
+		pr_err_ratelimited("%s_tables: %s target: only valid in %s table, not %s\n",
+				   xt_prefix[par->family], par->target->name,
+				   par->target->table, par->table);
 		return -EINVAL;
 	}
 	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
 		char used[64], allow[64];
 
-		pr_err("%s_tables: %s target: used from hooks %s, but only "
-		       "usable from %s\n",
-		       xt_prefix[par->family], par->target->name,
-		       textify_hooks(used, sizeof(used), par->hook_mask,
-		                     par->family),
-		       textify_hooks(allow, sizeof(allow), par->target->hooks,
-		                     par->family));
+		pr_err_ratelimited("%s_tables: %s target: used from hooks %s, but only usable from %s\n",
+				   xt_prefix[par->family], par->target->name,
+				   textify_hooks(used, sizeof(used),
+						 par->hook_mask, par->family),
+				   textify_hooks(allow, sizeof(allow),
+						 par->target->hooks,
+						 par->family));
 		return -EINVAL;
 	}
 	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
-		pr_err("%s_tables: %s target: only valid for protocol %u\n",
-		       xt_prefix[par->family], par->target->name,
-		       par->target->proto);
+		pr_err_ratelimited("%s_tables: %s target: only valid for protocol %u\n",
+				   xt_prefix[par->family], par->target->name,
+				   par->target->proto);
 		return -EINVAL;
 	}
 	if (par->target->checkentry != NULL) {
-- 
2.13.6

