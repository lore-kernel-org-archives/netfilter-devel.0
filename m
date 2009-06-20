From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 4/6] IPv4 specific extensions
Date: Sun, 21 Jun 2009 00:00:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906202359180.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37300 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbZFTWA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:00:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 55602188156
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:00:29 +0200 (CEST)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X-BszSS08+xn for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:00:29 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 397EF188154
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:00:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The IPv4 specific extensions with the new error reporting methods.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h |   12 +++++++
 include/linux/netfilter_ipv4/ipt_ECN.h       |    9 +++++
 include/linux/netfilter_ipv4/ipt_LOG.h       |    7 ++++
 include/linux/netfilter_ipv4/ipt_NAT.h       |   17 ++++++++++
 include/linux/netfilter_ipv4/ipt_REJECT.h    |    9 +++++
 include/linux/netfilter_ipv4/ipt_ULOG.h      |    7 ++++
 include/linux/netfilter_ipv4/ipt_addrtype.h  |    8 +++++
 include/linux/netfilter_ipv4/ipt_ah.h        |    7 ++++
 include/linux/netfilter_ipv4/ipt_ecn.h       |    8 +++++
 net/ipv4/netfilter/ipt_CLUSTERIP.c           |   40 +++++++++++++-----------
 net/ipv4/netfilter/ipt_ECN.c                 |   31 ++++++++++--------
 net/ipv4/netfilter/ipt_LOG.c                 |   11 ++++---
 net/ipv4/netfilter/ipt_MASQUERADE.c          |   22 +++++++++----
 net/ipv4/netfilter/ipt_NETMAP.c              |   26 +++++++++++----
 net/ipv4/netfilter/ipt_REDIRECT.c            |   23 ++++++++++----
 net/ipv4/netfilter/ipt_REJECT.c              |   34 ++++++++++++--------
 net/ipv4/netfilter/ipt_ULOG.c                |   12 ++++---
 net/ipv4/netfilter/ipt_addrtype.c            |   23 +++++++-------
 net/ipv4/netfilter/ipt_ah.c                  |   16 ++++++---
 net/ipv4/netfilter/ipt_ecn.c                 |   27 +++++++++-------
 net/ipv4/netfilter/nf_nat_rule.c             |   44 +++++++++++++++++++-------
 21 files changed, 277 insertions(+), 116 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
index e5a3687..257a4bf 100644
--- a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
+++ b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
@@ -7,6 +7,18 @@ enum clusterip_hashmode {
     CLUSTERIP_HASHMODE_SIP_SPT_DPT,
 };
 
+enum {
+	IPT_CLUSTERIP_ERR_NONE,
+	IPT_CLUSTERIP_ERR_MODE,
+	IPT_CLUSTERIP_ERR_DEST,
+	IPT_CLUSTERIP_ERR_CONFIG,
+	IPT_CLUSTERIP_ERR_NO_IFACE,
+	IPT_CLUSTERIP_ERR_UNKNOWN_IFACE,
+	IPT_CLUSTERIP_ERR_ALLOC,
+	IPT_CLUSTERIP_ERR_CONNTRACK,
+	IPT_CLUSTERIP_ERR_MAX,
+};
+
 #define CLUSTERIP_HASHMODE_MAX CLUSTERIP_HASHMODE_SIP_SPT_DPT
 
 #define CLUSTERIP_MAX_NODES 16
diff --git a/include/linux/netfilter_ipv4/ipt_ECN.h b/include/linux/netfilter_ipv4/ipt_ECN.h
index 94e0d98..ddf4f6e 100644
--- a/include/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/linux/netfilter_ipv4/ipt_ECN.h
@@ -18,6 +18,15 @@
 
 #define IPT_ECN_OP_MASK		0xce
 
