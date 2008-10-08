From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 51/79: change return types of check functions for Ebtables extensions
Date: Wed,  8 Oct 2008 12:47:30 +0200 (MEST)
Message-ID: <20081008104729.10423.96879.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46008 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYJHKrb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:31 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 19eda879a136889110c692dec4c2ab59e0e43cef
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:13 2008 +0200

    netfilter: change return types of check functions for Ebtables extensions
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index fd085af..5f71719 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -211,8 +211,7 @@ struct ebt_match
 	int (*match)(const struct sk_buff *skb, const struct net_device *in,
 	   const struct net_device *out, const void *matchdata,
 	   unsigned int datalen);
-	/* 0 == let it in */
-	int (*check)(const char *tablename, unsigned int hookmask,
+	bool (*check)(const char *tablename, unsigned int hookmask,
 	   const struct ebt_entry *e, void *matchdata, unsigned int datalen);
 	void (*destroy)(void *matchdata, unsigned int datalen);
 	unsigned int matchsize;
@@ -226,8 +225,7 @@ struct ebt_watcher
 	void (*watcher)(const struct sk_buff *skb, unsigned int hooknr,
 	   const struct net_device *in, const struct net_device *out,
 	   const void *watcherdata, unsigned int datalen);
-	/* 0 == let it in */
-	int (*check)(const char *tablename, unsigned int hookmask,
+	bool (*check)(const char *tablename, unsigned int hookmask,
 	   const struct ebt_entry *e, void *watcherdata, unsigned int datalen);
 	void (*destroy)(void *watcherdata, unsigned int datalen);
 	unsigned int targetsize;
@@ -242,8 +240,7 @@ struct ebt_target
 	int (*target)(struct sk_buff *skb, unsigned int hooknr,
 	   const struct net_device *in, const struct net_device *out,
 	   const void *targetdata, unsigned int datalen);
-	/* 0 == let it in */
-	int (*check)(const char *tablename, unsigned int hookmask,
+	bool (*check)(const char *tablename, unsigned int hookmask,
 	   const struct ebt_entry *e, void *targetdata, unsigned int datalen);
 	void (*destroy)(void *targetdata, unsigned int datalen);
 	unsigned int targetsize;
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index ccecfbd..868df9c 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -37,15 +37,15 @@ static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *
 }
 
 static struct ebt_match filter_802_3;
-static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
+static bool ebt_802_3_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_802_3_info *info = data;
 
 	if (info->bitmask & ~EBT_802_3_MASK || info->invflags & ~EBT_802_3_MASK)
-		return -EINVAL;
+		return false;
 
-	return 0;
+	return true;
 }
 
 static struct ebt_match filter_802_3 __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index b0acb13..95e2e70 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -177,9 +177,10 @@ static int ebt_filter_among(const struct sk_buff *skb,
 	return EBT_MATCH;
 }
 
-static int ebt_among_check(const char *tablename, unsigned int hookmask,
-			   const struct ebt_entry *e, void *data,
-			   unsigned int datalen)
+static bool
+ebt_among_check(const char *tablename, unsigned int hookmask,
+		const struct ebt_entry *e, void *data,
+		unsigned int datalen)
 {
 	const struct ebt_among_info *info = data;
 	int expected_length = sizeof(struct ebt_among_info);
@@ -197,19 +198,19 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 		       "against expected %d, rounded to %Zd\n",
 		       datalen, expected_length,
 		       EBT_ALIGN(expected_length));
-		return -EINVAL;
+		return false;
 	}
 	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
 		printk(KERN_WARNING
 		       "ebtables: among: dst integrity fail: %x\n", -err);
-		return -EINVAL;
+		return false;
 	}
 	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
 		printk(KERN_WARNING
 		       "ebtables: among: src integrity fail: %x\n", -err);
-		return -EINVAL;
+		return false;
 	}
-	return 0;
+	return true;
 }
 
 static struct ebt_match filter_among __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 385f9cb..cb33672 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -100,7 +100,7 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 	return EBT_MATCH;
 }
 
