From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/13]: x_tables: pass registered match/target data to
	match/target functions
Date: Thu, 16 Feb 2006 22:32:21 +0100 (MET)
Message-ID: <20060216213221.6933.2751.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: pass registered match/target data to match/target functions

This allows to make decisions based on the revision (and address family
with a follow-up patch) at runtime.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fa94db409d568fb96bc1e806ecd24506e2b1f4dd
tree ca00834de166904ae812808ae014ff2cb1eb4f09
parent 17605235f23efeda52fa086e6dfa6dccd9ab915e
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:28:20 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:28:20 +0100

 include/linux/netfilter/x_tables.h |   10 ++++++++--
 net/ipv4/netfilter/arp_tables.c    |    5 +++--
 net/ipv4/netfilter/ip_tables.c     |   13 +++++++------
 net/ipv6/netfilter/ip6_tables.c    |   11 ++++++-----
 net/sched/act_ipt.c                |   10 ++++++----
 5 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b9c37e1..2fdbc4a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -100,6 +100,7 @@ struct xt_match
 	int (*match)(const struct sk_buff *skb,
 		     const struct net_device *in,
 		     const struct net_device *out,
+		     const struct xt_match *match,
 		     const void *matchinfo,
 		     int offset,
 		     unsigned int protoff,
@@ -109,12 +110,14 @@ struct xt_match
 	/* Should return true or false. */
 	int (*checkentry)(const char *tablename,
 			  const void *ip,
+			  const struct xt_match *match,
 			  void *matchinfo,
 			  unsigned int matchinfosize,
 			  unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(void *matchinfo, unsigned int matchinfosize);
+	void (*destroy)(const struct xt_match *match, void *matchinfo,
+			unsigned int matchinfosize);
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -140,6 +143,7 @@ struct xt_target
 			       const struct net_device *in,
 			       const struct net_device *out,
 			       unsigned int hooknum,
+			       const struct xt_target *target,
 			       const void *targinfo,
 			       void *userdata);
 
@@ -149,12 +153,14 @@ struct xt_target
 	/* Should return true or false. */
 	int (*checkentry)(const char *tablename,
 			  const void *entry,
+			  const struct xt_target *target,
 			  void *targinfo,
 			  unsigned int targinfosize,
 			  unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(void *targinfo, unsigned int targinfosize);
+	void (*destroy)(const struct xt_target *target, void *targinfo,
+			unsigned int targinfosize);
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 082b748..59f74b7 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -300,6 +300,7 @@ unsigned int arpt_do_table(struct sk_buf
 				verdict = t->u.kernel.target->target(pskb,
 								     in, out,
 								     hook,
+								     t->u.kernel.target,
 								     t->data,
 								     userdata);
 
@@ -491,7 +492,7 @@ static inline int check_entry(struct arp
 			goto out;
 		}
 	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, t->data,
+		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
@@ -560,7 +561,7 @@ static inline int cleanup_entry(struct a
 
 	t = arpt_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 					    t->u.target_size - sizeof(*t));
 	module_put(t->u.kernel.target->me);
 	return 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 62f8d63..2381a4a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -197,8 +197,8 @@ int do_match(struct ipt_entry_match *m,
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->data, offset, 
-	    skb->nh.iph->ihl*4, hotdrop))
+	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
+				      offset, skb->nh.iph->ihl*4, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -305,6 +305,7 @@ ipt_do_table(struct sk_buff **pskb,
 				verdict = t->u.kernel.target->target(pskb,
 								     in, out,
 								     hook,
+								     t->u.kernel.target,
 								     t->data,
 								     userdata);
 
@@ -464,7 +465,7 @@ cleanup_match(struct ipt_entry_match *m,
 		return 1;
 
 	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->data,
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
 					   m->u.match_size - sizeof(*m));
 	module_put(m->u.kernel.match->me);
 	return 0;
@@ -517,7 +518,7 @@ check_match(struct ipt_entry_match *m,
 		goto err;
 
 	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, m->data,
+	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -578,7 +579,7 @@ check_entry(struct ipt_entry *e, const c
 			goto cleanup_matches;
 		}
 	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, t->data,
+		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
@@ -652,7 +653,7 @@ cleanup_entry(struct ipt_entry *e, unsig
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ipt_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 					    t->u.target_size - sizeof(*t));
 	module_put(t->u.kernel.target->me);
 	return 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 88f5d29..2dc731a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -251,7 +251,7 @@ int do_match(struct ip6t_entry_match *m,
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->data,
+	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
 				      offset, protoff, hotdrop))
 		return 1;
 	else
@@ -373,6 +373,7 @@ ip6t_do_table(struct sk_buff **pskb,
 				verdict = t->u.kernel.target->target(pskb,
 								     in, out,
 								     hook,
+								     t->u.kernel.target,
 								     t->data,
 								     userdata);
 
@@ -531,7 +532,7 @@ cleanup_match(struct ip6t_entry_match *m
 		return 1;
 
 	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->data,
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
 					   m->u.match_size - sizeof(*m));
 	module_put(m->u.kernel.match->me);
 	return 0;
@@ -584,7 +585,7 @@ check_match(struct ip6t_entry_match *m,
 		goto err;
 
 	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, m->data,
+	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -645,7 +646,7 @@ check_entry(struct ip6t_entry *e, const 
 			goto cleanup_matches;
 		}
 	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, t->data,
+		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
@@ -719,7 +720,7 @@ cleanup_entry(struct ip6t_entry *e, unsi
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ip6t_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 					    t->u.target_size - sizeof(*t));
 	module_put(t->u.kernel.target->me);
 	return 0;
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 39a22a3..6056d20 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -70,7 +70,8 @@ ipt_init_target(struct ipt_entry_target 
 	t->u.kernel.target = target;
 
 	if (t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(table, NULL, t->data,
+	    && !t->u.kernel.target->checkentry(table, NULL,
+		    			       t->u.kernel.target, t->data,
 					       t->u.target_size - sizeof(*t),
 					       hook)) {
 		DPRINTK("ipt_init_target: check failed for `%s'.\n",
@@ -86,7 +87,7 @@ static void
 ipt_destroy_target(struct ipt_entry_target *t)
 {
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 		                            t->u.target_size - sizeof(*t));
         module_put(t->u.kernel.target->me);
 }
@@ -224,8 +225,9 @@ tcf_ipt(struct sk_buff *skb, struct tc_a
 	/* iptables targets take a double skb pointer in case the skb
 	 * needs to be replaced. We don't own the skb, so this must not
 	 * happen. The pskb_expand_head above should make sure of this */
-	ret = p->t->u.kernel.target->target(&skb, skb->dev, NULL,
-					    p->hook, p->t->data, NULL);
+	ret = p->t->u.kernel.target->target(&skb, skb->dev, NULL, p->hook,
+					    p->t->u.kernel.target, p->t->data,
+					    NULL);
 	switch (ret) {
 	case NF_ACCEPT:
 		result = TC_ACT_OK;
