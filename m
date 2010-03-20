From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/8] netfilter: xtables: slightly better error reporting (1/2)
Date: Sat, 20 Mar 2010 02:02:17 +0100
Message-ID: <1269046942-31719-5-git-send-email-jengelh@medozas.de>
References: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59718 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0CTBCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:02:35 -0400
In-Reply-To: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Restore function signatures from bool to int so that we can report
memory allocation failures or similar using -ENOMEM rather than
always having to pass -EINVAL back.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h   |    6 +++---
 net/bridge/netfilter/ebt_802_3.c     |    2 +-
 net/bridge/netfilter/ebt_among.c     |    2 +-
 net/bridge/netfilter/ebt_arp.c       |    2 +-
 net/bridge/netfilter/ebt_arpreply.c  |    2 +-
 net/bridge/netfilter/ebt_dnat.c      |    2 +-
 net/bridge/netfilter/ebt_ip.c        |    2 +-
 net/bridge/netfilter/ebt_ip6.c       |    2 +-
 net/bridge/netfilter/ebt_limit.c     |    2 +-
 net/bridge/netfilter/ebt_log.c       |    2 +-
 net/bridge/netfilter/ebt_mark.c      |    2 +-
 net/bridge/netfilter/ebt_mark_m.c    |    2 +-
 net/bridge/netfilter/ebt_nflog.c     |    2 +-
 net/bridge/netfilter/ebt_pkttype.c   |    2 +-
 net/bridge/netfilter/ebt_redirect.c  |    2 +-
 net/bridge/netfilter/ebt_snat.c      |    2 +-
 net/bridge/netfilter/ebt_stp.c       |    2 +-
 net/bridge/netfilter/ebt_ulog.c      |    2 +-
 net/bridge/netfilter/ebt_vlan.c      |    2 +-
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/ip_tables.c       |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 net/ipv4/netfilter/ipt_ECN.c         |    2 +-
 net/ipv4/netfilter/ipt_LOG.c         |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c      |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c        |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c    |    2 +-
 net/ipv4/netfilter/ipt_ah.c          |    2 +-
 net/ipv4/netfilter/ipt_ecn.c         |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c     |    4 ++--
 net/ipv6/netfilter/ip6_tables.c      |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c        |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |    2 +-
 net/ipv6/netfilter/ip6t_frag.c       |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c        |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    2 +-
 net/netfilter/xt_CONNSECMARK.c       |    2 +-
 net/netfilter/xt_CT.c                |    2 +-
 net/netfilter/xt_DSCP.c              |    2 +-
 net/netfilter/xt_HL.c                |    4 ++--
 net/netfilter/xt_LED.c               |    2 +-
 net/netfilter/xt_NFLOG.c             |    2 +-
 net/netfilter/xt_NFQUEUE.c           |    2 +-
 net/netfilter/xt_RATEEST.c           |    2 +-
 net/netfilter/xt_SECMARK.c           |    2 +-
 net/netfilter/xt_TCPMSS.c            |    4 ++--
 net/netfilter/xt_TPROXY.c            |    2 +-
 net/netfilter/xt_cluster.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    2 +-
 net/netfilter/xt_connlimit.c         |    2 +-
 net/netfilter/xt_connmark.c          |    4 ++--
 net/netfilter/xt_conntrack.c         |    2 +-
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |    2 +-
 net/netfilter/xt_esp.c               |    2 +-
 net/netfilter/xt_hashlimit.c         |    4 ++--
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_limit.c             |    2 +-
 net/netfilter/xt_multiport.c         |    8 ++++----
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    2 +-
 net/netfilter/xt_rateest.c           |    2 +-
 net/netfilter/xt_recent.c            |    2 +-
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_state.c             |    2 +-
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    2 +-
 net/netfilter/xt_tcpudp.c            |    4 ++--
 net/netfilter/xt_time.c              |    2 +-
 76 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f8f5551..edba551 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -303,7 +303,7 @@ struct xt_match {
 		      const struct xt_match_param *);
 
 	/* Called when user tries to insert an entry of this type. */
