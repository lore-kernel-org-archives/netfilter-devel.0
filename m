From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 54/79: add dummy members to Ebtables code to ease transition to Xtables
Date: Wed,  8 Oct 2008 12:47:34 +0200 (MEST)
Message-ID: <20081008104734.10423.84387.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbYJHKre (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:34 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 001a18d369f4813ed792629ff4a9a6ade2a4a031
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:14 2008 +0200

    netfilter: add dummy members to Ebtables code to ease transition to Xtables
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 097432b..82f854b 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -214,6 +214,8 @@ struct ebt_match
 	   const struct ebt_entry *e, void *matchdata, unsigned int datalen);
 	void (*destroy)(void *matchdata, unsigned int datalen);
 	unsigned int matchsize;
+	u_int8_t revision;
+	u_int8_t family;
 	struct module *me;
 };
 
@@ -228,6 +230,8 @@ struct ebt_watcher
 	   const struct ebt_entry *e, void *watcherdata, unsigned int datalen);
 	void (*destroy)(void *watcherdata, unsigned int datalen);
 	unsigned int targetsize;
+	u_int8_t revision;
+	u_int8_t family;
 	struct module *me;
 };
 
@@ -243,6 +247,8 @@ struct ebt_target
 	   const struct ebt_entry *e, void *targetdata, unsigned int datalen);
 	void (*destroy)(void *targetdata, unsigned int datalen);
 	unsigned int targetsize;
