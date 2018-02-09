From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 8/9] netfilter: x_tables: use pr ratelimiting in matches/targets
Date: Fri,  9 Feb 2018 15:52:06 +0100
Message-ID: <20180209145207.2097-9-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46648 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751041AbeBIOzp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:45 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

all of these print simple error message - use single pr_ratelimit call.
checkpatch complains about lines > 80 but this would require splitting
several "literals" over multiple lines which is worse.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_HMARK.c    | 17 +++++++++++------
 net/netfilter/xt_addrtype.c | 33 ++++++++++++++++-----------------
 net/netfilter/xt_policy.c   | 23 +++++++++++++----------
 3 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index dd08cc1f86c7..9c75f419cd80 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -9,6 +9,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/icmp.h>
@@ -312,15 +314,15 @@ hmark_tg_v4(struct sk_buff *skb, const struct xt_action_param *par)
 static int hmark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_hmark_info *info = par->targinfo;
+	const char *errmsg = "proto mask must be zero with L3 mode";
 
 	if (!info->hmodulus)
 		return -EINVAL;
 
 	if (info->proto_mask &&
-	    (info->flags & XT_HMARK_FLAG(XT_HMARK_METHOD_L3))) {
-		pr_info("xt_HMARK: proto mask must be zero with L3 mode\n");
-		return -EINVAL;
-	}
+	    (info->flags & XT_HMARK_FLAG(XT_HMARK_METHOD_L3)))
+		goto err;
+
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK) &&
 	    (info->flags & (XT_HMARK_FLAG(XT_HMARK_SPORT_MASK) |
 			     XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))))
@@ -329,10 +331,13 @@ static int hmark_tg_check(const struct xt_tgchk_param *par)
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI) &&
 	    (info->flags & (XT_HMARK_FLAG(XT_HMARK_SPORT) |
 			     XT_HMARK_FLAG(XT_HMARK_DPORT)))) {
-		pr_info("xt_HMARK: spi-set and port-set can't be combined\n");
-		return -EINVAL;
+		errmsg = "spi-set and port-set can't be combined";
+		goto err;
 	}
 	return 0;
+err:
+	pr_info_ratelimited("%s\n", errmsg);
+	return -EINVAL;
 }
 
 static struct xt_target hmark_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 911a7c0da504..89e281b3bfc2 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -164,48 +164,47 @@ addrtype_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 
 static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 {
+	const char *errmsg = "both incoming and outgoing interface limitation cannot be selected";
 	struct xt_addrtype_info_v1 *info = par->matchinfo;
 
 	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN &&
-	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
-		pr_info("both incoming and outgoing "
-			"interface limitation cannot be selected\n");
-		return -EINVAL;
-	}
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
+		goto err;
 
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) &&
 	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
-		pr_info("output interface limitation "
-			"not valid in PREROUTING and INPUT\n");
-		return -EINVAL;
+		errmsg = "output interface limitation not valid in PREROUTING and INPUT";
+		goto err;
 	}
 
 	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
 	    (1 << NF_INET_LOCAL_OUT)) &&
 	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
-		pr_info("input interface limitation "
-			"not valid in POSTROUTING and OUTPUT\n");
-		return -EINVAL;
+		errmsg = "input interface limitation not valid in POSTROUTING and OUTPUT";
+		goto err;
 	}
 
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	if (par->family == NFPROTO_IPV6) {
 		if ((info->source | info->dest) & XT_ADDRTYPE_BLACKHOLE) {
-			pr_err("ipv6 BLACKHOLE matching not supported\n");
-			return -EINVAL;
+			errmsg = "ipv6 BLACKHOLE matching not supported";
+			goto err;
 		}
 		if ((info->source | info->dest) >= XT_ADDRTYPE_PROHIBIT) {
-			pr_err("ipv6 PROHIBIT (THROW, NAT ..) matching not supported\n");
-			return -EINVAL;
+			errmsg = "ipv6 PROHIBIT (THROW, NAT ..) matching not supported";
+			goto err;
 		}
 		if ((info->source | info->dest) & XT_ADDRTYPE_BROADCAST) {
-			pr_err("ipv6 does not support BROADCAST matching\n");
-			return -EINVAL;
+			errmsg = "ipv6 does not support BROADCAST matching";
+			goto err;
 		}
 	}
 #endif
 	return 0;
+err:
+	pr_info_ratelimited("%s\n", errmsg);
+	return -EINVAL;
 }
 
 static struct xt_match addrtype_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 5639fb03bdd9..13f8ccf946d6 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -132,26 +132,29 @@ policy_mt(const struct sk_buff *skb, struct xt_action_param *par)
 static int policy_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_policy_info *info = par->matchinfo;
+	const char *errmsg = "neither incoming nor outgoing policy selected";
+
+	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT)))
+		goto err;
 
-	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
-		pr_info("neither incoming nor outgoing policy selected\n");
-		return -EINVAL;
-	}
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) && info->flags & XT_POLICY_MATCH_OUT) {
-		pr_info("output policy not valid in PREROUTING and INPUT\n");
-		return -EINVAL;
+		errmsg = "output policy not valid in PREROUTING and INPUT";
+		goto err;
 	}
 	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
 	    (1 << NF_INET_LOCAL_OUT)) && info->flags & XT_POLICY_MATCH_IN) {
-		pr_info("input policy not valid in POSTROUTING and OUTPUT\n");
-		return -EINVAL;
+		errmsg = "input policy not valid in POSTROUTING and OUTPUT";
+		goto err;
 	}
 	if (info->len > XT_POLICY_MAX_ELEM) {
-		pr_info("too many policy elements\n");
-		return -EINVAL;
+		errmsg = "too many policy elements";
+		goto err;
 	}
 	return 0;
+err:
+	pr_info_ratelimited("%s\n", errmsg);
+	return -EINVAL;
 }
 
 static struct xt_match policy_mt_reg[] __read_mostly = {
-- 
2.13.6