-	bool (*checkentry)(const struct xt_mtchk_param *);
+	int (*checkentry)(const struct xt_mtchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
@@ -342,8 +342,8 @@ struct xt_target {
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
            called. */
-	/* Should return true or false. */
-	bool (*checkentry)(const struct xt_tgchk_param *);
+	/* Should return true or false, or an error code (-Exxxx). */
+	int (*checkentry)(const struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_tgdtor_param *);
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 5d11767..7b6f4c4 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -36,7 +36,7 @@ ebt_802_3_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_802_3_mt_check(const struct xt_mtchk_param *par)
+static int ebt_802_3_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_802_3_info *info = par->matchinfo;
 
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 60ad630..8a75d39 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -172,7 +172,7 @@ ebt_among_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_among_mt_check(const struct xt_mtchk_param *par)
+static int ebt_among_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_among_info *info = par->matchinfo;
 	const struct ebt_entry_match *em =
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index e727697..fc62055 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -100,7 +100,7 @@ ebt_arp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_arp_mt_check(const struct xt_mtchk_param *par)
+static int ebt_arp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_arp_info *info = par->matchinfo;
 	const struct ebt_entry *e = par->entryinfo;
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index f392e9d..2491564 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -57,7 +57,7 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
+static int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_arpreply_info *info = par->targinfo;
 	const struct ebt_entry *e = par->entryinfo;
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 2bb40d7..5fddebe 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -26,7 +26,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool ebt_dnat_tg_check(const struct xt_tgchk_param *par)
+static int ebt_dnat_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 	unsigned int hook_mask;
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 5de6df6..d1a555d 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -77,7 +77,7 @@ ebt_ip_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_ip_mt_check(const struct xt_mtchk_param *par)
+static int ebt_ip_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_ip_info *info = par->matchinfo;
 	const struct ebt_entry *e = par->entryinfo;
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 63e3888..fa4ecf5 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -80,7 +80,7 @@ ebt_ip6_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_ip6_mt_check(const struct xt_mtchk_param *par)
+static int ebt_ip6_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct ebt_ip6_info *info = par->matchinfo;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 5b7330b..abfb0ec 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -65,7 +65,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / EBT_LIMIT_SCALE;
 }
 
-static bool ebt_limit_mt_check(const struct xt_mtchk_param *par)
+static int ebt_limit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct ebt_limit_info *info = par->matchinfo;
 
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index e873924..a0aeac6 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,7 +24,7 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static bool ebt_log_tg_check(const struct xt_tgchk_param *par)
+static int ebt_log_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_log_info *info = par->targinfo;
 
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 2b5ce53..dd94daf 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -36,7 +36,7 @@ ebt_mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool ebt_mark_tg_check(const struct xt_tgchk_param *par)
+static int ebt_mark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_mark_t_info *info = par->targinfo;
 	int tmp;
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 8de8c39..1e5b0b3 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -22,7 +22,7 @@ ebt_mark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool ebt_mark_mt_check(const struct xt_mtchk_param *par)
+static int ebt_mark_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_mark_m_info *info = par->matchinfo;
 
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 40dbd24..1f2b7bb 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -35,7 +35,7 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool ebt_nflog_tg_check(const struct xt_tgchk_param *par)
+static int ebt_nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_nflog_info *info = par->targinfo;
 
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index e2a07e6..9b3c645 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -20,7 +20,7 @@ ebt_pkttype_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (skb->pkt_type == info->pkt_type) ^ info->invert;
 }
 
