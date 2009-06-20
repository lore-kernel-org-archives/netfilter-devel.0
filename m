From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/6] ebtables specific extensions
Date: Sat, 20 Jun 2009 23:59:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906202358050.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37271 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbZFTV7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:59:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 8BBDE188224
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2009 23:59:09 +0200 (CEST)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nLToSNUgBBox for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Jun 2009 23:59:09 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 6D89A18821F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2009 23:59:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ebtables specific extensions with the new error reporting
methods.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 include/linux/netfilter_bridge/ebt_802_3.h    |    6 ++++++
 include/linux/netfilter_bridge/ebt_among.h    |    8 ++++++++
 include/linux/netfilter_bridge/ebt_arp.h      |    7 +++++++
 include/linux/netfilter_bridge/ebt_arpreply.h |    9 +++++++++
 include/linux/netfilter_bridge/ebt_ip.h       |   11 +++++++++++
 include/linux/netfilter_bridge/ebt_ip6.h      |   11 +++++++++++
 include/linux/netfilter_bridge/ebt_limit.h    |    6 ++++++
 include/linux/netfilter_bridge/ebt_log.h      |    7 +++++++
 include/linux/netfilter_bridge/ebt_mark_m.h   |    9 +++++++++
 include/linux/netfilter_bridge/ebt_mark_t.h   |    8 ++++++++
 include/linux/netfilter_bridge/ebt_nat.h      |   13 +++++++++++++
 include/linux/netfilter_bridge/ebt_pkttype.h  |    6 ++++++
 include/linux/netfilter_bridge/ebt_redirect.h |   11 +++++++++++
 include/linux/netfilter_bridge/ebt_stp.h      |    7 +++++++
 include/linux/netfilter_bridge/ebt_ulog.h     |    6 ++++++
 include/linux/netfilter_bridge/ebt_vlan.h     |   11 +++++++++++
 net/bridge/netfilter/ebt_802_3.c              |    6 +++---
 net/bridge/netfilter/ebt_among.c              |   23 +++++++++++------------
 net/bridge/netfilter/ebt_arp.c                |    8 ++++----
 net/bridge/netfilter/ebt_arpreply.c           |   22 ++++++++++++++++------
 net/bridge/netfilter/ebt_dnat.c               |   25 ++++++++++++++-----------
 net/bridge/netfilter/ebt_ip.c                 |   16 ++++++++--------
 net/bridge/netfilter/ebt_ip6.c                |   16 ++++++++--------
 net/bridge/netfilter/ebt_limit.c              |    8 ++++----
 net/bridge/netfilter/ebt_log.c                |    8 ++++----
 net/bridge/netfilter/ebt_mark.c               |   10 +++++-----
 net/bridge/netfilter/ebt_mark_m.c             |   10 +++++-----
 net/bridge/netfilter/ebt_nflog.c              |    2 +-
 net/bridge/netfilter/ebt_pkttype.c            |    6 +++---
 net/bridge/netfilter/ebt_redirect.c           |   25 ++++++++++++++-----------
 net/bridge/netfilter/ebt_snat.c               |   19 ++++++++++++-------
 net/bridge/netfilter/ebt_stp.c                |    8 ++++----
 net/bridge/netfilter/ebt_ulog.c               |    6 +++---
 net/bridge/netfilter/ebt_vlan.c               |   16 ++++++++--------
 34 files changed, 263 insertions(+), 107 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
index a11b0c2..9cf4c09 100644
--- a/include/linux/netfilter_bridge/ebt_802_3.h
+++ b/include/linux/netfilter_bridge/ebt_802_3.h
@@ -22,6 +22,12 @@
 
 #define EBT_802_3_MASK (EBT_802_3_SAP | EBT_802_3_TYPE | EBT_802_3)
 