+enum {
+	IPT_ECN_ERR_NONE,
+	IPT_ECN_ERR_MANGLE_TABLE,
+	IPT_ECN_ERR_OPERATION,
+	IPT_ECN_ERR_ECT,
+	IPT_ECN_ERR_NOT_TCP,
+	IPT_ECN_ERR_MAX,
+};
+
 struct ipt_ECN_info {
 	u_int8_t operation;	/* bitset of operations */
 	u_int8_t ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
index 90fa652..b227905 100644
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -9,6 +9,13 @@
 #define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
 #define IPT_LOG_MASK		0x1f
 
+enum {
+	IPT_LOG_ERR_NONE,
+	IPT_LOG_ERR_LEVEL,
+	IPT_LOG_ERR_PREFIXLEN,
+	IPT_LOG_ERR_MAX,
+};
+
 struct ipt_log_info {
 	unsigned char level;
 	unsigned char logflags;
diff --git a/include/linux/netfilter_ipv4/ipt_NAT.h b/include/linux/netfilter_ipv4/ipt_NAT.h
new file mode 100644
index 0000000..564ecf4
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_NAT.h
@@ -0,0 +1,17 @@
+#ifndef _IPT_NAT_H
+#define _IPT_NAT_H
+
+enum {
+	IPT_NAT_ERR_NONE,
+	IPT_NAT_ERR_TABLE,
+	IPT_NAT_ERR_MASQ_HOOKS_4,
+	IPT_NAT_ERR_NETMAP_HOOKS_034,
+	IPT_NAT_ERR_REDIRECT_HOOKS_03,
+	IPT_NAT_ERR_SNAT_HOOKS_4,
+	IPT_NAT_ERR_DNAT_HOOKS_03,
+	IPT_NAT_ERR_MAP_IPS,
+	IPT_NAT_ERR_RANGESIZE,
+	IPT_NAT_ERR_MAX,
+};
+
+#endif
diff --git a/include/linux/netfilter_ipv4/ipt_REJECT.h b/include/linux/netfilter_ipv4/ipt_REJECT.h
index 4293a1a..89ba84e 100644
--- a/include/linux/netfilter_ipv4/ipt_REJECT.h
+++ b/include/linux/netfilter_ipv4/ipt_REJECT.h
@@ -13,6 +13,15 @@ enum ipt_reject_with {
 	IPT_ICMP_ADMIN_PROHIBITED
 };
 
+enum {
+	IPT_REJECT_ERR_NONE,
+	IPT_REJECT_ERR_FILTER_TABLE,
+	IPT_REJECT_ERR_HOOKS_123,
+	IPT_REJECT_ERR_ECHOREPLY,
+	IPT_REJECT_ERR_NOT_TCP,
+	IPT_REJECT_ERR_MAX,
+};
+
 struct ipt_reject_info {
 	enum ipt_reject_with with;      /* reject type */
 };
diff --git a/include/linux/netfilter_ipv4/ipt_ULOG.h b/include/linux/netfilter_ipv4/ipt_ULOG.h
index 417aad2..2129672 100644
--- a/include/linux/netfilter_ipv4/ipt_ULOG.h
+++ b/include/linux/netfilter_ipv4/ipt_ULOG.h
@@ -23,6 +23,13 @@
  * Assuming a standard ethernet-mtu of 1500, we could define this up
  * to 80... but even 50 seems to be big enough. */
 
+enum {
+	IPT_ULOG_ERR_NONE,
+	IPT_ULOG_ERR_PREFIXLEN,
+	IPT_ULOG_ERR_QLEN,
+	IPT_ULOG_ERR_MAX,
+};
+
 /* private data structure for each rule with a ULOG target */
 struct ipt_ulog_info {
 	unsigned int nl_group;
diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 446de6a..59480c5 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -8,6 +8,14 @@ enum {
 	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
 };
 
+enum {
+	IPT_ADDRTYPE_ERR_NONE,
+	IPT_ADDRTYPE_ERR_IFACE_BOTH,
+	IPT_ADDRTYPE_ERR_IFACE_IN_HOOKS_34,
+	IPT_ADDRTYPE_ERR_IFACE_OUT_HOOKS_01,
+	IPT_ADDRTYPE_ERR_MAX,
+};	
+
 struct ipt_addrtype_info_v1 {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
diff --git a/include/linux/netfilter_ipv4/ipt_ah.h b/include/linux/netfilter_ipv4/ipt_ah.h
index 7b9a2ac..5734201 100644
--- a/include/linux/netfilter_ipv4/ipt_ah.h
+++ b/include/linux/netfilter_ipv4/ipt_ah.h
@@ -1,6 +1,13 @@
 #ifndef _IPT_AH_H
 #define _IPT_AH_H
 
+enum {
+	IPT_AH_ERR_NONE,
+	IPT_AH_ERR_PROTO,
+	IPT_AH_ERR_FLAGS,
+	IPT_AH_ERR_MAX,
+};
+
 struct ipt_ah
 {
 	u_int32_t spis[2];			/* Security Parameter Index */
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
index 1f0d9a4..57200c1 100644
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/linux/netfilter_ipv4/ipt_ecn.h
@@ -18,6 +18,14 @@
 
 #define IPT_ECN_OP_MATCH_MASK	0xce
 
+enum {
+	IPT_ECN_ERR_NONE,
+	IPT_ECN_ERR_OPERATION,
+	IPT_ECN_ERR_INVERT,
+	IPT_ECN_ERR_NOT_TCP,
+	IPT_ECN_ERR_MAX,
+};
+
 /* match info */
 struct ipt_ecn_info {
 	u_int8_t operation;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2e4f98b..cbbcb5c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -347,7 +347,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool clusterip_tg_check(const struct xt_tgchk_param *par)
+static unsigned int clusterip_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
@@ -357,15 +357,15 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
-		printk(KERN_WARNING "CLUSTERIP: unknown mode `%u'\n",
-			cipinfo->hash_mode);
-		return false;
+		xt_compat_log(par, "CLUSTERIP: unknown mode `%u'",
+			      cipinfo->hash_mode);
+		return IPT_CLUSTERIP_ERR_MODE;
 
 	}
 	if (e->ip.dmsk.s_addr != htonl(0xffffffff)
 	    || e->ip.dst.s_addr == 0) {
-		printk(KERN_ERR "CLUSTERIP: Please specify destination IP\n");
-		return false;
+		xt_compat_log(par, "CLUSTERIP: Please specify destination IP");
+		return IPT_CLUSTERIP_ERR_DEST;
 	}
 
 	/* FIXME: further sanity checks */
@@ -373,28 +373,32 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 	config = clusterip_config_find_get(e->ip.dst.s_addr, 1);
 	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
-			printk(KERN_WARNING "CLUSTERIP: no config found for %pI4, need 'new'\n", &e->ip.dst.s_addr);
-			return false;
+			xt_compat_log(par, "CLUSTERIP: no config found for %pI4, "
+				      "need 'new'",
+				      &e->ip.dst.s_addr);
+			return IPT_CLUSTERIP_ERR_CONFIG;
 		} else {
 			struct net_device *dev;
 
 			if (e->ip.iniface[0] == '\0') {
-				printk(KERN_WARNING "CLUSTERIP: Please specify an interface name\n");
-				return false;
+				xt_compat_log(par, "CLUSTERIP: Please specify "
+					      "an interface name");
+				return IPT_CLUSTERIP_ERR_NO_IFACE;
 			}
 
 			dev = dev_get_by_name(&init_net, e->ip.iniface);
 			if (!dev) {
-				printk(KERN_WARNING "CLUSTERIP: no such interface %s\n", e->ip.iniface);
-				return false;
+				xt_compat_log(par, "CLUSTERIP: no such interface %s",
+					      e->ip.iniface);
+				return IPT_CLUSTERIP_ERR_UNKNOWN_IFACE;
 			}
 
 			config = clusterip_config_init(cipinfo,
 							e->ip.dst.s_addr, dev);
 			if (!config) {
-				printk(KERN_WARNING "CLUSTERIP: cannot allocate config\n");
+				xt_compat_log(par, "CLUSTERIP: cannot allocate config");
 				dev_put(dev);
-				return false;
+				return IPT_CLUSTERIP_ERR_ALLOC;
 			}
 			dev_mc_add(config->dev,config->clustermac, ETH_ALEN, 0);
 		}
@@ -402,12 +406,12 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 	cipinfo->config = config;
 
 	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->target->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->target->family);
+		return IPT_CLUSTERIP_ERR_CONNTRACK;
 	}
 
-	return true;
+	return IPT_CLUSTERIP_ERR_NONE;
 }
 
 /* drop reference count of cluster config when rule is deleted */
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index f7e2fa0..4b6b1e3 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -93,28 +93,32 @@ ecn_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool ecn_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ecn_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ECN_info *einfo = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
 
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "ECN target can only be used in the "
+			      "\"mangle\" table.");
+	    	return IPT_ECN_ERR_MANGLE_TABLE;
+	}
 	if (einfo->operation & IPT_ECN_OP_MASK) {
-		printk(KERN_WARNING "ECN: unsupported ECN operation %x\n",
-			einfo->operation);
-		return false;
+		xt_compat_log(par, "ECN: unsupported ECN operation %x",
+			      einfo->operation);
+		return IPT_ECN_ERR_OPERATION;
 	}
 	if (einfo->ip_ect & ~IPT_ECN_IP_MASK) {
-		printk(KERN_WARNING "ECN: new ECT codepoint %x out of mask\n",
-			einfo->ip_ect);
-		return false;
+		xt_compat_log(par, "ECN: new ECT codepoint %x out of mask",
+			      einfo->ip_ect);
+		return IPT_ECN_ERR_ECT;
 	}
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR))
-	    && (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
-		printk(KERN_WARNING "ECN: cannot use TCP operations on a "
-		       "non-tcp rule\n");
-		return false;
+	    && (par->proto != IPPROTO_TCP || par->inverted)) {
+		xt_compat_log(par, "ECN: cannot use TCP operations on a "
+			      "non-tcp rule");
+		return IPT_ECN_ERR_NOT_TCP;
 	}