-static bool ebt_pkttype_mt_check(const struct xt_mtchk_param *par)
+static int ebt_pkttype_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_pkttype_info *info = par->matchinfo;
 
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 9be8fbc..73c4d3a 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -32,7 +32,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool ebt_redirect_tg_check(const struct xt_tgchk_param *par)
+static int ebt_redirect_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
 	unsigned int hook_mask;
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 9c7b520..94bcecd 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -42,7 +42,7 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool ebt_snat_tg_check(const struct xt_tgchk_param *par)
+static int ebt_snat_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 	int tmp;
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 92a93d3..521186f 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -153,7 +153,7 @@ ebt_stp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_stp_mt_check(const struct xt_mtchk_param *par)
+static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_stp_info *info = par->matchinfo;
 	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 9faee5f..482674e 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -256,7 +256,7 @@ ebt_ulog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool ebt_ulog_tg_check(const struct xt_tgchk_param *par)
+static int ebt_ulog_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_ulog_info *uloginfo = par->targinfo;
 
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 5c44f51..04a9575 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -79,7 +79,7 @@ ebt_vlan_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
+static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 {
 	struct ebt_vlan_info *info = par->matchinfo;
 	const struct ebt_entry *e = par->entryinfo;
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index b0d5b1d..4b51a02 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -54,7 +54,7 @@ target(struct sk_buff *skb, const struct xt_target_param *par)
 	return mangle->target;
 }
 
-static bool checkentry(const struct xt_tgchk_param *par)
+static int checkentry(const struct xt_tgchk_param *par)
 {
 	const struct arpt_mangle *mangle = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 73fdf20..a23ce8d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2182,7 +2182,7 @@ icmp_match(const struct sk_buff *skb, const struct xt_match_param *par)
 				    !!(icmpinfo->invflags&IPT_ICMP_INV));
 }
 
-static bool icmp_checkentry(const struct xt_mtchk_param *par)
+static int icmp_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct ipt_icmp *icmpinfo = par->matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index f019c34..b8972ec 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -348,7 +348,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool clusterip_tg_check(const struct xt_tgchk_param *par)
+static int clusterip_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 0198875..9d96500 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -93,7 +93,7 @@ ecn_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool ecn_tg_check(const struct xt_tgchk_param *par)
+static int ecn_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ECN_info *einfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index b3bf623..c9ee5c4 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -439,7 +439,7 @@ log_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool log_tg_check(const struct xt_tgchk_param *par)
+static int log_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_log_info *loginfo = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 5063dda..5a182f6 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -28,7 +28,7 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 
 /* FIXME: Multiple targets. --RR */
-static bool masquerade_tg_check(const struct xt_tgchk_param *par)
+static int masquerade_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 51ab01a..cbfe5f7 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -22,7 +22,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
 
-static bool netmap_tg_check(const struct xt_tgchk_param *par)
+static int netmap_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 74f1f55..f8daec2 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -26,7 +26,7 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Connection redirection to localhost");
 
 /* FIXME: Take multiple ranges --RR */
-static bool redirect_tg_check(const struct xt_tgchk_param *par)
+static int redirect_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index ff32252..cf76f1b 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -174,7 +174,7 @@ reject_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool reject_tg_check(const struct xt_tgchk_param *par)
+static int reject_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_reject_info *rejinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 043350e..3836d29 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -312,7 +312,7 @@ static void ipt_logfn(u_int8_t pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static bool ulog_tg_check(const struct xt_tgchk_param *par)
+static int ulog_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ulog_info *loginfo = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index ea4f58a..81197f4 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -70,7 +70,7 @@ addrtype_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
+static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 {
 	struct ipt_addrtype_info_v1 *info = par->matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 4f27e17..667ded1 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -55,7 +55,7 @@ static bool ah_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			 !!(ahinfo->invflags & IPT_AH_INV_SPI));
 }
 
-static bool ah_mt_check(const struct xt_mtchk_param *par)
+static int ah_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ah *ahinfo = par->matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index e661108..d1e234f 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -85,7 +85,7 @@ static bool ecn_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ecn_mt_check(const struct xt_mtchk_param *par)
+static int ecn_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ecn_info *info = par->matchinfo;
 	const struct ipt_ip *ip = par->entryinfo;
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index ab74cc0..a3813af 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -73,7 +73,7 @@ ipt_dnat_target(struct sk_buff *skb, const struct xt_target_param *par)
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
 }
 