-static int ebt_arp_check(const char *tablename, unsigned int hookmask,
+static bool ebt_arp_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_arp_info *info = data;
@@ -108,10 +108,10 @@ static int ebt_arp_check(const char *tablename, unsigned int hookmask,
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
 	   e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & ~EBT_ARP_MASK || info->invflags & ~EBT_ARP_MASK)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_match filter_arp __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index a860ea6..c298d3d 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -58,20 +58,20 @@ static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
+static bool ebt_target_reply_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_arpreply_info *info = data;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_target reply_target __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index c2be41e..6ddea21 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -27,21 +27,21 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
+static bool ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_nat_info *info = data;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if ( (strcmp(tablename, "nat") ||
 	   (hookmask & ~((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT)))) &&
 	   (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
-		return -EINVAL;
+		return false;
 	if (INVALID_TARGET)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_target dnat __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index c1ae254..cbf0918 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -78,31 +78,31 @@ static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
 	return EBT_MATCH;
 }
 
-static int ebt_ip_check(const char *tablename, unsigned int hookmask,
+static bool ebt_ip_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_ip_info *info = data;
 
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & ~EBT_IP_MASK || info->invflags & ~EBT_IP_MASK)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & (EBT_IP_DPORT | EBT_IP_SPORT)) {
 		if (info->invflags & EBT_IP_PROTO)
-			return -EINVAL;
+			return false;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			 return -EINVAL;
+			 return false;
 	}
 	if (info->bitmask & EBT_IP_DPORT && info->dport[0] > info->dport[1])
-		return -EINVAL;
+		return false;
 	if (info->bitmask & EBT_IP_SPORT && info->sport[0] > info->sport[1])
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_match filter_ip __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 554dd68..1230c9e 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -92,30 +92,30 @@ static int ebt_filter_ip6(const struct sk_buff *skb,
 	return EBT_MATCH;
 }
 
-static int ebt_ip6_check(const char *tablename, unsigned int hookmask,
+static bool ebt_ip6_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
 
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & ~EBT_IP6_MASK || info->invflags & ~EBT_IP6_MASK)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & (EBT_IP6_DPORT | EBT_IP6_SPORT)) {
 		if (info->invflags & EBT_IP6_PROTO)
-			return -EINVAL;
+			return false;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			 return -EINVAL;
+			return false;
 	}
 	if (info->bitmask & EBT_IP6_DPORT && info->dport[0] > info->dport[1])
-		return -EINVAL;
+		return false;
 	if (info->bitmask & EBT_IP6_SPORT && info->sport[0] > info->sport[1])
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_match filter_ip6 =
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 3d71f35..9b04f2b 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -65,7 +65,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / EBT_LIMIT_SCALE;
 }
 
-static int ebt_limit_check(const char *tablename, unsigned int hookmask,
+static bool ebt_limit_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	struct ebt_limit_info *info = data;
@@ -75,7 +75,7 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 	    user2credits(info->avg * info->burst) < user2credits(info->avg)) {
 		printk("Overflow in ebt_limit, try lower: %u/%u\n",
 			info->avg, info->burst);
-		return -EINVAL;
+		return false;
 	}
 
 	/* User avg in seconds * EBT_LIMIT_SCALE: convert to jiffies * 128. */
@@ -83,7 +83,7 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 	info->credit = user2credits(info->avg * info->burst);
 	info->credit_cap = user2credits(info->avg * info->burst);
 	info->cost = user2credits(info->avg);
-	return 0;
+	return true;
 }
 
 static struct ebt_match ebt_limit_reg __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index d9596f1..f3d6d5e 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,17 +24,17 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static int ebt_log_check(const char *tablename, unsigned int hookmask,
+static bool ebt_log_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	struct ebt_log_info *info = data;
 
 	if (info->bitmask & ~EBT_LOG_MASK)
-		return -EINVAL;
+		return false;
 	if (info->loglevel >= 8)
-		return -EINVAL;
+		return false;
 	info->prefix[EBT_LOG_PREFIX_SIZE - 1] = '\0';
-	return 0;
+	return true;
 }
 
 struct tcpudphdr
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index bb02412..b85c738 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -37,7 +37,7 @@ static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
+static bool ebt_target_mark_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_mark_t_info *info = data;
@@ -45,15 +45,15 @@ static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return -EINVAL;
+		return false;
 	tmp = info->target & ~EBT_VERDICT_BITS;
 	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
 	    tmp != MARK_AND_VALUE && tmp != MARK_XOR_VALUE)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_target mark_target __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index b8ce9eb..b2707d7 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -23,18 +23,18 @@ static int ebt_filter_mark(const struct sk_buff *skb,
 	return !(((skb->mark & info->mask) == info->mark) ^ info->invert);
 }
 