+enum {
+	EBT_802_ERR_NONE,
+	EBT_802_ERR_FLAGS,
+	EBT_802_ERR_MAX,
+};
+
 /* ui has one byte ctrl, ni has two */
 struct hdr_ui {
 	uint8_t dsap;
diff --git a/include/linux/netfilter_bridge/ebt_among.h b/include/linux/netfilter_bridge/ebt_among.h
index 7654069..27c7a07 100644
--- a/include/linux/netfilter_bridge/ebt_among.h
+++ b/include/linux/netfilter_bridge/ebt_among.h
@@ -29,6 +29,14 @@
  * Yes, it is a memory overhead, but in 2003 AD, who cares?
  */
 
+enum {
+	EBT_AMONG_ERR_NONE,
+	EBT_AMONG_ERR_SIZE,
+	EBT_AMONG_ERR_DST_INTEGRITY,
+	EBT_AMONG_ERR_SRC_INTEGRITY,
+	EBT_AMONG_ERR_MAX,
+};
+
 struct ebt_mac_wormhash_tuple
 {
 	uint32_t cmp[2];
diff --git a/include/linux/netfilter_bridge/ebt_arp.h b/include/linux/netfilter_bridge/ebt_arp.h
index cbf4843..6dfe874 100644
--- a/include/linux/netfilter_bridge/ebt_arp.h
+++ b/include/linux/netfilter_bridge/ebt_arp.h
@@ -14,6 +14,13 @@
    EBT_ARP_GRAT)
 #define EBT_ARP_MATCH "arp"
 
+enum {
+	EBT_ARP_ERR_NONE,
+	EBT_ARP_ERR_PROTO,
+	EBT_ARP_ERR_FLAGS,
+	EBT_ARP_ERR_MAX,
+};
+
 struct ebt_arp_info
 {
 	__be16 htype;
diff --git a/include/linux/netfilter_bridge/ebt_arpreply.h b/include/linux/netfilter_bridge/ebt_arpreply.h
index 96a8339..9c6d047 100644
--- a/include/linux/netfilter_bridge/ebt_arpreply.h
+++ b/include/linux/netfilter_bridge/ebt_arpreply.h
@@ -1,6 +1,15 @@
 #ifndef __LINUX_BRIDGE_EBT_ARPREPLY_H
 #define __LINUX_BRIDGE_EBT_ARPREPLY_H
 
+enum  {
+	EBT_ARPREPLY_ERR_NONE,
+	EBT_ARPREPLY_ERR_NAT_TABLE,
+	EBT_ARPREPLY_ERR_HOOKS_0,
+	EBT_ARPREPLY_ERR_BASE,
+	EBT_ARPREPLY_ERR_PROTO,
+	EBT_ARPREPLY_ERR_MAX,
+};
+
 struct ebt_arpreply_info
 {
 	unsigned char mac[ETH_ALEN];
diff --git a/include/linux/netfilter_bridge/ebt_ip.h b/include/linux/netfilter_bridge/ebt_ip.h
index d684747..fedcfc7 100644
--- a/include/linux/netfilter_bridge/ebt_ip.h
+++ b/include/linux/netfilter_bridge/ebt_ip.h
@@ -25,6 +25,17 @@
  EBT_IP_SPORT | EBT_IP_DPORT )
 #define EBT_IP_MATCH "ip"
 
+enum {
+	EBT_IP_ERR_NONE,
+	EBT_IP_ERR_PROTO,
+	EBT_IP_ERR_FLAGS,
+	EBT_IP_ERR_PROTO_PORT,
+	EBT_IP_ERR_NOT_TRANSPORT,
+	EBT_IP_ERR_DPORT_RANGE,
+	EBT_IP_ERR_SPORT_RANGE,
+	EBT_IP_ERR_MAX,
+};
+
 /* the same values are used for the invflags */
 struct ebt_ip_info
 {
diff --git a/include/linux/netfilter_bridge/ebt_ip6.h b/include/linux/netfilter_bridge/ebt_ip6.h
index 2273c3a..5c8c457 100644
--- a/include/linux/netfilter_bridge/ebt_ip6.h
+++ b/include/linux/netfilter_bridge/ebt_ip6.h
@@ -22,6 +22,17 @@
 		      EBT_IP6_PROTO | EBT_IP6_SPORT | EBT_IP6_DPORT)
 #define EBT_IP6_MATCH "ip6"
 
+enum {
+	EBT_IP6_ERR_NONE,
+	EBT_IP6_ERR_PROTO,
+	EBT_IP6_ERR_FLAGS,
+	EBT_IP6_ERR_PROTO_PORT,
+	EBT_IP6_ERR_NOT_TRANSPORT,
+	EBT_IP6_ERR_DPORT_RANGE,
+	EBT_IP6_ERR_SPORT_RANGE,
+	EBT_IP6_ERR_MAX,
+};
+
 /* the same values are used for the invflags */
 struct ebt_ip6_info
 {
diff --git a/include/linux/netfilter_bridge/ebt_limit.h b/include/linux/netfilter_bridge/ebt_limit.h
index d8b6500..ed8c1cf 100644
--- a/include/linux/netfilter_bridge/ebt_limit.h
+++ b/include/linux/netfilter_bridge/ebt_limit.h
@@ -9,6 +9,12 @@
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 
+enum {
+	EBT_LIMIT_ERR_NONE,
+	EBT_LIMIT_ERR_OVERFLOW,
+	EBT_LIMIT_ERR_MAX,
+};
+
 struct ebt_limit_info
 {
 	u_int32_t avg;    /* Average secs between packets * scale */
diff --git a/include/linux/netfilter_bridge/ebt_log.h b/include/linux/netfilter_bridge/ebt_log.h
index b76e653..cc60c02 100644
--- a/include/linux/netfilter_bridge/ebt_log.h
+++ b/include/linux/netfilter_bridge/ebt_log.h
@@ -9,6 +9,13 @@
 #define EBT_LOG_PREFIX_SIZE 30
 #define EBT_LOG_WATCHER "log"
 
+enum {
+	EBT_LOG_ERR_NONE,
+	EBT_LOG_ERR_MASK,
+	EBT_LOG_ERR_LOGLEVEL,
+	EBT_LOG_ERR_MAX,
+};
+
 struct ebt_log_info
 {
 	uint8_t loglevel;
diff --git a/include/linux/netfilter_bridge/ebt_mark_m.h b/include/linux/netfilter_bridge/ebt_mark_m.h
index 301524f..877ef45 100644
--- a/include/linux/netfilter_bridge/ebt_mark_m.h
+++ b/include/linux/netfilter_bridge/ebt_mark_m.h
@@ -4,6 +4,15 @@
 #define EBT_MARK_AND 0x01
 #define EBT_MARK_OR 0x02
 #define EBT_MARK_MASK (EBT_MARK_AND | EBT_MARK_OR)
+
+enum {
+	EBT_MARK_ERR_NONE,
+	EBT_MARK_ERR_BITMASK,
+	EBT_MARK_ERR_AND_OR,
+	EBT_MARK_ERR_EMTPY_BITMASK,
+	EBT_MARK_ERR_MAX,
+};
+
 struct ebt_mark_m_info
 {
 	unsigned long mark, mask;
diff --git a/include/linux/netfilter_bridge/ebt_mark_t.h b/include/linux/netfilter_bridge/ebt_mark_t.h
index 6270f6f..fb52d4b 100644
--- a/include/linux/netfilter_bridge/ebt_mark_t.h
+++ b/include/linux/netfilter_bridge/ebt_mark_t.h
@@ -13,6 +13,14 @@
 #define MARK_AND_VALUE (0xffffffd0)
 #define MARK_XOR_VALUE (0xffffffc0)
 
+enum {
+	EBT_MARK_ERR_NONE,
+	EBT_MARK_ERR_BASE,
+	EBT_MARK_ERR_STANDARD,
+	EBT_MARK_ERR_VERDICT,
+	EBT_MARK_ERR_MAX,
+};
+
 struct ebt_mark_t_info
 {
 	unsigned long mark;
diff --git a/include/linux/netfilter_bridge/ebt_nat.h b/include/linux/netfilter_bridge/ebt_nat.h
index 435b886..e317574 100644
--- a/include/linux/netfilter_bridge/ebt_nat.h
+++ b/include/linux/netfilter_bridge/ebt_nat.h
@@ -1,6 +1,19 @@
 #ifndef __LINUX_BRIDGE_EBT_NAT_H
 #define __LINUX_BRIDGE_EBT_NAT_H
 
+enum {
+	EBT_NAT_ERR_NONE,
+	EBT_NAT_ERR_DNAT_NAT_BROUTE_TABLE,
+	EBT_NAT_ERR_DNAT_NAT_HOOKS_02,
+	EBT_NAT_ERR_DNAT_BROUTE_HOOKS_5,
+	EBT_NAT_ERR_SNAT_NAT_TABLE,
+	EBT_NAT_ERR_SNAT_NAT_HOOKS_4,
+	EBT_NAT_ERR_BASE,
+	EBT_NAT_ERR_STANDARD,
+	EBT_NAT_ERR_TARGET,
+	EBT_NAT_ERR_MAX,
+};
+
 #define NAT_ARP_BIT  (0x00000010)
 struct ebt_nat_info
 {
diff --git a/include/linux/netfilter_bridge/ebt_pkttype.h b/include/linux/netfilter_bridge/ebt_pkttype.h
index 0d64bbb..161673c 100644
--- a/include/linux/netfilter_bridge/ebt_pkttype.h
+++ b/include/linux/netfilter_bridge/ebt_pkttype.h
@@ -1,6 +1,12 @@
 #ifndef __LINUX_BRIDGE_EBT_PKTTYPE_H
 #define __LINUX_BRIDGE_EBT_PKTTYPE_H
 
+enum {
+	EBT_PKTTYPE_ERR_NONE,
+	EBT_PKTTYPE_ERR_FLAGS,
+	EBT_PKTTYPE_ERR_MAX,
+};
+
 struct ebt_pkttype_info
 {
 	uint8_t pkt_type;
diff --git a/include/linux/netfilter_bridge/ebt_redirect.h b/include/linux/netfilter_bridge/ebt_redirect.h
index 5c67990..ca12ef4 100644
--- a/include/linux/netfilter_bridge/ebt_redirect.h
+++ b/include/linux/netfilter_bridge/ebt_redirect.h
@@ -1,6 +1,17 @@
 #ifndef __LINUX_BRIDGE_EBT_REDIRECT_H
 #define __LINUX_BRIDGE_EBT_REDIRECT_H
 
+enum {
+	EBT_REDIRECT_ERR_NONE,
+	EBT_REDIRECT_ERR_NAT_BROUTE_TABLE,
+	EBT_REDIRECT_ERR_NAT_HOOKS_0,
+	EBT_REDIRECT_ERR_BROUTE_HOOKS_5,
+	EBT_REDIRECT_ERR_BASE,
+	EBT_REDIRECT_ERR_STANDARD,
+	EBT_REDIRECT_ERR_TARGET,
+	EBT_REDIRECT_ERR_MAX,
+};
+
 struct ebt_redirect_info
 {
 	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
diff --git a/include/linux/netfilter_bridge/ebt_stp.h b/include/linux/netfilter_bridge/ebt_stp.h
index e5fd678..11fb851 100644
--- a/include/linux/netfilter_bridge/ebt_stp.h
+++ b/include/linux/netfilter_bridge/ebt_stp.h
@@ -20,6 +20,13 @@
 
 #define EBT_STP_MATCH "stp"
 
+enum {
+	EBT_STP_ERR_NONE,
+	EBT_STP_ERR_FLAGS,
+	EBT_STP_ERR_FRAMES,
+	EBT_STP_ERR_MAX,
+};
+
 struct ebt_stp_config_info
 {
 	uint8_t flags;
diff --git a/include/linux/netfilter_bridge/ebt_ulog.h b/include/linux/netfilter_bridge/ebt_ulog.h
index b677e26..058546d 100644
--- a/include/linux/netfilter_bridge/ebt_ulog.h
+++ b/include/linux/netfilter_bridge/ebt_ulog.h
@@ -9,6 +9,12 @@
 #define EBT_ULOG_WATCHER "ulog"
 #define EBT_ULOG_VERSION 1
 
+enum {
+	EBT_ULOG_ERR_NONE,
+	EBT_ULOG_ERR_NLGROUP,
+	EBT_ULOG_ERR_MAX,
+};
+
 struct ebt_ulog_info {
 	uint32_t nlgroup;
 	unsigned int cprange;
diff --git a/include/linux/netfilter_bridge/ebt_vlan.h b/include/linux/netfilter_bridge/ebt_vlan.h
index 1d98be4..d656241 100644
--- a/include/linux/netfilter_bridge/ebt_vlan.h
+++ b/include/linux/netfilter_bridge/ebt_vlan.h
@@ -7,6 +7,17 @@
 #define EBT_VLAN_MASK (EBT_VLAN_ID | EBT_VLAN_PRIO | EBT_VLAN_ENCAP)
 #define EBT_VLAN_MATCH "vlan"
 
+enum {
+	EBT_VLAN_ERR_NONE,
+	EBT_VLAN_ERR_8021Q,
+	EBT_VLAN_ERR_BITMASK,
+	EBT_VLAN_ERR_INVFLAGS,
+	EBT_VLAN_ERR_ID_RANGE,
+	EBT_VLAN_ERR_PRIO_RANGE,
+	EBT_VLAN_ERR_ENCAP,
+	EBT_VLAN_ERR_MAX,
+};
+
 struct ebt_vlan_info {
 	uint16_t id;		/* VLAN ID {1-4095} */
 	uint8_t prio;		/* VLAN User Priority {0-7} */
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index bd91dc5..b4d6cad 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -36,14 +36,14 @@ ebt_802_3_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_802_3_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_802_3_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_802_3_info *info = par->matchinfo;
 
 	if (info->bitmask & ~EBT_802_3_MASK || info->invflags & ~EBT_802_3_MASK)
-		return false;
+		return EBT_802_ERR_FLAGS;
 
-	return true;
+	return EBT_802_ERR_NONE;
 }
 
 static struct xt_match ebt_802_3_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index b595f09..2e047a3 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -171,7 +171,7 @@ ebt_among_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_among_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_among_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_among_info *info = par->matchinfo;
 	const struct ebt_entry_match *em =
@@ -186,24 +186,23 @@ static bool ebt_among_mt_check(const struct xt_mtchk_param *par)
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
 	if (em->match_size != EBT_ALIGN(expected_length)) {
-		printk(KERN_WARNING
-		       "ebtables: among: wrong size: %d "
-		       "against expected %d, rounded to %Zd\n",
+		xt_compat_log(par, "ebtables: among: wrong size: %d "
+		       "against expected %d, rounded to %Zd",
 		       em->match_size, expected_length,
 		       EBT_ALIGN(expected_length));
-		return false;
+		return EBT_AMONG_ERR_SIZE;
 	}
 	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
-		printk(KERN_WARNING
-		       "ebtables: among: dst integrity fail: %x\n", -err);
-		return false;
+		xt_compat_log(par, "ebtables: among: dst integrity fail: %x",
+			      -err);
+		return EBT_AMONG_ERR_DST_INTEGRITY;
 	}
 	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
-		printk(KERN_WARNING
-		       "ebtables: among: src integrity fail: %x\n", -err);
-		return false;
+		xt_compat_log(par, "ebtables: among: src integrity fail: %x",
+			      -err);
+		return EBT_AMONG_ERR_SRC_INTEGRITY;
 	}
-	return true;
+	return EBT_AMONG_ERR_NONE;
 }
 
 static struct xt_match ebt_among_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index b7ad604..d3e18ec 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -100,7 +100,7 @@ ebt_arp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_arp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_arp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_arp_info *info = par->matchinfo;
 	const struct ebt_entry *e = par->entryinfo;
@@ -108,10 +108,10 @@ static bool ebt_arp_mt_check(const struct xt_mtchk_param *par)
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
 	   e->invflags & EBT_IPROTO)
-		return false;
+		return EBT_ARP_ERR_PROTO;
 	if (info->bitmask & ~EBT_ARP_MASK || info->invflags & ~EBT_ARP_MASK)
-		return false;
-	return true;
+		return EBT_ARP_ERR_FLAGS;
+	return EBT_ARP_ERR_NONE;
 }
 
 static struct xt_match ebt_arp_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 76584cd..c1b14ff 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -57,25 +57,35 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_arpreply_info *info = par->targinfo;
 	const struct ebt_entry *e = par->entryinfo;
+	unsigned int valid_hooks = (1 << NF_BR_NUMHOOKS) |
+		(1 << NF_BR_PRE_ROUTING);
 
+	if (strcmp(par->table, "nat") != 0) {
+		xt_compat_log(par, "arpreply target can only be used in the "
+			      "\"nat\" table.");
+	    	return EBT_ARPREPLY_ERR_NAT_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "arpreply target can only be used in the "
+			      "PREROUTING chain.");
+		return EBT_ARPREPLY_ERR_HOOKS_0;
+	}
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
+		return EBT_ARPREPLY_ERR_BASE;
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
-		return false;
-	return true;
+		return EBT_ARPREPLY_ERR_PROTO;
+	return EBT_ARPREPLY_ERR_NONE;
 }
 
 static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
 	.name		= "arpreply",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.table		= "nat",
-	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_PRE_ROUTING),
 	.target		= ebt_arpreply_tg,
 	.checkentry	= ebt_arpreply_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 6b49ea9..65e0e82 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -26,32 +26,35 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool ebt_dnat_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_dnat_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 	unsigned int hook_mask;
 
+	if (strcmp(par->table, "nat") != 0 &&
+	    strcmp(par->table, "broute") != 0)
+	    	return EBT_NAT_ERR_DNAT_NAT_BROUTE_TABLE;
+
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
+		return EBT_NAT_ERR_BASE;
 
 	hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
-	if ((strcmp(par->table, "nat") != 0 ||
+	if (strcmp(par->table, "nat") == 0 &&
 	    (hook_mask & ~((1 << NF_BR_PRE_ROUTING) |
-	    (1 << NF_BR_LOCAL_OUT)))) &&
-	    (strcmp(par->table, "broute") != 0 ||
-	    hook_mask & ~(1 << NF_BR_BROUTING)))
-		return false;
+	                   (1 << NF_BR_LOCAL_OUT))))
+		return EBT_NAT_ERR_DNAT_NAT_HOOKS_02;
+	if (strcmp(par->table, "broute") == 0 &&
+	    (hook_mask & ~(1 << NF_BR_BROUTING)))
+		return EBT_NAT_ERR_DNAT_BROUTE_HOOKS_5;
 	if (INVALID_TARGET)
-		return false;
-	return true;
+		return EBT_NAT_ERR_TARGET;
+	return EBT_NAT_ERR_NONE;
 }
 
 static struct xt_target ebt_dnat_tg_reg __read_mostly = {
 	.name		= "dnat",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_PRE_ROUTING) |
-			  (1 << NF_BR_LOCAL_OUT) | (1 << NF_BR_BROUTING),
 	.target		= ebt_dnat_tg,
 	.checkentry	= ebt_dnat_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index d771bbf..52118d4 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -77,31 +77,31 @@ ebt_ip_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_ip_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_ip_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_ip_info *info = par->matchinfo;
 	const struct ebt_entry *e = par->entryinfo;
 
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
-		return false;
+		return EBT_IP_ERR_PROTO;
 	if (info->bitmask & ~EBT_IP_MASK || info->invflags & ~EBT_IP_MASK)
-		return false;
+		return EBT_IP_ERR_FLAGS;
 	if (info->bitmask & (EBT_IP_DPORT | EBT_IP_SPORT)) {
 		if (info->invflags & EBT_IP_PROTO)
-			return false;
+			return EBT_IP_ERR_PROTO_PORT;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			 return false;
+			 return EBT_IP_ERR_NOT_TRANSPORT;
 	}
 	if (info->bitmask & EBT_IP_DPORT && info->dport[0] > info->dport[1])
-		return false;
+		return EBT_IP_ERR_DPORT_RANGE;
 	if (info->bitmask & EBT_IP_SPORT && info->sport[0] > info->sport[1])
-		return false;
-	return true;
+		return EBT_IP_ERR_SPORT_RANGE;
+	return EBT_IP_ERR_NONE;
 }
 
 static struct xt_match ebt_ip_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 784a657..35092fe 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -90,30 +90,30 @@ ebt_ip6_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_ip6_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_ip6_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct ebt_ip6_info *info = par->matchinfo;
 
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
-		return false;
+		return EBT_IP6_ERR_PROTO;
 	if (info->bitmask & ~EBT_IP6_MASK || info->invflags & ~EBT_IP6_MASK)
-		return false;
+		return EBT_IP6_ERR_FLAGS;
 	if (info->bitmask & (EBT_IP6_DPORT | EBT_IP6_SPORT)) {
 		if (info->invflags & EBT_IP6_PROTO)
-			return false;
+			return EBT_IP6_ERR_PROTO_PORT;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			return false;
+			return EBT_IP6_ERR_NOT_TRANSPORT;
 	}
 	if (info->bitmask & EBT_IP6_DPORT && info->dport[0] > info->dport[1])
-		return false;
+		return EBT_IP6_ERR_DPORT_RANGE;
 	if (info->bitmask & EBT_IP6_SPORT && info->sport[0] > info->sport[1])
-		return false;
-	return true;
+		return EBT_IP6_ERR_SPORT_RANGE;
+	return EBT_IP6_ERR_NONE;
 }
 
 static struct xt_match ebt_ip6_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index f7bd919..c232bdf 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -64,16 +64,16 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / EBT_LIMIT_SCALE;
 }
 
