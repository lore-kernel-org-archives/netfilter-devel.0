From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry return values
Date: Wed, 17 Mar 2010 14:18:57 +0100
Message-ID: <1268831945-6041-3-git-send-email-jengelh@medozas.de>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59344 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0CQNTS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:18 -0400
In-Reply-To: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When extended status codes are available, such as ENOMEM on failed
allocations, or subsequent functions (e.g. nf_ct_get_l3proto), passing
them up to userspace seems like a good idea compared to just always
EINVAL.

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
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |   13 +++++++------
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
 net/netfilter/x_tables.c             |   22 ++++++++++++++++++----
 net/netfilter/xt_CONNSECMARK.c       |    8 +++++---
 net/netfilter/xt_CT.c                |   13 ++++++++++---
 net/netfilter/xt_DSCP.c              |    2 +-
 net/netfilter/xt_HL.c                |    4 ++--
 net/netfilter/xt_LED.c               |   13 ++++---------
 net/netfilter/xt_NFLOG.c             |    2 +-
 net/netfilter/xt_NFQUEUE.c           |    2 +-
 net/netfilter/xt_RATEEST.c           |   11 +++++++----
 net/netfilter/xt_SECMARK.c           |   14 ++++++++------
 net/netfilter/xt_TCPMSS.c            |    4 ++--
 net/netfilter/xt_TPROXY.c            |    2 +-
 net/netfilter/xt_cluster.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    8 +++++---
 net/netfilter/xt_connlimit.c         |   10 ++++++----
 net/netfilter/xt_connmark.c          |   18 ++++++++++++------
 net/netfilter/xt_conntrack.c         |    9 ++++++---
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |    2 +-
 net/netfilter/xt_esp.c               |    2 +-
 net/netfilter/xt_hashlimit.c         |   33 ++++++++++++++++++++-------------
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_limit.c             |    4 ++--
 net/netfilter/xt_multiport.c         |    8 ++++----
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    4 ++--
 net/netfilter/xt_rateest.c           |    4 +++-
 net/netfilter/xt_recent.c            |    9 ++++++---
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_state.c             |    9 ++++++---
 net/netfilter/xt_statistic.c         |    4 ++--
 net/netfilter/xt_string.c            |    4 ++--
 net/netfilter/xt_tcpudp.c            |    4 ++--
 net/netfilter/xt_time.c              |    2 +-
 77 files changed, 198 insertions(+), 146 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 84c7c92..568677d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -297,7 +297,7 @@ struct xt_match {
 		      const struct xt_match_param *);
 
 	/* Called when user tries to insert an entry of this type. */
-	bool (*checkentry)(const struct xt_mtchk_param *);
+	int (*checkentry)(const struct xt_mtchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
@@ -338,8 +338,8 @@ struct xt_target {
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
            called. */
-	/* Should return true or false. */
-	bool (*checkentry)(const struct xt_tgchk_param *);
+	/* Can return either true or false, or an error code. */
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
index b595f09..682d277 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -171,7 +171,7 @@ ebt_among_mt(const struct sk_buff *skb, const struct xt_match_param *par)
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
index 05d0d0c..06563c8 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -90,7 +90,7 @@ ebt_ip6_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_ip6_mt_check(const struct xt_mtchk_param *par)
+static int ebt_ip6_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct ebt_ip6_info *info = par->matchinfo;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 7a81827..b8c5e69 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -64,7 +64,7 @@ user2credits(u_int32_t user)
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
index c6ac657..8253e4e 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -254,7 +254,7 @@ ebt_ulog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool ebt_ulog_tg_check(const struct xt_tgchk_param *par)
+static int ebt_ulog_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_ulog_info *uloginfo = par->targinfo;
 
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index be1dd2e..79b95f0 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -84,7 +84,7 @@ ebt_vlan_mt(const struct sk_buff *skb, const struct xt_match_param *par)
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
index b29c66d..afa94eb 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2184,7 +2184,7 @@ icmp_match(const struct sk_buff *skb, const struct xt_match_param *par)
 				    !!(icmpinfo->invflags&IPT_ICMP_INV));
 }
 
-static bool icmp_checkentry(const struct xt_mtchk_param *par)
+static int icmp_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct ipt_icmp *icmpinfo = par->matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 0886f96..e5977f7 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -347,12 +347,12 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool clusterip_tg_check(const struct xt_tgchk_param *par)
+static int clusterip_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
-
 	struct clusterip_config *config;
