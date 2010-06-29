From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/56] netfilter: xtables2: xt_check_target in combination with xt2 contexts
Date: Tue, 29 Jun 2010 10:42:52 +0200
Message-ID: <1277801017-30600-13-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44256 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab0F2Inx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:53 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The xt1 entryinfo (e.g. struct ip6t_entry) is not available in xt2
tables. Most targets only use it to get at struct ip6t_ip6 anyway,
but TCPMSS does an ematch traversal in order to look for xt_tcp.

So TCPMSS needs to learn about xt2 ematch traversal, while the other
modules are henceforth adjusted to not depend on entryinfo anymore,
but use the supplied nfp_info set from both xt1 and xt2 contexts.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h  |    7 +++++
 net/bridge/netfilter/ebt_arpreply.c |    2 +-
 net/bridge/netfilter/ebtables.c     |    2 +-
 net/ipv4/netfilter/arp_tables.c     |    1 +
 net/ipv4/netfilter/ip_tables.c      |    1 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   17 ++++++-------
 net/ipv4/netfilter/ipt_ECN.c        |    4 +-
 net/ipv4/netfilter/ipt_REJECT.c     |    6 ++--
 net/ipv6/netfilter/ip6_tables.c     |    1 +
 net/ipv6/netfilter/ip6t_REJECT.c    |    6 ++--
 net/netfilter/x_tables.c            |    2 +
 net/netfilter/xt_TCPMSS.c           |   42 +++++++++++++++++++++-------------
 net/netfilter/xt_TPROXY.c           |    2 +-
 net/sched/act_ipt.c                 |    3 ++
 14 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 335cdc4..3849383 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -182,6 +182,8 @@ struct xt_counters_info {
 
 #include <linux/netdevice.h>
 
+struct xt2_rule;
+
 /**
  * struct xt_action_param - parameters for matches/targets
  *
@@ -258,6 +260,9 @@ struct xt_mtdtor_param {
  *
  * @entryinfo:	the family-specific rule data
  * 		(struct ipt_entry, ip6t_entry, arpt_entry, ebt_entry)
+ * @nfproto_info:	xt2 layer-2/3 data block (struct ipt_ip, ip6t_ip6,
+ * 			arpt_arp/ebt_entry). Always valid.
+ * @rule:		Pointer to rule target is contained within.
  *
  * Other fields see above.
  */
@@ -265,6 +270,8 @@ struct xt_tgchk_param {
 	struct net *net;
 	const char *table;
 	const void *entryinfo;
+	const void *nfproto_info;
+	const struct xt2_rule *rule;
 	const struct xt_target *target;
 	void *targinfo;
 	unsigned int hook_mask;
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 070cf13..8ac717b 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -60,7 +60,7 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ebt_arpreply_info *info = par->targinfo;
-	const struct ebt_entry *e = par->entryinfo;
+	const struct ebt_entry *e = par->nfproto_info;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ab37e1c..8a820cf 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -692,7 +692,7 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 
 	mtpar.net	= tgpar.net       = net;
 	mtpar.table     = tgpar.table     = name;
-	mtpar.entryinfo = tgpar.entryinfo = e;
+	mtpar.entryinfo = tgpar.entryinfo = tgpar.nfproto_info = e;
 	mtpar.hook_mask = tgpar.hook_mask = hookmask;
 	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2fee4a5..85ea80e 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -548,6 +548,7 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 	struct xt_tgchk_param par = {
 		.table     = name,
 		.entryinfo = e,
+		.nfproto_info = &e->arp,
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3809f38..c7757b1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -742,6 +742,7 @@ static int check_target(struct ipt_entry *e, struct net *net, const char *name)
 		.net       = net,
 		.table     = name,
 		.entryinfo = e,
+		.nfproto_info = &e->ip,
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 64d0875..5beed9f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -358,7 +358,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int clusterip_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
+	const struct ipt_ip *eip = par->nfproto_info;
 	struct clusterip_config *config;
 	int ret;
 
@@ -369,37 +369,36 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	}
-	if (e->ip.dmsk.s_addr != htonl(0xffffffff) ||
-	    e->ip.dst.s_addr == 0) {
+	if (eip->dmsk.s_addr != htonl(0xffffffff) || eip->dst.s_addr == 0) {
 		pr_info("Please specify destination IP\n");
 		return -EINVAL;
 	}
 
 	/* FIXME: further sanity checks */
 
-	config = clusterip_config_find_get(e->ip.dst.s_addr, 1);
+	config = clusterip_config_find_get(eip->dst.s_addr, 1);
 	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			pr_info("no config found for %pI4, need 'new'\n",
-				&e->ip.dst.s_addr);
+				&eip->dst.s_addr);
 			return -EINVAL;
 		} else {
 			struct net_device *dev;
 
-			if (e->ip.iniface[0] == '\0') {
+			if (eip->iniface[0] == '\0') {
 				pr_info("Please specify an interface name\n");
 				return -EINVAL;
 			}
 
-			dev = dev_get_by_name(&init_net, e->ip.iniface);
+			dev = dev_get_by_name(&init_net, eip->iniface);
 			if (!dev) {
 				pr_info("no such interface %s\n",
-					e->ip.iniface);
+					eip->iniface);
 				return -ENOENT;
 			}
 
 			config = clusterip_config_init(cipinfo,
-							e->ip.dst.s_addr, dev);
+							eip->dst.s_addr, dev);
 			if (!config) {
 				pr_info("cannot allocate config\n");
 				dev_put(dev);
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 4bf3dc4..603ea84 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -96,7 +96,7 @@ ecn_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int ecn_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ECN_info *einfo = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
+	const struct ipt_ip *eip = par->nfproto_info;
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		pr_info("unsupported ECN operation %x\n", einfo->operation);
@@ -107,7 +107,7 @@ static int ecn_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	}
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR)) &&
-	    (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
+	    (eip->proto != IPPROTO_TCP || (eip->invflags & XT_INV_PROTO))) {
 		pr_info("cannot use TCP operations on a non-tcp rule\n");
 		return -EINVAL;
 	}
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index f5f4a88..ca35673 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -175,15 +175,15 @@ reject_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int reject_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_reject_info *rejinfo = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
+	const struct ipt_ip *eip = par->nfproto_info;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		pr_info("ECHOREPLY no longer supported.\n");
 		return -EINVAL;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