-static bool ipt_snat_checkentry(const struct xt_tgchk_param *par)
+static int ipt_snat_checkentry(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
@@ -85,7 +85,7 @@ static bool ipt_snat_checkentry(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static bool ipt_dnat_checkentry(const struct xt_tgchk_param *par)
+static int ipt_dnat_checkentry(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1b2414e..90be263 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2215,7 +2215,7 @@ icmp6_match(const struct sk_buff *skb, const struct xt_match_param *par)
 }
 
 /* Called when user tries to insert an entry of this type. */
-static bool icmp6_checkentry(const struct xt_mtchk_param *par)
+static int icmp6_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_icmp *icmpinfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 5a79883..bcc3fc1 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -451,7 +451,7 @@ log_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 }
 
 
-static bool log_tg6_check(const struct xt_tgchk_param *par)
+static int log_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_log_info *loginfo = par->targinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 45efb9f..8d5141e 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -213,7 +213,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool reject_tg6_check(const struct xt_tgchk_param *par)
+static int reject_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_reject_info *rejinfo = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 4429bfd..3d57044 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -87,7 +87,7 @@ static bool ah_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		!(ahinfo->hdrres && ah->reserved);
 }
 
-static bool ah_mt6_check(const struct xt_mtchk_param *par)
+static int ah_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ah *ahinfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 5c0da91..c2dba27 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -102,7 +102,7 @@ frag_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		  (ntohs(fh->frag_off) & IP6_MF));
 }
 
-static bool frag_mt6_check(const struct xt_mtchk_param *par)
+static int frag_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_frag *fraginfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index f4b7388..1b29431 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -164,7 +164,7 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool hbh_mt6_check(const struct xt_mtchk_param *par)
+static int hbh_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_opts *optsinfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 91490ad..90e1e04 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -118,7 +118,7 @@ ipv6header_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	}
 }
 
-static bool ipv6header_mt6_check(const struct xt_mtchk_param *par)
+static int ipv6header_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ipv6header_info *info = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index 0181eb8..d940804 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -62,7 +62,7 @@ static bool mh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
 }
 
-static bool mh_mt6_check(const struct xt_mtchk_param *par)
+static int mh_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_mh *mhinfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index c58d653..76397f3 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -183,7 +183,7 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool rt_mt6_check(const struct xt_mtchk_param *par)
+static int rt_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_rt *rtinfo = par->matchinfo;
 
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 6812865..3f9d0f4 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -84,7 +84,7 @@ connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
+static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_connsecmark_target_info *info = par->targinfo;
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 6509e03..c1553bf 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -53,7 +53,7 @@ static u8 xt_ct_find_proto(const struct xt_tgchk_param *par)
 		return 0;
 }
 
-static bool xt_ct_tg_check(const struct xt_tgchk_param *par)
+static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_ct_target_info *info = par->targinfo;
 	struct nf_conntrack_tuple t;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index bbf08a9..1fa7b67 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -60,7 +60,7 @@ dscp_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool dscp_tg_check(const struct xt_tgchk_param *par)
+static int dscp_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_DSCP_info *info = par->targinfo;
 
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 7004ed2..15ba161 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -101,7 +101,7 @@ hl_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool ttl_tg_check(const struct xt_tgchk_param *par)
+static int ttl_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_TTL_info *info = par->targinfo;
 
@@ -114,7 +114,7 @@ static bool ttl_tg_check(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static bool hl_tg6_check(const struct xt_tgchk_param *par)
+static int hl_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_HL_info *info = par->targinfo;
 
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index f511bea..1a3e3dd 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -80,7 +80,7 @@ static void led_timeout_callback(unsigned long data)
 	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
 }
 
