From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nf-next] net: Replace NF_CT_ASSERT() with WARN_ON().
Date: Wed, 30 Aug 2017 13:37:11 +0530
Message-ID: <20170830080712.26076-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38322 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdH3IH1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2017 04:07:27 -0400
Received: by mail-pg0-f67.google.com with SMTP id t3so4558619pgt.5
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2017 01:07:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes NF_CT_ASSERT() and instead uses WARN_ON().

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/net/netfilter/nf_conntrack.h           |  2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  2 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c       |  6 +++---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c    |  8 ++++----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c       |  6 +++---
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c    |  4 ++--
 net/netfilter/nf_conntrack_core.c              | 11 +++++------
 net/netfilter/nf_conntrack_expect.c            |  4 ++--
 net/netfilter/nf_conntrack_extend.c            |  2 +-
 net/netfilter/nf_conntrack_standalone.c        |  6 +++---
 net/netfilter/nf_nat_core.c                    |  4 ++--
 net/netfilter/nf_nat_redirect.c                |  6 +++---
 net/netfilter/xt_NETMAP.c                      |  8 ++++----
 net/netfilter/xt_nat.c                         | 20 ++++++++++----------
 15 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6e6f678aaac7..0385cb08c478 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -159,7 +159,7 @@ nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 /* decrement reference count on a conntrack */
 static inline void nf_ct_put(struct nf_conn *ct)
 {
-	NF_CT_ASSERT(ct);
+	WARN_ON(!ct);
 	nf_conntrack_put(&ct->ct_general);
 }
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 434b4e20f6db..8a66a9407f53 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -127,7 +127,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_zone tmp;
 
-	NF_CT_ASSERT(!skb_nfct(skb));
+	WARN_ON(skb_nfct(skb));
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 
 	/* Are they talking about one of our connections? */
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index feedd759ca80..a0f37b208268 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -190,7 +190,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 	struct nf_conntrack_tuple target;
 	unsigned long statusbit;
 
-	NF_CT_ASSERT(ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY);
+	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
 
 	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
@@ -306,8 +306,8 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 
 	default:
 		/* ESTABLISHED */
-		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
-			     ctinfo == IP_CT_ESTABLISHED_REPLY);
+		WARN_ON(ctinfo != IP_CT_ESTABLISHED &&
+			ctinfo != IP_CT_ESTABLISHED_REPLY);
 		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
 			goto oif_changed;
 	}
diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index f39037fca923..0c366aad89cb 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -34,12 +34,12 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	const struct rtable *rt;
 	__be32 newsrc, nh;
 
-	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
+	WARN_ON(hooknum != NF_INET_POST_ROUTING);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
-	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-			    ctinfo == IP_CT_RELATED_REPLY));
+	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+			 ctinfo == IP_CT_RELATED_REPLY)));
 
 	/* Source address is 0.0.0.0 - locally generated packet that is
 	 * probably not supposed to be masqueraded.
@@ -96,7 +96,7 @@ static int masq_device_event(struct notifier_block *this,
 		 * conntracks which were associated with that device,
 		 * and forget them.
 		 */
-		NF_CT_ASSERT(dev->ifindex != 0);
+		WARN_ON(dev->ifindex == 0);
 
 		nf_ct_iterate_cleanup_net(net, device_cmp,
 					  (void *)(long)dev->ifindex, 0, 0);
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 43544b975eae..1ebbb0836020 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -138,7 +138,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_zone tmp;
 
-	NF_CT_ASSERT(!skb_nfct(skb));
+	WARN_ON(skb_nfct(skb));
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuplepr(skb,
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index b2b4f031b3a1..46d6dba50698 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -196,7 +196,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 	struct nf_conntrack_tuple target;
 	unsigned long statusbit;
 
-	NF_CT_ASSERT(ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY);
+	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
 
 	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
@@ -319,8 +319,8 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 
 	default:
 		/* ESTABLISHED */
-		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
-			     ctinfo == IP_CT_ESTABLISHED_REPLY);
+		WARN_ON(ctinfo != IP_CT_ESTABLISHED &&
+			ctinfo != IP_CT_ESTABLISHED_REPLY);
 		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
 			goto oif_changed;
 	}
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index d7b679037bae..98f61fcb9108 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -36,8 +36,8 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
 	struct nf_nat_range newrange;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-			    ctinfo == IP_CT_RELATED_REPLY));
+	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+			 ctinfo == IP_CT_RELATED_REPLY)));
 
 	if (ipv6_dev_get_saddr(nf_ct_net(ct), out,
 			       &ipv6_hdr(skb)->daddr, 0, &src) < 0)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c23df7c9cd59..0f6910787a27 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -403,7 +403,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	const struct nf_conntrack_l4proto *l4proto;
 
 	pr_debug("destroy_conntrack(%p)\n", ct);
