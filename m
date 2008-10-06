From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/23] netfilter: xtables: do centralized checkentry call (1/2)
Date: Mon,  6 Oct 2008 08:15:10 -0400
Message-ID: <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57100 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYJFMPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:31 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It used to be that {ip,ip6,etc}_tables called extension->checkentry
themselves, but this can be moved into the xtables core.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    6 ++++--
 net/bridge/netfilter/ebtables.c    |   24 ++++++------------------
 net/ipv4/netfilter/arp_tables.c    |    2 +-
 net/ipv4/netfilter/ip_tables.c     |    4 ++--
 net/ipv6/netfilter/ip6_tables.c    |    4 ++--
 net/netfilter/x_tables.c           |   12 ++++++++++--
 net/sched/act_ipt.c                |    2 +-
 7 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 6989b22..85aa427 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -330,10 +330,12 @@ extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
 extern int xt_check_match(const struct xt_match *match, unsigned short family,
 			  unsigned int size, const char *table, unsigned int hook,
-			  unsigned short proto, int inv_proto);
+			  unsigned short proto, int inv_proto,
+			  const void *entry, void *matchinfo);
 extern int xt_check_target(const struct xt_target *target, unsigned short family,
 			   unsigned int size, const char *table, unsigned int hook,
-			   unsigned short proto, int inv_proto);
+			   unsigned short proto, int inv_proto,
+			   const void *entry, void *targinfo);
 
 extern struct xt_table *xt_register_table(struct net *net,
 					  struct xt_table *table,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 7d8ead5..7ee72b7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -340,15 +340,11 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 	m->u.match = match;
 
 	ret = xt_check_match(match, NFPROTO_BRIDGE, m->match_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
+	      e, m->data);
 	if (ret < 0) {
 		module_put(match->me);
 		return ret;
-	} else if (match->checkentry != NULL &&
-	    !match->checkentry(name, e, NULL, m->data, hookmask)) {
-		module_put(match->me);
-		BUGPRINT("match->check failed\n");
-		return -EINVAL;
 	}
 
 	(*cnt)++;
@@ -377,15 +373,11 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 	w->u.watcher = watcher;
 
 	ret = xt_check_target(watcher, NFPROTO_BRIDGE, w->watcher_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
+	      e, w->data);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
-	} else if (watcher->checkentry != NULL &&
-	    !watcher->checkentry(name, e, NULL, w->data, hookmask)) {
-		module_put(watcher->me);
-		BUGPRINT("watcher->check failed\n");
-		return -EINVAL;
 	}
 
 	(*cnt)++;
@@ -692,15 +684,11 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	}
 
 	ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
+	      e, t->data);
 	if (ret < 0) {
 		module_put(target->me);
 		goto cleanup_watchers;
-	} else if (t->u.target->checkentry &&
-	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
-		module_put(t->u.target->me);
-		ret = -EINVAL;
-		goto cleanup_watchers;
 	}
 	(*cnt)++;
 	return 0;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b4a9a17..19bebe2 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -465,7 +465,7 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 
 	ret = xt_check_target(target, NFPROTO_ARP,
 			      t->u.target_size - sizeof(*t),
-			      name, e->comefrom, 0, 0);
+			      name, e->comefrom, 0, 0, e, t->data);
 	if (!ret && t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
 					       e->comefrom)) {
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4e7c719..e4003de 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -616,7 +616,7 @@ check_match(struct ipt_entry_match *m, const char *name,
 	match = m->u.kernel.match;
 	ret = xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
 			     name, hookmask, ip->proto,
-			     ip->invflags & IPT_INV_PROTO);
+			     ip->invflags & IPT_INV_PROTO, ip, m->data);
 	if (!ret && m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
 					      hookmask)) {
@@ -668,7 +668,7 @@ static int check_target(struct ipt_entry *e, const char *name)
 	target = t->u.kernel.target;
 	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ip.proto,
-			      e->ip.invflags & IPT_INV_PROTO);
+			      e->ip.invflags & IPT_INV_PROTO, e, t->data);
 	if (!ret && t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
 					       e->comefrom)) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0b4557e..79c4965 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -642,7 +642,7 @@ static int check_match(struct ip6t_entry_match *m, const char *name,
 	match = m->u.kernel.match;
 	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
 			     name, hookmask, ipv6->proto,
-			     ipv6->invflags & IP6T_INV_PROTO);
+			     ipv6->invflags & IP6T_INV_PROTO, ipv6, m->data);
 	if (!ret && m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ipv6, match, m->data,
 					      hookmask)) {
@@ -694,7 +694,7 @@ static int check_target(struct ip6t_entry *e, const char *name)
 	target = t->u.kernel.target;
 	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ipv6.proto,
-			      e->ipv6.invflags & IP6T_INV_PROTO);
+			      e->ipv6.invflags & IP6T_INV_PROTO, e, t->data);
 	if (!ret && t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
 					       e->comefrom)) {
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 3b1fc40..d1f2fb3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -323,7 +323,8 @@ EXPORT_SYMBOL_GPL(xt_find_revision);
 
 int xt_check_match(const struct xt_match *match, unsigned short family,
 		   unsigned int size, const char *table, unsigned int hook_mask,
-		   unsigned short proto, int inv_proto)
+		   unsigned short proto, int inv_proto, const void *entry,
+		   void *matchinfo)
 {
 	if (XT_ALIGN(match->matchsize) != size &&
 	    match->matchsize != -1) {
@@ -351,6 +352,9 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 		       xt_prefix[family], match->name, match->proto);
 		return -EINVAL;
 	}
+	if (match->checkentry != NULL &&
+	    !match->checkentry(table, entry, match, matchinfo, hook_mask))
+		return -EINVAL;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_match);
@@ -469,7 +473,8 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 
 int xt_check_target(const struct xt_target *target, unsigned short family,
 		    unsigned int size, const char *table, unsigned int hook_mask,
-		    unsigned short proto, int inv_proto)
+		    unsigned short proto, int inv_proto, const void *entry,
+		    void *targinfo)
 {
 	if (XT_ALIGN(target->targetsize) != size) {
 		printk("%s_tables: %s target: invalid size %Zu != %u\n",
@@ -493,6 +498,9 @@ int xt_check_target(const struct xt_target *target, unsigned short family,
 		       xt_prefix[family], target->name, target->proto);
 		return -EINVAL;
 	}
+	if (target->checkentry != NULL &&
+	    !target->checkentry(table, entry, target, targinfo, hook_mask))
+		return -EINVAL;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_target);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index d1263b3..ca5d72b 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -51,7 +51,7 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 	t->u.kernel.target = target;
 
 	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
-			      table, hook, 0, 0);
+			      table, hook, 0, 0, NULL, t->data);
 	if (ret) {
 		module_put(t->u.kernel.target->me);
 		return ret;
-- 
1.6.0.1