-static bool led_tg_check(const struct xt_tgchk_param *par)
+static int led_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_led_info *ledinfo = par->targinfo;
 	struct xt_led_info_internal *ledinternal;
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index a57c5cf..13e6c00 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -37,7 +37,7 @@ nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool nflog_tg_check(const struct xt_tgchk_param *par)
+static int nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_nflog_info *info = par->targinfo;
 
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 7cc0de6..d435579 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -81,7 +81,7 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_QUEUE_NR(queue);
 }
 
-static bool nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
+static int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_NFQ_info_v1 *info = par->targinfo;
 	u32 maxid;
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 87ae97e..9743e50 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -85,7 +85,7 @@ xt_rateest_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
+static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 {
 	struct xt_rateest_target_info *info = par->targinfo;
 	struct xt_rateest *est;
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 4855fd9..48f8e4f 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -80,7 +80,7 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 	return true;
 }
 
-static bool secmark_tg_check(const struct xt_tgchk_param *par)
+static int secmark_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_secmark_target_info *info = par->targinfo;
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 45161d9..70288dc 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -234,7 +234,7 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
-static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
+static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
@@ -256,7 +256,7 @@ static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static bool tcpmss_tg6_check(const struct xt_tgchk_param *par)
+static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index e9244fd..189df9a 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -59,7 +59,7 @@ tproxy_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool tproxy_tg_check(const struct xt_tgchk_param *par)
+static int tproxy_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ip *i = par->entryinfo;
 
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 4c273e8..1f2c35e 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -132,7 +132,7 @@ xt_cluster_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	       !!(info->flags & XT_CLUSTER_F_INV);
 }
 
-static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
+static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_cluster_match_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index edb7bbd..136ef4c 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -93,7 +93,7 @@ connbytes_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		return what >= sinfo->count.from;
 }
 
-static bool connbytes_mt_check(const struct xt_mtchk_param *par)
+static int connbytes_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index d5b26da..a9fec38 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -216,7 +216,7 @@ connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool connlimit_mt_check(const struct xt_mtchk_param *par)
+static int connlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int i;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 7a51ba6..0e69427 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -74,7 +74,7 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connmark_tg_check(const struct xt_tgchk_param *par)
+static int connmark_tg_check(const struct xt_tgchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
@@ -103,7 +103,7 @@ connmark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool connmark_mt_check(const struct xt_mtchk_param *par)
+static int connmark_mt_check(const struct xt_mtchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 387172b..500e033 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -206,7 +206,7 @@ conntrack_mt_v2(const struct sk_buff *skb, const struct xt_match_param *par)
 	return conntrack_mt(skb, par, info->state_mask, info->status_mask);
 }
 
-static bool conntrack_mt_check(const struct xt_mtchk_param *par)
+static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 0989f29..1394deb 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -123,7 +123,7 @@ dccp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 
-static bool dccp_mt_check(const struct xt_mtchk_param *par)
+static int dccp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_dccp_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 6ecedc1..295da4c 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -42,7 +42,7 @@ dscp_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static bool dscp_mt_check(const struct xt_mtchk_param *par)
+static int dscp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 1a446d6..9f5da97 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -60,7 +60,7 @@ static bool esp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			 !!(espinfo->invflags & XT_ESP_INV_SPI));
 }
 
-static bool esp_mt_check(const struct xt_mtchk_param *par)
+static int esp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_esp *espinfo = par->matchinfo;
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 8f3e0c0..d13800c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -671,7 +671,7 @@ hashlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
+static int hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	struct net *net = par->net;
 	struct xt_hashlimit_info *r = par->matchinfo;
@@ -707,7 +707,7 @@ static bool hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
+static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct net *net = par->net;
 	struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 482aff2..6e177b2 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -54,7 +54,7 @@ helper_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool helper_mt_check(const struct xt_mtchk_param *par)
+static int helper_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_helper_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index b3dfca6..138a324 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -97,7 +97,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / XT_LIMIT_SCALE;
 }
 