-	return true;
+	return IPT_ECN_ERR_NONE;
 }
 
 static struct xt_target ecn_tg_reg __read_mostly = {
@@ -122,7 +126,6 @@ static struct xt_target ecn_tg_reg __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.target		= ecn_tg,
 	.targetsize	= sizeof(struct ipt_ECN_info),
-	.table		= "mangle",
 	.checkentry	= ecn_tg_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index acc44c6..fd99551 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -439,20 +439,21 @@ log_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool log_tg_check(const struct xt_tgchk_param *par)
+static unsigned int log_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_log_info *loginfo = par->targinfo;
+	struct ipt_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
-		return false;
+		return IPT_LOG_ERR_LEVEL;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		pr_debug("LOG: prefix term %i\n",
 			 loginfo->prefix[sizeof(loginfo->prefix)-1]);
-		return false;
+		loginfo->prefix[sizeof(loginfo->prefix)-1] = '\0';
+		return IPT_LOG_ERR_PREFIXLEN;
 	}
-	return true;
+	return IPT_LOG_ERR_NONE;
 }
 
 static struct xt_target log_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index dada086..17f5aaa 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -22,25 +22,37 @@
 #include <net/netfilter/nf_nat_rule.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 
 /* FIXME: Multiple targets. --RR */
-static bool masquerade_tg_check(const struct xt_tgchk_param *par)
+static unsigned int masquerade_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
+	unsigned int valid_hooks = 1 << NF_INET_POST_ROUTING;
 
