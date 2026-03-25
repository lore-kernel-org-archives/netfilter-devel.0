Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51FB3D9022;
	Wed, 25 Mar 2026 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444344; cv=none; b=Cy62wdjyhaHzjrwx6F/EVWus2m+H6gLXceCXKhrlICsZYN6ig7wFc8YCSNnR6HDNecRlhATv/uMxk/+uh4t27GmDiWeTpFw4fW1wIbNEQcf/vmmqFg1+BJZOacnwpwfRocF1baPupVrePjlo7OdR4tmPDtMqkcUoYoECpNPkGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444344; c=relaxed/simple;
	bh=/E6hGD2SWtfR8W6UsJdY6xZ4Q4GbinANu0aUHkmUkEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M42j28R3Xd5Ie1dAkMPhe+4v6nev8XKMvsdIqoxglswcE4YFFkB6VDeXojIOfXe0fGG/UDyiIv//PzPdhDkx6MHBZH7+VuEpoYdDsiAZtUE6OhmuNTyVmU23dxshPA28QAn/jW+AdanCncGz+SMmwaYAYtQi+dN1YGXp1SJCW+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 514F860AE1; Wed, 25 Mar 2026 14:12:21 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 11/14] netfilter: nf_conntrack_expect: store netns and zone in expectation
Date: Wed, 25 Mar 2026 14:11:05 +0100
Message-ID: <20260325131108.23045-12-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++++++++++-
 net/netfilter/nf_conntrack_expect.c         |  8 ++++++--
 net/netfilter/nf_conntrack_netlink.c        |  3 +++
 3 files changed, 26 insertions(+), 3 deletions(-)

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
index 2505d1f4b68c..8896fb20b58e 100644
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
@@ -324,6 +324,8 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		       const union nf_inet_addr *daddr,
 		       u_int8_t proto, const __be16 *src, const __be16 *dst)
 {
+	struct net *net = read_pnet(&exp->master->ct_net);
+
 	int len;
 
 	if (family == AF_INET)
@@ -335,6 +337,8 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->class = class;
 	exp->expectfn = NULL;
 	rcu_assign_pointer(exp->helper, nfct_help(exp->master)->helper);
+	write_pnet(&exp->net, net);
+	exp->zone = exp->master->zone;
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
2.52.0