-static int ebt_mark_check(const char *tablename, unsigned int hookmask,
+static bool ebt_mark_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_mark_m_info *info = data;
 
 	if (info->bitmask & ~EBT_MARK_MASK)
-		return -EINVAL;
+		return false;
 	if ((info->bitmask & EBT_MARK_OR) && (info->bitmask & EBT_MARK_AND))
-		return -EINVAL;
+		return false;
 	if (!info->bitmask)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_match filter_mark __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 88ceb5e..a6954eb 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -36,17 +36,17 @@ static void ebt_nflog(const struct sk_buff *skb,
 	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, "%s", info->prefix);
 }
 
-static int ebt_nflog_check(const char *tablename,
-			   unsigned int hookmask,
-			   const struct ebt_entry *e,
-			   void *data, unsigned int datalen)
+static bool ebt_nflog_check(const char *tablename,
+			    unsigned int hookmask,
+			    const struct ebt_entry *e,
+			    void *data, unsigned int datalen)
 {
 	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
-		return -EINVAL;
+		return false;
 	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
-	return 0;
+	return true;
 }
 
 static struct ebt_watcher nflog __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 0190261..4dcd3b8 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -23,15 +23,15 @@ static int ebt_filter_pkttype(const struct sk_buff *skb,
 	return (skb->pkt_type != info->pkt_type) ^ info->invert;
 }
 
-static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
+static bool ebt_pkttype_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_pkttype_info *info = data;
 
 	if (info->invert != 0 && info->invert != 1)
-		return -EINVAL;
+		return false;
 	/* Allow any pkt_type value */