-static bool ebt_limit_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_limit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct ebt_limit_info *info = par->matchinfo;
 
 	/* Check for overflow. */
 	if (info->burst == 0 ||
 	    user2credits(info->avg * info->burst) < user2credits(info->avg)) {
-		printk("Overflow in ebt_limit, try lower: %u/%u\n",
+		xt_compat_log(par, "Overflow in ebt_limit, try lower: %u/%u",
 			info->avg, info->burst);
-		return false;
+		return EBT_LIMIT_ERR_OVERFLOW;
 	}
 
 	/* User avg in seconds * EBT_LIMIT_SCALE: convert to jiffies * 128. */
@@ -81,7 +81,7 @@ static bool ebt_limit_mt_check(const struct xt_mtchk_param *par)
 	info->credit = user2credits(info->avg * info->burst);
 	info->credit_cap = user2credits(info->avg * info->burst);
 	info->cost = user2credits(info->avg);
-	return true;
+	return EBT_LIMIT_ERR_NONE;
 }
 
 static struct xt_match ebt_limit_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index a94f3cc..6c1e1d9 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,16 +24,16 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static bool ebt_log_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_log_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_log_info *info = par->targinfo;
 
 	if (info->bitmask & ~EBT_LOG_MASK)
-		return false;
+		return EBT_LOG_ERR_MASK;
 	if (info->loglevel >= 8)
