From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/7] netfilter: x_tables: remove pr_info where possible
Date: Wed,  7 Feb 2018 14:48:22 +0100
Message-ID: <20180207134828.18691-2-fw@strlen.de>
References: <20180207134828.18691-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38814 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754258AbeBGNts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 08:49:48 -0500
In-Reply-To: <20180207134828.18691-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

remove several pr_info messages that cannot be triggered with iptables.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_ECN.c | 10 ++++------
 net/netfilter/xt_HL.c        | 13 +++----------
 net/netfilter/xt_LED.c       |  4 +---
 net/netfilter/xt_cgroup.c    |  4 +---
 4 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 270765236f5e..39ff167e6d86 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -98,14 +98,12 @@ static int ecn_tg_check(const struct xt_tgchk_param *par)
 	const struct ipt_ECN_info *einfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
 
-	if (einfo->operation & IPT_ECN_OP_MASK) {
-		pr_info("unsupported ECN operation %x\n", einfo->operation);
+	if (einfo->operation & IPT_ECN_OP_MASK)
 		return -EINVAL;
-	}
-	if (einfo->ip_ect & ~IPT_ECN_IP_MASK) {
-		pr_info("new ECT codepoint %x out of mask\n", einfo->ip_ect);
+
+	if (einfo->ip_ect & ~IPT_ECN_IP_MASK)
 		return -EINVAL;
-	}
+
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR)) &&
 	    (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
 		pr_info("cannot use TCP operations on a non-tcp rule\n");
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 1535e87ed9bd..4653b071bed4 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -105,10 +105,8 @@ static int ttl_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_TTL_info *info = par->targinfo;
 
-	if (info->mode > IPT_TTL_MAXMODE) {
-		pr_info("TTL: invalid or unknown mode %u\n", info->mode);
+	if (info->mode > IPT_TTL_MAXMODE)
 		return -EINVAL;
-	}
 	if (info->mode != IPT_TTL_SET && info->ttl == 0)
 		return -EINVAL;
 	return 0;
@@ -118,15 +116,10 @@ static int hl_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_HL_info *info = par->targinfo;
 
-	if (info->mode > IP6T_HL_MAXMODE) {
-		pr_info("invalid or unknown mode %u\n", info->mode);
+	if (info->mode > IP6T_HL_MAXMODE)
 		return -EINVAL;
-	}
-	if (info->mode != IP6T_HL_SET && info->hop_limit == 0) {
-		pr_info("increment/decrement does not "
-			"make sense with value 0\n");
+	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
 		return -EINVAL;
-	}
 	return 0;
 }
 
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 1dcad893df78..ece311c11fdc 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -111,10 +111,8 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 	struct xt_led_info_internal *ledinternal;
 	int err;
 
-	if (ledinfo->id[0] == '\0') {
-		pr_info("No 'id' parameter given.\n");
+	if (ledinfo->id[0] == '\0')
 		return -EINVAL;
-	}
 
 	mutex_lock(&xt_led_mutex);
 
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 891f4e7e8ea7..556530db7dbb 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -42,10 +42,8 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	if ((info->invert_path & ~1) || (info->invert_classid & ~1))
 		return -EINVAL;
 
-	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+	if (!info->has_path && !info->has_classid)
 		return -EINVAL;
-	}
 
 	if (info->has_path && info->has_classid) {
 		pr_info("xt_cgroup: both path and classid specified\n");
-- 
2.13.6

