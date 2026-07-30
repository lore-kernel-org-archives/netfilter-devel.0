Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC80346FD2
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 18:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436769; cv=none; b=nEJ154+eBZxXjf3n4E9B8sxRytw24MOS9D5mbfnt4aWy8ZtkeTOUE8SUnwH1c8Dbo+gItV67S+ERCbwJKqeRXFiUofbx0WxjcYZkaQvubbkqoBqXcfvRRVydndo+PCHSWHD/tCCSzmbjlKtK96C9TR0E/9He0hw2OUaFlSIq5C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436769; c=relaxed/simple;
	bh=lFO7q/uTij5TPkTVmlbzsbV5lWoSsWnZcQsLGOdXGKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1KGIL90WAKT8l1YPwgp3yLBV5k9ENJFtiL4c2K19p3/aO6X4FtIvnJaDx1HpZB4vV7XEnV6lhQ19hmgc0c6WZMrMZKBPrqnfX7KCbsaaw4ImRp3px024L+X1nwbDt3Oqn7BdCxMm4gHIpU/pMhvO64oS/X2maEvExYXeBb0iOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BDFF8605AD; Thu, 30 Jul 2026 20:39:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/5] netfilter: ipset: add small wrappers for hash and bucket sizes
Date: Thu, 30 Jul 2026 20:38:51 +0200
Message-ID: <20260730183853.21868-4-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260730183853.21868-1-fw@strlen.de>
References: <20260730183853.21868-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preparation patch.  Once the ipset hash table is replaced with rhashtable
these functions are needed. Add them in extra commit to have reviewable
chunks.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 39 +++++++++++++++++++++------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8841daf28f01..ef586b486f51 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -201,6 +201,8 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_same_set
 #undef mtype_kadt
 #undef mtype_uadt
+#undef mtype_bucket_size
+#undef mtype_hash_size
 
 #undef mtype_add
 #undef mtype_del
@@ -246,6 +248,8 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_same_set		IPSET_TOKEN(MTYPE, _same_set)
 #define mtype_kadt		IPSET_TOKEN(MTYPE, _kadt)
 #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
+#define mtype_bucket_size	IPSET_TOKEN(MTYPE, _bucket_size)
+#define mtype_hash_size		IPSET_TOKEN(MTYPE, _hash_size)
 
 #define mtype_add		IPSET_TOKEN(MTYPE, _add)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
@@ -1358,6 +1362,24 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	return ret;
 }
 
+static u32 mtype_hash_size(const struct htype *h)
+{
+	const struct htable *t;
+	u8 htable_bits;
+
+	rcu_read_lock();
+	t = rcu_dereference(h->table);
+	htable_bits = t->htable_bits;
+	rcu_read_unlock();
+
+	return jhash_size(htable_bits);
+}
+
+static u32 mtype_bucket_size(const struct htype *h)
+{
+	return h->bucketsize;
+}
+
 /* Reply a HEADER request: fill out the header part of the set */
 static int
 mtype_head(struct ip_set *set, struct sk_buff *skb)
@@ -1368,21 +1390,20 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	size_t memsize;
 	u32 elements = 0;
 	size_t ext_size = 0;
-	u8 htable_bits;
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	mtype_ext_size(set, &elements, &ext_size);
 	memsize = mtype_ahash_memsize(h, t) + ext_size + atomic64_read(&set->ext_size);
-	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
-	if (nla_put_net32(skb, IPSET_ATTR_HASHSIZE,
-			  htonl(jhash_size(htable_bits))) ||
-	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
+
+	if (nla_put_net32(skb, IPSET_ATTR_HASHSIZE, htonl(mtype_hash_size(h))))
+		goto nla_put_failure;
+	if (nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
 #ifdef IP_SET_HASH_WITH_BITMASK
 	/* if netmask is set to anything other than HOST_MASK we know that the user supplied netmask
@@ -1406,8 +1427,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 #endif
 	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE) {
-		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize) ||
-		    nla_put_net32(skb, IPSET_ATTR_INITVAL, htonl(h->initval)))
+		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, mtype_bucket_size(h)))
+			goto nla_put_failure;
+		if (nla_put_net32(skb, IPSET_ATTR_INITVAL, htonl(h->initval)))
 			goto nla_put_failure;
 	}
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
@@ -1721,6 +1743,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	INIT_LIST_HEAD(&t->ad);
 	RCU_INIT_POINTER(h->table, t);
 	set->data = h;
+
 #ifndef IP_SET_PROTO_UNDEF
 	if (set->family == NFPROTO_IPV4) {
 #endif
@@ -1749,7 +1772,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 	}
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
-		 set->name, jhash_size(t->htable_bits),
+		 set->name, mtype_hash_size(h),
 		 t->htable_bits, h->maxelem, set->data, t);
 
 	return 0;
-- 
2.54.0