+	if (strcmp(par->table, "nat") != 0) {
+		xt_compat_log(par, "MASQUERADE target can only be used in the "
+			      "\"nat\" table.");
+	    	return IPT_NAT_ERR_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "MASQUERADE target can only be used in the "
+			      "POSTROUTING chain.");
+		return IPT_NAT_ERR_MASQ_HOOKS_4;
+	}
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("masquerade_check: bad MAP_IPS.\n");
-		return false;
+		return IPT_NAT_ERR_MAP_IPS;
 	}
 	if (mr->rangesize != 1) {
 		pr_debug("masquerade_check: bad rangesize %u\n", mr->rangesize);
-		return false;
+		return IPT_NAT_ERR_RANGESIZE;
 	}
-	return true;
+	return IPT_NAT_ERR_NONE;
 }
 
 static unsigned int
@@ -140,8 +152,6 @@ static struct xt_target masquerade_tg_reg __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.target		= masquerade_tg,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
-	.table		= "nat",
-	.hooks		= 1 << NF_INET_POST_ROUTING,
 	.checkentry	= masquerade_tg_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 7c29582..224646c 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -16,25 +16,39 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat_rule.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
 
-static bool netmap_tg_check(const struct xt_tgchk_param *par)
+static unsigned int netmap_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
+	unsigned int valid_hooks = (1 << NF_INET_PRE_ROUTING) |
+		(1 << NF_INET_POST_ROUTING) |
+		(1 << NF_INET_LOCAL_OUT);
 
