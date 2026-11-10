Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317697;
	b=Ov3zhIU7QUR8a+VaUAPr3GP+qz79y1zJne/1nWw/72uiTWH7SV28C9F++fbTZqEQrHNl
	 p5a61qgWwYe61dAx6YtZy+OcGZsFApvGVZ6mZsTkAl2TdgVPStlFEj8uAEHTNYlnE7+CU
	 ScLdRblpno+VXcQGVbbcTKGIQkKpIcCqvur5+GRCUD+zxO9SOw6DwyV+tv0Xl4tVA7yFr
	 pfyLqNEXcGXcuIAexAnefebXLLcROvCSvc2Hhc8NBJ3bGytV3ULB6z3Yo4dK1hqfFStoq
	 hA9O85HuT04HTOVPnbW6VwyeZKHLnmqTMPG/nXT7PiWSSEiHZD1K4mda0eQ72/xXFNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317697;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoWrDLZje56b4oqasj2yvMig6Biue8/jHjs00Wc5S/s=;
	b=nu0b6ZUbs0lMQvK2MGDpBChipJkA+JcR4X949lcUm8Hm/RmTi+1/3LEmOqABYCNI9wiA
	 DN4h6V1nyP2+PClZtcAudsZugNWc/3BCgXvnJjOEVi1Rr48DnYMLK2UCU5pX5z/3B0Khd
	 RAsJt0gWLuyPgdezU8GOtCQAAty0Do8ZXFQfrpWyRd66GinwqfBYiZHCUOYXK7lSWQ0Dg
	 fqK1KV0uaq+ixvZXdKtF8LVVaiUO7bm+tcm9vfUMlp37MaDgXxXllfgS7ZBg7xx/uFjnD
	 qlWlkeLvEJ9TNqZe+Z0aoWMmmnAbM/o5IShZvvB5vRUZFB2RNgt+stBNbHXJ+iAaXSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C6A606A33B
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:34:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97C6A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 000FF60342; Tue, 10 Nov 2026 14:34:48 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH nf v2] netfilter: nf_conntrack: limit expectation master chain depth
Date: Tue, 10 Nov 2026 14:34:43 +0100
Message-ID: <20261110133443.21073-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A conntrack can point to a master conntrack, which itself may point to
another master, and so on.  There is currently no bound on how deep this
chain can grow.

Force a max depth in nf_ct_expect_alloc(): walk the master chain and
reject allocation if it would exceed 8 levels of nesting.

Also add ctnetlink_find_get_master and use it so that ctnetlink create
paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
and returning a misleading -ENOMEM.

This prevents unbounded ct->master->master->... chains.

This also restricts the number of call forward/redirects that h323 and sip
helpers will follow.

Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: increase cap to 8, no other changes.

 include/net/netfilter/nf_conntrack_helper.h | 15 +++++++++
 net/netfilter/nf_conntrack_expect.c         | 15 +++++++--
 net/netfilter/nf_conntrack_netlink.c        | 36 +++++++++++++++------
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 335b8c43694f..53a8eda848dc 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -29,6 +29,8 @@ enum nf_ct_helper_flags {
 
 #define NF_CT_HELPER_NAME_LEN	16
 
+#define NF_CT_MAX_EXPECT_CHAIN_LEN	8
+
 /* Must be kept in sync with the classes defined by helpers */
 #define NF_CT_MAX_EXPECT_CLASSES	4
 
@@ -159,6 +161,19 @@ static inline void nf_ct_help_put(const struct nf_conn *ct)
 		kfree_rcu(helper, rcu);
 }
 
+static inline bool nf_ct_master_acceptable(const struct nf_conn *m)
+{
+	unsigned int depth = 0;
+
+	while (m->master) {
+		if (++depth >= NF_CT_MAX_EXPECT_CHAIN_LEN)
+			return false;
+		m = m->master;
+	}
+
+	return true;
+}
+
 int nf_conntrack_helper_init(void);
 void nf_conntrack_helper_fini(void);
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 06242c86e1dc..62e434cd57c9 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -299,13 +299,22 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_unexpect_related);
 
-/* We don't increase the master conntrack refcount for non-fulfilled
- * conntracks. During the conntrack destruction, the expectations are
- * always killed before the conntrack itself */
+/**
+ * nf_ct_expect_alloc - allocate a new conntrack expectation
+ * @me: The conntrack to be used as master.
+ *
+ * The master conntrack refcount is not incremented; expectations
+ * are always killed before the master conntrack is destroyed.
+ *
+ * Return: a new expectation on success or NULL on failure.
+ */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
 
+	if (!nf_ct_master_acceptable(me))
+		return NULL;
+
 	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
 	if (!new)
 		return NULL;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1f8d94a05240..30428d520e43 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2231,6 +2231,26 @@ ctnetlink_change_conntrack(struct nf_conn *ct,
 	return 0;
 }
 
+static struct nf_conn *
+ctnetlink_find_get_master(struct net *net, const struct nf_conntrack_zone *zone,
+			  const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_tuple_hash *master_h;
+	struct nf_conn *master_ct;
+
+	master_h = nf_conntrack_find_get(net, zone, tuple);
+	if (!master_h)
+		return ERR_PTR(-ENOENT);
+
+	master_ct = nf_ct_tuplehash_to_ctrack(master_h);
+	if (!nf_ct_master_acceptable(master_ct)) {
+		nf_ct_put(master_ct);
+		return ERR_PTR(-EMLINK);
+	}
+
+	return master_ct;
+}
+
 static struct nf_conn *
 ctnetlink_create_conntrack(struct net *net,
 			   const struct nf_conntrack_zone *zone,
@@ -2356,7 +2376,6 @@ ctnetlink_create_conntrack(struct net *net,
 	/* setup master conntrack: this is a confirmed expectation */
 	if (cda[CTA_TUPLE_MASTER]) {
 		struct nf_conntrack_tuple master;
-		struct nf_conntrack_tuple_hash *master_h;
 		struct nf_conn *master_ct;
 
 		err = ctnetlink_parse_tuple(cda, &master, CTA_TUPLE_MASTER,
@@ -2364,12 +2383,11 @@ ctnetlink_create_conntrack(struct net *net,
 		if (err < 0)
 			goto err2;
 
-		master_h = nf_conntrack_find_get(net, zone, &master);
-		if (master_h == NULL) {
-			err = -ENOENT;
+		master_ct = ctnetlink_find_get_master(net, zone, &master);
+		if (IS_ERR(master_ct)) {
+			err = PTR_ERR(master_ct);
 			goto err2;
 		}
-		master_ct = nf_ct_tuplehash_to_ctrack(master_h);
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
 	}
@@ -3613,7 +3631,6 @@ ctnetlink_create_expect(struct net *net,
 			u_int8_t u3, u32 portid, int report)
 {
 	struct nf_conntrack_tuple tuple, mask, master_tuple;
-	struct nf_conntrack_tuple_hash *h = NULL;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *ct;
 	int err;
@@ -3633,10 +3650,9 @@ ctnetlink_create_expect(struct net *net,
 		return err;
 
 	/* Look for master conntrack of this expectation */
-	h = nf_conntrack_find_get(net, zone, &master_tuple);
-	if (!h)
-		return -ENOENT;
-	ct = nf_ct_tuplehash_to_ctrack(h);
+	ct = ctnetlink_find_get_master(net, zone, &master_tuple);
+	if (IS_ERR(ct))
+		return PTR_ERR(ct);
 
 	rcu_read_lock();
 	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask);
-- 
2.56.0

