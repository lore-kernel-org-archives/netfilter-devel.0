From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/16] [NETFILTER]: Remove left-over checks
Date: Sat,  4 Oct 2008 15:41:16 -0400
Message-ID: <4dd5adf66e567948d6c27876a246fcd806dc0cd5.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34299 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYJDTld (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:33 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the previous patch moving checks into xtables.c, checks exist
twice in {ip,ip6,arp}_tables. Clean it up. Also propagate the error
code from xt_{match,target}_check in the error case instead of always
using -EINVAL.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |    8 +++-----
 net/ipv4/netfilter/ip_tables.c  |   19 +++++++------------
 net/ipv6/netfilter/ip6_tables.c |   19 +++++++------------
 net/sched/act_ipt.c             |   12 ++----------
 4 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 19bebe2..ae525a9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -466,14 +466,12 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 	ret = xt_check_target(target, NFPROTO_ARP,
 			      t->u.target_size - sizeof(*t),
 			      name, e->comefrom, 0, 0, e, t->data);
-	if (!ret && t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
+	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
-		ret = -EINVAL;
+		return ret;
 	}
-	return ret;
+	return 0;
 }
 
 static inline int
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e4003de..b4c74a7 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -617,16 +617,13 @@ check_match(struct ipt_entry_match *m, const char *name,
 	ret = xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
 			     name, hookmask, ip->proto,
 			     ip->invflags & IPT_INV_PROTO, ip, m->data);
-	if (!ret && m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
-					      hookmask)) {
+	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
-		ret = -EINVAL;
+		return ret;
 	}
-	if (!ret)
-		(*i)++;
-	return ret;
+	++*i;
+	return 0;
 }
 
 static int
@@ -669,14 +666,12 @@ static int check_target(struct ipt_entry *e, const char *name)
 	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ip.proto,
 			      e->ip.invflags & IPT_INV_PROTO, e, t->data);
-	if (!ret && t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
+	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
-		ret = -EINVAL;
+		return ret;
 	}
-	return ret;
+	return 0;
 }
 
 static int
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 79c4965..12c41b8 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -643,16 +643,13 @@ static int check_match(struct ip6t_entry_match *m, const char *name,
 	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
 			     name, hookmask, ipv6->proto,
 			     ipv6->invflags & IP6T_INV_PROTO, ipv6, m->data);
-	if (!ret && m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, match, m->data,
-					      hookmask)) {
+	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
-		ret = -EINVAL;
+		return ret;
 	}
-	if (!ret)
-		(*i)++;
-	return ret;
+	++*i;
+	return 0;
 }
 
 static int
@@ -695,14 +692,12 @@ static int check_target(struct ip6t_entry *e, const char *name)
 	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ipv6.proto,
 			      e->ipv6.invflags & IP6T_INV_PROTO, e, t->data);
-	if (!ret && t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
+	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
-		ret = -EINVAL;
+		return ret;
 	}
-	return ret;
+	return 0;
 }
 
 static int
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index ca5d72b..79ea193 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -52,19 +52,11 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 
 	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
 			      table, hook, 0, 0, NULL, t->data);
-	if (ret) {
+	if (ret < 0) {
 		module_put(t->u.kernel.target->me);
 		return ret;
 	}
-	if (t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(table, NULL,
-					       t->u.kernel.target, t->data,
-					       hook)) {
-		module_put(t->u.kernel.target->me);
-		ret = -EINVAL;
-	}
-
-	return ret;
+	return 0;
 }
 
 static void ipt_destroy_target(struct ipt_entry_target *t)
-- 
1.6.0.1

