Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714607;
	b=shATzxag8KvAW19SI9l86vMwdDue6nopKyUqwIjzXefepyE3EM8r0plgLUAuDMkOHQFW
	 vEsw+rb7cvfnSYPga58wmbZu6bKlFGhgSWbeMil5TYdyDutQKrIXkcp8bDy3zPh0sbCUW
	 xUAR95XMBYdR9q29xno3T6f7N+XGOOp0E+T16Tbcf0KxlmerKQBjEvGTaPIhOIne4dPRa
	 5C1h3GbvEUN07wzdw84exGroM7+8w5y4NO1m/YEz+FMCjBVNFK3PMQtFTlzj3gLme6B8V
	 mV9doGnS8L04ZRwX6YDePT0T2yNPIL9HgHcs75TYB0K0vIqSWBXmRqxZLLpHqACduUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714607;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=7Ntrx+LlfYSxv86cRPNpj6p/MA3HXhyARlMmyZ8YFhA=;
	b=STlsQrYtWncIUva3NlnWYKXTGHa24lt8Ev+sQHVNiVfQ6PIXAl7hk84Lt/Cw2hJj1HE+
	 H5n/ktUwUi4cf2OMbGWWmfyOE4q1tKxOBFr512X2sPYkgJWw1Cuxmvp3IfWkepUGTK5eQ
	 URhBXZsKfzTZQHoytI00HgpMTKTznAjc5Yb91IF9Rt66k1A3tu7XXcZl6Sfsg8WaBlJvU
	 qZAyECmKk9cm5ihxl3IDMfgO8BAO+vuQAE7N8QEt7cnTeuUDcde6lvlKa0p3LrFjPN2FN
	 JXSo943g6U+sTCUn3uPahvFyO6O2WJ02SiAy1XGhUY1uum+OKd0ECHMZy5+gE7+624Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=JrXSx27D;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8306083602;
	Tue,  3 Nov 2026 14:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD8306083602
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=JrXSx27D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714605;
	bh=7Ntrx+LlfYSxv86cRPNpj6p/MA3HXhyARlMmyZ8YFhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrXSx27DNsaJitwk0qQ+FwBtyaB6tIpkuUxIsWFrtV0YfmnkzphxeKC3s5R+Nlktx
	 wFOqs19Wjmxf5IWiEhEnOu9oR5JMjV7J0lBaN2bhJzFa/dHAiHuPzshMT1pBbCLnse
	 /4/yCfnBTpLiVU4mpaYlX61wjZq7cRJBrwBLlxY7uRpygB5Cx43ES7rary6zP0bMVX
	 lYRfbHMxgUe60sy15ze4wKPrBE7mUiLZ6sY/0LHREsaTXT9ukjY16f13v8PS8v5CCM
	 KGBMDTOPGxxy8bUD1h+2t8ZlKro9np9FOJp/W48n9Y9RKe43kL236xf/E/0OmtUjUK
	 ANISirPAG6/OA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6510160090;
	Tue,  3 Nov 2026 15:03:24 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 06/15] netfilter: nf_conntrack: limit expectation master chain depth
Date: Tue,  3 Nov 2026 15:02:59 +0100
Message-ID: <20261103140308.591690-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

A conntrack can point to a master conntrack, which itself may point to
another master, and so on.  There is currently no bound on how deep this
chain can grow.

Force a max depth in nf_ct_expect_alloc(): walk the master chain and
reject allocation if it would exceed 2 levels of nesting.

Also add ctnetlink_find_get_master and use it so that ctnetlink create
paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
and returning a misleading -ENOMEM.

This prevents unbounded ct->master->master->... chains.

Assisted-by: LLM
Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 15 +++++++++
 net/netfilter/nf_conntrack_expect.c         |  3 ++
 net/netfilter/nf_conntrack_netlink.c        | 36 +++++++++++++++------
 3 files changed, 44 insertions(+), 10 deletions(-)

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
index 06242c86e1dc..65c9964ea6ff 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -306,6 +306,9 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
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
2.47.3

