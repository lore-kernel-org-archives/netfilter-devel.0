From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 56/79: change Ebtables function signatures to match Xtables's
Date: Wed,  8 Oct 2008 12:47:36 +0200 (MEST)
Message-ID: <20081008104736.10423.59429.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46033 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYJHKri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:38 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2d06d4a5cc107046508d860a0b47dbc43b829b79
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:15 2008 +0200

    netfilter: change Ebtables function signatures to match Xtables's
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 82f854b..f20a57d 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -31,6 +31,9 @@
  * The 4 lsb are more than enough to store the verdict. */
 #define EBT_VERDICT_BITS 0x0000000F
 
+struct xt_match;
+struct xt_target;
+
 struct ebt_counter
 {
 	uint64_t pcnt;
@@ -208,11 +211,13 @@ struct ebt_match
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
 	bool (*match)(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const void *matchdata,
-	   unsigned int datalen);
-	bool (*check)(const char *tablename, unsigned int hookmask,
-	   const struct ebt_entry *e, void *matchdata, unsigned int datalen);
-	void (*destroy)(void *matchdata, unsigned int datalen);
+		const struct net_device *out, const struct xt_match *match,
+		const void *matchinfo, int offset, unsigned int protoff,
+		bool *hotdrop);
+	bool (*checkentry)(const char *table, const void *entry,
+		const struct xt_match *match, void *matchinfo,
+		unsigned int hook_mask);
+	void (*destroy)(const struct xt_match *match, void *matchinfo);
 	unsigned int matchsize;
 	u_int8_t revision;
 	u_int8_t family;