-		return false;
+		return EBT_LOG_ERR_LOGLEVEL;
 	info->prefix[EBT_LOG_PREFIX_SIZE - 1] = '\0';
-	return true;
+	return EBT_LOG_ERR_NONE;
 }
 
 struct tcpudphdr
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 2fee7e8..418d33d 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -36,21 +36,21 @@ ebt_mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool ebt_mark_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_mark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_mark_t_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return false;
+		return EBT_MARK_ERR_BASE;
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return false;
+		return EBT_MARK_ERR_STANDARD;
 	tmp = info->target & ~EBT_VERDICT_BITS;
 	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
 	    tmp != MARK_AND_VALUE && tmp != MARK_XOR_VALUE)
-		return false;
-	return true;
+		return EBT_MARK_ERR_VERDICT;
+	return EBT_MARK_ERR_NONE;
 }
 
 static struct xt_target ebt_mark_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index ea570f2..a8bb8cc 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -22,17 +22,17 @@ ebt_mark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool ebt_mark_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_mark_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_mark_m_info *info = par->matchinfo;
 
 	if (info->bitmask & ~EBT_MARK_MASK)
-		return false;
+		return EBT_MARK_ERR_BITMASK;
 	if ((info->bitmask & EBT_MARK_OR) && (info->bitmask & EBT_MARK_AND))
