From: Jan Engelhardt <jengelh@medozas.de>
Subject: [NETFILTER]: Move extensions' arguments into compound structure
 (2/2)
Date: Fri, 3 Oct 2008 18:54:23 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810031852420.13861@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43750 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYJCWyZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:54:25 -0400
In-Reply-To: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit d9e3e5b45e5003f2a95ebc0ac3781be9a8b0d1e1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Oct 3 18:50:52 2008 -0400

[NETFILTER]: Move extensions' arguments into compound structure (2/2)

The function signatures for Xtables extensions have grown over time.
It involves a lot of typing/replication, and also a bit of stack space
even if they are not used. Realize an NFWS2008 idea and pack them into
structs. The skb remains outside of the struct so gcc can continue to
apply its optimizations.

This patch does this for targets (only).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |   38 ++++++++++----
 include/linux/netfilter_bridge/ebtables.h |    4 +-
 net/bridge/netfilter/ebt_arpreply.c       |   20 +++-----
 net/bridge/netfilter/ebt_dnat.c           |   21 ++++-----
 net/bridge/netfilter/ebt_log.c            |   21 +++-----
 net/bridge/netfilter/ebt_mark.c           |   13 ++----
 net/bridge/netfilter/ebt_nflog.c          |   16 ++----
 net/bridge/netfilter/ebt_redirect.c       |   25 ++++-----
 net/bridge/netfilter/ebt_snat.c           |   17 ++----
 net/bridge/netfilter/ebt_ulog.c           |   16 ++----
 net/bridge/netfilter/ebtables.c           |   22 +++++++--
 net/ipv4/netfilter/arp_tables.c           |   48 ++++++++++---------
 net/ipv4/netfilter/arpt_mangle.c          |   13 ++----
 net/ipv4/netfilter/ip_tables.c            |   46 +++++++++--------
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |   19 +++-----
 net/ipv4/netfilter/ipt_ECN.c              |   16 ++----
 net/ipv4/netfilter/ipt_LOG.c              |   16 ++----
 net/ipv4/netfilter/ipt_MASQUERADE.c       |   21 +++-----
 net/ipv4/netfilter/ipt_NETMAP.c           |   25 ++++------
 net/ipv4/netfilter/ipt_REDIRECT.c         |   19 +++-----
 net/ipv4/netfilter/ipt_REJECT.c           |   18 ++-----
 net/ipv4/netfilter/ipt_TTL.c              |   14 ++----
 net/ipv4/netfilter/ipt_ULOG.c             |   18 ++-----
 net/ipv4/netfilter/nf_nat_rule.c          |   46 ++++++------------
 net/ipv6/netfilter/ip6_tables.c           |   47 ++++++++++--------
 net/ipv6/netfilter/ip6t_HL.c              |   14 ++----
 net/ipv6/netfilter/ip6t_LOG.c             |   16 ++----
 net/ipv6/netfilter/ip6t_REJECT.c          |   27 ++++------
 net/netfilter/xt_CLASSIFY.c               |    6 +--
 net/netfilter/xt_CONNMARK.c               |   36 +++++---------
 net/netfilter/xt_CONNSECMARK.c            |   22 ++++-----
 net/netfilter/xt_DSCP.c                   |   54 +++++++--------------
 net/netfilter/xt_MARK.c                   |   33 ++++---------
 net/netfilter/xt_NFLOG.c                  |   18 ++-----
 net/netfilter/xt_NFQUEUE.c                |    6 +--
 net/netfilter/xt_NOTRACK.c                |    4 +-
 net/netfilter/xt_RATEEST.c                |   18 ++-----
 net/netfilter/xt_SECMARK.c                |   18 +++----
 net/netfilter/xt_TCPMSS.c                 |   34 +++++--------
 net/netfilter/xt_TCPOPTSTRIP.c            |   12 ++---
 net/netfilter/xt_TRACE.c                  |    5 +--
 net/sched/act_ipt.c                       |   29 +++++++----
 42 files changed, 382 insertions(+), 549 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 6c6babd..028a8f1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -211,6 +211,31 @@ struct xt_mtchk_param {
 	unsigned int hook_mask;
 };
 
+/**
+ * struct xt_target_param - parameters for target functions
+ *
+ * @hooknum:	hook through which this target was invoked
+ * @target:	struct xt_target through which this function was invoked
+ * @targinfo:	per-target data
+ *
+ * Other fields see above.
+ */
+struct xt_target_param {
+	const struct net_device *in, *out;
+	unsigned int hooknum;
+	const struct xt_target *target;
+	const void *targinfo;
+};
+
+/* Field descriptions see above (xt_mtchk_param). */
+struct xt_tgchk_param {
+	const char *table;
+	void *entryinfo;
+	const struct xt_target *target;
+	void *targinfo;
+	unsigned int hook_mask;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -260,22 +285,13 @@ struct xt_target
 	/* Returns verdict. Argument order changed since 2.6.9, as this
 	   must now handle non-linear skbs, using skb_copy_bits and
 	   skb_ip_make_writable. */
-	unsigned int (*target)(struct sk_buff *skb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       unsigned int hooknum,
-			       const struct xt_target *target,
-			       const void *targinfo);
+	unsigned int (*target)(struct sk_buff *skb, struct xt_target_param *);
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
-	bool (*checkentry)(const char *tablename,
-			   const void *entry,
-			   const struct xt_target *target,
-			   void *targinfo,
-			   unsigned int hook_mask);
+	bool (*checkentry)(struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_target *target, void *targinfo);
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 568a690..d45e29c 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -310,9 +310,9 @@ extern unsigned int ebt_do_table(unsigned int hook, struct sk_buff *skb,
 #define FWINV(bool,invflg) ((bool) ^ !!(info->invflags & invflg))
 /* True if the hook mask denotes that the rule is in a base chain,
  * used in the check() functions */
-#define BASE_CHAIN (hookmask & (1 << NF_BR_NUMHOOKS))
+#define BASE_CHAIN (par->hook_mask & (1 << NF_BR_NUMHOOKS))
 /* Clear the bit in the hook mask that tells if the rule is on a base chain */
-#define CLEAR_BASE_CHAIN_BIT (hookmask &= ~(1 << NF_BR_NUMHOOKS))
+#define CLEAR_BASE_CHAIN_BIT (par->hook_mask &= ~(1 << NF_BR_NUMHOOKS))
 /* True if the target is not a standard target */
 #define INVALID_TARGET (info->target < -NUM_STANDARD_TARGETS || info->target >= 0)
 
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 93596d9..9afac0c 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -16,11 +16,9 @@
 #include <linux/netfilter_bridge/ebt_arpreply.h>
 
 static unsigned int
-ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hook_nr,
-		const struct xt_target *target, const void *data)
+ebt_arpreply_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_arpreply_info *info = data;
+	const struct ebt_arpreply_info *info = par->targinfo;
 	const __be32 *siptr, *diptr;
 	__be32 _sip, _dip;
 	const struct arphdr *ap;
@@ -53,19 +51,16 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
 	if (diptr == NULL)
 		return EBT_DROP;
 
-	arp_send(ARPOP_REPLY, ETH_P_ARP, *siptr, (struct net_device *)in,
+	arp_send(ARPOP_REPLY, ETH_P_ARP, *siptr, (struct net_device *)par->in,
 		 *diptr, shp, info->mac, shp);
 
 	return info->target;
 }
 
-static bool
-ebt_arpreply_tg_check(const char *tablename, const void *entry,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
+static bool ebt_arpreply_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_arpreply_info *info = data;
-	const struct ebt_entry *e = entry;
+	const struct ebt_arpreply_info *info = par->targinfo;
+	const struct ebt_entry *e = par->entryinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
@@ -73,7 +68,8 @@ ebt_arpreply_tg_check(const char *tablename, const void *entry,
 	    e->invflags & EBT_IPROTO)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
+	if (strcmp(par->table, "nat") ||
+	    par->hook_mask & ~(1 << NF_BR_PRE_ROUTING))
 		return false;
 	return true;
 }
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index d2211c4..0569fea 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -15,11 +15,9 @@
 #include <linux/netfilter_bridge/ebt_nat.h>
 
 static unsigned int
-ebt_dnat_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hook_nr,
-	    const struct xt_target *target, const void *data)
+ebt_dnat_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
@@ -28,19 +26,18 @@ ebt_dnat_tg(struct sk_buff *skb, const struct net_device *in,
 	return info->target;
 }
 
