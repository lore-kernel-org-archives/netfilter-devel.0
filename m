Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711936;
	b=Mz3FaDNW+T4BlBpomPRO0rZrZcSWeOvEMmIypiG+iVE6Kj+ZtW12oSYRRQNStHxJynpm
	 ehmRHHzUu96LKIVLSb7b2558GOW/HumLJf1KMtdhRbo/wo291AXRVSaq6n8bL/J3/arYx
	 J9zITZ9Ixq0UxujlwmQP6cOiZAe5mzciFjk6k6W7zRr+X7LNHl5xHCCQp7vfH08BiX6dU
	 pt0HInHZ2UwOfxoKC8tt+imtUYcKH5U76h8EPWaa9jYJ+MNVrX+qXSfaBbabITM+MipLX
	 smDhPrn/2N5RDXwNeO85y8ksEEOBD09bDLF07AKmvNg2HaZCAAWbqci6kbcuKmtJKBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711936;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PxD5LmXCZioRF1ePMhXhKQZKIo65p/jI7A49m7OnWBI=;
	b=IzBywb+1hgotfcNVrQATIiMPAkgdS/eCk9HNuzVguE9xU2DzDnfA8RiCBsAA0Gj3pavt
	 w9a52iCNJyKEFsTuP3bkwB+H3XYnAAIgpM9lcVDyd5uNAoPItxbD+6LwfQ4d9sc4ZFSwz
	 pkuRBgh2XxznlJTuVPevFFYw7UEn3feB9PvtDEze7YllkMYaNHRBJ91pcHvTqLnT5sHLj
	 JK2hiqEIfEHOjNf5lcSlAshCn08jPHkg6Kut0k8sC6BB8shnFpxJf7g5VOuE0p1ROR4CD
	 y9agQqYZAsLNM5xKLYj/Rgm23idjtEA8NIpWWmodyDimIN4n+5r+FNjFRIrNksZZJkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B826606A331
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 13:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B826606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 93D0B60678; Tue, 03 Nov 2026 14:18:53 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf v2] netfilter: nf_conntrack: limit expectation master chain depth
Date: Tue,  3 Nov 2026 14:18:49 +0100
Message-ID: <20261103131849.25702-1-fw@strlen.de>
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
reject allocation if it would exceed 2 levels of nesting.

Also add ctnetlink_find_get_master and use it so that ctnetlink create
paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
and returning a misleading -ENOMEM.

This prevents unbounded ct->master->master->... chains.

Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 V2: add a ":" in kdoc comment

 include/net/netfilter/nf_conntrack_helper.h | 15 +++++++++
 net/netfilter/nf_conntrack_expect.c         | 15 +++++++--
 net/netfilter/nf_conntrack_netlink.c        | 36 +++++++++++++++------
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 335b8c43694f..617178fd4d8b 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -29,6 +29,8 @@ enum nf_ct_helper_flags {
 
 #define NF_CT_HELPER_NAME_LEN	16
 
+#define NF_CT_MAX_EXPECT_CHAIN_LEN	2
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

