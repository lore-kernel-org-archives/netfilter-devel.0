Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54379248861;
	Thu, 26 Mar 2026 12:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529533; cv=none; b=TCaQgtu7Xq+WbEEd9GXf/A0Ade07MDZGlTY0w6qGvG73o+AHaDPQoocpKcgIX/I/3Kr17IkJ+mBMFMWwlmRvkPWexB/ZrZGmjMyCVinPW8R0M92K51bCzcaFZiP8WBKDph8oiAXncR7QO7SGaYgZpqg59qnQ1wbBzHuM66mxuzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529533; c=relaxed/simple;
	bh=gztqscbUaLD/2uRGb0cq135ZPkvkaCUcDDpyOb7ibUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOj7IWyeh2h2zPw+8kEKRgJNynTMoW1uZzY9oXdxyuB5FDS/BRg7T8h63W4pbSBn8WS73ywO8yzpolGgFpv4vdK3/A3zcyU5XNWUs6SCorKy5/Qv4BUK2xM9ev5ic46z9n2Qo/MOdCSTgsoP0GryxE31R59X+8ijp/601Xr8aBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cFmBQh20; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cFmBQh20"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2D64660272;
	Thu, 26 Mar 2026 13:52:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529528;
	bh=BhmEnl0LM1sg6QQoh5cz1f0Q9H6mjqbhLb5C6npbmUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFmBQh20U/ccFahbJj5AWf6V/VcRCXmMgNluks10T6tPObvb/X0ldrirxHvivqWS1
	 0cZZxYQwMAUvvX22bLwvjTHB+6rP7feIWeEGGd9g6Ha70qsOcAurhX0kgSTzjtFJLH
	 Z2mXxVquXYy9+C09tbQRiIiWMfvwsI01QIgC1P9R8U3l7ft0dnYkwmjQgPLR5xhU+t
	 sMuvHyymPYrOXNDlaAZxu7/9kjcB73y93QDIEQLOO37z6YotNwsaBIhA6V5yWWgpVQ
	 l3URevPpymCSiSBTCYEWha2nYg/R7zf2tn4M5KfQlBqRA2mfxbi+XScfbcQ1KcxVh+
	 4QdQmUJRYQlNg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/12] netfilter: nf_conntrack_expect: store netns and zone in expectation
Date: Thu, 26 Mar 2026 13:51:50 +0100
Message-ID: <20260326125153.685915-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326125153.685915-1-pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__nf_ct_expect_find() and nf_ct_expect_find_get() are called under
rcu_read_lock() but they dereference the master conntrack via
exp->master.

Since the expectation does not hold a reference on the master conntrack,
this could be dying conntrack or different recycled conntrack than the
real master due to SLAB_TYPESAFE_RCU.

Store the netns, the master_tuple and the zone in struct
nf_conntrack_expect as a safety measure.

This patch is required by the follow up fix not to dump expectations
that do not belong to this netns.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++++++++++-
 net/netfilter/nf_conntrack_broadcast.c      |  6 +++++-
 net/netfilter/nf_conntrack_expect.c         |  9 +++++++--
 net/netfilter/nf_conntrack_netlink.c        |  5 +++++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 1b01400b10bd..e9a8350e7ccf 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -22,10 +22,16 @@ struct nf_conntrack_expect {
 	/* Hash member */
 	struct hlist_node hnode;
 
+	/* Network namespace */
+	possible_net_t net;
+
 	/* We expect this tuple, with the following mask */
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	struct nf_conntrack_zone zone;
+#endif
 	/* Usage count. */
 	refcount_t use;
 
@@ -62,7 +68,17 @@ struct nf_conntrack_expect {
 
 static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
 {
-	return nf_ct_net(exp->master);
+	return read_pnet(&exp->net);
+}
+
+static inline bool nf_ct_exp_zone_equal_any(const struct nf_conntrack_expect *a,
+					    const struct nf_conntrack_zone *b)
+{
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	return a->zone.id == b->id;
+#else
+	return true;
+#endif
 }
 
 #define NF_CT_EXP_POLICY_NAME_LEN	16
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 1964c596c646..4f39bf7c843f 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -21,6 +21,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 				unsigned int timeout)
 {
 	const struct nf_conntrack_helper *helper;
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_expect *exp;
 	struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt = skb_rtable(skb);
@@ -71,7 +72,10 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	rcu_assign_pointer(exp->helper, helper);
-
+	write_pnet(&exp->net, net);
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	exp->zone = ct->zone;
+#endif
 	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 1cbe5f1108c2..db28801b1688 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -113,8 +113,8 @@ nf_ct_exp_equal(const struct nf_conntrack_tuple *tuple,
 		const struct net *net)
 {
 	return nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
-	       net_eq(net, nf_ct_net(i->master)) &&
-	       nf_ct_zone_equal_any(i->master, zone);
+	       net_eq(net, read_pnet(&i->net)) &&
+	       nf_ct_exp_zone_equal_any(i, zone);
 }
 
 bool nf_ct_remove_expect(struct nf_conntrack_expect *exp)
@@ -326,6 +326,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 {
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn *ct = exp->master;
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conn_help *help;
 	int len;
 
@@ -343,6 +344,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		helper = rcu_dereference(help->helper);
 
 	rcu_assign_pointer(exp->helper, helper);
+	write_pnet(&exp->net, net);
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	exp->zone = ct->zone;
+#endif
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 89540112d165..6e6aeb0ab0a1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3538,6 +3538,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
 	u32 class = 0;
@@ -3577,6 +3578,10 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
+	write_pnet(&exp->net, net);
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	exp->zone = ct->zone;
+#endif
 	if (!helper)
 		helper = rcu_dereference(help->helper);
 	rcu_assign_pointer(exp->helper, helper);
-- 
2.47.3