+	if (strcmp(par->table, "nat") != 0) {
+		xt_compat_log(par, "NETMAP target can only be used in the "
+			      "\"nat\" table.");
+	    	return IPT_NAT_ERR_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "NETMAP target can only be used in the "
+			      "PREROUTING, OUTPUT and POSTROUTING chains.");
+		return IPT_NAT_ERR_NETMAP_HOOKS_034;
+	}
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		pr_debug("NETMAP:check: bad MAP_IPS.\n");
-		return false;
+		return IPT_NAT_ERR_MAP_IPS;
 	}
 	if (mr->rangesize != 1) {
 		pr_debug("NETMAP:check: bad rangesize %u.\n", mr->rangesize);
-		return false;
+		return IPT_NAT_ERR_RANGESIZE;
 	}
-	return true;
+	return IPT_NAT_ERR_NONE;
 }
 
 static unsigned int
@@ -74,10 +88,6 @@ static struct xt_target netmap_tg_reg __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.target 	= netmap_tg,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
-	.table		= "nat",
-	.hooks		= (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING) |
-			  (1 << NF_INET_LOCAL_OUT),
 	.checkentry 	= netmap_tg_check,
 	.me 		= THIS_MODULE
 };
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 698e5e7..34d3efd 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -19,6 +19,7 @@
 #include <net/checksum.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat_rule.h>
 
 MODULE_LICENSE("GPL");
@@ -26,19 +27,31 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Connection redirection to localhost");
 
 /* FIXME: Take multiple ranges --RR */
-static bool redirect_tg_check(const struct xt_tgchk_param *par)
+static unsigned int redirect_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
+	unsigned int valid_hooks = (1 << NF_INET_PRE_ROUTING) |
+		(1 << NF_INET_LOCAL_OUT);
 
+	if (strcmp(par->table, "nat") != 0) {
+		xt_compat_log(par, "REDIRECT target can only be used in the "
+			      "\"nat\" table.");
+	    	return IPT_NAT_ERR_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "REDIRECT target can only be used in the "
+			      "PREROUTING and OUTPUT chains.");
+		return IPT_NAT_ERR_REDIRECT_HOOKS_03;
+	}
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("redirect_check: bad MAP_IPS.\n");
-		return false;
+		return IPT_NAT_ERR_MAP_IPS;
 	}
 	if (mr->rangesize != 1) {
 		pr_debug("redirect_check: bad rangesize %u.\n", mr->rangesize);
-		return false;
+		return IPT_NAT_ERR_RANGESIZE;
 	}
-	return true;
+	return IPT_NAT_ERR_NONE;
 }
 
 static unsigned int
@@ -90,8 +103,6 @@ static struct xt_target redirect_tg_reg __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.target		= redirect_tg,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
-	.table		= "nat",
-	.hooks		= (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT),
 	.checkentry	= redirect_tg_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index c93ae44..65b323b 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -174,23 +174,34 @@ reject_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool reject_tg_check(const struct xt_tgchk_param *par)
+static unsigned int reject_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_reject_info *rejinfo = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
-
+	unsigned int valid_hooks = (1 << NF_INET_LOCAL_IN) | 
+		(1 << NF_INET_FORWARD) |
+		(1 << NF_INET_LOCAL_OUT);
+
+	if (strcmp(par->table, "filter") != 0) {
+		xt_compat_log(par, "REJECT target can only be used in the "
+			      "\"filter\" table.");
+	    	return IPT_REJECT_ERR_FILTER_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "REJECT target can only be used in the "
+			      "INPUT, FORWARD and OUTPUT chains.");
+		return IPT_REJECT_ERR_HOOKS_123;
+	}
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
-		printk("ipt_REJECT: ECHOREPLY no longer supported.\n");
-		return false;
+		xt_compat_log(par, "ipt_REJECT: ECHOREPLY no longer supported.");
+		return IPT_REJECT_ERR_ECHOREPLY;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
-		if (e->ip.proto != IPPROTO_TCP
-		    || (e->ip.invflags & XT_INV_PROTO)) {
-			printk("ipt_REJECT: TCP_RESET invalid for non-tcp\n");
-			return false;
+		if (par->proto != IPPROTO_TCP || par->inverted) {
+			xt_compat_log(par, "ipt_REJECT: TCP_RESET invalid for non-tcp");
+			return IPT_REJECT_ERR_NOT_TCP;
 		}
 	}
