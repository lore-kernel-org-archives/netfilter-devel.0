From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/8] netfilter: xtables: use only error codes for checkentry
Date: Sat, 20 Mar 2010 02:02:19 +0100
Message-ID: <1269046942-31719-7-git-send-email-jengelh@medozas.de>
References: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59728 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab0CTBCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:02:37 -0400
In-Reply-To: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Convert the return true/false to integer codes.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebt_802_3.c     |    4 ++--
 net/bridge/netfilter/ebt_among.c     |    8 ++++----
 net/bridge/netfilter/ebt_arp.c       |    6 +++---
 net/bridge/netfilter/ebt_arpreply.c  |    6 +++---
 net/bridge/netfilter/ebt_dnat.c      |    8 ++++----
 net/bridge/netfilter/ebt_ip.c        |   14 +++++++-------
 net/bridge/netfilter/ebt_ip6.c       |   14 +++++++-------
 net/bridge/netfilter/ebt_limit.c     |    4 ++--
 net/bridge/netfilter/ebt_log.c       |    6 +++---
 net/bridge/netfilter/ebt_mark.c      |    8 ++++----
 net/bridge/netfilter/ebt_mark_m.c    |    8 ++++----
 net/bridge/netfilter/ebt_nflog.c     |    4 ++--
 net/bridge/netfilter/ebt_pkttype.c   |    4 ++--
 net/bridge/netfilter/ebt_redirect.c  |    8 ++++----
 net/bridge/netfilter/ebt_snat.c      |    8 ++++----
 net/bridge/netfilter/ebt_stp.c       |    6 +++---
 net/bridge/netfilter/ebt_ulog.c      |    4 ++--
 net/bridge/netfilter/ebt_vlan.c      |   14 +++++++-------
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |   10 +++++-----
 net/ipv4/netfilter/ipt_ECN.c         |    8 ++++----
 net/ipv4/netfilter/ipt_LOG.c         |    4 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    6 +++---
 net/ipv4/netfilter/ipt_NETMAP.c      |    6 +++---
 net/ipv4/netfilter/ipt_REDIRECT.c    |    6 +++---
 net/ipv4/netfilter/ipt_REJECT.c      |    6 +++---
 net/ipv4/netfilter/ipt_ULOG.c        |    6 +++---
 net/ipv4/netfilter/ipt_addrtype.c    |    8 ++++----
 net/ipv4/netfilter/ipt_ah.c          |    4 ++--
 net/ipv4/netfilter/ipt_ecn.c         |    8 ++++----
 net/ipv6/netfilter/ip6t_LOG.c        |    6 +++---
 net/ipv6/netfilter/ip6t_REJECT.c     |    6 +++---
 net/ipv6/netfilter/ip6t_ah.c         |    4 ++--
 net/ipv6/netfilter/ip6t_frag.c       |    4 ++--
 net/ipv6/netfilter/ip6t_hbh.c        |    6 +++---
 net/ipv6/netfilter/ip6t_ipv6header.c |    4 ++--
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    6 +++---
 net/netfilter/x_tables.c             |    5 +++--
 net/netfilter/xt_CONNSECMARK.c       |    4 ++--
 net/netfilter/xt_CT.c                |    4 ++--
 net/netfilter/xt_DSCP.c              |    2 +-
 net/netfilter/xt_HL.c                |    8 ++++----
 net/netfilter/xt_LED.c               |    4 ++--
 net/netfilter/xt_NFLOG.c             |    6 +++---
 net/netfilter/xt_NFQUEUE.c           |    4 ++--
 net/netfilter/xt_RATEEST.c           |    7 +++----
 net/netfilter/xt_SECMARK.c           |   10 +++++-----
 net/netfilter/xt_TCPMSS.c            |   12 ++++++------
 net/netfilter/xt_TPROXY.c            |    4 ++--
 net/netfilter/xt_cluster.c           |    4 ++--
 net/netfilter/xt_connbytes.c         |    6 +++---
 net/netfilter/xt_connlimit.c         |    2 +-
 net/netfilter/xt_connmark.c          |    2 +-
 net/netfilter/xt_conntrack.c         |    2 +-
 54 files changed, 165 insertions(+), 165 deletions(-)

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 7b6f4c4..f7de8db 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -41,9 +41,9 @@ static int ebt_802_3_mt_check(const struct xt_mtchk_param *par)
 	const struct ebt_802_3_info *info = par->matchinfo;
 
 	if (info->bitmask & ~EBT_802_3_MASK || info->invflags & ~EBT_802_3_MASK)
