From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 5/9] netfilter: xt_set: use pr ratelimiting
Date: Fri,  9 Feb 2018 15:52:03 +0100
Message-ID: <20180209145207.2097-6-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46636 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbeBIOzf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:35 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also convert this to info for consistency.
These errors are informational message to user, given iptables doesn't
have netlink extack equivalent.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 patch is new in v2 (split away from different patch).
 net/netfilter/xt_set.c | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 16b6b11ee83f..6f4c5217d835 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -92,12 +92,12 @@ set_match_v0_checkentry(const struct xt_mtchk_param *par)
 	index = ip_set_nfnl_get_byindex(par->net, info->match_set.index);
 
 	if (index == IPSET_INVALID_ID) {
-		pr_warn("Cannot find set identified by id %u to match\n",
-			info->match_set.index);
+		pr_info_ratelimited("Cannot find set identified by id %u to match\n",
+				    info->match_set.index);
 		return -ENOENT;
 	}
 	if (info->match_set.u.flags[IPSET_DIM_MAX - 1] != 0) {
-		pr_warn("Protocol error: set match dimension is over the limit!\n");
+		pr_info_ratelimited("set match dimension is over the limit!\n");
 		ip_set_nfnl_put(par->net, info->match_set.index);
 		return -ERANGE;
 	}
@@ -143,12 +143,12 @@ set_match_v1_checkentry(const struct xt_mtchk_param *par)
 	index = ip_set_nfnl_get_byindex(par->net, info->match_set.index);
 
 	if (index == IPSET_INVALID_ID) {
-		pr_warn("Cannot find set identified by id %u to match\n",
-			info->match_set.index);
+		pr_info_ratelimited("Cannot find set identified by id %u to match\n",
+				    info->match_set.index);
 		return -ENOENT;
 	}
 	if (info->match_set.dim > IPSET_DIM_MAX) {
-		pr_warn("Protocol error: set match dimension is over the limit!\n");
+		pr_info_ratelimited("set match dimension is over the limit!\n");
 		ip_set_nfnl_put(par->net, info->match_set.index);
 		return -ERANGE;
 	}
@@ -241,8 +241,8 @@ set_target_v0_checkentry(const struct xt_tgchk_param *par)
 	if (info->add_set.index != IPSET_INVALID_ID) {
 		index = ip_set_nfnl_get_byindex(par->net, info->add_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find add_set index %u as target\n",
-				info->add_set.index);
+			pr_info_ratelimited("Cannot find add_set index %u as target\n",
+					    info->add_set.index);
 			return -ENOENT;
 		}
 	}
@@ -250,8 +250,8 @@ set_target_v0_checkentry(const struct xt_tgchk_param *par)
 	if (info->del_set.index != IPSET_INVALID_ID) {
 		index = ip_set_nfnl_get_byindex(par->net, info->del_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find del_set index %u as target\n",
-				info->del_set.index);
+			pr_info_ratelimited("Cannot find del_set index %u as target\n",
+					    info->del_set.index);
 			if (info->add_set.index != IPSET_INVALID_ID)
 				ip_set_nfnl_put(par->net, info->add_set.index);
 			return -ENOENT;
@@ -259,7 +259,7 @@ set_target_v0_checkentry(const struct xt_tgchk_param *par)
 	}
 	if (info->add_set.u.flags[IPSET_DIM_MAX - 1] != 0 ||
 	    info->del_set.u.flags[IPSET_DIM_MAX - 1] != 0) {
-		pr_warn("Protocol error: SET target dimension is over the limit!\n");
+		pr_info_ratelimited("SET target dimension over the limit!\n");
 		if (info->add_set.index != IPSET_INVALID_ID)
 			ip_set_nfnl_put(par->net, info->add_set.index);
 		if (info->del_set.index != IPSET_INVALID_ID)
@@ -316,8 +316,8 @@ set_target_v1_checkentry(const struct xt_tgchk_param *par)
 	if (info->add_set.index != IPSET_INVALID_ID) {
 		index = ip_set_nfnl_get_byindex(par->net, info->add_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find add_set index %u as target\n",
-				info->add_set.index);
+			pr_info_ratelimited("Cannot find add_set index %u as target\n",
+					    info->add_set.index);
 			return -ENOENT;
 		}
 	}