-	return true;
+	return IPT_REJECT_ERR_NONE;
 }
 
 static struct xt_target reject_tg_reg __read_mostly = {
@@ -198,9 +209,6 @@ static struct xt_target reject_tg_reg __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.target		= reject_tg,
 	.targetsize	= sizeof(struct ipt_reject_info),
-	.table		= "filter",
-	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT),
 	.checkentry	= reject_tg_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index d32cc4b..7b68903 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -313,21 +313,23 @@ static void ipt_logfn(u_int8_t pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static bool ulog_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ulog_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_ulog_info *loginfo = par->targinfo;
+	struct ipt_ulog_info *loginfo = par->targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		pr_debug("ipt_ULOG: prefix term %i\n",
 			 loginfo->prefix[sizeof(loginfo->prefix) - 1]);
-		return false;
+		loginfo->prefix[sizeof(loginfo->prefix) - 1] = '\0';
+		return IPT_ULOG_ERR_PREFIXLEN;
 	}
 	if (loginfo->qthreshold > ULOG_MAX_QLEN) {
 		pr_debug("ipt_ULOG: queue threshold %Zu > MAX_QLEN\n",
 			 loginfo->qthreshold);
-		return false;
+		loginfo->qthreshold = ULOG_MAX_QLEN;
+		return IPT_ULOG_ERR_QLEN;
 	}
-	return true;
+	return IPT_ULOG_ERR_NONE;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 3b216be..748cf75 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -70,34 +70,35 @@ addrtype_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
+static unsigned int
+addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 {
 	struct ipt_addrtype_info_v1 *info = par->matchinfo;
 
 	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN &&
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
-		printk(KERN_ERR "ipt_addrtype: both incoming and outgoing "
-				"interface limitation cannot be selected\n");
-		return false;
+		xt_compat_log(par, "ipt_addrtype: both incoming and outgoing "
+			      "interface limitation cannot be selected");
+		return IPT_ADDRTYPE_ERR_IFACE_BOTH;
 	}
 
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) &&
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
-		printk(KERN_ERR "ipt_addrtype: output interface limitation "
-				"not valid in PRE_ROUTING and INPUT\n");
-		return false;
+		xt_compat_log(par, "ipt_addrtype: output interface limitation "
+			      "not valid in the PREROUTING and INPUT chains.");
+		return IPT_ADDRTYPE_ERR_IFACE_OUT_HOOKS_01;
 	}
 
 	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
 	    (1 << NF_INET_LOCAL_OUT)) &&
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
-		printk(KERN_ERR "ipt_addrtype: input interface limitation "
-				"not valid in POST_ROUTING and OUTPUT\n");
-		return false;
+		xt_compat_log(par, "ipt_addrtype: input interface limitation "
+			      "not valid in the POSTROUTING and OUTPUT chains.");
+		return IPT_ADDRTYPE_ERR_IFACE_IN_HOOKS_34;
 	}
 
-	return true;
+	return IPT_ADDRTYPE_ERR_NONE;
 }
 
 static struct xt_match addrtype_mt_reg[] __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 0104c0b..8b70fcb 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -61,16 +61,21 @@ static bool ah_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			 !!(ahinfo->invflags & IPT_AH_INV_SPI));
 }
 
-static bool ah_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ah_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct ipt_ah *ahinfo = par->matchinfo;
+	struct ipt_ah *ahinfo = par->matchinfo;
 
+	if (par->proto != IPPROTO_AH || par->inverted) {
+		xt_compat_log(par, "ah match: only valid for protocol AH");
+		return IPT_AH_ERR_PROTO;
+	}
 	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
-		duprintf("ipt_ah: unknown flags %X\n", ahinfo->invflags);
-		return false;
+		duprintf("ipt_ah: unknown flags %X", ahinfo->invflags);
+		ahinfo->invflags &= ~IPT_AH_INV_MASK;
+		return IPT_AH_ERR_FLAGS;
 	}