-		return false;
+		return -EINVAL;
 
-	return true;
+	return 0;
 }
 
 static struct xt_match ebt_802_3_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 8a75d39..20068e0 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -190,17 +190,17 @@ static int ebt_among_mt_check(const struct xt_mtchk_param *par)
 		pr_info("wrong size: %d against expected %d, rounded to %Zd\n",
 			em->match_size, expected_length,
 			EBT_ALIGN(expected_length));
-		return false;
+		return -EINVAL;
 	}
 	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
 		pr_info("dst integrity fail: %x\n", -err);
-		return false;
+		return -EINVAL;
 	}
 	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
 		pr_info("src integrity fail: %x\n", -err);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_match ebt_among_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index fc62055..952150c 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -108,10 +108,10 @@ static int ebt_arp_mt_check(const struct xt_mtchk_param *par)
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
 	   e->invflags & EBT_IPROTO)
-		return false;
+		return -EINVAL;
 	if (info->bitmask & ~EBT_ARP_MASK || info->invflags & ~EBT_ARP_MASK)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_match ebt_arp_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 2491564..4581adb 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -63,11 +63,11 @@ static int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 	const struct ebt_entry *e = par->entryinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
+		return -EINVAL;
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 5fddebe..59d5b7c 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -32,7 +32,7 @@ static int ebt_dnat_tg_check(const struct xt_tgchk_param *par)
 	unsigned int hook_mask;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
+		return -EINVAL;
 
 	hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
 	if ((strcmp(par->table, "nat") != 0 ||
@@ -40,10 +40,10 @@ static int ebt_dnat_tg_check(const struct xt_tgchk_param *par)
 	    (1 << NF_BR_LOCAL_OUT)))) &&
 	    (strcmp(par->table, "broute") != 0 ||
 	    hook_mask & ~(1 << NF_BR_BROUTING)))
-		return false;
+		return -EINVAL;
 	if (INVALID_TARGET)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target ebt_dnat_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index d1a555d..a1c76c7 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -84,24 +84,24 @@ static int ebt_ip_mt_check(const struct xt_mtchk_param *par)
 
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
-		return false;
+		return -EINVAL;
 	if (info->bitmask & ~EBT_IP_MASK || info->invflags & ~EBT_IP_MASK)
-		return false;
+		return -EINVAL;
 	if (info->bitmask & (EBT_IP_DPORT | EBT_IP_SPORT)) {
 		if (info->invflags & EBT_IP_PROTO)
-			return false;
+			return -EINVAL;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			 return false;
+			 return -EINVAL;
 	}
 	if (info->bitmask & EBT_IP_DPORT && info->dport[0] > info->dport[1])
-		return false;
+		return -EINVAL;
 	if (info->bitmask & EBT_IP_SPORT && info->sport[0] > info->sport[1])
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_match ebt_ip_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index fa4ecf5..33f8413 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -86,24 +86,24 @@ static int ebt_ip6_mt_check(const struct xt_mtchk_param *par)
 	struct ebt_ip6_info *info = par->matchinfo;
 
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
-		return false;
+		return -EINVAL;
 	if (info->bitmask & ~EBT_IP6_MASK || info->invflags & ~EBT_IP6_MASK)
-		return false;
+		return -EINVAL;
 	if (info->bitmask & (EBT_IP6_DPORT | EBT_IP6_SPORT)) {
 		if (info->invflags & EBT_IP6_PROTO)
-			return false;
+			return -EINVAL;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			return false;
+			return -EINVAL;
 	}
 	if (info->bitmask & EBT_IP6_DPORT && info->dport[0] > info->dport[1])
