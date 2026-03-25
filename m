Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B69371D0E;
	Wed, 25 Mar 2026 22:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477601; cv=none; b=Lfu1IgQ3jEebGzva6tMNPOC3J6ItVNiM6sZ06C0pIyhBYhKqgcb2yqAdx5vadZXzsbJ6MgSbvsrHPbZ972FNPxiVvpoX+4alsyILz7iyHtj82Nbue7Te/zjekc05KjOENE+mytMTmj1oi/sGzCrTx5NQWogVP4slmIjmOUTPkfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477601; c=relaxed/simple;
	bh=tEyzgpBl6untVBoLfLqJ7aRUslMYGDD6YmvDurlq/tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJKqUykmYkS0QNssHeilGxNAWkEMeSL11H6i3igTYxWzw2RC1scY7ad5Gq2JtBTzuZcM1SUQwmj89osNLU6zDHagqpJ6Iclu5aJoKVU+p+CfBE/5wV2jemU+LRFs/tcvhQosmGXnpuWbLRyvzrTQtwRWe7Xk0QSAR2FY+FYcZlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C8v9DLR/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C8v9DLR/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 209FA6017D;
	Wed, 25 Mar 2026 23:26:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477598;
	bh=Jieo/3if9WncjG+80KJlCXCChmQ3rYE4ZAyLUHFPIK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8v9DLR/c7NJwAv9Uj7M7W+oQzOfKSHoCrPIGqZF04ctKOBBFqv+ActqUb+frDXoY
	 cg7vV0t3Estp6g34q/X+cRXFqohUXOwr9VzkXWXTjM+5nebyudw8mdup8FRh7H+Jue
	 tbwJmMX9pvHjkF5tTpPhy/buOWCvc3IdIGbx93hVaaDjclo3vCL7azjX4m08n8aYWQ
	 my5m4JVtvHsg6AVcucKD8rktHwYPS0/3Y3yGQsGDSgor9gFcq8ofJ5jtaFTUaLzTKZ
	 M0lacTwKgH7xUXCCYmLMAD2wzhPmn6wJH1r3ydtQyrewqKoQK0+1NdXpwqEzSJCeS+
	 PtyeZvIbrTfRQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/14] netfilter: nf_conntrack_expect: store netns and zone in expectation
Date: Wed, 25 Mar 2026 23:26:12 +0100
Message-ID: <20260325222615.637793-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
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
 net/netfilter/nf_conntrack_expect.c         |  7 +++++--
 net/netfilter/nf_conntrack_netlink.c        |  3 +++
 3 files changed, 25 insertions(+), 3 deletions(-)

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
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 1cbe5f1108c2..29b9d984a990 100644
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
 
@@ -343,6 +344,8 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		helper = rcu_dereference(help->helper);
 
 	rcu_assign_pointer(exp->helper, helper);
+	write_pnet(&exp->net, net);
+	exp->zone = ct->zone;
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 89540112d165..2ec33c0518e9 100644
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
@@ -3577,6 +3578,8 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
+	write_pnet(&exp->net, net);
+	exp->zone = ct->zone;
 	if (!helper)
 		helper = rcu_dereference(help->helper);
 	rcu_assign_pointer(exp->helper, helper);
-- 
2.47.3

