From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/13]: Change {ip, ip6,
	arp}_tables to use centralized error checking
Date: Thu, 16 Feb 2006 22:32:13 +0100 (MET)
Message-ID: <20060216213213.6933.32188.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Change {ip,ip6,arp}_tables to use centralized error checking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 21596d6b3f1a5d828a9dbe4e3db8430898a97f17
tree d4f3cd7a721c4260e614939bdfe8db92b1d5548b
parent ef8e3f5ae821c8023c72faf255f2256a5326d723
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:02 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:02 +0100

 net/ipv4/netfilter/arp_tables.c |   11 ++++++++---
 net/ipv4/netfilter/ip_tables.c  |   26 +++++++++++++++++++++-----
 net/ipv6/netfilter/ip6_tables.c |   26 +++++++++++++++++++++-----
 3 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index dd1048b..f68eb67 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -480,6 +480,11 @@ static inline int check_entry(struct arp
 	}
 	t->u.kernel.target = target;
 
+	ret = xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
+			      name, e->comefrom, 0, 0);
+	if (ret)
+		goto err;
+			    
 	if (t->u.kernel.target == &arpt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
@@ -490,16 +495,16 @@ static inline int check_entry(struct arp
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		module_put(t->u.kernel.target->me);
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
-		goto out;
+		goto err;
 	}
 
 	(*i)++;
 	return 0;
-
+err:
+	module_put(t->u.kernel.target->me);
 out:
 	return ret;
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 16f47c6..f884ca2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -508,6 +508,7 @@ check_match(struct ipt_entry_match *m,
 	    unsigned int *i)
 {
 	struct ipt_match *match;
+	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
 						   m->u.user.revision),
@@ -518,18 +519,27 @@ check_match(struct ipt_entry_match *m,
 	}
 	m->u.kernel.match = match;
 
+	ret = xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
+			     name, hookmask, ip->proto,
+			     ip->invflags & IPT_INV_PROTO);
+	if (ret)
+		goto err;
+
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ip, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
-		module_put(m->u.kernel.match->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	(*i)++;
 	return 0;
+err:
+	module_put(m->u.kernel.match->me);
+	return ret;
 }
 
 static struct ipt_target ipt_standard_target;
@@ -565,6 +575,12 @@ check_entry(struct ipt_entry *e, const c
 	}
 	t->u.kernel.target = target;
 
+	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
+			      name, e->comefrom, e->ip.proto,
+			      e->ip.invflags & IPT_INV_PROTO);
+	if (ret)
+		goto err;
+
 	if (t->u.kernel.target == &ipt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
@@ -575,16 +591,16 @@ check_entry(struct ipt_entry *e, const c
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		module_put(t->u.kernel.target->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
-		goto cleanup_matches;
+		goto err;
 	}
 
 	(*i)++;
 	return 0;
-
+ err:
+	module_put(t->u.kernel.target->me);
  cleanup_matches:
 	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 74ff56c..3d2fefe 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -575,6 +575,7 @@ check_match(struct ip6t_entry_match *m,
 	    unsigned int *i)
 {
 	struct ip6t_match *match;
+	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
 			      		m->u.user.revision),
@@ -585,18 +586,27 @@ check_match(struct ip6t_entry_match *m,
 	}
 	m->u.kernel.match = match;
 
+	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
+			     name, hookmask, ipv6->proto,
+			     ipv6->invflags & IP6T_INV_PROTO);
+	if (ret)
+		goto err;
+
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ipv6, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
-		module_put(m->u.kernel.match->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	(*i)++;
 	return 0;
+err:
+	module_put(m->u.kernel.match->me);
+	return ret;
 }
 
 static struct ip6t_target ip6t_standard_target;
@@ -632,6 +642,12 @@ check_entry(struct ip6t_entry *e, const 
 	}
 	t->u.kernel.target = target;
 
+	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
+			      name, e->comefrom, e->ipv6.proto,
+			      e->ipv6.invflags & IP6T_INV_PROTO);
+	if (ret)
+		goto err;
+	
 	if (t->u.kernel.target == &ip6t_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
@@ -642,16 +658,16 @@ check_entry(struct ip6t_entry *e, const 
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
-		module_put(t->u.kernel.target->me);
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
-		goto cleanup_matches;
+		goto err;
 	}
 
 	(*i)++;
 	return 0;
-
+ err:
+	module_put(t->u.kernel.target->me);
  cleanup_matches:
 	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