-		return false;
+		return -EINVAL;
 	if (info->bitmask & EBT_IP6_SPORT && info->sport[0] > info->sport[1])
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_match ebt_ip6_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index abfb0ec..21d1a89 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -74,7 +74,7 @@ static int ebt_limit_mt_check(const struct xt_mtchk_param *par)
 	    user2credits(info->avg * info->burst) < user2credits(info->avg)) {
 		pr_info("overflow, try lower: %u/%u\n",
 			info->avg, info->burst);
-		return false;
+		return -ERANGE;
 	}
 
 	/* User avg in seconds * EBT_LIMIT_SCALE: convert to jiffies * 128. */
@@ -82,7 +82,7 @@ static int ebt_limit_mt_check(const struct xt_mtchk_param *par)
 	info->credit = user2credits(info->avg * info->burst);
 	info->credit_cap = user2credits(info->avg * info->burst);
 	info->cost = user2credits(info->avg);
-	return true;
+	return 0;
 }
 
 
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index a0aeac6..2ba36f2 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -29,11 +29,11 @@ static int ebt_log_tg_check(const struct xt_tgchk_param *par)
 	struct ebt_log_info *info = par->targinfo;
 
 	if (info->bitmask & ~EBT_LOG_MASK)
-		return false;
+		return -EINVAL;
 	if (info->loglevel >= 8)
-		return false;
+		return -EDOM;
 	info->prefix[EBT_LOG_PREFIX_SIZE - 1] = '\0';
-	return true;
+	return 0;
 }
 
 struct tcpudphdr
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index dd94daf..126e536 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -43,14 +43,14 @@ static int ebt_mark_tg_check(const struct xt_tgchk_param *par)
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return false;
+		return -EINVAL;
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return false;
+		return -EINVAL;
 	tmp = info->target & ~EBT_VERDICT_BITS;
 	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
 	    tmp != MARK_AND_VALUE && tmp != MARK_XOR_VALUE)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 #ifdef CONFIG_COMPAT
 struct compat_ebt_mark_t_info {
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 1e5b0b3..e4366c0 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -27,12 +27,12 @@ static int ebt_mark_mt_check(const struct xt_mtchk_param *par)
 	const struct ebt_mark_m_info *info = par->matchinfo;
 
 	if (info->bitmask & ~EBT_MARK_MASK)
-		return false;
+		return -EINVAL;
 	if ((info->bitmask & EBT_MARK_OR) && (info->bitmask & EBT_MARK_AND))
-		return false;
+		return -EINVAL;
 	if (!info->bitmask)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 1f2b7bb..22e2ad5 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -40,9 +40,9 @@ static int ebt_nflog_tg_check(const struct xt_tgchk_param *par)
 	struct ebt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
-		return false;
+		return -EINVAL;
 	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
-	return true;
+	return 0;
 }
 
 static struct xt_target ebt_nflog_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 9b3c645..f34bcc3 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -25,9 +25,9 @@ static int ebt_pkttype_mt_check(const struct xt_mtchk_param *par)
 	const struct ebt_pkttype_info *info = par->matchinfo;
 
 	if (info->invert != 0 && info->invert != 1)
-		return false;
+		return -EINVAL;
 	/* Allow any pkt_type value */
-	return true;
+	return 0;
 }
 
 static struct xt_match ebt_pkttype_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 73c4d3a..a6044a6 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -38,17 +38,17 @@ static int ebt_redirect_tg_check(const struct xt_tgchk_param *par)
 	unsigned int hook_mask;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
+		return -EINVAL;
 
 	hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
 	if ((strcmp(par->table, "nat") != 0 ||
 	    hook_mask & ~(1 << NF_BR_PRE_ROUTING)) &&
 	    (strcmp(par->table, "broute") != 0 ||
 	    hook_mask & ~(1 << NF_BR_BROUTING)))