+	int ret;
 
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
@@ -386,7 +386,7 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 			dev = dev_get_by_name(&init_net, e->ip.iniface);
 			if (!dev) {
 				printk(KERN_WARNING "CLUSTERIP: no such interface %s\n", e->ip.iniface);
-				return false;
+				return -ENOENT;
 			}
 
 			config = clusterip_config_init(cipinfo,
@@ -394,17 +394,18 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 			if (!config) {
 				printk(KERN_WARNING "CLUSTERIP: cannot allocate config\n");
 				dev_put(dev);
-				return false;
+				return -ENOMEM;
 			}
 			dev_mc_add(config->dev,config->clustermac, ETH_ALEN, 0);
 		}
 	}
 	cipinfo->config = config;
 
-	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->target->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%u\n", par->target->family);
-		return false;
+		return ret;
 	}
 
 	return true;
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index ea5cea2..7e78fd3 100644
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
index ee128ef..1113fc5 100644
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
index 650b540..fa58726 100644
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
index 7c29582..e75dbe7 100644
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
index 698e5e7..aff6e67 100644
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
index 5113b8f..48e13e0 100644
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
index 09a5d3f..0074514 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -313,7 +313,7 @@ static void ipt_logfn(u_int8_t pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static bool ulog_tg_check(const struct xt_tgchk_param *par)
+static int ulog_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ulog_info *loginfo = par->targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 3b216be..454ab1a 100644
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
index 0104c0b..e9c736d 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -61,7 +61,7 @@ static bool ah_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			 !!(ahinfo->invflags & IPT_AH_INV_SPI));
 }
 
-static bool ah_mt_check(const struct xt_mtchk_param *par)
+static int ah_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ah *ahinfo = par->matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 2a1e56b..eb8442f 100644
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
index 9210e31..3ade0b7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2216,7 +2216,7 @@ icmp6_match(const struct sk_buff *skb, const struct xt_match_param *par)
 }
 
 /* Called when user tries to insert an entry of this type. */
-static bool icmp6_checkentry(const struct xt_mtchk_param *par)
+static int icmp6_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_icmp *icmpinfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index b285fdf..2f374d2 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -452,7 +452,7 @@ log_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 }
 
 
-static bool log_tg6_check(const struct xt_tgchk_param *par)
+static int log_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_log_info *loginfo = par->targinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index dd8afba..ec67465 100644
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
index ac0b7c6..4a23ba4 100644
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
index 7b91c25..41c901c 100644
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
index cbe8dec..252c9cd 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -160,7 +160,7 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
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
index aafe4e6..5847bdb 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -67,7 +67,7 @@ static bool mh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
 }
 