-	return true;
+	return IPT_AH_ERR_NONE;
 }
 
 static struct xt_match ah_mt_reg __read_mostly = {
@@ -78,7 +83,6 @@ static struct xt_match ah_mt_reg __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.match		= ah_mt,
 	.matchsize	= sizeof(struct ipt_ah),
-	.proto		= IPPROTO_AH,
 	.checkentry	= ah_mt_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 6289b64..71c37e0 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -85,25 +85,28 @@ static bool ecn_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool ecn_mt_check(const struct xt_mtchk_param *par)
+static unsigned int ecn_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct ipt_ecn_info *info = par->matchinfo;
-	const struct ipt_ip *ip = par->entryinfo;
+	struct ipt_ecn_info *info = par->matchinfo;
 
-	if (info->operation & IPT_ECN_OP_MATCH_MASK)
-		return false;
+	if (info->operation & IPT_ECN_OP_MATCH_MASK) {
+		info->operation &= IPT_ECN_OP_MATCH_MASK;
+		return IPT_ECN_ERR_OPERATION;
+	}
 
-	if (info->invert & IPT_ECN_OP_MATCH_MASK)
-		return false;
+	if (info->invert & IPT_ECN_OP_MATCH_MASK) {
+		info->invert &= IPT_ECN_OP_MATCH_MASK;
+		return IPT_ECN_ERR_INVERT;
+	}
 
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)
-	    && ip->proto != IPPROTO_TCP) {
-		printk(KERN_WARNING "ipt_ecn: can't match TCP bits in rule for"
-		       " non-tcp packets\n");
-		return false;
+	    && par->proto != IPPROTO_TCP) {
+		xt_compat_log(par, "ipt_ecn: can't match TCP bits in rule for "
+			      "non-tcp packets");
+		return IPT_ECN_ERR_NOT_TCP;
 	}
 
-	return true;
+	return IPT_ECN_ERR_NONE;
 }
 
 static struct xt_match ecn_mt_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 6348a79..91db926 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -20,6 +20,7 @@
 #include <linux/bitops.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_rule.h>
@@ -103,28 +104,51 @@ ipt_dnat_target(struct sk_buff *skb, const struct xt_target_param *par)
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
 }
 
-static bool ipt_snat_checkentry(const struct xt_tgchk_param *par)
+static unsigned int ipt_snat_checkentry(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
+	unsigned int valid_hooks = 1 << NF_INET_POST_ROUTING;
 
+	if (strcmp(par->table, "nat") != 0) {
+		xt_compat_log(par, "SNAT target can only be used in the "
+			      "\"nat\" table.");
+	    	return IPT_NAT_ERR_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "SNAT target can only be used in the "
+			      "POSTROUTING chain.");
+		return IPT_NAT_ERR_SNAT_HOOKS_4;
+	}
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
-		printk("SNAT: multiple ranges no longer supported\n");
-		return false;
+		xt_compat_log(par, "SNAT: multiple ranges no longer supported");
+		return IPT_NAT_ERR_RANGESIZE;
 	}
-	return true;
+	return IPT_NAT_ERR_NONE;
 }
 
-static bool ipt_dnat_checkentry(const struct xt_tgchk_param *par)
+static unsigned int ipt_dnat_checkentry(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
+	unsigned int valid_hooks = (1 << NF_INET_PRE_ROUTING) |
+		(1 << NF_INET_LOCAL_OUT);
 
+	if (strcmp(par->table, "nat") != 0) {
+		xt_compat_log(par, "DNAT target can only be used in the "
+			      "\"nat\" table.");
+	    	return IPT_NAT_ERR_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "DNAT target can only be used in the "
+			      "PREROUTING and OUTPUT chains.");
+		return IPT_NAT_ERR_DNAT_HOOKS_03;
+	}
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
-		printk("DNAT: multiple ranges no longer supported\n");
-		return false;
+		xt_compat_log(par, "DNAT: multiple ranges no longer supported");
+		return IPT_NAT_ERR_RANGESIZE;
 	}
-	return true;
+	return IPT_NAT_ERR_NONE;
 }
 
 unsigned int
@@ -168,8 +192,6 @@ static struct xt_target ipt_snat_reg __read_mostly = {
 	.name		= "SNAT",
 	.target		= ipt_snat_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
-	.table		= "nat",
-	.hooks		= 1 << NF_INET_POST_ROUTING,
 	.checkentry	= ipt_snat_checkentry,
 	.family		= AF_INET,
 };
@@ -178,8 +200,6 @@ static struct xt_target ipt_dnat_reg __read_mostly = {
 	.name		= "DNAT",
 	.target		= ipt_dnat_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
-	.table		= "nat",
-	.hooks		= (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT),
 	.checkentry	= ipt_dnat_checkentry,
 	.family		= AF_INET,
 };


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