@@ -325,8 +325,8 @@ set_target_v1_checkentry(const struct xt_tgchk_param *par)
 	if (info->del_set.index != IPSET_INVALID_ID) {
 		index = ip_set_nfnl_get_byindex(par->net, info->del_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find del_set index %u as target\n",
-				info->del_set.index);
+			pr_info_ratelimited("Cannot find del_set index %u as target\n",
+					    info->del_set.index);
 			if (info->add_set.index != IPSET_INVALID_ID)
 				ip_set_nfnl_put(par->net, info->add_set.index);
 			return -ENOENT;
@@ -334,7 +334,7 @@ set_target_v1_checkentry(const struct xt_tgchk_param *par)
 	}
 	if (info->add_set.dim > IPSET_DIM_MAX ||
 	    info->del_set.dim > IPSET_DIM_MAX) {
-		pr_warn("Protocol error: SET target dimension is over the limit!\n");
+		pr_info_ratelimited("SET target dimension over the limit!\n");
 		if (info->add_set.index != IPSET_INVALID_ID)
 			ip_set_nfnl_put(par->net, info->add_set.index);
 		if (info->del_set.index != IPSET_INVALID_ID)
@@ -444,8 +444,8 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 		index = ip_set_nfnl_get_byindex(par->net,
 						info->add_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find add_set index %u as target\n",
-				info->add_set.index);
+			pr_info_ratelimited("Cannot find add_set index %u as target\n",
+					    info->add_set.index);
 			return -ENOENT;
 		}
 	}
@@ -454,8 +454,8 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 		index = ip_set_nfnl_get_byindex(par->net,
 						info->del_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find del_set index %u as target\n",
-				info->del_set.index);
+			pr_info_ratelimited("Cannot find del_set index %u as target\n",
+					    info->del_set.index);
 			if (info->add_set.index != IPSET_INVALID_ID)
 				ip_set_nfnl_put(par->net,
 						info->add_set.index);
@@ -465,7 +465,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 
 	if (info->map_set.index != IPSET_INVALID_ID) {
 		if (strncmp(par->table, "mangle", 7)) {
-			pr_warn("--map-set only usable from mangle table\n");
+			pr_info_ratelimited("--map-set only usable from mangle table\n");
 			return -EINVAL;
 		}
 		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
@@ -473,14 +473,14 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 		     !(par->hook_mask & (1 << NF_INET_FORWARD |
 					 1 << NF_INET_LOCAL_OUT |
 					 1 << NF_INET_POST_ROUTING))) {
-			pr_warn("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
+			pr_info_ratelimited("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
 			return -EINVAL;
 		}
 		index = ip_set_nfnl_get_byindex(par->net,
 						info->map_set.index);
 		if (index == IPSET_INVALID_ID) {
-			pr_warn("Cannot find map_set index %u as target\n",
-				info->map_set.index);
+			pr_info_ratelimited("Cannot find map_set index %u as target\n",
+					    info->map_set.index);
 			if (info->add_set.index != IPSET_INVALID_ID)
 				ip_set_nfnl_put(par->net,
 						info->add_set.index);
@@ -494,7 +494,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 	if (info->add_set.dim > IPSET_DIM_MAX ||
 	    info->del_set.dim > IPSET_DIM_MAX ||
 	    info->map_set.dim > IPSET_DIM_MAX) {
-		pr_warn("Protocol error: SET target dimension is over the limit!\n");
+		pr_info_ratelimited("SET target dimension over the limit!\n");
 		if (info->add_set.index != IPSET_INVALID_ID)
 			ip_set_nfnl_put(par->net, info->add_set.index);
 		if (info->del_set.index != IPSET_INVALID_ID)
-- 
2.13.6