-static bool mh_mt6_check(const struct xt_mtchk_param *par)
+static int mh_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_mh *mhinfo = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index b77307f..31f2f54 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -183,7 +183,7 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool rt_mt6_check(const struct xt_mtchk_param *par)
+static int rt_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_rt *rtinfo = par->matchinfo;
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0a12ced..59bde81 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -360,6 +360,8 @@ static char *textify_hooks(char *buf, size_t size, unsigned int mask)
 int xt_check_match(struct xt_mtchk_param *par,
 		   unsigned int size, u_int8_t proto, bool inv_proto)
 {
+	int ret;
+
 	if (XT_ALIGN(par->match->matchsize) != size &&
 	    par->match->matchsize != -1) {
 		/*
@@ -396,8 +398,13 @@ int xt_check_match(struct xt_mtchk_param *par,
 		       par->match->proto);
 		return -EINVAL;
 	}
-	if (par->match->checkentry != NULL && !par->match->checkentry(par))
-		return -EINVAL;
+	if (par->match->checkentry != NULL) {
+		ret = par->match->checkentry(par);
+		if (ret < 0)
+			return ret;
+		else if (ret == 0)
+			return -EINVAL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_match);
@@ -517,6 +524,8 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
+	int ret;
+
 	if (XT_ALIGN(par->target->targetsize) != size) {
 		pr_err("%s_tables: %s.%u target: invalid size "
 		       "%u (kernel) != (user) %u\n",
@@ -548,8 +557,13 @@ int xt_check_target(struct xt_tgchk_param *par,
 		       par->target->proto);
 		return -EINVAL;
 	}
-	if (par->target->checkentry != NULL && !par->target->checkentry(par))
-		return -EINVAL;
+	if (par->target->checkentry != NULL) {
+		ret = par->target->checkentry(par);
+		if (ret < 0)
+			return ret;
+		else if (ret == false)
+			return -EINVAL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_target);
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index b54c375..9d86530 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -85,9 +85,10 @@ connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
+static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_connsecmark_target_info *info = par->targinfo;
+	int ret;
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
@@ -106,10 +107,11 @@ static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
 		return false;
 	}
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%u\n", par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 6509e03..da5b951 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -53,12 +53,13 @@ static u8 xt_ct_find_proto(const struct xt_tgchk_param *par)
 		return 0;
 }
 
-static bool xt_ct_tg_check(const struct xt_tgchk_param *par)
+static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_ct_target_info *info = par->targinfo;
 	struct nf_conntrack_tuple t;
 	struct nf_conn_help *help;
 	struct nf_conn *ct;
+	int ret = 0;
 	u8 proto;
 
 	if (info->flags & ~XT_CT_NOTRACK)
@@ -75,28 +76,34 @@ static bool xt_ct_tg_check(const struct xt_tgchk_param *par)
 		goto err1;
 #endif
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0)
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0)
 		goto err1;
 
 	memset(&t, 0, sizeof(t));
 	ct = nf_conntrack_alloc(par->net, info->zone, &t, &t, GFP_KERNEL);
+	ret = PTR_ERR(ct);
 	if (IS_ERR(ct))
 		goto err2;
 
+	ret = 0;
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
 				  GFP_KERNEL))
 		goto err3;
 
 	if (info->helper[0]) {
+		ret = -ENOENT;
 		proto = xt_ct_find_proto(par);
 		if (!proto)
 			goto err3;
 
+		ret = -ENOMEM;
 		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 		if (help == NULL)
 			goto err3;
 
+		ret = -ENOENT;
 		help->helper = nf_conntrack_helper_try_module_get(info->helper,
 								  par->family,
 								  proto);
@@ -115,7 +122,7 @@ err3:
 err2:
 	nf_ct_l3proto_module_put(par->family);
 err1:
-	return false;
+	return ret;
 }
 
 static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 74ce892..e37ca94 100644
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
index 10e789e..601321e 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -101,7 +101,7 @@ hl_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool ttl_tg_check(const struct xt_tgchk_param *par)
+static int ttl_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_TTL_info *info = par->targinfo;
 
@@ -115,7 +115,7 @@ static bool ttl_tg_check(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static bool hl_tg6_check(const struct xt_tgchk_param *par)
+static int hl_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_HL_info *info = par->targinfo;
 
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index f86dc52..f776f52 100644
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
@@ -94,7 +94,7 @@ static bool led_tg_check(const struct xt_tgchk_param *par)
 	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
 	if (!ledinternal) {
 		printk(KERN_CRIT KBUILD_MODNAME ": out of memory\n");
-		return false;
+		return -ENOMEM;
 	}
 
 	ledinternal->netfilter_led_trigger.name = ledinfo->id;
@@ -106,7 +106,8 @@ static bool led_tg_check(const struct xt_tgchk_param *par)
 		if (err == -EEXIST)
 			printk(KERN_ERR KBUILD_MODNAME
 				": Trigger name is already in use.\n");
-		goto exit_alloc;
+		kfree(ledinternal);
+		return err;
 	}
 
 	/* See if we need to set up a timer */
@@ -115,13 +116,7 @@ static bool led_tg_check(const struct xt_tgchk_param *par)
 			    (unsigned long)ledinfo);
 
 	ledinfo->internal_data = ledinternal;
-
 	return true;
-
-exit_alloc:
-	kfree(ledinternal);
-
-	return false;
 }
 
 static void led_tg_destroy(const struct xt_tgdtor_param *par)
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
index a37e216..5e503b1 100644
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
index 87ae97e..3c5d1c9 100644
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
@@ -93,6 +93,7 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		struct nlattr		opt;
 		struct gnet_estimator	est;
 	} cfg;
+	int ret;
 
 	if (unlikely(!rnd_inited)) {
 		get_random_bytes(&jhash_rnd, sizeof(jhash_rnd));
@@ -115,6 +116,7 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		return true;
 	}
 