-static bool limit_mt_check(const struct xt_mtchk_param *par)
+static int limit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_rateinfo *r = par->matchinfo;
 	struct xt_limit_priv *priv;
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 4fa90c8..b446738 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -152,7 +152,7 @@ check(u_int16_t proto,
 		&& count <= XT_MULTI_PORTS;
 }
 
-static bool multiport_mt_check_v0(const struct xt_mtchk_param *par)
+static int multiport_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport *multiinfo = par->matchinfo;
@@ -161,7 +161,7 @@ static bool multiport_mt_check_v0(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static bool multiport_mt_check(const struct xt_mtchk_param *par)
+static int multiport_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
@@ -170,7 +170,7 @@ static bool multiport_mt_check(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static bool multiport_mt6_check_v0(const struct xt_mtchk_param *par)
+static int multiport_mt6_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport *multiinfo = par->matchinfo;
@@ -179,7 +179,7 @@ static bool multiport_mt6_check_v0(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static bool multiport_mt6_check(const struct xt_mtchk_param *par)
+static int multiport_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 3d42a27..850e412 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -83,7 +83,7 @@ match_outdev:
 	return (!!ret ^ !(info->invert & XT_PHYSDEV_OP_OUT));
 }
 
-static bool physdev_mt_check(const struct xt_mtchk_param *par)
+static int physdev_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_physdev_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index de3aded..c9965b6 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -128,7 +128,7 @@ policy_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool policy_mt_check(const struct xt_mtchk_param *par)
+static int policy_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_policy_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 390b7d0..2861fac 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -43,7 +43,7 @@ quota_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool quota_mt_check(const struct xt_mtchk_param *par)
+static int quota_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_quota_info *q = par->matchinfo;
 
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 4fc6a91..3b5e3d6 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -74,7 +74,7 @@ xt_rateest_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
+static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_rateest_match_info *info = par->matchinfo;
 	struct xt_rateest *est1, *est2;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 8530944..52042c8 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -305,7 +305,7 @@ out:
 	return ret;
 }
 
-static bool recent_mt_check(const struct xt_mtchk_param *par)
+static int recent_mt_check(const struct xt_mtchk_param *par)
 {
 	struct recent_net *recent_net = recent_pernet(par->net);
 	const struct xt_recent_mtinfo *info = par->matchinfo;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 43c7e1d..f0a33bd 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -144,7 +144,7 @@ sctp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
-static bool sctp_mt_check(const struct xt_mtchk_param *par)
+static int sctp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_sctp_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 94893be..8b15b13 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -37,7 +37,7 @@ state_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (sinfo->statemask & statebit);
 }
 
-static bool state_mt_check(const struct xt_mtchk_param *par)
+static int state_mt_check(const struct xt_mtchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 51ac1bb..a577ab0 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -52,7 +52,7 @@ statistic_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool statistic_mt_check(const struct xt_mtchk_param *par)
+static int statistic_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_statistic_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index b4d7741..7d14121 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -40,7 +40,7 @@ string_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
 
-static bool string_mt_check(const struct xt_mtchk_param *par)
+static int string_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_string_info *conf = par->matchinfo;
 	struct ts_config *ts_conf;
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index b53887f..0072841 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -120,7 +120,7 @@ static bool tcp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool tcp_mt_check(const struct xt_mtchk_param *par)
+static int tcp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_tcp *tcpinfo = par->matchinfo;
 
@@ -155,7 +155,7 @@ static bool udp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			      !!(udpinfo->invflags & XT_UDP_INV_DSTPT));
 }
 
-static bool udp_mt_check(const struct xt_mtchk_param *par)
+static int udp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_udp *udpinfo = par->matchinfo;
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 9a9c9a3..fa5ab6e 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -217,7 +217,7 @@ time_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool time_mt_check(const struct xt_mtchk_param *par)
+static int time_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_time_info *info = par->matchinfo;
 
-- 
1.7.0.2