-static bool
-ebt_dnat_tg_check(const char *tablename, const void *entry,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_dnat_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if ( (strcmp(tablename, "nat") ||
-	   (hookmask & ~((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT)))) &&
-	   (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
+	if ((strcmp(par->table, "nat") != 0 ||
+	    (par->hook_mask & ~((1 << NF_BR_PRE_ROUTING) |
+	    (1 << NF_BR_LOCAL_OUT)))) &&
+	    (strcmp(par->table, "broute") != 0 ||
+	    par->hook_mask & ~(1 << NF_BR_BROUTING)))
 		return false;
 	if (INVALID_TARGET)
 		return false;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index b40f9ed..f7543b7 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,12 +24,9 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static bool
-ebt_log_tg_check(const char *table, const void *entry,
-		 const struct xt_target *target, void *data,
-		 unsigned int hook_mask)
+static bool ebt_log_tg_check(struct xt_tgchk_param *par)
 {
-	struct ebt_log_info *info = data;
+	struct ebt_log_info *info = par->targinfo;
 
 	if (info->bitmask & ~EBT_LOG_MASK)
 		return false;
@@ -195,11 +192,9 @@ out:
 }
 
 static unsigned int
-ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, unsigned int hooknr,
-	   const struct xt_target *target, const void *data)
+ebt_log_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_log_info *info = data;
+	const struct ebt_log_info *info = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
@@ -207,11 +202,11 @@ ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.log.logflags = info->bitmask;
 
 	if (info->bitmask & EBT_LOG_NFLOG)
-		nf_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
-			      "%s", info->prefix);
+		nf_log_packet(NFPROTO_BRIDGE, par->hooknum, skb, par->in,
+		              par->out, &li, "%s", info->prefix);
 	else
-		ebt_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
-			       info->prefix);
+		ebt_log_packet(NFPROTO_BRIDGE, par->hooknum, skb, par->in,
+		               par->out, &li, info->prefix);
 	return EBT_CONTINUE;
 }
 
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index dff19fc..f8796a0 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -19,11 +19,9 @@
 #include <linux/netfilter_bridge/ebt_mark_t.h>
 
 static unsigned int
-ebt_mark_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hook_nr,
-	    const struct xt_target *target, const void *data)
+ebt_mark_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_mark_t_info *info = data;
+	const struct ebt_mark_t_info *info = par->targinfo;
 	int action = info->target & -16;
 
 	if (action == MARK_SET_VALUE)
@@ -38,12 +36,9 @@ ebt_mark_tg(struct sk_buff *skb, const struct net_device *in,
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool
-ebt_mark_tg_check(const char *table, const void *e,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_mark_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_mark_t_info *info = data;
+	const struct ebt_mark_t_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 74b4fa0..53a700f 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -20,11 +20,9 @@
 #include <net/netfilter/nf_log.h>
 
 static unsigned int
-ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, unsigned int hooknr,
-	     const struct xt_target *target, const void *data)
+ebt_nflog_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_nflog_info *info = data;
+	const struct ebt_nflog_info *info = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_ULOG;
@@ -32,16 +30,14 @@ ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.ulog.group = info->group;
 	li.u.ulog.qthreshold = info->threshold;
 
-	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, "%s", info->prefix);
+	nf_log_packet(PF_BRIDGE, par->hooknum, skb, par->in, par->out,
+	              &li, "%s", info->prefix);
 	return EBT_CONTINUE;
 }
 
-static bool
-ebt_nflog_tg_check(const char *table, const void *e,
-		   const struct xt_target *target, void *data,
-		   unsigned int hookmask)
+static bool ebt_nflog_tg_check(struct xt_tgchk_param *par)
 {
-	struct ebt_nflog_info *info = data;
+	struct ebt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 1b7684f..83d43df 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -16,36 +16,33 @@
 #include <linux/netfilter_bridge/ebt_redirect.h>
 
 static unsigned int
-ebt_redirect_tg(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hooknr,
-		const struct xt_target *target, const void *data)
+ebt_redirect_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_redirect_info *info = data;
+	const struct ebt_redirect_info *info = par->targinfo;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
 
-	if (hooknr != NF_BR_BROUTING)
+	if (par->hooknum != NF_BR_BROUTING)
 		memcpy(eth_hdr(skb)->h_dest,
-		       in->br_port->br->dev->dev_addr, ETH_ALEN);
+		       par->in->br_port->br->dev->dev_addr, ETH_ALEN);
 	else
-		memcpy(eth_hdr(skb)->h_dest, in->dev_addr, ETH_ALEN);
+		memcpy(eth_hdr(skb)->h_dest, par->in->dev_addr, ETH_ALEN);
 	skb->pkt_type = PACKET_HOST;
 	return info->target;
 }
 
-static bool
-ebt_redirect_tg_check(const char *tablename, const void *e,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
+static bool ebt_redirect_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_redirect_info *info = data;
+	const struct ebt_redirect_info *info = par->targinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if ( (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING)) &&
-	     (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
+	if ((strcmp(par->table, "nat") != 0 ||
+	    par->hook_mask & ~(1 << NF_BR_PRE_ROUTING)) &&
+	    (strcmp(par->table, "broute") != 0 ||
+	    par->hook_mask & ~(1 << NF_BR_BROUTING)))
 		return false;
 	if (INVALID_TARGET)
 		return false;
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index c90217a..53b9763 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -17,11 +17,9 @@
 #include <linux/netfilter_bridge/ebt_nat.h>
 
 static unsigned int
-ebt_snat_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hook_nr,
-	    const struct xt_target *target, const void *data)
+ebt_snat_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
@@ -44,21 +42,18 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool
-ebt_snat_tg_check(const char *tablename, const void *e,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_snat_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat"))
+	if (strcmp(par->table, "nat") != 0)
 		return false;
-	if (hookmask & ~(1 << NF_BR_POST_ROUTING))
+	if (par->hook_mask & ~(1 << NF_BR_POST_ROUTING))
 		return false;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 25ca646..759b20f 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -247,22 +247,16 @@ static void ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 }
 
 static unsigned int
-ebt_ulog_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hooknr,
-	    const struct xt_target *target, const void *data)
+ebt_ulog_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ebt_ulog_info *uloginfo = data;
-
-	ebt_ulog_packet(hooknr, skb, in, out, uloginfo, NULL);
+	ebt_ulog_packet(par->hooknum, skb, par->in, par->out,
+	                par->targinfo, NULL);
 	return EBT_CONTINUE;
 }
 