+	ret = -ENOMEM;
 	est = kzalloc(sizeof(*est), GFP_KERNEL);
 	if (!est)
 		goto err1;
@@ -130,8 +132,9 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	cfg.est.interval	= info->interval;
 	cfg.est.ewma_log	= info->ewma_log;
 
-	if (gen_new_estimator(&est->bstats, &est->rstats, &est->lock,
-			      &cfg.opt) < 0)
+	ret = gen_new_estimator(&est->bstats, &est->rstats,
+				&est->lock, &cfg.opt);
+	if (ret < 0)
 		goto err2;
 
 	info->est = est;
@@ -142,7 +145,7 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 err2:
 	kfree(est);
 err1:
-	return false;
+	return ret;
 }
 
 static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 7a6f9e6..acb2b98 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -49,7 +49,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool checkentry_selinux(struct xt_secmark_target_info *info)
+static int checkentry_selinux(struct xt_secmark_target_info *info)
 {
 	int err;
 	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
@@ -61,7 +61,7 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 		if (err == -EINVAL)
 			printk(KERN_INFO PFX "invalid SELinux context \'%s\'\n",
 			       sel->selctx);
-		return false;
+		return err;
 	}
 
 	if (!sel->selsid) {
@@ -73,16 +73,17 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 	err = selinux_secmark_relabel_packet_permission(sel->selsid);
 	if (err) {
 		printk(KERN_INFO PFX "unable to obtain relabeling permission\n");
-		return false;
+		return err;
 	}
 
 	selinux_secmark_refcount_inc();
 	return true;
 }
 
-static bool secmark_tg_check(const struct xt_tgchk_param *par)
+static int secmark_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_secmark_target_info *info = par->targinfo;
+	int err;
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
@@ -99,8 +100,9 @@ static bool secmark_tg_check(const struct xt_tgchk_param *par)
 
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
-		if (!checkentry_selinux(info))
-			return false;
+		err = checkentry_selinux(info);
+		if (err <= 0)
+			return err;
 		break;
 
 	default:
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 0e357ac..5f69a20 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -235,7 +235,7 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
-static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
+static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
@@ -257,7 +257,7 @@ static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static bool tcpmss_tg6_check(const struct xt_tgchk_param *par)
+static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 1340c2f..bb4d385 100644
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
index 225ee3e..f049121 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -131,7 +131,7 @@ xt_cluster_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	       !!(info->flags & XT_CLUSTER_F_INV);
 }
 
-static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
+static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_cluster_match_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 955e659..697fd4a 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -92,9 +92,10 @@ connbytes_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		return what >= sinfo->count.from;
 }
 
-static bool connbytes_mt_check(const struct xt_mtchk_param *par)
+static int connbytes_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
+	int ret;
 
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
@@ -106,10 +107,11 @@ static bool connbytes_mt_check(const struct xt_mtchk_param *par)
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
 		return false;
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%u\n", par->family);
-		return false;
+		return ret;
 	}
 
 	return true;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 9e624af..ead25e3 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -215,26 +215,28 @@ connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool connlimit_mt_check(const struct xt_mtchk_param *par)
+static int connlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int i;
+	int ret;
 
 	if (unlikely(!connlimit_rnd_inited)) {
 		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
 		connlimit_rnd_inited = true;
 	}
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
 		       "address family %u\n", par->family);
-		return false;
+		return ret;
 	}
 
 	/* init private data */
 	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
 	if (info->data == NULL) {
 		nf_ct_l3proto_module_put(par->family);
-		return false;
+		return -ENOMEM;
 	}
 
 	spin_lock_init(&info->data->lock);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 97465a4..4d59846 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -74,12 +74,15 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connmark_tg_check(const struct xt_tgchk_param *par)
+static int connmark_tg_check(const struct xt_tgchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
 		       "proto=%u\n", par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
@@ -103,12 +106,15 @@ connmark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool connmark_mt_check(const struct xt_mtchk_param *par)
+static int connmark_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
 		       "proto=%u\n", par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index ae66305..60fc99f 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -206,12 +206,15 @@ conntrack_mt_v2(const struct sk_buff *skb, const struct xt_match_param *par)
 	return conntrack_mt(skb, par, info->state_mask, info->status_mask);
 }
 