-	return 0;
+	return true;
 }
 
 static struct ebt_match filter_pkttype __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 0405326..d2076f4 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -33,20 +33,20 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static int ebt_target_redirect_check(const char *tablename, unsigned int hookmask,
+static bool ebt_target_redirect_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_redirect_info *info = data;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if ( (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING)) &&
 	     (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
-		return -EINVAL;
+		return false;
 	if (INVALID_TARGET)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_target redirect_target __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index abfbc6c..5a5a16a 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -43,7 +43,7 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
+static bool ebt_target_snat_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_nat_info *info = data;
@@ -51,19 +51,19 @@ static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if (strcmp(tablename, "nat"))
-		return -EINVAL;
+		return false;
 	if (hookmask & ~(1 << NF_BR_POST_ROUTING))
-		return -EINVAL;
+		return false;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return -EINVAL;
+		return false;
 	tmp = info->target | EBT_VERDICT_BITS;
 	if ((tmp & ~NAT_ARP_BIT) != ~NAT_ARP_BIT)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
 static struct ebt_target snat __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index c7a0a00..37d9480 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -153,7 +153,7 @@ static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in
 	return EBT_MATCH;
 }
 
-static int ebt_stp_check(const char *tablename, unsigned int hookmask,
+static bool ebt_stp_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_stp_info *info = data;
@@ -162,13 +162,13 @@ static int ebt_stp_check(const char *tablename, unsigned int hookmask,
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
-		return -EINVAL;
+		return false;
 	/* Make sure the match only receives stp frames */
 	if (compare_ether_addr(e->destmac, bridge_ula) ||
 	    compare_ether_addr(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
-		return -EINVAL;
+		return false;
 
-	return 0;
+	return true;
 }
 
 static struct ebt_match filter_stp __read_mostly = {
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index bdd8a27..e13a005 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -255,14 +255,13 @@ static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
 	ebt_ulog_packet(hooknr, skb, in, out, uloginfo, NULL);
 }
 
-
-static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
+static bool ebt_ulog_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	struct ebt_ulog_info *uloginfo = data;
 
 	if (uloginfo->nlgroup > 31)
-		return -EINVAL;
+		return false;
 
 	uloginfo->prefix[EBT_ULOG_PREFIX_LEN - 1] = '\0';
 
@@ -288,12 +287,13 @@ static const struct nf_logger ebt_ulog_logger = {
 
 static int __init ebt_ulog_init(void)
 {
-	int i, ret = 0;
+	bool ret = true;
+	int i;
 
 	if (nlbufsiz >= 128*1024) {
 		printk(KERN_NOTICE "ebt_ulog: Netlink buffer has to be <= 128kB,"
 		       " please try a smaller nlbufsiz parameter.\n");
-		return -EINVAL;
+		return false;
 	}
 
 	/* initialize ulog_buffers */
@@ -305,12 +305,15 @@ static int __init ebt_ulog_init(void)
 	ebtulognl = netlink_kernel_create(&init_net, NETLINK_NFLOG,
 					  EBT_ULOG_MAXNLGROUPS, NULL, NULL,
 					  THIS_MODULE);
-	if (!ebtulognl)
-		ret = -ENOMEM;
-	else if ((ret = ebt_register_watcher(&ulog)))
+	if (!ebtulognl) {
+		printk(KERN_WARNING KBUILD_MODNAME ": out of memory trying to "
+		       "call netlink_kernel_create\n");
+		ret = false;
+	} else if (ebt_register_watcher(&ulog) != 0) {
 		netlink_kernel_release(ebtulognl);
+	}
 
-	if (ret == 0)
+	if (ret)
 		nf_log_register(NFPROTO_BRIDGE, &ebt_ulog_logger);
 
 	return ret;
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 4dba47a..fc88d5d 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -87,7 +87,7 @@ ebt_filter_vlan(const struct sk_buff *skb,
 	return EBT_MATCH;
 }
 
-static int
+static bool
 ebt_check_vlan(const char *tablename,
 	       unsigned int hooknr,
 	       const struct ebt_entry *e, void *data, unsigned int datalen)
@@ -99,7 +99,7 @@ ebt_check_vlan(const char *tablename,
 		DEBUG_MSG
 		    ("passed entry proto %2.4X is not 802.1Q (8100)\n",
 		     (unsigned short) ntohs(e->ethproto));
-		return -EINVAL;
+		return false;
 	}
 
 	/* Check for bitmask range
@@ -107,14 +107,14 @@ ebt_check_vlan(const char *tablename,
 	if (info->bitmask & ~EBT_VLAN_MASK) {
 		DEBUG_MSG("bitmask %2X is out of mask (%2X)\n",
 			  info->bitmask, EBT_VLAN_MASK);
-		return -EINVAL;
+		return false;
 	}
 
 	/* Check for inversion flags range */
 	if (info->invflags & ~EBT_VLAN_MASK) {
 		DEBUG_MSG("inversion flags %2X is out of mask (%2X)\n",
 			  info->invflags, EBT_VLAN_MASK);
-		return -EINVAL;
+		return false;
 	}
 
 	/* Reserved VLAN ID (VID) values
@@ -129,7 +129,7 @@ ebt_check_vlan(const char *tablename,
 				DEBUG_MSG
 				    ("id %d is out of range (1-4096)\n",
 				     info->id);
-				return -EINVAL;
+				return false;
 			}
 			/* Note: This is valid VLAN-tagged frame point.
 			 * Any value of user_priority are acceptable,
@@ -144,7 +144,7 @@ ebt_check_vlan(const char *tablename,
 		if ((unsigned char) info->prio > 7) {
 			DEBUG_MSG("prio %d is out of range (0-7)\n",
 			     info->prio);
-			return -EINVAL;
+			return false;
 		}
 	}
 	/* Check for encapsulated proto range - it is possible to be
@@ -155,11 +155,11 @@ ebt_check_vlan(const char *tablename,
 			DEBUG_MSG
 			    ("encap frame length %d is less than minimal\n",
 			     ntohs(info->encap));
-			return -EINVAL;
+			return false;
 		}
 	}
 
-	return 0;
+	return true;
 }
 
 static struct ebt_match filter_vlan __read_mostly = {
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index b04e288..fe49952 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -365,7 +365,7 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 		return -EINVAL;
 	}
 	if (match->check &&
-	   match->check(name, hookmask, e, m->data, m->match_size) != 0) {
+	    !match->check(name, hookmask, e, m->data, m->match_size)) {
 		BUGPRINT("match->check failed\n");
 		module_put(match->me);
 		return -EINVAL;
@@ -403,7 +403,7 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 		return -EINVAL;
 	}
 	if (watcher->check &&
-	   watcher->check(name, hookmask, e, w->data, w->watcher_size) != 0) {
+	    !watcher->check(name, hookmask, e, w->data, w->watcher_size)) {
 		BUGPRINT("watcher->check failed\n");
 		module_put(watcher->me);
 		return -EINVAL;
@@ -716,7 +716,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		ret = -EINVAL;
 		goto cleanup_watchers;
 	} else if (t->u.target->check &&
-	    t->u.target->check(name, hookmask, e, t->data, t->target_size) != 0) {
+	    !t->u.target->check(name, hookmask, e, t->data, t->target_size)) {
 		module_put(t->u.target->me);
 		ret = -EFAULT;
 		goto cleanup_watchers;