-		return false;
+		return -EINVAL;
 	if (INVALID_TARGET)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target ebt_redirect_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 94bcecd..79caca3 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -49,14 +49,14 @@ static int ebt_snat_tg_check(const struct xt_tgchk_param *par)
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return false;
+		return -EINVAL;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return false;
+		return -EINVAL;
 	tmp = info->target | EBT_VERDICT_BITS;
 	if ((tmp & ~NAT_ARP_BIT) != ~NAT_ARP_BIT)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target ebt_snat_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 521186f..02f28fd 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -162,13 +162,13 @@ static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
-		return false;
+		return -EINVAL;
 	/* Make sure the match only receives stp frames */
 	if (compare_ether_addr(e->destmac, bridge_ula) ||
 	    compare_ether_addr(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
-		return false;
+		return -EINVAL;
 
-	return true;
+	return 0;
 }
 
 static struct xt_match ebt_stp_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 482674e..5d873b2 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -261,14 +261,14 @@ static int ebt_ulog_tg_check(const struct xt_tgchk_param *par)
 	struct ebt_ulog_info *uloginfo = par->targinfo;
 
 	if (uloginfo->nlgroup > 31)
-		return false;
+		return -EINVAL;
 
 	uloginfo->prefix[EBT_ULOG_PREFIX_LEN - 1] = '\0';
 
 	if (uloginfo->qthreshold > EBT_ULOG_MAX_QLEN)
 		uloginfo->qthreshold = EBT_ULOG_MAX_QLEN;
 
-	return true;
+	return 0;
 }
 
 static struct xt_target ebt_ulog_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 04a9575..bf8ae5c 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -88,7 +88,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	if (e->ethproto != htons(ETH_P_8021Q)) {
 		pr_debug("passed entry proto %2.4X is not 802.1Q (8100)\n",
 			 ntohs(e->ethproto));
-		return false;
+		return -EINVAL;
 	}
 
 	/* Check for bitmask range
@@ -96,14 +96,14 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	if (info->bitmask & ~EBT_VLAN_MASK) {
 		pr_debug("bitmask %2X is out of mask (%2X)\n",
 			 info->bitmask, EBT_VLAN_MASK);
-		return false;
+		return -EINVAL;
 	}
 
 	/* Check for inversion flags range */
 	if (info->invflags & ~EBT_VLAN_MASK) {
 		pr_debug("inversion flags %2X is out of mask (%2X)\n",
 			 info->invflags, EBT_VLAN_MASK);
-		return false;
+		return -EINVAL;
 	}
 
 	/* Reserved VLAN ID (VID) values
@@ -117,7 +117,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 			if (info->id > VLAN_GROUP_ARRAY_LEN) {
 				pr_debug("id %d is out of range (1-4096)\n",
 					 info->id);
-				return false;
+				return -EINVAL;
 			}
 			/* Note: This is valid VLAN-tagged frame point.
 			 * Any value of user_priority are acceptable,
@@ -132,7 +132,7 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 		if ((unsigned char) info->prio > 7) {
 			pr_debug("prio %d is out of range (0-7)\n",
 				 info->prio);
-			return false;
+			return -EINVAL;
 		}
 	}
 	/* Check for encapsulated proto range - it is possible to be
@@ -142,11 +142,11 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 		if ((unsigned short) ntohs(info->encap) < ETH_ZLEN) {
 			pr_debug("encap frame length %d is less than "
 				 "minimal\n", ntohs(info->encap));
-			return false;
+			return -EINVAL;
 		}
 	}
 
-	return true;
+	return 0;
 }
 
 static struct xt_match ebt_vlan_mt_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e29e8e5..8bd4714 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -359,13 +359,13 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
 		pr_info("unknown mode %u\n", cipinfo->hash_mode);
-		return false;
+		return -EINVAL;
 
 	}
 	if (e->ip.dmsk.s_addr != htonl(0xffffffff) ||
 	    e->ip.dst.s_addr == 0) {
 		pr_info("Please specify destination IP\n");
-		return false;
+		return -EINVAL;
 	}
 
 	/* FIXME: further sanity checks */