-static bool
-ebt_ulog_tg_check(const char *table, const void *entry,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_ulog_tg_check(struct xt_tgchk_param *par)
 {
-	struct ebt_ulog_info *uloginfo = data;
+	struct ebt_ulog_info *uloginfo = par->targinfo;
 
 	if (uloginfo->nlgroup > 31)
 		return false;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 2e6c0d2..c25f078 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -67,7 +67,14 @@ static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
    struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
    const struct net_device *out)
 {
-	w->u.watcher->target(skb, in, out, hooknr, w->u.watcher, w->data);
+	struct xt_target_param par = {
+		.in       = in,
+		.out      = out,
+		.hooknum  = hooknr,
+		.target   = w->u.watcher,
+		.targinfo = w->data,
+	};
+	par.target->target(skb, &par);
 	/* watchers don't give a verdict */
 	return 0;
 }
@@ -204,9 +211,16 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		/* standard target */
 		if (!t->u.target->target)
 			verdict = ((struct ebt_standard_target *)t)->verdict;
-		else
-			verdict = t->u.target->target(skb, in, out, hook,
-				  t->u.target, t->data);
+		else {
+			struct xt_target_param par = {
+				.in       = in,
+				.out      = out,
+				.hooknum  = hook,
+				.target   = t->u.target,
+				.targinfo = t->data,
+			};
+			verdict = t->u.target->target(skb, &par);
+		}
 		if (verdict == EBT_ACCEPT) {
 			read_unlock_bh(&table->lock);
 			return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b4a9a17..afbee6e 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -200,15 +200,12 @@ static inline int arp_checkentry(const struct arpt_arp *arp)
 	return 1;
 }
 
-static unsigned int arpt_error(struct sk_buff *skb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       unsigned int hooknum,
-			       const struct xt_target *target,
-			       const void *targinfo)
+static unsigned int
+arpt_error(struct sk_buff *skb, struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("arp_tables: error: '%s'\n", (char *)targinfo);
+		printk("arp_tables: error: '%s'\n",
+		       (const char *)par->targinfo);
 
 	return NF_DROP;
 }
@@ -290,11 +287,14 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 				/* Targets which reenter must return
 				 * abs. verdicts
 				 */
-				verdict = t->u.kernel.target->target(skb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data);
+				struct xt_target_param par = {
+					.in       = in,
+					.out      = out,
+					.hooknum  = hook,
+					.target   = t->u.kernel.target,
+					.targinfo = t->data,
+				};
+				verdict = par.target->target(skb, &par);
 
 				/* Target might have changed stuff. */
 				arp = arp_hdr(skb);
@@ -456,21 +456,23 @@ static inline int check_entry(struct arpt_entry *e, const char *name)
 
 static inline int check_target(struct arpt_entry *e, const char *name)
 {
-	struct arpt_entry_target *t;
-	struct xt_target *target;
+	struct arpt_entry_target *t = arpt_get_target(e);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
 	int ret;
 
-	t = arpt_get_target(e);
-	target = t->u.kernel.target;
-
-	ret = xt_check_target(target, NFPROTO_ARP,
+	ret = xt_check_target(par.target, NFPROTO_ARP,
 			      t->u.target_size - sizeof(*t),
 			      name, e->comefrom, 0, 0);
-	if (!ret && t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
-		duprintf("arp_tables: check failed for `%s'.\n",
-			 t->u.kernel.target->name);
+	if (!ret && par.target->checkentry != NULL &&
+	    !par.target->checkentry(&par)) {
+		duprintf(KBUILD_MODNAME ": check failed for target \"%s\".\n",
+			 par.target->name);
 		ret = -EINVAL;
 	}
 	return ret;
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 3f9e4cc..1f52f8a 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -9,12 +9,9 @@ MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
 MODULE_DESCRIPTION("arptables arp payload mangle target");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in, const struct net_device *out,
-       unsigned int hooknum, const struct xt_target *target,
-       const void *targinfo)
+target(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct arpt_mangle *mangle = targinfo;
+	const struct arpt_mangle *mangle = par->targinfo;
 	const struct arphdr *arp;
 	unsigned char *arpptr;
 	int pln, hln;
@@ -57,11 +54,9 @@ target(struct sk_buff *skb,
 	return mangle->target;
 }
 
-static bool
-checkentry(const char *tablename, const void *e, const struct xt_target *target,
-	   void *targinfo, unsigned int hook_mask)
+static bool checkentry(struct xt_tgchk_param *par)
 {
-	const struct arpt_mangle *mangle = targinfo;
+	const struct arpt_mangle *mangle = par->targinfo;
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index aea16a4..7d9382f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -170,16 +170,11 @@ ip_checkentry(const struct ipt_ip *ip)
 	return true;
 }
 
-static unsigned int
-ipt_error(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+static unsigned int ipt_error(struct sk_buff *skb, struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("ip_tables: error: `%s'\n", (char *)targinfo);
+		printk("ip_tables: error: `%s'\n",
+		       (const char *)par->targinfo);
 
 	return NF_DROP;
 }
@@ -422,16 +417,19 @@ ipt_do_table(struct sk_buff *skb,
 			} else {
 				/* Targets which reenter must return
 				   abs. verdicts */
+
+				struct xt_target_param par = {
+					.in       = in,
+					.out      = out,
+					.hooknum  = hook,
+					.target   = t->u.kernel.target,
+					.targinfo = t->data,
+				};
 #ifdef CONFIG_NETFILTER_DEBUG
 				((struct ipt_entry *)table_base)->comefrom
 					= 0xeeeeeeec;
 #endif
-				verdict = t->u.kernel.target->target(skb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data);
-
+				verdict = par.target->target(skb, &par);
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ipt_entry *)table_base)->comefrom
 				    != 0xeeeeeeec
@@ -673,18 +671,22 @@ err:
 
 static int check_target(struct ipt_entry *e, const char *name)
 {
-	struct ipt_entry_target *t;
-	struct xt_target *target;
+	struct ipt_entry_target *t = ipt_get_target(e);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
 	int ret;
 
-	t = ipt_get_target(e);
-	target = t->u.kernel.target;
-	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
+	ret = xt_check_target(par.target, AF_INET,
+			      t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ip.proto,
 			      e->ip.invflags & IPT_INV_PROTO);
-	if (!ret && t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
+	if (!ret && par.target->checkentry != NULL &&
+	    !par.target->checkentry(&par)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 63faddc..be81a50 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -281,11 +281,9 @@ clusterip_responsible(const struct clusterip_config *config, u_int32_t hash)
  ***********************************************************************/
 
 static unsigned int
-clusterip_tg(struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, unsigned int hooknum,
-             const struct xt_target *target, const void *targinfo)
+clusterip_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
+	const struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t hash;
@@ -349,13 +347,10 @@ clusterip_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-clusterip_tg_check(const char *tablename, const void *e_void,
-                   const struct xt_target *target, void *targinfo,
-                   unsigned int hook_mask)
+static bool clusterip_tg_check(struct xt_tgchk_param *par)
 {
-	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	struct clusterip_config *config;
 
@@ -406,9 +401,9 @@ clusterip_tg_check(const char *tablename, const void *e_void,
 	}
 	cipinfo->config = config;
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", target->family);
+				    "proto=%u\n", par->target->family);
 		return false;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index aee2364..923a55e 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -76,12 +76,9 @@ set_ect_tcp(struct sk_buff *skb, const struct ipt_ECN_info *einfo)
 	return true;
 }
 
-static unsigned int
-ecn_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+static unsigned int ecn_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ipt_ECN_info *einfo = targinfo;
+	const struct ipt_ECN_info *einfo = par->targinfo;
 
 	if (einfo->operation & IPT_ECN_OP_SET_IP)
 		if (!set_ect_ip(skb, einfo))
@@ -95,13 +92,10 @@ ecn_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-ecn_tg_check(const char *tablename, const void *e_void,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool ecn_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_ECN_info *einfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	const struct ipt_ECN_info *einfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		printk(KERN_WARNING "ECN: unsupported ECN operation %x\n",
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 1c9785d..9ac759f 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -425,29 +425,23 @@ ipt_log_packet(u_int8_t pf,
 	spin_unlock_bh(&log_lock);
 }
 
-static unsigned int
-log_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+static unsigned int log_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	ipt_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, &li,
+	ipt_log_packet(NFPROTO_IPV4, par->hooknum, skb, par->in, par->out, &li,
 		       loginfo->prefix);
 	return XT_CONTINUE;
 }
 
-static bool
-log_tg_check(const char *tablename, const void *e,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool log_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 5e1c817..bfbfed1 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -31,12 +31,9 @@ MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 static DEFINE_RWLOCK(masq_lock);
 
 /* FIXME: Multiple targets. --RR */
-static bool
-masquerade_tg_check(const char *tablename, const void *e,
-                    const struct xt_target *target, void *targinfo,
-                    unsigned int hook_mask)
+static bool masquerade_tg_check(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("masquerade_check: bad MAP_IPS.\n");
@@ -50,9 +47,7 @@ masquerade_tg_check(const char *tablename, const void *e,
 }
 
 static unsigned int
-masquerade_tg(struct sk_buff *skb, const struct net_device *in,
-              const struct net_device *out, unsigned int hooknum,
-              const struct xt_target *target, const void *targinfo)
+masquerade_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	struct nf_conn_nat *nat;
@@ -62,7 +57,7 @@ masquerade_tg(struct sk_buff *skb, const struct net_device *in,
 	const struct rtable *rt;
 	__be32 newsrc;
 
-	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
+	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING);
 
 	ct = nf_ct_get(skb, &ctinfo);
 	nat = nfct_nat(ct);
@@ -76,16 +71,16 @@ masquerade_tg(struct sk_buff *skb, const struct net_device *in,
 	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip == 0)
 		return NF_ACCEPT;
 
-	mr = targinfo;
+	mr = par->targinfo;
 	rt = skb->rtable;
-	newsrc = inet_select_addr(out, rt->rt_gateway, RT_SCOPE_UNIVERSE);
+	newsrc = inet_select_addr(par->out, rt->rt_gateway, RT_SCOPE_UNIVERSE);
 	if (!newsrc) {
-		printk("MASQUERADE: %s ate my IP address\n", out->name);
+		printk("MASQUERADE: %s ate my IP address\n", par->out->name);
 		return NF_DROP;
 	}
 
 	write_lock_bh(&masq_lock);
-	nat->masq_index = out->ifindex;
+	nat->masq_index = par->out->ifindex;
 	write_unlock_bh(&masq_lock);
 
 	/* Transfer from original range. */
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index f281500..09dee68 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -22,12 +22,9 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
 
-static bool
-netmap_tg_check(const char *tablename, const void *e,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool netmap_tg_check(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		pr_debug("NETMAP:check: bad MAP_IPS.\n");
@@ -40,25 +37,23 @@ netmap_tg_check(const char *tablename, const void *e,
 	return true;
 }
 
-static unsigned int
-netmap_tg(struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, unsigned int hooknum,
-          const struct xt_target *target, const void *targinfo)
+static unsigned int netmap_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	__be32 new_ip, netmask;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range newrange;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING
-		     || hooknum == NF_INET_POST_ROUTING
-		     || hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
+		     par->hooknum == NF_INET_POST_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_OUT);
 	ct = nf_ct_get(skb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
 
-	if (hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_LOCAL_OUT)
+	if (par->hooknum == NF_INET_PRE_ROUTING ||
+	    par->hooknum == NF_INET_LOCAL_OUT)
 		new_ip = ip_hdr(skb)->daddr & ~netmask;
 	else
 		new_ip = ip_hdr(skb)->saddr & ~netmask;
@@ -70,7 +65,7 @@ netmap_tg(struct sk_buff *skb, const struct net_device *in,
 		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(hooknum));
+	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(par->hooknum));
 }
 
 static struct xt_target netmap_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index ef49610..0b9cb99 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -26,12 +26,9 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Connection redirection to localhost");
 
 /* FIXME: Take multiple ranges --RR */
-static bool
-redirect_tg_check(const char *tablename, const void *e,
-                  const struct xt_target *target, void *targinfo,
-                  unsigned int hook_mask)
+static bool redirect_tg_check(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("redirect_check: bad MAP_IPS.\n");
@@ -45,24 +42,22 @@ redirect_tg_check(const char *tablename, const void *e,
 }
 
 static unsigned int
-redirect_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+redirect_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	__be32 newdst;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range newrange;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING
-		     || hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_OUT);
 
 	ct = nf_ct_get(skb, &ctinfo);
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
 	/* Local packets: make them go to loopback */
-	if (hooknum == NF_INET_LOCAL_OUT)
+	if (par->hooknum == NF_INET_LOCAL_OUT)
 		newdst = htonl(0x7F000001);
 	else {
 		struct in_device *indev;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 9f5da0c..a77442a 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -135,12 +135,9 @@ static inline void send_unreach(struct sk_buff *skb_in, int code)
 	icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 }
 
-static unsigned int
-reject_tg(struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, unsigned int hooknum,
-          const struct xt_target *target, const void *targinfo)
+static unsigned int reject_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ipt_reject_info *reject = targinfo;
+	const struct ipt_reject_info *reject = par->targinfo;
 
 	/* WARNING: This code causes reentry within iptables.
 	   This means that the iptables jump stack is now crap.  We
@@ -168,7 +165,7 @@ reject_tg(struct sk_buff *skb, const struct net_device *in,
 		send_unreach(skb, ICMP_PKT_FILTERED);
 		break;
 	case IPT_TCP_RESET:
-		send_reset(skb, hooknum);
+		send_reset(skb, par->hooknum);
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
@@ -177,13 +174,10 @@ reject_tg(struct sk_buff *skb, const struct net_device *in,
 	return NF_DROP;
 }
 
-static bool
-reject_tg_check(const char *tablename, const void *e_void,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool reject_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_reject_info *rejinfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	const struct ipt_reject_info *rejinfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		printk("ipt_REJECT: ECHOREPLY no longer supported.\n");
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 7d01d42..35585ea 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -19,13 +19,10 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: IPv4 TTL field modification target");
 MODULE_LICENSE("GPL");
 
-static unsigned int
-ttl_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+static unsigned int ttl_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct iphdr *iph;
-	const struct ipt_TTL_info *info = targinfo;
+	const struct ipt_TTL_info *info = par->targinfo;
 	int new_ttl;
 
 	if (!skb_make_writable(skb, skb->len))
@@ -61,12 +58,9 @@ ttl_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-ttl_tg_check(const char *tablename, const void *e,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool ttl_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_TTL_info *info = targinfo;
+	const struct ipt_TTL_info *info = par->targinfo;
 
 	if (info->mode > IPT_TTL_MAXMODE) {
 		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 9065e4a..5e49612 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -280,15 +280,10 @@ alloc_failure:
 	spin_unlock_bh(&ulog_lock);
 }
 
-static unsigned int
-ulog_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+static unsigned int ulog_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
-
-	ipt_ulog_packet(hooknum, skb, in, out, loginfo, NULL);
-
+	ipt_ulog_packet(par->hooknum, skb, par->in, par->out,
+	                par->targinfo, NULL);
 	return XT_CONTINUE;
 }
 
@@ -317,12 +312,9 @@ static void ipt_logfn(u_int8_t pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static bool
-ulog_tg_check(const char *tablename, const void *e,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hookmask)
+static bool ulog_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_ulog_info *loginfo = targinfo;
+	const struct ipt_ulog_info *loginfo = par->targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		pr_debug("ipt_ULOG: prefix term %i\n",
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index e8b4d0d..a21c86c 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -68,25 +68,21 @@ static struct xt_table __nat_table = {
 static struct xt_table *nat_table;
 
 /* Source NAT */
-static unsigned int ipt_snat_target(struct sk_buff *skb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    unsigned int hooknum,
-				    const struct xt_target *target,
-				    const void *targinfo)
+static unsigned int
+ipt_snat_target(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
-	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
+	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
 	/* Connection must be valid and new. */
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			    ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
-	NF_CT_ASSERT(out);
+	NF_CT_ASSERT(par->out != NULL);
 
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_SRC);
 }
@@ -110,26 +106,22 @@ static void warn_if_extra_mangle(__be32 dstip, __be32 srcip)
 	ip_rt_put(rt);
 }
 
-static unsigned int ipt_dnat_target(struct sk_buff *skb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    unsigned int hooknum,
-				    const struct xt_target *target,
-				    const void *targinfo)
+static unsigned int
+ipt_dnat_target(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING ||
-		     hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_OUT);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
 	/* Connection must be valid and new. */
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
-	if (hooknum == NF_INET_LOCAL_OUT &&
+	if (par->hooknum == NF_INET_LOCAL_OUT &&
 	    mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)
 		warn_if_extra_mangle(ip_hdr(skb)->daddr,
 				     mr->range[0].min_ip);
@@ -137,13 +129,9 @@ static unsigned int ipt_dnat_target(struct sk_buff *skb,
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
 }
 
-static bool ipt_snat_checkentry(const char *tablename,
-				const void *entry,
-				const struct xt_target *target,
-				void *targinfo,
-				unsigned int hook_mask)
+static bool ipt_snat_checkentry(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
@@ -153,13 +141,9 @@ static bool ipt_snat_checkentry(const char *tablename,
 	return true;
 }
 
-static bool ipt_dnat_checkentry(const char *tablename,
-				const void *entry,
-				const struct xt_target *target,
-				void *targinfo,
-				unsigned int hook_mask)
+static bool ipt_dnat_checkentry(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1b3dacb..245602e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -200,15 +200,11 @@ ip6_checkentry(const struct ip6t_ip6 *ipv6)
 }
 
 static unsigned int
-ip6t_error(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+ip6t_error(struct sk_buff *skb, struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("ip6_tables: error: `%s'\n", (char *)targinfo);
+		printk("ip6_tables: error: `%s'\n",
+		       (const char *)par->targinfo);
 
 	return NF_DROP;
 }
@@ -450,15 +446,19 @@ ip6t_do_table(struct sk_buff *skb,
 			} else {
 				/* Targets which reenter must return
 				   abs. verdicts */
+				struct xt_target_param par = {
+					.in       = in,
+					.out      = out,
+					.hooknum  = hook,
+					.target   = t->u.kernel.target,
+					.targinfo = t->data,
+				};
+
 #ifdef CONFIG_NETFILTER_DEBUG
 				((struct ip6t_entry *)table_base)->comefrom
 					= 0xeeeeeeec;
 #endif
-				verdict = t->u.kernel.target->target(skb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data);
+				verdict = par.target->target(skb, &par);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ip6t_entry *)table_base)->comefrom
@@ -699,20 +699,25 @@ err:
 
 static int check_target(struct ip6t_entry *e, const char *name)
 {
-	struct ip6t_entry_target *t;
-	struct xt_target *target;
+	struct ip6t_entry_target *t = ip6t_get_target(e);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
 	int ret;
 
 	t = ip6t_get_target(e);
-	target = t->u.kernel.target;
-	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
+	ret = xt_check_target(par.target, AF_INET6,
+			      t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ipv6.proto,
 			      e->ipv6.invflags & IP6T_INV_PROTO);
-	if (!ret && t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 t->u.kernel.target->name);
+	if (!ret && par.target->checkentry != NULL &&
+	    !par.target->checkentry(&par)) {
+		duprintf(KBUILD_MODNAME ": check failed for target \"%s\".\n",
+			 par.target->name);
 		ret = -EINVAL;
 	}
 	return ret;
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 7eebd35..f4da8a1 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -18,13 +18,10 @@ MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
 MODULE_DESCRIPTION("Xtables: IPv6 Hop Limit field modification target");
 MODULE_LICENSE("GPL");
 
-static unsigned int
-hl_tg6(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+static unsigned int hl_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct ipv6hdr *ip6h;
-	const struct ip6t_HL_info *info = targinfo;
+	const struct ip6t_HL_info *info = par->targinfo;
 	int new_hl;
 
 	if (!skb_make_writable(skb, skb->len))
@@ -56,12 +53,9 @@ hl_tg6(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-hl_tg6_check(const char *tablename, const void *entry,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool hl_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct ip6t_HL_info *info = targinfo;
+	const struct ip6t_HL_info *info = par->targinfo;
 
 	if (info->mode > IP6T_HL_MAXMODE) {
 		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index fd148f3..b2bfe6a 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -437,30 +437,24 @@ ip6t_log_packet(u_int8_t pf,
 	spin_unlock_bh(&log_lock);
 }
 
-static unsigned int
-log_tg6(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+static unsigned int log_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ip6t_log_info *loginfo = targinfo;
+	const struct ip6t_log_info *loginfo = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	ip6t_log_packet(NFPROTO_IPV6, hooknum, skb, in, out,
+	ip6t_log_packet(NFPROTO_IPV6, par->hooknum, skb, par->in, par->out,
 			&li, loginfo->prefix);
 	return XT_CONTINUE;
 }
 
 
-static bool
-log_tg6_check(const char *tablename, const void *entry,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+static bool log_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct ip6t_log_info *loginfo = targinfo;
+	const struct ip6t_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index f1a9fce..522de8d 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -173,12 +173,10 @@ send_unreach(struct net *net, struct sk_buff *skb_in, unsigned char code,
 }
 
 static unsigned int
-reject_tg6(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+reject_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ip6t_reject_info *reject = targinfo;
-	struct net *net = dev_net(in ? in : out);
+	const struct ip6t_reject_info *reject = par->targinfo;
+	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);
 
 	pr_debug("%s: medium point\n", __func__);
 	/* WARNING: This code causes reentry within ip6tables.
@@ -186,19 +184,19 @@ reject_tg6(struct sk_buff *skb, const struct net_device *in,
 	   must return an absolute verdict. --RR */
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
-		send_unreach(net, skb, ICMPV6_NOROUTE, hooknum);
+		send_unreach(net, skb, ICMPV6_NOROUTE, par->hooknum);
 		break;
 	case IP6T_ICMP6_ADM_PROHIBITED:
-		send_unreach(net, skb, ICMPV6_ADM_PROHIBITED, hooknum);
+		send_unreach(net, skb, ICMPV6_ADM_PROHIBITED, par->hooknum);
 		break;
 	case IP6T_ICMP6_NOT_NEIGHBOUR:
-		send_unreach(net, skb, ICMPV6_NOT_NEIGHBOUR, hooknum);
+		send_unreach(net, skb, ICMPV6_NOT_NEIGHBOUR, par->hooknum);
 		break;
 	case IP6T_ICMP6_ADDR_UNREACH:
-		send_unreach(net, skb, ICMPV6_ADDR_UNREACH, hooknum);
+		send_unreach(net, skb, ICMPV6_ADDR_UNREACH, par->hooknum);
 		break;
 	case IP6T_ICMP6_PORT_UNREACH:
-		send_unreach(net, skb, ICMPV6_PORT_UNREACH, hooknum);
+		send_unreach(net, skb, ICMPV6_PORT_UNREACH, par->hooknum);
 		break;
 	case IP6T_ICMP6_ECHOREPLY:
 		/* Do nothing */
@@ -215,13 +213,10 @@ reject_tg6(struct sk_buff *skb, const struct net_device *in,
 	return NF_DROP;
 }
 
-static bool
-reject_tg6_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool reject_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct ip6t_reject_info *rejinfo = targinfo;
-	const struct ip6t_entry *e = entry;
+	const struct ip6t_reject_info *rejinfo = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		printk("ip6t_REJECT: ECHOREPLY is not supported.\n");
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 8cffa29..0582bba 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -27,11 +27,9 @@ MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
 
 static unsigned int
-classify_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+classify_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_classify_target_info *clinfo = targinfo;
+	const struct xt_classify_target_info *clinfo = par->targinfo;
 
 	skb->priority = clinfo->priority;
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index e72e5d0..bf84f6c 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -36,11 +36,9 @@ MODULE_ALIAS("ip6t_CONNMARK");
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 static unsigned int
-connmark_tg_v0(struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, unsigned int hooknum,
-               const struct xt_target *target, const void *targinfo)
+connmark_tg_v0(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_connmark_target_info *markinfo = targinfo;
+	const struct xt_connmark_target_info *markinfo = par->targinfo;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t diff;
@@ -77,11 +75,9 @@ connmark_tg_v0(struct sk_buff *skb, const struct net_device *in,
 }
 
 static unsigned int
-connmark_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+connmark_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_connmark_tginfo1 *info = targinfo;
+	const struct xt_connmark_tginfo1 *info = par->targinfo;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	u_int32_t newmark;
@@ -116,18 +112,15 @@ connmark_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-connmark_tg_check_v0(const char *tablename, const void *entry,
-                     const struct xt_target *target, void *targinfo,
-                     unsigned int hook_mask)
+static bool connmark_tg_check_v0(struct xt_tgchk_param *par)
 {
-	const struct xt_connmark_target_info *matchinfo = targinfo;
+	const struct xt_connmark_target_info *matchinfo = par->targinfo;
 
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
-		if (strcmp(tablename, "mangle") != 0) {
+		if (strcmp(par->table, "mangle") != 0) {
 			printk(KERN_WARNING "CONNMARK: restore can only be "
 			       "called from \"mangle\" table, not \"%s\"\n",
-			       tablename);
+			       par->table);
 			return false;
 		}
 	}
@@ -135,22 +128,19 @@ connmark_tg_check_v0(const char *tablename, const void *entry,
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
 		return false;
 	}
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", target->family);
+				    "proto=%u\n", par->target->family);
 		return false;
 	}
 	return true;
 }
 
-static bool
-connmark_tg_check(const char *tablename, const void *entry,
-                  const struct xt_target *target, void *targinfo,
-                  unsigned int hook_mask)
+static bool connmark_tg_check(struct xt_tgchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", target->family);
+		       "proto=%u\n", par->target->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index ae939e5..3506f37 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -65,11 +65,9 @@ static void secmark_restore(struct sk_buff *skb)
 }
 
 static unsigned int
-connsecmark_tg(struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, unsigned int hooknum,
-               const struct xt_target *target, const void *targinfo)
+connsecmark_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_connsecmark_target_info *info = targinfo;
+	const struct xt_connsecmark_target_info *info = par->targinfo;
 
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
@@ -87,16 +85,14 @@ connsecmark_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-connsecmark_tg_check(const char *tablename, const void *entry,
-                     const struct xt_target *target, void *targinfo,
-                     unsigned int hook_mask)
+static bool connsecmark_tg_check(struct xt_tgchk_param *par)
 {
-	const struct xt_connsecmark_target_info *info = targinfo;
+	const struct xt_connsecmark_target_info *info = par->targinfo;
 
-	if (strcmp(tablename, "mangle") && strcmp(tablename, "security")) {
+	if (strcmp(par->table, "mangle") != 0 &&
+	    strcmp(par->table, "security") != 0) {
 		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
-		       "or \'security\' tables, not \'%s\'.\n", tablename);
+		       "or \'security\' tables, not \'%s\'.\n", par->table);
 		return false;
 	}
 
@@ -110,9 +106,9 @@ connsecmark_tg_check(const char *tablename, const void *entry,
 		return false;
 	}
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", target->family);
+				    "proto=%u\n", par->target->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index f0b4958..cf67598 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -28,12 +28,9 @@ MODULE_ALIAS("ip6t_DSCP");
 MODULE_ALIAS("ipt_TOS");
 MODULE_ALIAS("ip6t_TOS");
 
-static unsigned int
-dscp_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+static unsigned int dscp_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_DSCP_info *dinfo = targinfo;
+	const struct xt_DSCP_info *dinfo = par->targinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
@@ -47,12 +44,9 @@ dscp_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static unsigned int
-dscp_tg6(struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, unsigned int hooknum,
-         const struct xt_target *target, const void *targinfo)
+static unsigned int dscp_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_DSCP_info *dinfo = targinfo;
+	const struct xt_DSCP_info *dinfo = par->targinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
@@ -65,26 +59,20 @@ dscp_tg6(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-dscp_tg_check(const char *tablename, const void *e_void,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+static bool dscp_tg_check(struct xt_tgchk_param *par)
 {
-	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
+	const struct xt_DSCP_info *info = par->targinfo;
 
-	if (dscp > XT_DSCP_MAX) {
-		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
+	if (info->dscp > XT_DSCP_MAX) {
+		printk(KERN_WARNING "DSCP: dscp %x out of range\n", info->dscp);
 		return false;
 	}
 	return true;
 }
 
-static unsigned int
-tos_tg_v0(struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, unsigned int hooknum,
-          const struct xt_target *target, const void *targinfo)
+static unsigned int tos_tg_v0(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct ipt_tos_target_info *info = targinfo;
+	const struct ipt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
 	u_int8_t oldtos;
 
@@ -101,12 +89,10 @@ tos_tg_v0(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static bool
-tos_tg_check_v0(const char *tablename, const void *e_void,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool tos_tg_check_v0(struct xt_tgchk_param *par)
 {
-	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
+	const struct ipt_tos_target_info *info = par->targinfo;
+	const uint8_t tos = info->tos;
 
 	if (tos != IPTOS_LOWDELAY && tos != IPTOS_THROUGHPUT &&
 	    tos != IPTOS_RELIABILITY && tos != IPTOS_MINCOST &&
@@ -118,12 +104,9 @@ tos_tg_check_v0(const char *tablename, const void *e_void,
 	return true;
 }
 
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+static unsigned int tos_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_tos_target_info *info = targinfo;
+	const struct xt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
 	u_int8_t orig, nv;
 
@@ -140,12 +123,9 @@ tos_tg(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static unsigned int
-tos_tg6(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+static unsigned int tos_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_tos_target_info *info = targinfo;
+	const struct xt_tos_target_info *info = par->targinfo;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	u_int8_t orig, nv;
 
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index c8ea7a8..3af5b86 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -25,22 +25,18 @@ MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
 
 static unsigned int
-mark_tg_v0(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+mark_tg_v0(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_mark_target_info *markinfo = targinfo;
+	const struct xt_mark_target_info *markinfo = par->targinfo;
 
 	skb->mark = markinfo->mark;
 	return XT_CONTINUE;
 }
 
 static unsigned int
-mark_tg_v1(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+mark_tg_v1(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_mark_target_info_v1 *markinfo = targinfo;
+	const struct xt_mark_target_info_v1 *markinfo = par->targinfo;
 	int mark = 0;
 
 	switch (markinfo->mode) {
@@ -61,23 +57,17 @@ mark_tg_v1(struct sk_buff *skb, const struct net_device *in,
 	return XT_CONTINUE;
 }
 
-static unsigned int
-mark_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+static unsigned int mark_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_mark_tginfo2 *info = targinfo;
+	const struct xt_mark_tginfo2 *info = par->targinfo;
 
 	skb->mark = (skb->mark & ~info->mask) ^ info->mark;
 	return XT_CONTINUE;
 }
 
-static bool
-mark_tg_check_v0(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool mark_tg_check_v0(struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info *markinfo = targinfo;
+	const struct xt_mark_target_info *markinfo = par->targinfo;
 
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
@@ -86,12 +76,9 @@ mark_tg_check_v0(const char *tablename, const void *entry,
 	return true;
 }
 
-static bool
-mark_tg_check_v1(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool mark_tg_check_v1(struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info_v1 *markinfo = targinfo;
+	const struct xt_mark_target_info_v1 *markinfo = par->targinfo;
 
 	if (markinfo->mode != XT_MARK_SET
 	    && markinfo->mode != XT_MARK_AND
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 9b09552..39e696c 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -20,12 +20,9 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NFLOG");
 MODULE_ALIAS("ip6t_NFLOG");
 
-static unsigned int
-nflog_tg(struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, unsigned int hooknum,
-         const struct xt_target *target, const void *targinfo)
+static unsigned int nflog_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_nflog_info *info = targinfo;
+	const struct xt_nflog_info *info = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type		     = NF_LOG_TYPE_ULOG;
@@ -33,17 +30,14 @@ nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.ulog.group	     = info->group;
 	li.u.ulog.qthreshold = info->threshold;
 
-	nf_log_packet(target->family, hooknum, skb, in, out, &li,
-		      "%s", info->prefix);
+	nf_log_packet(par->target->family, par->hooknum, skb, par->in,
+	              par->out, &li, "%s", info->prefix);
 	return XT_CONTINUE;
 }
 
-static bool
-nflog_tg_check(const char *tablename, const void *entry,
-               const struct xt_target *target, void *targetinfo,
-               unsigned int hookmask)
+static bool nflog_tg_check(struct xt_tgchk_param *par)
 {
-	const struct xt_nflog_info *info = targetinfo;
+	const struct xt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
 		return false;
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index c03c2e8..ccc0b39 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -24,11 +24,9 @@ MODULE_ALIAS("ip6t_NFQUEUE");
 MODULE_ALIAS("arpt_NFQUEUE");
 
 static unsigned int
-nfqueue_tg(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+nfqueue_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_NFQ_info *tinfo = targinfo;
+	const struct xt_NFQ_info *tinfo = par->targinfo;
 
 	return NF_QUEUE_NR(tinfo->queuenum);
 }
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index b9ee268..c126917 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -13,9 +13,7 @@ MODULE_ALIAS("ipt_NOTRACK");
 MODULE_ALIAS("ip6t_NOTRACK");
 
 static unsigned int
-notrack_tg(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+notrack_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if (skb->nfct != NULL)
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index da7946e..4465609 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -71,14 +71,9 @@ void xt_rateest_put(struct xt_rateest *est)
 EXPORT_SYMBOL_GPL(xt_rateest_put);
 
 static unsigned int
-xt_rateest_tg(struct sk_buff *skb,
-	      const struct net_device *in,
-	      const struct net_device *out,
-	      unsigned int hooknum,
-	      const struct xt_target *target,
-	      const void *targinfo)
+xt_rateest_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
-	const struct xt_rateest_target_info *info = targinfo;
+	const struct xt_rateest_target_info *info = par->targinfo;
 	struct gnet_stats_basic *stats = &info->est->bstats;
 
 	spin_lock_bh(&info->est->lock);
@@ -89,14 +84,9 @@ xt_rateest_tg(struct sk_buff *skb,
 	return XT_CONTINUE;
 }
 
-static bool
-xt_rateest_tg_checkentry(const char *tablename,
-			 const void *entry,
-			 const struct xt_target *target,
-			 void *targinfo,
-			 unsigned int hook_mask)
+static bool xt_rateest_tg_checkentry(struct xt_tgchk_param *par)
 {
-	struct xt_rateest_target_info *info = targinfo;
+	struct xt_rateest_target_info *info = par->targinfo;
 	struct xt_rateest *est;
 	struct {
 		struct nlattr		opt;
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 2a2ab83..b8b6818 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -29,12 +29,10 @@ MODULE_ALIAS("ip6t_SECMARK");
 static u8 mode;
 
 static unsigned int
-secmark_tg(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+secmark_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	u32 secmark = 0;
-	const struct xt_secmark_target_info *info = targinfo;
+	const struct xt_secmark_target_info *info = par->targinfo;
 
 	BUG_ON(info->mode != mode);
 
@@ -82,16 +80,14 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 	return true;
 }
 
-static bool
-secmark_tg_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool secmark_tg_check(struct xt_tgchk_param *par)
 {
-	struct xt_secmark_target_info *info = targinfo;
+	struct xt_secmark_target_info *info = par->targinfo;
 
-	if (strcmp(tablename, "mangle") && strcmp(tablename, "security")) {
+	if (strcmp(par->table, "mangle") != 0 &&
+	    strcmp(par->table, "security") != 0) {
 		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
-		       "or \'security\' tables, not \'%s\'.\n", tablename);
+		       "or \'security\' tables, not \'%s\'.\n", par->table);
 		return false;
 	}
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index b868f99..4a1e717 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -174,15 +174,13 @@ static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
 }
 
 static unsigned int
-tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+tcpmss_tg4(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct iphdr *iph = ip_hdr(skb);
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo,
+	ret = tcpmss_mangle_packet(skb, par->targinfo,
 				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
@@ -199,9 +197,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 static unsigned int
-tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+tcpmss_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u8 nexthdr;
@@ -212,7 +208,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo,
+	ret = tcpmss_mangle_packet(skb, par->targinfo,
 				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
@@ -241,16 +237,13 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
-static bool
-tcpmss_tg4_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool tcpmss_tg4_check(struct xt_tgchk_param *par)
 {
-	const struct xt_tcpmss_info *info = targinfo;
-	const struct ipt_entry *e = entry;
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (hook_mask & ~((1 << NF_INET_FORWARD) |
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
 		printk("xt_TCPMSS: path-MTU clamping only supported in "
@@ -264,16 +257,13 @@ tcpmss_tg4_check(const char *tablename, const void *entry,
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static bool
-tcpmss_tg6_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool tcpmss_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct xt_tcpmss_info *info = targinfo;
-	const struct ip6t_entry *e = entry;
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (hook_mask & ~((1 << NF_INET_FORWARD) |
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
 		printk("xt_TCPMSS: path-MTU clamping only supported in "
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 2e0ae6c..e8188c6 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -75,19 +75,15 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 }
 
 static unsigned int
-tcpoptstrip_tg4(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hooknum,
-		const struct xt_target *target, const void *targinfo)
+tcpoptstrip_tg4(struct sk_buff *skb, struct xt_target_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, targinfo, ip_hdrlen(skb),
+	return tcpoptstrip_mangle_packet(skb, par->targinfo, ip_hdrlen(skb),
 	       sizeof(struct iphdr) + sizeof(struct tcphdr));
 }
 
 #if defined(CONFIG_IP6_NF_MANGLE) || defined(CONFIG_IP6_NF_MANGLE_MODULE)
 static unsigned int
-tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hooknum,
-		const struct xt_target *target, const void *targinfo)
+tcpoptstrip_tg6(struct sk_buff *skb, struct xt_target_param *par)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int tcphoff;
@@ -98,7 +94,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, targinfo, tcphoff,
+	return tcpoptstrip_mangle_packet(skb, par->targinfo, tcphoff,
 	       sizeof(*ipv6h) + sizeof(struct tcphdr));
 }
 #endif
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index da35f9f..a89ac41 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -10,10 +10,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TRACE");
 MODULE_ALIAS("ip6t_TRACE");
 
-static unsigned int
-trace_tg(struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, unsigned int hooknum,
-         const struct xt_target *target, const void *targinfo)
+static unsigned int trace_tg(struct sk_buff *skb, struct xt_target_param *par)
 {
 	skb->nf_trace = 1;
 	return XT_CONTINUE;
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index d1263b3..6ac6613 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -40,6 +40,7 @@ static struct tcf_hashinfo ipt_hash_info = {
 
 static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int hook)
 {
+	struct xt_tgchk_param par;
 	struct xt_target *target;
 	int ret = 0;
 
@@ -49,17 +50,21 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 		return -ENOENT;
 
 	t->u.kernel.target = target;
-
-	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
+	par.table     = table;
+	par.entryinfo = NULL;
+	par.target    = target;
+	par.targinfo  = t->data;
+	par.hook_mask = hook;
+
+	ret = xt_check_target(par.target, AF_INET,
+			      t->u.target_size - sizeof(*t),
 			      table, hook, 0, 0);
 	if (ret) {
 		module_put(t->u.kernel.target->me);
 		return ret;
 	}
-	if (t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(table, NULL,
-					       t->u.kernel.target, t->data,
-					       hook)) {
+	if (par.target->checkentry != NULL &&
+	    !par.target->checkentry(&par)) {
 		module_put(t->u.kernel.target->me);
 		ret = -EINVAL;
 	}
@@ -196,6 +201,7 @@ static int tcf_ipt(struct sk_buff *skb, struct tc_action *a,
 {
 	int ret = 0, result = 0;
 	struct tcf_ipt *ipt = a->priv;
+	struct xt_target_param par;
 
 	if (skb_cloned(skb)) {
 		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
@@ -211,10 +217,13 @@ static int tcf_ipt(struct sk_buff *skb, struct tc_action *a,
 	/* yes, we have to worry about both in and out dev
 	 worry later - danger - this API seems to have changed
 	 from earlier kernels */
-	ret = ipt->tcfi_t->u.kernel.target->target(skb, skb->dev, NULL,
-						   ipt->tcfi_hook,
-						   ipt->tcfi_t->u.kernel.target,
-						   ipt->tcfi_t->data);
+	par.in       = skb->dev;
+	par.out      = NULL;
+	par.hooknum  = ipt->tcfi_hook;
+	par.target   = ipt->tcfi_t->u.kernel.target;
+	par.targinfo = ipt->tcfi_t->data;
+	ret = par.target->target(skb, &par);
+
 	switch (ret) {
 	case NF_ACCEPT:
 		result = TC_ACT_OK;