@@ -223,12 +228,14 @@ struct ebt_watcher
 {
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
-	unsigned int (*watcher)(const struct sk_buff *skb, unsigned int hooknr,
-	   const struct net_device *in, const struct net_device *out,
-	   const void *watcherdata, unsigned int datalen);
-	bool (*check)(const char *tablename, unsigned int hookmask,
-	   const struct ebt_entry *e, void *watcherdata, unsigned int datalen);
-	void (*destroy)(void *watcherdata, unsigned int datalen);
+	unsigned int (*target)(struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		unsigned int hook_num, const struct xt_target *target,
+		const void *targinfo);
+	bool (*checkentry)(const char *table, const void *entry,
+		const struct xt_target *target, void *targinfo,
+		unsigned int hook_mask);
+	void (*destroy)(const struct xt_target *target, void *targinfo);
 	unsigned int targetsize;
 	u_int8_t revision;
 	u_int8_t family;
@@ -240,12 +247,14 @@ struct ebt_target
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
 	/* returns one of the standard EBT_* verdicts */
-	unsigned int (*target)(struct sk_buff *skb, unsigned int hooknr,
-	   const struct net_device *in, const struct net_device *out,
-	   const void *targetdata, unsigned int datalen);
-	bool (*check)(const char *tablename, unsigned int hookmask,
-	   const struct ebt_entry *e, void *targetdata, unsigned int datalen);
-	void (*destroy)(void *targetdata, unsigned int datalen);
+	unsigned int (*target)(struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		unsigned int hook_num, const struct xt_target *target,
+		const void *targinfo);
+	bool (*checkentry)(const char *table, const void *entry,
+		const struct xt_target *target, void *targinfo,
+		unsigned int hook_mask);
+	void (*destroy)(const struct xt_target *target, void *targinfo);
 	unsigned int targetsize;
 	u_int8_t revision;
 	u_int8_t family;
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index f9876f2..6f1a69c 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -12,9 +12,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_802_3.h>
 
-static bool ebt_filter_802_3(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out, const void *data, unsigned int datalen)
+static bool
+ebt_802_3_mt(const struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, const struct xt_match *match,
+	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_802_3_info *info = data;
 	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
@@ -37,9 +38,10 @@ static bool ebt_filter_802_3(const struct sk_buff *skb,
 	return true;
 }
 
-static struct ebt_match filter_802_3;
-static bool ebt_802_3_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_802_3_mt_check(const char *table, const void *entry,
+		   const struct xt_match *match, void *data,
+		   unsigned int hook_mask)
 {
 	const struct ebt_802_3_info *info = data;
 
@@ -53,8 +55,8 @@ static struct ebt_match filter_802_3 __read_mostly = {
 	.name		= EBT_802_3_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_802_3,
-	.check		= ebt_802_3_check,
+	.match		= ebt_802_3_mt,
+	.checkentry	= ebt_802_3_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 88b5c91..84a306f 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -127,10 +127,10 @@ static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 	return 0;
 }
 
-static bool ebt_filter_among(const struct sk_buff *skb,
-			     const struct net_device *in,
-			     const struct net_device *out, const void *data,
-			     unsigned int datalen)
+static bool
+ebt_among_mt(const struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, const struct xt_match *match,
+	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_among_info *info = data;
 	const char *dmac, *smac;
@@ -174,9 +174,9 @@ static bool ebt_filter_among(const struct sk_buff *skb,
 }
 
 static bool
-ebt_among_check(const char *tablename, unsigned int hookmask,
-		const struct ebt_entry *e, void *data,
-		unsigned int datalen)
+ebt_among_mt_check(const char *table, const void *entry,
+		   const struct xt_match *match, void *data,
+		   unsigned int hook_mask)
 {
 	const struct ebt_entry_match *em =
 		container_of(data, const struct ebt_entry_match, data);
@@ -215,8 +215,8 @@ static struct ebt_match filter_among __read_mostly = {
 	.name		= EBT_AMONG_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_among,
-	.check		= ebt_among_check,
+	.match		= ebt_among_mt,
+	.checkentry	= ebt_among_mt_check,
 	.matchsize	= -1, /* special case */
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 4a5226c..6e7cd2f 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -15,9 +15,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_arp.h>
 
-static bool ebt_filter_arp(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out, const void *data, unsigned int datalen)
+static bool
+ebt_arp_mt(const struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, const struct xt_match *match,
+	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_arp_info *info = data;
 	const struct arphdr *ah;
@@ -101,10 +102,13 @@ static bool ebt_filter_arp(const struct sk_buff *skb,
 	return true;
 }
 
-static bool ebt_arp_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_arp_mt_check(const char *table, const void *entry,
+		 const struct xt_match *match, void *data,
+		 unsigned int hook_mask)
 {
 	const struct ebt_arp_info *info = data;
+	const struct ebt_entry *e = entry;
 
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
@@ -119,8 +123,8 @@ static struct ebt_match filter_arp __read_mostly = {
 	.name		= EBT_ARP_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_arp,
-	.check		= ebt_arp_check,
+	.match		= ebt_arp_mt,
+	.checkentry	= ebt_arp_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_arp_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 7ab1655..6f2f658 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -15,9 +15,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_arpreply.h>
 
-static unsigned int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hook_nr,
+		const struct xt_target *target, const void *data)
 {
 	struct ebt_arpreply_info *info = (void *)data;
 	const __be32 *siptr, *diptr;
@@ -58,10 +59,13 @@ static unsigned int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static bool ebt_target_reply_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_arpreply_tg_check(const char *tablename, const void *entry,
+		      const struct xt_target *target, void *data,
+		      unsigned int hookmask)
 {
 	const struct ebt_arpreply_info *info = data;
+	const struct ebt_entry *e = entry;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
@@ -78,8 +82,8 @@ static struct ebt_target reply_target __read_mostly = {
 	.name		= EBT_ARPREPLY_TARGET,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.target		= ebt_target_reply,
-	.check		= ebt_target_reply_check,
+	.target		= ebt_arpreply_tg,
+	.checkentry	= ebt_arpreply_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 64838e2..b7cc013 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -14,9 +14,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
 
-static unsigned int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_dnat_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hook_nr,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_nat_info *info = data;
 
@@ -27,8 +28,10 @@ static unsigned int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static bool ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_dnat_tg_check(const char *tablename, const void *entry,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	const struct ebt_nat_info *info = data;
 
@@ -48,8 +51,8 @@ static struct ebt_target dnat __read_mostly = {
 	.name		= EBT_DNAT_TARGET,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.target		= ebt_target_dnat,
-	.check		= ebt_target_dnat_check,
+	.target		= ebt_dnat_tg,
+	.checkentry	= ebt_dnat_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 0bef6f7..e7f3b17 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -24,10 +24,10 @@ struct tcpudphdr {
 	__be16 dst;
 };
 
-static bool ebt_filter_ip(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out, const void *data,
-   unsigned int datalen)
+static bool
+ebt_ip_mt(const struct sk_buff *skb, const struct net_device *in,
+	  const struct net_device *out, const struct xt_match *match,
+	  const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_ip_info *info = data;
 	const struct iphdr *ih;
@@ -79,10 +79,13 @@ static bool ebt_filter_ip(const struct sk_buff *skb,
 	return true;
 }
 
-static bool ebt_ip_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_ip_mt_check(const char *table, const void *entry,
+		const struct xt_match *match, void *data,
+		unsigned int hook_mask)
 {
 	const struct ebt_ip_info *info = data;
+	const struct ebt_entry *e = entry;
 
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
@@ -110,8 +113,8 @@ static struct ebt_match filter_ip __read_mostly = {
 	.name		= EBT_IP_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_ip,
-	.check		= ebt_ip_check,
+	.match		= ebt_ip_mt,
+	.checkentry	= ebt_ip_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_ip_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index afcabe2..807685d 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -27,10 +27,10 @@ struct tcpudphdr {
 	__be16 dst;
 };
 
-static bool ebt_filter_ip6(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out, const void *data,
-   unsigned int datalen)
+static bool
+ebt_ip6_mt(const struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, const struct xt_match *match,
+	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
 	const struct ipv6hdr *ih6;
@@ -92,9 +92,12 @@ static bool ebt_filter_ip6(const struct sk_buff *skb,
 	return true;
 }
 
-static bool ebt_ip6_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_ip6_mt_check(const char *table, const void *entry,
+		 const struct xt_match *match, void *data,
+		 unsigned int hook_mask)
 {
+	const struct ebt_entry *e = entry;
 	struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
 
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
@@ -123,8 +126,8 @@ static struct ebt_match filter_ip6 =
 	.name		= EBT_IP6_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_ip6,
-	.check		= ebt_ip6_check,
+	.match		= ebt_ip6_mt,
+	.checkentry	= ebt_ip6_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_ip6_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 9ca0a25..d337273 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -30,9 +30,10 @@ static DEFINE_SPINLOCK(limit_lock);
 
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
-static bool ebt_limit_match(const struct sk_buff *skb,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static bool
+ebt_limit_mt(const struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, const struct xt_match *match,
+	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	struct ebt_limit_info *info = (struct ebt_limit_info *)data;
 	unsigned long now = jiffies;
@@ -65,8 +66,10 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / EBT_LIMIT_SCALE;
 }
 
-static bool ebt_limit_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_limit_mt_check(const char *table, const void *e,
+		   const struct xt_match *match, void *data,
+		   unsigned int hook_mask)
 {
 	struct ebt_limit_info *info = data;
 
@@ -90,8 +93,8 @@ static struct ebt_match ebt_limit_reg __read_mostly = {
 	.name		= EBT_LIMIT_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_limit_match,
-	.check		= ebt_limit_check,
+	.match		= ebt_limit_mt,
+	.checkentry	= ebt_limit_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_limit_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index c2e1c35..424dfdf 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,8 +24,10 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static bool ebt_log_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_log_tg_check(const char *table, const void *entry,
+		 const struct xt_target *target, void *data,
+		 unsigned int hook_mask)
 {
 	struct ebt_log_info *info = data;
 
@@ -192,9 +194,10 @@ out:
 
 }
 
-static unsigned int ebt_log(const struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, unsigned int hooknr,
+	   const struct xt_target *target, const void *data)
 {
 	const struct ebt_log_info *info = data;
 	struct nf_loginfo li;
@@ -217,8 +220,8 @@ static struct ebt_watcher log =
 	.name		= EBT_LOG_WATCHER,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.watcher	= ebt_log,
-	.check		= ebt_log_check,
+	.target		= ebt_log_tg,
+	.checkentry	= ebt_log_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_log_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 910721a..92c6727 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -18,9 +18,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_t.h>
 
-static unsigned int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_mark_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hook_nr,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_mark_t_info *info = data;
 	int action = info->target & -16;
@@ -37,8 +38,10 @@ static unsigned int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool ebt_target_mark_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_mark_tg_check(const char *table, const void *e,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	const struct ebt_mark_t_info *info = data;
 	int tmp;
@@ -60,8 +63,8 @@ static struct ebt_target mark_target __read_mostly = {
 	.name		= EBT_MARK_TARGET,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.target		= ebt_target_mark,
-	.check		= ebt_target_mark_check,
+	.target		= ebt_mark_tg,
+	.checkentry	= ebt_mark_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_mark_t_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 6512ad9..db64a0d 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -12,9 +12,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_m.h>
 
-static bool ebt_filter_mark(const struct sk_buff *skb,
-   const struct net_device *in, const struct net_device *out, const void *data,
-   unsigned int datalen)
+static bool
+ebt_mark_mt(const struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, const struct xt_match *match,
+	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_mark_m_info *info = data;
 
@@ -23,8 +24,10 @@ static bool ebt_filter_mark(const struct sk_buff *skb,
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool ebt_mark_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_mark_mt_check(const char *table, const void *e,
+		  const struct xt_match *match, void *data,
+		  unsigned int hook_mask)
 {
 	const struct ebt_mark_m_info *info = data;
 
@@ -41,8 +44,8 @@ static struct ebt_match filter_mark __read_mostly = {
 	.name		= EBT_MARK_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_mark,
-	.check		= ebt_mark_check,
+	.match		= ebt_mark_mt,
+	.checkentry	= ebt_mark_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index aa0410c..b415f88 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -19,11 +19,10 @@
 #include <linux/netfilter_bridge/ebt_nflog.h>
 #include <net/netfilter/nf_log.h>
 
-static unsigned int ebt_nflog(const struct sk_buff *skb,
-			      unsigned int hooknr,
-			      const struct net_device *in,
-			      const struct net_device *out,
-			      const void *data, unsigned int datalen)
+static unsigned int
+ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, unsigned int hooknr,
+	     const struct xt_target *target, const void *data)
 {
 	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
 	struct nf_loginfo li;
@@ -37,10 +36,10 @@ static unsigned int ebt_nflog(const struct sk_buff *skb,
 	return EBT_CONTINUE;
 }
 
-static bool ebt_nflog_check(const char *tablename,
-			    unsigned int hookmask,
-			    const struct ebt_entry *e,
-			    void *data, unsigned int datalen)
+static bool
+ebt_nflog_tg_check(const char *table, const void *e,
+		   const struct xt_target *target, void *data,
+		   unsigned int hookmask)
 {
 	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
 
@@ -54,8 +53,8 @@ static struct ebt_watcher nflog __read_mostly = {
 	.name = EBT_NFLOG_WATCHER,
 	.revision = 0,
 	.family = NFPROTO_BRIDGE,
-	.watcher = ebt_nflog,
-	.check = ebt_nflog_check,
+	.target = ebt_nflog_tg,
+	.checkentry = ebt_nflog_tg_check,
 	.targetsize = XT_ALIGN(sizeof(struct ebt_nflog_info)),
 	.me = THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index a9acecc..0639345 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -12,19 +12,21 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_pkttype.h>
 
-static bool ebt_filter_pkttype(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out,
-   const void *data,
-   unsigned int datalen)
+static bool
+ebt_pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
+	       const struct net_device *out, const struct xt_match *match,
+	       const void *data, int offset, unsigned int protoff,
+	       bool *hotdrop)
 {
 	const struct ebt_pkttype_info *info = data;
 
 	return (skb->pkt_type == info->pkt_type) ^ info->invert;
 }
 
-static bool ebt_pkttype_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_pkttype_mt_check(const char *table, const void *e,
+		     const struct xt_match *match, void *data,
+		     unsigned int hook_mask)
 {
 	const struct ebt_pkttype_info *info = data;
 
@@ -38,8 +40,8 @@ static struct ebt_match filter_pkttype __read_mostly = {
 	.name		= EBT_PKTTYPE_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_pkttype,
-	.check		= ebt_pkttype_check,
+	.match		= ebt_pkttype_mt,
+	.checkentry	= ebt_pkttype_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_pkttype_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 4c62810..e9540cf 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -15,10 +15,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_redirect.h>
 
-static unsigned int ebt_target_redirect(struct sk_buff *skb,
-   unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_redirect_tg(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hooknr,
+		const struct xt_target *target, const void *data)
 {
 	const struct ebt_redirect_info *info = data;
 
@@ -34,8 +34,10 @@ static unsigned int ebt_target_redirect(struct sk_buff *skb,
 	return info->target;
 }
 
-static bool ebt_target_redirect_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_redirect_tg_check(const char *tablename, const void *e,
+		      const struct xt_target *target, void *data,
+		      unsigned int hookmask)
 {
 	const struct ebt_redirect_info *info = data;
 
@@ -54,8 +56,8 @@ static struct ebt_target redirect_target __read_mostly = {
 	.name		= EBT_REDIRECT_TARGET,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.target		= ebt_target_redirect,
-	.check		= ebt_target_redirect_check,
+	.target		= ebt_redirect_tg,
+	.checkentry	= ebt_redirect_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_redirect_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 0e83de7..363d005 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -16,9 +16,10 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
 
-static unsigned int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_snat_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hook_nr,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_nat_info *info = data;
 
@@ -43,8 +44,10 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool ebt_target_snat_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_snat_tg_check(const char *tablename, const void *e,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	const struct ebt_nat_info *info = data;
 	int tmp;
@@ -70,8 +73,8 @@ static struct ebt_target snat __read_mostly = {
 	.name		= EBT_SNAT_TARGET,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.target		= ebt_target_snat,
-	.check		= ebt_target_snat_check,
+	.target		= ebt_snat_tg,
+	.checkentry	= ebt_snat_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index e6d8f0c..7576d1d 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -119,9 +119,10 @@ static bool ebt_filter_config(const struct ebt_stp_info *info,
 	return true;
 }
 
-static bool ebt_filter_stp(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out, const void *data, unsigned int datalen)
+static bool
+ebt_stp_mt(const struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, const struct xt_match *match,
+	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_stp_info *info = data;
 	const struct stp_header *sp;
@@ -154,12 +155,15 @@ static bool ebt_filter_stp(const struct sk_buff *skb,
 	return true;
 }
 
-static bool ebt_stp_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_stp_mt_check(const char *table, const void *entry,
+		 const struct xt_match *match, void *data,
+		 unsigned int hook_mask)
 {
 	const struct ebt_stp_info *info = data;
 	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
 	const uint8_t msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	const struct ebt_entry *e = entry;
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
@@ -176,8 +180,8 @@ static struct ebt_match filter_stp __read_mostly = {
 	.name		= EBT_STP_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_stp,
-	.check		= ebt_stp_check,
+	.match		= ebt_stp_mt,
+	.checkentry	= ebt_stp_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_stp_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 076b445..77ff9c4 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -246,9 +246,10 @@ static void ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 	ebt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static unsigned int ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_ulog_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hooknr,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_ulog_info *uloginfo = data;
 
@@ -256,8 +257,10 @@ static unsigned int ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
 	return EBT_CONTINUE;
 }
 
-static bool ebt_ulog_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_ulog_tg_check(const char *table, const void *entry,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	struct ebt_ulog_info *uloginfo = data;
 
@@ -276,8 +279,8 @@ static struct ebt_watcher ulog __read_mostly = {
 	.name		= EBT_ULOG_WATCHER,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.watcher	= ebt_ulog,
-	.check		= ebt_ulog_check,
+	.target		= ebt_ulog_tg,
+	.checkentry	= ebt_ulog_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_ulog_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 9e3a39a..3af688b 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -41,10 +41,9 @@ MODULE_LICENSE("GPL");
 #define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return false; }
 
 static bool
-ebt_filter_vlan(const struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		const void *data, unsigned int datalen)
+ebt_vlan_mt(const struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, const struct xt_match *match,
+	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_vlan_info *info = data;
 	const struct vlan_hdr *fp;
@@ -88,11 +87,12 @@ ebt_filter_vlan(const struct sk_buff *skb,
 }
 
 static bool
-ebt_check_vlan(const char *tablename,
-	       unsigned int hooknr,
-	       const struct ebt_entry *e, void *data, unsigned int datalen)
+ebt_vlan_mt_check(const char *table, const void *entry,
+		  const struct xt_match *match, void *data,
+		  unsigned int hook_mask)
 {
 	struct ebt_vlan_info *info = data;
+	const struct ebt_entry *e = entry;
 
 	/* Is it 802.1Q frame checked? */
 	if (e->ethproto != htons(ETH_P_8021Q)) {
@@ -166,8 +166,8 @@ static struct ebt_match filter_vlan __read_mostly = {
 	.name		= EBT_VLAN_MATCH,
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
-	.match		= ebt_filter_vlan,
-	.check		= ebt_check_vlan,
+	.match		= ebt_vlan_mt,
+	.checkentry	= ebt_vlan_mt_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_vlan_info)),
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index bc4b3f4..340e1c6 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -67,11 +67,10 @@ static struct ebt_target ebt_standard_target = {
 };
 
 static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
-   const struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
+   struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
    const struct net_device *out)
 {
-	w->u.watcher->watcher(skb, hooknr, in, out, w->data,
-	   w->watcher_size);
+	w->u.watcher->target(skb, in, out, hooknr, NULL, w->data);
 	/* watchers don't give a verdict */
 	return 0;
 }
@@ -80,8 +79,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
    const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out)
 {
-	return m->u.match->match(skb, in, out, m->data,
-	   m->match_size);
+	return m->u.match->match(skb, in, out, NULL, m->data, 0, 0, NULL);
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
@@ -195,8 +193,8 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (!t->u.target->target)
 			verdict = ((struct ebt_standard_target *)t)->verdict;
 		else
-			verdict = t->u.target->target(skb, hook,
-			   in, out, t->data, t->target_size);
+			verdict = t->u.target->target(skb, in, out, hook,
+				  NULL, t->data);
 		if (verdict == EBT_ACCEPT) {
 			read_unlock_bh(&table->lock);
 			return NF_ACCEPT;
@@ -376,8 +374,8 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 		       match->name, XT_ALIGN(match->matchsize), m->match_size);
 		goto out;
 	}
-	if (match->check &&
-	    !match->check(name, hookmask, e, m->data, m->match_size)) {
+	if (match->checkentry &&
+	    !match->checkentry(name, e, NULL, m->data, hookmask)) {
 		BUGPRINT("match->check failed\n");
 		goto out;
 	}
@@ -426,8 +424,8 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 		       w->watcher_size);
 		goto out;
 	}
-	if (watcher->check &&
-	    !watcher->check(name, hookmask, e, w->data, w->watcher_size)) {
+	if (watcher->checkentry &&
+	    !watcher->checkentry(name, e, NULL, w->data, hookmask)) {
 		BUGPRINT("watcher->check failed\n");
 		goto out;
 	}
@@ -609,7 +607,7 @@ ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
 	if (i && (*i)-- == 0)
 		return 1;
 	if (m->u.match->destroy)
-		m->u.match->destroy(m->data, m->match_size);
+		m->u.match->destroy(NULL, m->data);
 	module_put(m->u.match->me);
 
 	return 0;
@@ -621,7 +619,7 @@ ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
 	if (i && (*i)-- == 0)
 		return 1;
 	if (w->u.watcher->destroy)
-		w->u.watcher->destroy(w->data, w->watcher_size);
+		w->u.watcher->destroy(NULL, w->data);
 	module_put(w->u.watcher->me);
 
 	return 0;
@@ -641,7 +639,7 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, NULL);
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 	if (t->u.target->destroy)
-		t->u.target->destroy(t->data, t->target_size);
+		t->u.target->destroy(NULL, t->data);
 	module_put(t->u.target->me);
 
 	return 0;
@@ -755,8 +753,8 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		module_put(t->u.target->me);
 		ret = -EINVAL;
 		goto cleanup_watchers;
-	} else if (t->u.target->check &&
-	    !t->u.target->check(name, hookmask, e, t->data, t->target_size)) {
+	} else if (t->u.target->checkentry &&
+	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
 		module_put(t->u.target->me);
 		ret = -EFAULT;
 		goto cleanup_watchers;