-		if (e->ip.proto != IPPROTO_TCP ||
-		    (e->ip.invflags & XT_INV_PROTO)) {
+		if (eip->proto != IPPROTO_TCP ||
+		    (eip->invflags & XT_INV_PROTO)) {
 			pr_info("TCP_RESET invalid for non-tcp\n");
 			return -EINVAL;
 		}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index cd8a2f1..3b91f0a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -756,6 +756,7 @@ static int check_target(struct ip6t_entry *e, struct net *net, const char *name)
 		.net       = net,
 		.table     = name,
 		.entryinfo = e,
+		.nfproto_info = &e->ipv6,
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 47d2277..14014d6 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -215,15 +215,15 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 static int reject_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_reject_info *rejinfo = par->targinfo;
-	const struct ip6t_entry *e = par->entryinfo;
+	const struct ip6t_ip6 *eip = par->nfproto_info;
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		pr_info("ECHOREPLY is not supported.\n");
 		return -EINVAL;
 	} else if (rejinfo->with == IP6T_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
-		if (e->ipv6.proto != IPPROTO_TCP ||
-		    (e->ipv6.invflags & XT_INV_PROTO)) {
+		if (eip->proto != IPPROTO_TCP ||
+		    (eip->invflags & XT_INV_PROTO)) {
 			pr_info("TCP_RESET illegal for non-tcp\n");
 			return -EINVAL;
 		}
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index bfa2fea..7126e28 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1386,6 +1386,8 @@ int xt2_rule_add_target(struct xt2_rule *rule, const char *ext_name,
 	if (etarget->data == NULL)
 		goto free_etarget;
 
+	tgpar.nfproto_info = xt2_entryinfo_mt_get(rule);
+	tgpar.rule      = rule;
 	tgpar.net       = rule->chain->table->net;
 	tgpar.table     = rule->chain->table->name;
 	tgpar.target    = ext;
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 1841388..01576f9 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -223,14 +223,30 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 #define TH_SYN 0x02
 
 /* Must specify -p tcp --syn */
-static inline bool find_syn_match(const struct xt_entry_match *m)
+static inline bool find_syn_match(const struct xt_tgchk_param *par)
 {
-	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
+	const struct xt_tcp *tcpinfo;
 
-	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
-	    tcpinfo->flg_cmp & TH_SYN &&
-	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
-		return true;
+	if (par->rule != NULL) {
+		const struct xt2_entry_match *ematch;
+
+		list_for_each_entry(ematch, &par->rule->match_list, anchor) {
+			tcpinfo = ematch->data;
+			if (strcmp(ematch->ext->name, "tcp") == 0 &&
+			    (tcpinfo->flg_cmp & TH_SYN) &&
+			    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
+				return true;
+		}
+	} else {
+		const struct xt_entry_match *ematch;
+		const struct ip6t_entry *e = par->entryinfo;
+
+		xt_ematch_foreach(ematch, e)
+			if (strcmp(ematch->u.kernel.match->name, "tcp") == 0 &&
+			    (tcpinfo->flg_cmp & TH_SYN) &&
+			    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
+				return true;
+	}
 
 	return false;
 }
@@ -238,8 +254,6 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
@@ -249,9 +263,8 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
+	if (find_syn_match(par))
+		return 0;
 	pr_info("Only works on TCP SYN packets\n");
 	return -EINVAL;
 }
@@ -260,8 +273,6 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ip6t_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
@@ -271,9 +282,8 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
+	if (find_syn_match(par))
+		return 0;
 	pr_info("Only works on TCP SYN packets\n");
 	return -EINVAL;
 }
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index e1a0ded..dcf061a 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -61,7 +61,7 @@ tproxy_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int tproxy_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_ip *i = par->entryinfo;
+	const struct ipt_ip *i = par->nfproto_info;
 
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
 	    && !(i->invflags & IPT_INV_PROTO))
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 79223ec..b78887f 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -41,6 +41,7 @@ static struct tcf_hashinfo ipt_hash_info = {
 
 static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int hook)
 {
+	struct ipt_ip l3info = {};
 	struct xt_tgchk_param par;
 	struct xt_target *target;
 	int ret = 0;
@@ -51,6 +52,8 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 		return PTR_ERR(target);
 
 	t->u.kernel.target = target;
+	par.nfproto_info = &l3info;
+	par.rule      = NULL;
 	par.table     = table;
 	par.entryinfo = NULL;
 	par.target    = target;
-- 
1.7.1