@@ -375,13 +375,13 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			pr_info("no config found for %pI4, need 'new'\n",
 				&e->ip.dst.s_addr);
-			return false;
+			return -EINVAL;
 		} else {
 			struct net_device *dev;
 
 			if (e->ip.iniface[0] == '\0') {
 				pr_info("Please specify an interface name\n");
-				return false;
+				return -EINVAL;
 			}
 
 			dev = dev_get_by_name(&init_net, e->ip.iniface);
@@ -410,7 +410,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		return ret;
 	}
 
-	return true;
+	return 0;
 }
 
 /* drop reference count of cluster config when rule is deleted */
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 9d96500..563049f 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -100,18 +100,18 @@ static int ecn_tg_check(const struct xt_tgchk_param *par)
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		pr_info("unsupported ECN operation %x\n", einfo->operation);
-		return false;
+		return -EINVAL;
 	}
 	if (einfo->ip_ect & ~IPT_ECN_IP_MASK) {
 		pr_info("new ECT codepoint %x out of mask\n", einfo->ip_ect);
-		return false;
+		return -EINVAL;
 	}
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR)) &&
 	    (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
 		pr_info("cannot use TCP operations on a non-tcp rule\n");
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target ecn_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 33213d6..e9dbd8a 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -449,9 +449,9 @@ static int log_tg_check(const struct xt_tgchk_param *par)
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		pr_debug("prefix is not null-terminated\n");
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target log_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 5a182f6..02b1bc4 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -34,13 +34,13 @@ static int masquerade_tg_check(const struct xt_tgchk_param *par)
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("bad MAP_IPS.\n");
-		return false;
+		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
 		pr_debug("bad rangesize %u\n", mr->rangesize);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static unsigned int
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index cbfe5f7..708c7f8 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -28,13 +28,13 @@ static int netmap_tg_check(const struct xt_tgchk_param *par)
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		pr_debug("bad MAP_IPS.\n");
-		return false;
+		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
 		pr_debug("bad rangesize %u.\n", mr->rangesize);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static unsigned int
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index f8daec2..3cf1019 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -32,13 +32,13 @@ static int redirect_tg_check(const struct xt_tgchk_param *par)
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("bad MAP_IPS.\n");
-		return false;
+		return -EINVAL;
 	}
 	if (mr->rangesize != 1) {
 		pr_debug("bad rangesize %u.\n", mr->rangesize);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static unsigned int
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index cf76f1b..b026014 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -181,16 +181,16 @@ static int reject_tg_check(const struct xt_tgchk_param *par)
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		pr_info("ECHOREPLY no longer supported.\n");
-		return false;
+		return -EINVAL;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ip.proto != IPPROTO_TCP ||
 		    (e->ip.invflags & XT_INV_PROTO)) {
 			pr_info("TCP_RESET invalid for non-tcp\n");
-			return false;
+			return -EINVAL;
 		}
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target reject_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 3836d29..7e3002e 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -318,14 +318,14 @@ static int ulog_tg_check(const struct xt_tgchk_param *par)
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		pr_debug("prefix not null-terminated\n");
-		return false;
+		return -EINVAL;
 	}
 	if (loginfo->qthreshold > ULOG_MAX_QLEN) {
 		pr_debug("queue threshold %Zu > MAX_QLEN\n",
 			 loginfo->qthreshold);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 81197f4..e4b8f2b 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -78,7 +78,7 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		pr_info("both incoming and outgoing "
 			"interface limitation cannot be selected\n");
-		return false;
+		return -EINVAL;
 	}
 
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
@@ -86,7 +86,7 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		pr_info("output interface limitation "
 			"not valid in PREROUTING and INPUT\n");
-		return false;
+		return -EINVAL;
 	}
 
 	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
