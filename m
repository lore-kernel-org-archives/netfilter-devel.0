From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 1/9] netfilter: x_tables: remove pr_info where possible
Date: Fri,  9 Feb 2018 15:51:59 +0100
Message-ID: <20180209145207.2097-2-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46620 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbeBIOzV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:21 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

remove several pr_info messages that cannot be triggered with iptables,
the check is only to ensure input is sane.

iptables(8) already prints error messages in these cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v2:
  - remove a few more pr_info (dscp, checksum)
 net/ipv4/netfilter/ipt_ECN.c | 10 ++++------
 net/netfilter/xt_CHECKSUM.c  |  5 ++---
 net/netfilter/xt_DSCP.c      |  4 +---
 net/netfilter/xt_HL.c        | 13 +++----------
 net/netfilter/xt_HMARK.c     | 10 ++++------
 net/netfilter/xt_LED.c       |  4 +---
 net/netfilter/xt_dscp.c      |  4 +---
 7 files changed, 16 insertions(+), 34 deletions(-)

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
diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
index 0f642ef8cd26..ea3c5701fb0f 100644
--- a/net/netfilter/xt_CHECKSUM.c
+++ b/net/netfilter/xt_CHECKSUM.c
@@ -39,10 +39,9 @@ static int checksum_tg_check(const struct xt_tgchk_param *par)
 		pr_info("unsupported CHECKSUM operation %x\n", einfo->operation);
 		return -EINVAL;
 	}
-	if (!einfo->operation) {
-		pr_info("no CHECKSUM operation enabled\n");
+	if (!einfo->operation)
 		return -EINVAL;
-	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 3f83d38c4e5b..098ed851b7a7 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -66,10 +66,8 @@ static int dscp_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_DSCP_info *info = par->targinfo;
 
-	if (info->dscp > XT_DSCP_MAX) {
-		pr_info("dscp %x out of range\n", info->dscp);
+	if (info->dscp > XT_DSCP_MAX)
 		return -EDOM;
-	}
 	return 0;
 }
 
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
 
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index 60e6dbe12460..dd08cc1f86c7 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -313,10 +313,9 @@ static int hmark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_hmark_info *info = par->targinfo;
 
-	if (!info->hmodulus) {
-		pr_info("xt_HMARK: hash modulus can't be zero\n");
+	if (!info->hmodulus)
 		return -EINVAL;
-	}
+
 	if (info->proto_mask &&
 	    (info->flags & XT_HMARK_FLAG(XT_HMARK_METHOD_L3))) {
 		pr_info("xt_HMARK: proto mask must be zero with L3 mode\n");
@@ -324,10 +323,9 @@ static int hmark_tg_check(const struct xt_tgchk_param *par)
 	}
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI_MASK) &&
 	    (info->flags & (XT_HMARK_FLAG(XT_HMARK_SPORT_MASK) |
-			     XT_HMARK_FLAG(XT_HMARK_DPORT_MASK)))) {
-		pr_info("xt_HMARK: spi-mask and port-mask can't be combined\n");
+			     XT_HMARK_FLAG(XT_HMARK_DPORT_MASK))))
 		return -EINVAL;
-	}
+
 	if (info->flags & XT_HMARK_FLAG(XT_HMARK_SPI) &&
 	    (info->flags & (XT_HMARK_FLAG(XT_HMARK_SPORT) |
 			     XT_HMARK_FLAG(XT_HMARK_DPORT)))) {
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
 
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 236ac8008909..a4c2b862f820 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -46,10 +46,8 @@ static int dscp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
 
-	if (info->dscp > XT_DSCP_MAX) {
-		pr_info("dscp %x out of range\n", info->dscp);
+	if (info->dscp > XT_DSCP_MAX)
 		return -EDOM;
-	}
 
 	return 0;
 }
-- 
2.13.6