+	u_int8_t revision;
+	u_int8_t family;
 	struct module *me;
 };
 
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 8ebe62b..f9876f2 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -51,6 +51,8 @@ static bool ebt_802_3_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_802_3 __read_mostly = {
 	.name		= EBT_802_3_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_802_3,
 	.check		= ebt_802_3_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index bfdc67b..568c890 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -211,6 +211,8 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_among __read_mostly = {
 	.name		= EBT_AMONG_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_among,
 	.check		= ebt_among_check,
 	.matchsize	= -1, /* special case */
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index f1f0bcf..4a5226c 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -117,6 +117,8 @@ static bool ebt_arp_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_arp __read_mostly = {
 	.name		= EBT_ARP_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_arp,
 	.check		= ebt_arp_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_arp_info)),
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index b444cf8..7ab1655 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -76,6 +76,8 @@ static bool ebt_target_reply_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target reply_target __read_mostly = {
 	.name		= EBT_ARPREPLY_TARGET,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_target_reply,
 	.check		= ebt_target_reply_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index d58b9e3..64838e2 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -46,6 +46,8 @@ static bool ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target dnat __read_mostly = {
 	.name		= EBT_DNAT_TARGET,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_target_dnat,
 	.check		= ebt_target_dnat_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 018782f..0bef6f7 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -108,6 +108,8 @@ static bool ebt_ip_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_ip __read_mostly = {
 	.name		= EBT_IP_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_ip,
 	.check		= ebt_ip_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_ip_info)),
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 7fc3928..afcabe2 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -121,6 +121,8 @@ static bool ebt_ip6_check(const char *tablename, unsigned int hookmask,
 static struct ebt_match filter_ip6 =
 {
 	.name		= EBT_IP6_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_ip6,
 	.check		= ebt_ip6_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_ip6_info)),
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 925065a..9ca0a25 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -88,6 +88,8 @@ static bool ebt_limit_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match ebt_limit_reg __read_mostly = {
 	.name		= EBT_LIMIT_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_limit_match,
 	.check		= ebt_limit_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_limit_info)),
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 2705d7a..c2e1c35 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -215,6 +215,8 @@ static unsigned int ebt_log(const struct sk_buff *skb, unsigned int hooknr,
 static struct ebt_watcher log =
 {
 	.name		= EBT_LOG_WATCHER,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.watcher	= ebt_log,
 	.check		= ebt_log_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_log_info)),
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index e4b91d8..910721a 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -58,6 +58,8 @@ static bool ebt_target_mark_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target mark_target __read_mostly = {
 	.name		= EBT_MARK_TARGET,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_target_mark,
 	.check		= ebt_target_mark_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_mark_t_info)),
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index ec16c0e..6512ad9 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -39,6 +39,8 @@ static bool ebt_mark_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_mark __read_mostly = {
 	.name		= EBT_MARK_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_mark,
 	.check		= ebt_mark_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 2c75023..aa0410c 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -52,6 +52,8 @@ static bool ebt_nflog_check(const char *tablename,
 
 static struct ebt_watcher nflog __read_mostly = {
 	.name = EBT_NFLOG_WATCHER,
+	.revision = 0,
+	.family = NFPROTO_BRIDGE,
 	.watcher = ebt_nflog,
 	.check = ebt_nflog_check,
 	.targetsize = XT_ALIGN(sizeof(struct ebt_nflog_info)),
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 74b4432..a9acecc 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -36,6 +36,8 @@ static bool ebt_pkttype_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_pkttype __read_mostly = {
 	.name		= EBT_PKTTYPE_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_pkttype,
 	.check		= ebt_pkttype_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_pkttype_info)),
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 7bf1390..4c62810 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -52,6 +52,8 @@ static bool ebt_target_redirect_check(const char *tablename, unsigned int hookma
 
 static struct ebt_target redirect_target __read_mostly = {
 	.name		= EBT_REDIRECT_TARGET,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_target_redirect,
 	.check		= ebt_target_redirect_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_redirect_info)),
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index d13f05d..0e83de7 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -68,6 +68,8 @@ static bool ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target snat __read_mostly = {
 	.name		= EBT_SNAT_TARGET,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_target_snat,
 	.check		= ebt_target_snat_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 7618206..e6d8f0c 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -174,6 +174,8 @@ static bool ebt_stp_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_stp __read_mostly = {
 	.name		= EBT_STP_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_stp,
 	.check		= ebt_stp_check,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_stp_info)),
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 5f86f55..076b445 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -274,6 +274,8 @@ static bool ebt_ulog_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_watcher ulog __read_mostly = {
 	.name		= EBT_ULOG_WATCHER,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.watcher	= ebt_ulog,
 	.check		= ebt_ulog_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_ulog_info)),
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 8cc4257..9e3a39a 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -164,6 +164,8 @@ ebt_check_vlan(const char *tablename,
 
 static struct ebt_match filter_vlan __read_mostly = {
 	.name		= EBT_VLAN_MATCH,
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_filter_vlan,
 	.check		= ebt_check_vlan,
 	.matchsize	= XT_ALIGN(sizeof(struct ebt_vlan_info)),
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index fe49952..bc4b3f4 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -61,7 +61,9 @@ static LIST_HEAD(ebt_matches);
 static LIST_HEAD(ebt_watchers);
 
 static struct ebt_target ebt_standard_target = {
-	.name = "standard",
+	.name       = "standard",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
 };
 
 static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
@@ -352,6 +354,17 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 		return -ENOENT;
 	}
 	mutex_unlock(&ebt_mutex);
+	if (match->family != NFPROTO_BRIDGE) {
+		printk(KERN_WARNING "ebtables: %s match: not for ebtables?\n",
+		       match->name);
+		goto out;
+	}
+	if (match->revision != 0) {
+		printk(KERN_WARNING "ebtables: %s match: ebtables is not "
+		       "supporting revisions at this time\n",
+		       match->name);
+		goto out;
+	}
 	if (XT_ALIGN(match->matchsize) != m->match_size &&
 	    match->matchsize != -1) {
 		/*
@@ -361,17 +374,18 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 		printk(KERN_WARNING "ebtables: %s match: "
 		       "invalid size %Zu != %u\n",
 		       match->name, XT_ALIGN(match->matchsize), m->match_size);
-		module_put(match->me);
-		return -EINVAL;
+		goto out;
 	}
 	if (match->check &&
 	    !match->check(name, hookmask, e, m->data, m->match_size)) {
 		BUGPRINT("match->check failed\n");
-		module_put(match->me);
-		return -EINVAL;
+		goto out;
 	}
 	(*cnt)++;
 	return 0;
+ out:
+	module_put(match->me);
+	return -EINVAL;
 }
 
 static inline int
@@ -394,22 +408,34 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 		return -ENOENT;
 	}
 	mutex_unlock(&ebt_mutex);
+	if (watcher->family != NFPROTO_BRIDGE) {
+		printk(KERN_WARNING "ebtables: %s watcher: not for ebtables?\n",
+		       watcher->name);
+		goto out;
+	}
+	if (watcher->revision != 0) {
+		printk(KERN_WARNING "ebtables: %s watcher: ebtables is not "
+		       "supporting revisions at this time\n",
+		       watcher->name);
+		goto out;
+	}
 	if (XT_ALIGN(watcher->targetsize) != w->watcher_size) {
 		printk(KERN_WARNING "ebtables: %s watcher: "
 		       "invalid size %Zu != %u\n",
 		       watcher->name, XT_ALIGN(watcher->targetsize),
 		       w->watcher_size);
-		module_put(watcher->me);
-		return -EINVAL;
+		goto out;
 	}
 	if (watcher->check &&
 	    !watcher->check(name, hookmask, e, w->data, w->watcher_size)) {
 		BUGPRINT("watcher->check failed\n");
-		module_put(watcher->me);
-		return -EINVAL;
+		goto out;
 	}
 	(*cnt)++;
 	return 0;
+ out:
+	module_put(watcher->me);
+	return -EINVAL;
 }
 
 static int ebt_verify_pointers(struct ebt_replace *repl,
@@ -690,6 +716,20 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	}
 	mutex_unlock(&ebt_mutex);
 
+	if (target->family != NFPROTO_BRIDGE) {
+		printk(KERN_WARNING "ebtables: %s target: not for ebtables?\n",
+		       target->name);
+		ret = -EINVAL;
+		goto cleanup_watchers;
+	}
+	if (target->revision != 0) {
+		printk(KERN_WARNING "ebtables: %s target: ebtables is not "
+		       "supporting revisions at this time\n",
+		       target->name);
+		ret = -EINVAL;
+		goto cleanup_watchers;
+	}
+
 	t->u.target = target;
 	if (t->u.target == &ebt_standard_target) {
 		if (gap < sizeof(struct ebt_standard_target)) {