@@ -94,10 +94,10 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
 		pr_info("input interface limitation "
 			"not valid in POSTROUTING and OUTPUT\n");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return 0;
 }
 
 static struct xt_match addrtype_mt_reg[] __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 667ded1..9f98102 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -62,9 +62,9 @@ static int ah_mt_check(const struct xt_mtchk_param *par)
 	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
 		pr_debug("unknown flags %X\n", ahinfo->invflags);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_match ah_mt_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index d1e234f..32e2410 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -91,18 +91,18 @@ static int ecn_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ip *ip = par->entryinfo;
 
 	if (info->operation & IPT_ECN_OP_MATCH_MASK)
-		return false;
+		return -EINVAL;
 
 	if (info->invert & IPT_ECN_OP_MATCH_MASK)
-		return false;
+		return -EINVAL;
 
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR) &&
 	    ip->proto != IPPROTO_TCP) {
 		pr_info("cannot match TCP bits in rule for non-tcp packets\n");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return 0;
 }
 
 static struct xt_match ecn_mt_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index bcc3fc1..64254aa 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -457,13 +457,13 @@ static int log_tg6_check(const struct xt_tgchk_param *par)
 
 	if (loginfo->level >= 8) {
 		pr_debug("level %u >= 8\n", loginfo->level);
-		return false;
+		return -EDOM;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		pr_debug("prefix not null-terminated\n");
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target log_tg6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 8d5141e..55b9b2d 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -220,16 +220,16 @@ static int reject_tg6_check(const struct xt_tgchk_param *par)
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		pr_info("ECHOREPLY is not supported.\n");
-		return false;
+		return -EINVAL;
 	} else if (rejinfo->with == IP6T_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ipv6.proto != IPPROTO_TCP ||
 		    (e->ipv6.invflags & XT_INV_PROTO)) {
 			pr_info("TCP_RESET illegal for non-tcp\n");
-			return false;
+			return -EINVAL;
 		}
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target reject_tg6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 3d57044..1580693 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -93,9 +93,9 @@ static int ah_mt6_check(const struct xt_mtchk_param *par)
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
 		pr_debug("unknown flags %X\n", ahinfo->invflags);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_match ah_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index c2dba27..a5daf0f 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -108,9 +108,9 @@ static int frag_mt6_check(const struct xt_mtchk_param *par)
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
 		pr_debug("unknown flags %X\n", fraginfo->invflags);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_match frag_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 1b29431..5e6acda 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -170,15 +170,15 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
 		pr_debug("unknown flags %X\n", optsinfo->invflags);
-		return false;
+		return -EINVAL;
 	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
 		pr_debug("Not strict - not implemented");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return 0;
 }
 
 static struct xt_match hbh_mt6_reg[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 90e1e04..46fbabb 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -125,9 +125,9 @@ static int ipv6header_mt6_check(const struct xt_mtchk_param *par)
 	/* invflags is 0 or 0xff in hard mode */
 	if ((!info->modeflag) && info->invflags != 0x00 &&
 	    info->invflags != 0xFF)
-		return false;
+		return -EINVAL;
 
-	return true;
+	return 0;
 }
 
 static struct xt_match ipv6header_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index d940804..c9f443e 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -67,7 +67,7 @@ static int mh_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_mh *mhinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
-	return !(mhinfo->invflags & ~IP6T_MH_INV_MASK);
+	return (mhinfo->invflags & ~IP6T_MH_INV_MASK) ? -EINVAL : 0;
 }
 
 static struct xt_match mh_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 76397f3..0932272 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -189,17 +189,17 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
 		pr_debug("unknown flags %X\n", rtinfo->invflags);