-static bool conntrack_mt_check(const struct xt_mtchk_param *par)
+static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%u\n", par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
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
index 0280d3a..e29b1b2 100644
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
index 6094399..990a824 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -66,7 +66,7 @@ static bool esp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			 !!(espinfo->invflags & XT_ESP_INV_SPI));
 }
 
-static bool esp_mt_check(const struct xt_mtchk_param *par)
+static int esp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_esp *espinfo = par->matchinfo;
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 8032463..9ec2ad5 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -217,7 +217,7 @@ static int htable_create_v0(struct net *net, struct xt_hashlimit_info *minfo, u_
 			sizeof(struct list_head) * size);
 	if (!hinfo) {
 		printk(KERN_ERR "xt_hashlimit: unable to create hashtable\n");
-		return -1;
+		return -ENOMEM;
 	}
 	minfo->hinfo = hinfo;
 
@@ -254,7 +254,7 @@ static int htable_create_v0(struct net *net, struct xt_hashlimit_info *minfo, u_
 		&dl_file_ops, hinfo);
 	if (!hinfo->pde) {
 		vfree(hinfo);
-		return -1;
+		return -ENOMEM;
 	}
 	hinfo->net = net;
 
@@ -290,7 +290,7 @@ static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 	                sizeof(struct list_head) * size);
 	if (hinfo == NULL) {
 		printk(KERN_ERR "xt_hashlimit: unable to create hashtable\n");
-		return -1;
+		return -ENOMEM;
 	}
 	minfo->hinfo = hinfo;
 
@@ -317,7 +317,7 @@ static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 		&dl_file_ops, hinfo);
 	if (hinfo->pde == NULL) {
 		vfree(hinfo);
-		return -1;
+		return -ENOMEM;
 	}
 	hinfo->net = net;
 
@@ -677,10 +677,11 @@ hashlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
+static int hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	struct net *net = par->net;
 	struct xt_hashlimit_info *r = par->matchinfo;