-		return false;
+		return EBT_MARK_ERR_AND_OR;
 	if (!info->bitmask)
-		return false;
-	return true;
+		return EBT_MARK_ERR_EMTPY_BITMASK;
+	return EBT_MARK_ERR_NONE;
 }
 
 static struct xt_match ebt_mark_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 2a63d99..003846c 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -35,7 +35,7 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool ebt_nflog_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_nflog_info *info = par->targinfo;
 
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 883e96e..7af2de9 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -20,14 +20,14 @@ ebt_pkttype_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (skb->pkt_type == info->pkt_type) ^ info->invert;
 }
 
-static bool ebt_pkttype_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_pkttype_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_pkttype_info *info = par->matchinfo;
 
 	if (info->invert != 0 && info->invert != 1)
-		return false;
+		return EBT_PKTTYPE_ERR_FLAGS;
 	/* Allow any pkt_type value */
-	return true;
+	return EBT_PKTTYPE_ERR_NONE;
 }
 
 static struct xt_match ebt_pkttype_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index c8a49f7..70d0236 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -32,31 +32,34 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool ebt_redirect_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_redirect_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
 	unsigned int hook_mask;
 
+	if (strcmp(par->table, "nat") != 0 &&
+	    strcmp(par->table, "broute") != 0)
+	    	return EBT_REDIRECT_ERR_NAT_BROUTE_TABLE;
+
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
+		return EBT_REDIRECT_ERR_BASE;
 
 	hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