-		return false;
+		return -EINVAL;
 	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
 	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
 		pr_debug("`--rt-type 0' required before `--rt-0-*'");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return 0;
 }
 
 static struct xt_match rt_mt6_reg __read_mostly = {
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8c8dd20..cc58fff 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -396,8 +396,9 @@ int xt_check_match(struct xt_mtchk_param *par,
 		ret = par->match->checkentry(par);
 		if (ret < 0)
 			return ret;
-		else if (ret == 0)
-			return -EINVAL;
+		else if (ret > 0)
+			/* Flag up potential errors. */
+			return -EIO;
 	}
 	return 0;
 }
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index d338d18..99e0b84 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -93,7 +93,7 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 	    strcmp(par->table, "security") != 0) {
 		pr_info("target only valid in the \'mangle\' "
 			"or \'security\' tables, not \'%s\'.\n", par->table);
-		return false;
+		return -EINVAL;
 	}
 
 	switch (info->mode) {
@@ -112,7 +112,7 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 			par->family);
 		return ret;
 	}
-	return true;
+	return 0;
 }
 
 static void connsecmark_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index da5b951..65dd348 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -63,7 +63,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 	u8 proto;
 
 	if (info->flags & ~XT_CT_NOTRACK)
-		return false;
+		return -EINVAL;
 
 	if (info->flags & XT_CT_NOTRACK) {
 		ct = &nf_conntrack_untracked;
@@ -115,7 +115,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 out:
 	info->ct = ct;
-	return true;
+	return 0;
 
 err3:
 	nf_conntrack_free(ct);
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 0c9aae6..969634f 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -68,7 +68,7 @@ static int dscp_tg_check(const struct xt_tgchk_param *par)
 		pr_info("dscp %x out of range\n", info->dscp);
 		return -EDOM;
 	}
-	return true;
+	return 0;
 }
 
 static unsigned int
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 22ed2dc..df1f314 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -110,8 +110,8 @@ static int ttl_tg_check(const struct xt_tgchk_param *par)
 		return -EDOM;
 	}
 	if (info->mode != IPT_TTL_SET && info->ttl == 0)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static int hl_tg6_check(const struct xt_tgchk_param *par)
@@ -125,9 +125,9 @@ static int hl_tg6_check(const struct xt_tgchk_param *par)
 	if (info->mode != IP6T_HL_SET && info->hop_limit == 0) {
 		pr_info("increment/decrement does not "
 			"make sense with value 0\n");
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target hl_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 899da12..656531e 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -88,7 +88,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 
 	if (ledinfo->id[0] == '\0') {
 		pr_info("No 'id' parameter given.\n");
-		return false;
+		return -EINVAL;
 	}
 
 	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
@@ -112,7 +112,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 			    (unsigned long)ledinfo);
 
 	ledinfo->internal_data = ledinternal;
-	return true;
+	return 0;
 }
 
 static void led_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 13e6c00..42dd874 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -42,10 +42,10 @@ static int nflog_tg_check(const struct xt_tgchk_param *par)
 	const struct xt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
-		return false;
+		return -EINVAL;
 	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target nflog_tg_reg __read_mostly = {
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 143f0e0..a3f05a6 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -92,7 +92,7 @@ static int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
 	}
 	if (info->queues_total == 0) {
 		pr_err("NFQUEUE: number of total queues is 0\n");
-		return false;
+		return -EINVAL;
 	}
 	maxid = info->queues_total - 1 + info->queuenum;
 	if (maxid > 0xffff) {
@@ -100,7 +100,7 @@ static int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
 		       info->queues_total, maxid);
 		return -EDOM;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 3c5d1c9..40751c6 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -110,10 +110,10 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		    (info->interval != est->params.interval ||
 		     info->ewma_log != est->params.ewma_log)) {
 			xt_rateest_put(est);
-			return false;
+			return -EINVAL;
 		}
 		info->est = est;
-		return true;
+		return 0;
 	}
 
 	ret = -ENOMEM;
@@ -139,8 +139,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 
 	info->est = est;
 	xt_rateest_hash_insert(est);
-
-	return true;
+	return 0;
 
 err2:
 	kfree(est);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 6525eee..836d126 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -77,7 +77,7 @@ static int checkentry_selinux(struct xt_secmark_target_info *info)
 	}
 
 	selinux_secmark_refcount_inc();
-	return true;
+	return 0;
 }
 
 static int secmark_tg_check(const struct xt_tgchk_param *par)