-	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
+	WARN_ON(atomic_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -756,12 +756,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * connections for unconfirmed conns.  But packet copies and
 	 * REJECT will give spurious warnings here.
 	 */
-	/* NF_CT_ASSERT(atomic_read(&ct->ct_general.use) == 1); */
 
 	/* No external references means no one else could have
 	 * confirmed us.
 	 */
-	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
+	WARN_ON(nf_ct_is_confirmed(ct));
 	pr_debug("Confirming conntrack %p\n", ct);
 	/* We have to check the DYING flag after unlink to prevent
 	 * a race against nf_ct_get_next_corpse() possibly called from
@@ -1160,7 +1159,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
 	 */
-	NF_CT_ASSERT(atomic_read(&ct->ct_general.use) == 0);
+	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
 	nf_ct_ext_free(ct);
@@ -1468,7 +1467,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	struct nf_conn_help *help = nfct_help(ct);
 
 	/* Should be unconfirmed, so not in hash table yet */
-	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
+	WARN_ON(nf_ct_is_confirmed(ct));
 
 	pr_debug("Altering reply tuple of %p to ", ct);
 	nf_ct_dump_tuple(newreply);
@@ -1490,7 +1489,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  unsigned long extra_jiffies,
 			  int do_acct)
 {
-	NF_CT_ASSERT(skb);
+	WARN_ON(!skb);
 
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index dad2c0c22ad5..64778f9a8548 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -51,8 +51,8 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct net *net = nf_ct_exp_net(exp);
 
-	NF_CT_ASSERT(master_help);
-	NF_CT_ASSERT(!timer_pending(&exp->timeout));
+	WARN_ON(!master_help);
+	WARN_ON(timer_pending(&exp->timeout));
 
 	hlist_del_rcu(&exp->hnode);
 	net->ct.expect_count--;
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 6c605e88ebae..9fe0ddc333fb 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -47,7 +47,7 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	struct nf_ct_ext_type *t;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
-	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
+	WARN_ON(nf_ct_is_confirmed(ct));
 
 	old = ct->ext;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9eb85858d764..5a101caa3e12 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -287,7 +287,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	struct net *net = seq_file_net(s);
 	int ret = 0;
 
-	NF_CT_ASSERT(ct);
+	WARN_ON(!ct);
 	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
@@ -304,9 +304,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
-	NF_CT_ASSERT(l3proto);
+	WARN_ON(!l3proto);
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	NF_CT_ASSERT(l4proto);
+	WARN_ON(!l4proto);
 
 	ret = -ENOSPC;
 	seq_printf(s, "%-8s %u %-8s %u %ld ",
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index eb541786ccb7..82529ecc975f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -414,8 +414,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		return NF_ACCEPT;
 
-	NF_CT_ASSERT(maniptype == NF_NAT_MANIP_SRC ||
-		     maniptype == NF_NAT_MANIP_DST);
+	WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
+		maniptype != NF_NAT_MANIP_DST);
 	BUG_ON(nf_nat_initialized(ct, maniptype));
 
 	/* What we've got will look like inverse of reply. Normally
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 86067560a318..25b06b959118 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -38,11 +38,11 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 	__be32 newdst;
 	struct nf_nat_range newrange;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING ||
-		     hooknum == NF_INET_LOCAL_OUT);
+	WARN_ON(hooknum != NF_INET_PRE_ROUTING &&
+		hooknum != NF_INET_LOCAL_OUT);
 
 	ct = nf_ct_get(skb, &ctinfo);
-	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
+	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	/* Local packets: make them go to loopback */
 	if (hooknum == NF_INET_LOCAL_OUT) {
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index e45a01255e70..58aa9dd3c5b7 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -77,10 +77,10 @@ netmap_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range newrange;
 
-	NF_CT_ASSERT(xt_hooknum(par) == NF_INET_PRE_ROUTING ||
-		     xt_hooknum(par) == NF_INET_POST_ROUTING ||
-		     xt_hooknum(par) == NF_INET_LOCAL_OUT ||
-		     xt_hooknum(par) == NF_INET_LOCAL_IN);
+	WARN_ON(xt_hooknum(par) != NF_INET_PRE_ROUTING &&
+		xt_hooknum(par) != NF_INET_POST_ROUTING &&
+		xt_hooknum(par) != NF_INET_LOCAL_OUT &&
+		xt_hooknum(par) != NF_INET_LOCAL_IN);
 	ct = nf_ct_get(skb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 8107b3eb865f..0fd14d1eb09d 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -58,9 +58,9 @@ xt_snat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	NF_CT_ASSERT(ct != NULL &&
-		     (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		      ctinfo == IP_CT_RELATED_REPLY));
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+		  ctinfo == IP_CT_RELATED_REPLY)));
 
 	xt_nat_convert_range(&range, &mr->range[0]);
 	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
@@ -75,8 +75,8 @@ xt_dnat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	NF_CT_ASSERT(ct != NULL &&
-		     (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	xt_nat_convert_range(&range, &mr->range[0]);
 	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
@@ -90,9 +90,9 @@ xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	NF_CT_ASSERT(ct != NULL &&
-		     (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		      ctinfo == IP_CT_RELATED_REPLY));
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+		  ctinfo == IP_CT_RELATED_REPLY)));
 
 	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_SRC);
 }
@@ -105,8 +105,8 @@ xt_dnat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	NF_CT_ASSERT(ct != NULL &&
-		     (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_DST);
 }
-- 
2.13.5