-	if ((strcmp(par->table, "nat") != 0 ||
-	    hook_mask & ~(1 << NF_BR_PRE_ROUTING)) &&
-	    (strcmp(par->table, "broute") != 0 ||
-	    hook_mask & ~(1 << NF_BR_BROUTING)))
-		return false;
+	if (strcmp(par->table, "nat") == 0 &&
+	    hook_mask & ~(1 << NF_BR_PRE_ROUTING))
+	    	return EBT_REDIRECT_ERR_NAT_HOOKS_0;
+	if (strcmp(par->table, "broute") == 0 &&
+	    hook_mask & ~(1 << NF_BR_BROUTING))
+		return EBT_REDIRECT_ERR_BROUTE_HOOKS_5;
 	if (INVALID_TARGET)
-		return false;
-	return true;
+		return EBT_REDIRECT_ERR_TARGET;
+	return EBT_REDIRECT_ERR_NONE;
 }
 
 static struct xt_target ebt_redirect_tg_reg __read_mostly = {
 	.name		= "redirect",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_PRE_ROUTING) |
-			  (1 << NF_BR_BROUTING),
 	.target		= ebt_redirect_tg,
 	.checkentry	= ebt_redirect_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_redirect_info)),
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 8d04d4c..a555bfd 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -42,29 +42,34 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool ebt_snat_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_snat_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
+	unsigned int hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
 	int tmp;
 