@@ -89,19 +89,19 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 	    strcmp(par->table, "security") != 0) {
 		pr_info("target only valid in the \'mangle\' "
 			"or \'security\' tables, not \'%s\'.\n", par->table);
-		return false;
+		return -EINVAL;
 	}
 
 	if (mode && mode != info->mode) {
 		pr_info("mode already set to %hu cannot mix with "
 			"rules for mode %hu\n", mode, info->mode);
-		return false;
+		return -EINVAL;
 	}
 
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
 		err = checkentry_selinux(info);
-		if (err <= 0)
+		if (err < 0)
 			return err;
 		break;
 
@@ -112,7 +112,7 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 
 	if (!mode)
 		mode = info->mode;
-	return true;
+	return 0;
 }
 
 static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 70288dc..385677b 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -246,13 +246,13 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
 		pr_info("path-MTU clamping only supported in "
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return false;
+		return -EINVAL;
 	}
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
-			return true;
+			return 0;
 	pr_info("Only works on TCP SYN packets\n");
-	return false;
+	return -EINVAL;
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
@@ -268,13 +268,13 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
 		pr_info("path-MTU clamping only supported in "
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return false;
+		return -EINVAL;
 	}
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
-			return true;
+			return 0;
 	pr_info("Only works on TCP SYN packets\n");
-	return false;
+	return -EINVAL;
 }
 #endif
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 189df9a..4f246dd 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -65,11 +65,11 @@ static int tproxy_tg_check(const struct xt_tgchk_param *par)
 
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
 	    && !(i->invflags & IPT_INV_PROTO))
-		return true;
+		return 0;
 
 	pr_info("Can be used only in combination with "
 		"either -p tcp or -p udp\n");
-	return false;
+	return -EINVAL;
 }
 
 static struct xt_target tproxy_tg_reg __read_mostly = {
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 0c8a653..6c941e1 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -140,14 +140,14 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 		pr_info("you have exceeded the maximum "
 			"number of cluster nodes (%u > %u)\n",
 			info->total_nodes, XT_CLUSTER_NODES_MAX);
-		return false;
+		return -EINVAL;
 	}
 	if (info->node_mask >= (1ULL << info->total_nodes)) {
 		pr_info("this node mask cannot be "
 			"higher than the total number of nodes\n");
 		return -EDOM;
 	}
-	return true;
+	return 0;
 }
 
 static struct xt_match xt_cluster_match __read_mostly = {
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d50a53e..2ff332e 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -101,12 +101,12 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
 	    sinfo->what != XT_CONNBYTES_AVGPKT)
-		return false;
+		return -EINVAL;
 
 	if (sinfo->direction != XT_CONNBYTES_DIR_ORIGINAL &&
 	    sinfo->direction != XT_CONNBYTES_DIR_REPLY &&
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
-		return false;
+		return -EINVAL;
 
 	ret = nf_ct_l3proto_try_module_get(par->family);
 	if (ret < 0) {
@@ -115,7 +115,7 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 		return ret;
 	}
 
-	return true;
+	return 0;
 }
 
 static void connbytes_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index f8d92aa..370088e 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -244,7 +244,7 @@ static int connlimit_mt_check(const struct xt_mtchk_param *par)
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
 		INIT_LIST_HEAD(&info->data->iphash[i]);
 
-	return true;
+	return 0;
 }
 
 static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 1ffbafb..b12f0e3 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -116,7 +116,7 @@ static int connmark_mt_check(const struct xt_mtchk_param *par)
 			par->family);
 		return ret;
 	}
-	return true;
+	return 0;
 }
 
 static void connmark_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 59d2589..e0bcf8d 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -216,7 +216,7 @@ static int conntrack_mt_check(const struct xt_mtchk_param *par)
 			par->family);
 		return ret;
 	}
-	return true;
+	return 0;
 }
 
 static void conntrack_mt_destroy(const struct xt_mtdtor_param *par)
-- 
1.7.0.2