+	int ret;
 
 	/* Check for overflow. */
 	if (r->cfg.burst == 0 ||
@@ -704,19 +705,22 @@ static bool hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 
 	mutex_lock(&hashlimit_mutex);
 	r->hinfo = htable_find_get(net, r->name, par->match->family);
-	if (!r->hinfo && htable_create_v0(net, r, par->match->family) != 0) {
-		mutex_unlock(&hashlimit_mutex);
-		return false;
+	if (r->hinfo == NULL) {
+		ret = htable_create_v0(net, r, par->match->family);
+		if (ret < 0) {
+			mutex_unlock(&hashlimit_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
-
 	return true;
 }
 
-static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
+static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct net *net = par->net;
 	struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
+	int ret;
 
 	/* Check for overflow. */
 	if (info->cfg.burst == 0 ||
@@ -740,9 +744,12 @@ static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
 
 	mutex_lock(&hashlimit_mutex);
 	info->hinfo = htable_find_get(net, info->name, par->match->family);
-	if (!info->hinfo && htable_create(net, info, par->match->family) != 0) {
-		mutex_unlock(&hashlimit_mutex);
-		return false;
+	if (info->hinfo == NULL) {
+		ret = htable_create(net, info, par->match->family);
+		if (ret < 0) {
+			mutex_unlock(&hashlimit_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
 	return true;
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 64fc7f2..ce05d3a 100644
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
index a0ca533..9638de3 100644
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
@@ -112,7 +112,7 @@ static bool limit_mt_check(const struct xt_mtchk_param *par)
 
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL)
-		return false;
+		return -ENOMEM;
 
 	/* For SMP, we only want to use one set of state. */
 	r->master = priv;
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index d06bb2d..75d9ad4 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -158,7 +158,7 @@ check(u_int16_t proto,
 		&& count <= XT_MULTI_PORTS;
 }
 
-static bool multiport_mt_check_v0(const struct xt_mtchk_param *par)
+static int multiport_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport *multiinfo = par->matchinfo;
@@ -167,7 +167,7 @@ static bool multiport_mt_check_v0(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static bool multiport_mt_check(const struct xt_mtchk_param *par)
+static int multiport_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
@@ -176,7 +176,7 @@ static bool multiport_mt_check(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static bool multiport_mt6_check_v0(const struct xt_mtchk_param *par)
+static int multiport_mt6_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport *multiinfo = par->matchinfo;
@@ -185,7 +185,7 @@ static bool multiport_mt6_check_v0(const struct xt_mtchk_param *par)
 		     multiinfo->count);
 }
 
-static bool multiport_mt6_check(const struct xt_mtchk_param *par)
+static int multiport_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 8d28ca5..ecce894 100644
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
index 4cbfebd..e4bd7c7 100644
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
index 390b7d0..d61f05d 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -43,7 +43,7 @@ quota_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool quota_mt_check(const struct xt_mtchk_param *par)
+static int quota_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_quota_info *q = par->matchinfo;
 
@@ -52,7 +52,7 @@ static bool quota_mt_check(const struct xt_mtchk_param *par)
 
 	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
 	if (q->master == NULL)
-		return false;
+		return -ENOMEM;
 
 	q->master->quota = q->quota;
 	return true;
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 4fc6a91..9badfa6 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -74,10 +74,11 @@ xt_rateest_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
+static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_rateest_match_info *info = par->matchinfo;
 	struct xt_rateest *est1, *est2;
+	int ret = false;
 
 	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
 				     XT_RATEEST_MATCH_REL)) != 1)
@@ -95,6 +96,7 @@ static bool xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 		goto err1;
 	}
 
+	ret  = -ENOENT;
 	est1 = xt_rateest_lookup(info->name1);
 	if (!est1)
 		goto err1;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index b65eca9..deef3bc 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -304,7 +304,7 @@ out:
 	return ret;
 }
 
-static bool recent_mt_check(const struct xt_mtchk_param *par)
+static int recent_mt_check(const struct xt_mtchk_param *par)
 {
 	struct recent_net *recent_net = recent_pernet(par->net);
 	const struct xt_recent_mtinfo *info = par->matchinfo;
@@ -313,7 +313,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	struct proc_dir_entry *pde;
 #endif
 	unsigned i;
-	bool ret = false;
+	int ret = false;
 
 	if (unlikely(!hash_rnd_inited)) {
 		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
@@ -349,8 +349,10 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 
 	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
 		    GFP_KERNEL);
-	if (t == NULL)
+	if (t == NULL) {
+		ret = -ENOMEM;
 		goto out;
+	}
 	t->refcnt = 1;
 	strcpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
@@ -361,6 +363,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 		  &recent_mt_fops, t);
 	if (pde == NULL) {
 		kfree(t);
+		ret = -ENOMEM;
 		goto out;
 	}
 	pde->uid = ip_list_uid;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index a189ada..3d2d1b8 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -147,7 +147,7 @@ sctp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
-static bool sctp_mt_check(const struct xt_mtchk_param *par)
+static int sctp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_sctp_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 4c946cb..f4205f3 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -37,12 +37,15 @@ state_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (sinfo->statemask & statebit);
 }
 
-static bool state_mt_check(const struct xt_mtchk_param *par)
+static int state_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->match->family);
+	if (ret < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%u\n", par->match->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index d8c0f8f..43f0d42 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -52,7 +52,7 @@ statistic_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool statistic_mt_check(const struct xt_mtchk_param *par)
+static int statistic_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_statistic_info *info = par->matchinfo;
 
@@ -63,7 +63,7 @@ static bool statistic_mt_check(const struct xt_mtchk_param *par)
 	info->master = kzalloc(sizeof(*info->master), GFP_KERNEL);
 	if (info->master == NULL) {
 		printk(KERN_ERR KBUILD_MODNAME ": Out of memory\n");
-		return false;
+		return -ENOMEM;
 	}
 	info->master->count = info->u.nth.count;
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index b4d7741..fa7d066 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -40,7 +40,7 @@ string_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
 
-static bool string_mt_check(const struct xt_mtchk_param *par)
+static int string_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_string_info *conf = par->matchinfo;
 	struct ts_config *ts_conf;
@@ -63,7 +63,7 @@ static bool string_mt_check(const struct xt_mtchk_param *par)
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
 				     GFP_KERNEL, flags);
 	if (IS_ERR(ts_conf))
-		return false;
+		return PTR_ERR(ts_conf);
 
 	conf->config = ts_conf;
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 1ebdc49..7ec34ee 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -126,7 +126,7 @@ static bool tcp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool tcp_mt_check(const struct xt_mtchk_param *par)
+static int tcp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_tcp *tcpinfo = par->matchinfo;
 
@@ -161,7 +161,7 @@ static bool udp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
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