+	if (strcmp(par->table, "nat") != 0)
+	    	return EBT_NAT_ERR_SNAT_NAT_TABLE;
+
+	if (hook_mask & ~(1 << NF_BR_POST_ROUTING))
+		return EBT_NAT_ERR_SNAT_NAT_HOOKS_4;
+
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return false;
+		return EBT_NAT_ERR_BASE;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return false;
+		return EBT_NAT_ERR_STANDARD;
 	tmp = info->target | EBT_VERDICT_BITS;
 	if ((tmp & ~NAT_ARP_BIT) != ~NAT_ARP_BIT)
-		return false;
-	return true;
+		return EBT_NAT_ERR_TARGET;
+	return EBT_NAT_ERR_NONE;
 }
 
 static struct xt_target ebt_snat_tg_reg __read_mostly = {
 	.name		= "snat",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.table		= "nat",
-	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_POST_ROUTING),
 	.target		= ebt_snat_tg,
 	.checkentry	= ebt_snat_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 48527e6..bf3d093 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -153,7 +153,7 @@ ebt_stp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_stp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_stp_info *info = par->matchinfo;
 	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
@@ -162,13 +162,13 @@ static bool ebt_stp_mt_check(const struct xt_mtchk_param *par)
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
-		return false;
+		return EBT_STP_ERR_FLAGS;
 	/* Make sure the match only receives stp frames */
 	if (compare_ether_addr(e->destmac, bridge_ula) ||
 	    compare_ether_addr(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
-		return false;
+		return EBT_STP_ERR_FRAMES;
 
-	return true;
+	return EBT_STP_ERR_NONE;
 }
 
 static struct xt_match ebt_stp_mt_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 133eeae..ca9fc27 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -254,19 +254,19 @@ ebt_ulog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool ebt_ulog_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ebt_ulog_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ebt_ulog_info *uloginfo = par->targinfo;
 
 	if (uloginfo->nlgroup > 31)
-		return false;
+		return EBT_ULOG_ERR_NLGROUP;
 
 	uloginfo->prefix[EBT_ULOG_PREFIX_LEN - 1] = '\0';
 
 	if (uloginfo->qthreshold > EBT_ULOG_MAX_QLEN)
 		uloginfo->qthreshold = EBT_ULOG_MAX_QLEN;
 
-	return 0;
+	return EBT_ULOG_ERR_NONE;
 }
 
 static struct xt_target ebt_ulog_tg_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 3dddd48..f1dda63 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -84,7 +84,7 @@ ebt_vlan_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 {
 	struct ebt_vlan_info *info = par->matchinfo;
 	const struct ebt_entry *e = par->entryinfo;
@@ -94,7 +94,7 @@ static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 		DEBUG_MSG
 		    ("passed entry proto %2.4X is not 802.1Q (8100)\n",
 		     (unsigned short) ntohs(e->ethproto));
-		return false;
+		return EBT_VLAN_ERR_8021Q;
 	}
 
 	/* Check for bitmask range
@@ -102,14 +102,14 @@ static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	if (info->bitmask & ~EBT_VLAN_MASK) {
 		DEBUG_MSG("bitmask %2X is out of mask (%2X)\n",
 			  info->bitmask, EBT_VLAN_MASK);
-		return false;
+		return EBT_VLAN_ERR_BITMASK;
 	}
 
 	/* Check for inversion flags range */
 	if (info->invflags & ~EBT_VLAN_MASK) {
 		DEBUG_MSG("inversion flags %2X is out of mask (%2X)\n",
 			  info->invflags, EBT_VLAN_MASK);
-		return false;
+		return EBT_VLAN_ERR_INVFLAGS;
 	}
 
 	/* Reserved VLAN ID (VID) values
@@ -124,7 +124,7 @@ static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 				DEBUG_MSG
 				    ("id %d is out of range (1-4096)\n",
 				     info->id);
-				return false;
+				return EBT_VLAN_ERR_ID_RANGE;
 			}
 			/* Note: This is valid VLAN-tagged frame point.
 			 * Any value of user_priority are acceptable,
@@ -139,7 +139,7 @@ static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 		if ((unsigned char) info->prio > 7) {
 			DEBUG_MSG("prio %d is out of range (0-7)\n",
 			     info->prio);
-			return false;
+			return EBT_VLAN_ERR_PRIO_RANGE;
 		}
 	}
 	/* Check for encapsulated proto range - it is possible to be
@@ -150,11 +150,11 @@ static bool ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 			DEBUG_MSG
 			    ("encap frame length %d is less than minimal\n",
 			     ntohs(info->encap));
-			return false;
+			return EBT_VLAN_ERR_ENCAP;
 		}
 	}
 
-	return true;
+	return EBT_VLAN_ERR_NONE;
 }
 
 static struct xt_match ebt_vlan_mt_reg __read_mostly = {


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
