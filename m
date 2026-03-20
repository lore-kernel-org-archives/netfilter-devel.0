Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91E73B774F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011599; cv=none; b=sr0BYbaYzcYazhLG+p0fJuOt0z1CeCJGLycKmDqusX7e/7eo1ZI/L2oX1ebYE2V5vxsJpt3migb2kb/yYJzdx9Rqn9VnVd3fd6sGPOn+xEDp+2l2W4dGfQmpPYI8ubNjhhtd21tMi71frkVgo8etv+to1rU1fLmsthKI839jU7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011599; c=relaxed/simple;
	bh=1iM2efys2kQqpqYGbxwtFKUKxBBlrnDM8hiPE7f0bx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpdI3vUu344MBkEW2pBS6C95s812zH3PZmf0c26vs1ig/K/mXdjLvs49FsGM2Tpijhr+BsXe0vzHI8jji8RcBBYhxTWpbivfaMh3qelTT9m+3WUaeyLO3so5OXqm9nhvFcs3QUkCFB4aAdY6QoECvx5zDF3SVXKqi+r1Oya4iD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MKz1UF3j; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MKz1UF3j"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E8ECE60180;
	Fri, 20 Mar 2026 13:59:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774011596;
	bh=fhMgvz8Diq3nP++VS0Tqze27EyiYkhN63Bm+W0j9H1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKz1UF3jBlRXWMBoK+N1qxAOOLZXre3RMZLw1qfw52f5QGR6LK8wlA0LvR0jPSkQX
	 R3xN+WAqc6/Y7JMMzMfCGhfvM6SntfEI27ZNDMojenx2nHl27sbnigUHdQfEeNg/66
	 /E17+7ul6Xodm1MrrT2n9eBM6WcmzW+NRk7NxyThSkqLDL2bzECQUL462qEvgzl77Y
	 mzjI0f4pRSYk0CKEVUFLQMGdfVrMEWCTH5G1F58r9Ft7Xqt5xEfM9DoJDUqDu9Ed/9
	 wGKoLhvHDnkhFXGL/h7rvXQJXBoLsbxLEefJo1OIn00t6mrpdhUQuop64XGs7OeP0l
	 4bsrBk95uE/Ew==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf 4/5] netfilter: nf_conntrack_expect: store netns and zone in expectation
Date: Fri, 20 Mar 2026 13:59:46 +0100
Message-ID: <20260320125947.305117-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320125947.305117-1-pablo@netfilter.org>
References: <20260320125947.305117-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++++++++++-
 net/netfilter/nf_conntrack_expect.c         |  8 ++++++--
 net/netfilter/nf_conntrack_netlink.c        |  5 ++++-
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 1b01400b10bd..550e03cd2ed1 100644
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
+        return a->zone.id == b->id;
+#else
+        return true;
+#endif
 }
 
 #define NF_CT_EXP_POLICY_NAME_LEN	16
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 105d0c39a3c1..4f2c0cb871d7 100644
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
index 17975fb4905c..72bbdeb4a2e7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3539,9 +3539,10 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
-	u_int32_t class = 0;
+	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
+	u_int32_t class = 0;
 	int err;
 
 	help = nfct_help(ct);
@@ -3578,6 +3579,8 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
+	write_pnet(&exp->net, net);
+	exp->zone = ct->zone;
 	rcu_assign_pointer(exp->helper, helper ? : help->helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
-- 
2.47.3

