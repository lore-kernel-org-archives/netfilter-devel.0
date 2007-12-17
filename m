From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/64]: ip6_tables: move entry, match and target checks to seperate functions
Date: Tue, 18 Dec 2007 00:46:25 +0100 (MET)
Message-ID: <20071217234624.23601.23279.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38905 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXLQXq0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:26 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: move entry, match and target checks to seperate functions

Resync with ip_tables.c as preparation for compat support.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e3dd889d718409e2ebd6010d6db111c5ee304804
tree c654332f845415a4ce63e5fe7220c674ca3eb330
parent de6db21852632a229cad718da30eb526b6b46da9
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:45 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 16:05:28 +0100

 net/ipv6/netfilter/ip6_tables.c |  129 +++++++++++++++++++++++++--------------
 1 files changed, 82 insertions(+), 47 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index b73e6b6..655c221 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -607,11 +607,55 @@ cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
 }
 
 static inline int
-check_match(struct ip6t_entry_match *m,
-	    const char *name,
-	    const struct ip6t_ip6 *ipv6,
-	    unsigned int hookmask,
-	    unsigned int *i)
+check_entry(struct ip6t_entry *e, const char *name)
+{
+	struct ip6t_entry_target *t;
+
+	if (!ip6_checkentry(&e->ipv6)) {
+		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
+		return -EINVAL;
+	}
+
+	if (e->target_offset + sizeof(struct ip6t_entry_target) >
+	    e->next_offset)
+		return -EINVAL;
+
+	t = ip6t_get_target(e);
+	if (e->target_offset + t->u.target_size > e->next_offset)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline int check_match(struct ip6t_entry_match *m, const char *name,
+			      const struct ip6t_ip6 *ipv6,
+			      unsigned int hookmask, unsigned int *i)
+{
+	struct xt_match *match;
+	int ret;
+
+	match = m->u.kernel.match;
+	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
+			     name, hookmask, ipv6->proto,
+			     ipv6->invflags & IP6T_INV_PROTO);
+	if (!ret && m->u.kernel.match->checkentry
+	    && !m->u.kernel.match->checkentry(name, ipv6, match, m->data,
+					      hookmask)) {
+		duprintf("ip_tables: check failed for `%s'.\n",
+			 m->u.kernel.match->name);
+		ret = -EINVAL;
+	}
+	if (!ret)
+		(*i)++;
+	return ret;
+}
+
+static inline int
+find_check_match(struct ip6t_entry_match *m,
+		 const char *name,
+		 const struct ip6t_ip6 *ipv6,
+		 unsigned int hookmask,
+		 unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
@@ -620,86 +664,77 @@ check_match(struct ip6t_entry_match *m,
 					m->u.user.revision),
 					"ip6t_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
-		duprintf("check_match: `%s' not found\n", m->u.user.name);
+		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
 		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match = match;
 
-	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
-			     name, hookmask, ipv6->proto,
-			     ipv6->invflags & IP6T_INV_PROTO);
+	ret = check_match(m, name, ipv6, hookmask, i);
 	if (ret)
 		goto err;
 
-	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
-					      hookmask)) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	(*i)++;
 	return 0;
 err:
 	module_put(m->u.kernel.match->me);
 	return ret;
 }
 
-static inline int
-check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
-	    unsigned int *i)
+static inline int check_target(struct ip6t_entry *e, const char *name)
 {
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
 	int ret;
-	unsigned int j;
 
-	if (!ip6_checkentry(&e->ipv6)) {
-		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
-		return -EINVAL;
+	t = ip6t_get_target(e);
+	target = t->u.kernel.target;
+	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
+			      name, e->comefrom, e->ipv6.proto,
+			      e->ipv6.invflags & IP6T_INV_PROTO);
+	if (!ret && t->u.kernel.target->checkentry
+	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
+					       e->comefrom)) {
+		duprintf("ip_tables: check failed for `%s'.\n",
+			 t->u.kernel.target->name);
+		ret = -EINVAL;
 	}
+	return ret;
+}
 
-	if (e->target_offset + sizeof(struct ip6t_entry_target) >
-								e->next_offset)
-		return -EINVAL;
+static inline int
+find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
+		 unsigned int *i)
+{
+	struct ip6t_entry_target *t;
+	struct xt_target *target;
+	int ret;
+	unsigned int j;
+
+	ret = check_entry(e, name);
+	if (ret)
+		return ret;
 
 	j = 0;
-	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6, e->comefrom, &j);
+	ret = IP6T_MATCH_ITERATE(e, find_check_match, name, &e->ipv6,
+				 e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ip6t_get_target(e);
-	ret = -EINVAL;
-	if (e->target_offset + t->u.target_size > e->next_offset)
-			goto cleanup_matches;
 	target = try_then_request_module(xt_find_target(AF_INET6,
 							t->u.user.name,
 							t->u.user.revision),
 					 "ip6t_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
 
-	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, e->ipv6.proto,
-			      e->ipv6.invflags & IP6T_INV_PROTO);
+	ret = check_target(e, name);
 	if (ret)
 		goto err;
 
-	if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      e->comefrom)) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 t->u.kernel.target->name);
-		ret = -EINVAL;
-		goto err;
-	}
-
 	(*i)++;
 	return 0;
  err:
@@ -834,7 +869,7 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				check_entry, name, size, &i);
+				find_check_entry, name, size, &i);
 
 	if (ret != 0) {
 		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
