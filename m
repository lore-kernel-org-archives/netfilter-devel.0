Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D7F8286B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801213; cv=none; b=QXhNfkLDm1fpAgSVsDKE1xmlswDhJATwjp4LoCLriWL8xDZlgYXSgmNE/FJn62G5kCbfmu157iggDwjDxkWcRuIAluDP+GFgGnvq24x8BXMS4FmOBYqTxp70hhIeVMYD0VJ5+o6pnCtvqxrdPa3XHmsAXR1S7JfHa3hSw3Wveeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801213; c=relaxed/simple;
	bh=mt1pNdi3FicBYl6gcaJVTqXqZ2X1XKCZeaq7spSo0gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbn/5CQKEqxP6IQMg7c4q63lIPndBmWXqefYGAixQeNsDB/O9MxIs80B5+mevp/QZsS7uUCYxFKZOFmOT8Ewd9xNwB2C+Un9aZRM+CgxEIRmKXG5yvvYhmc8ac5p8NixWt6HBN2S46vPojwmUshkombHzOgiD/ejpeH/GP9lSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9Or-0005Lr-SK; Thu, 07 Mar 2024 09:46:49 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/9] netfilter: nf_tables: add in-kernel only query that will return expired/dead elements
Date: Thu,  7 Mar 2024 09:40:10 +0100
Message-ID: <20240307084018.2219-7-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307084018.2219-1-fw@strlen.de>
References: <20240307084018.2219-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the rhashtable backend so that nf_tables core can lookup a dead
or expired entry.

As-is, a set lookup will never return a matching entry that has expired,
which is the desired behaviour.

This has to be toggleable, else a dead element can shadow an alive one,
or vice versa.

Add internal NFT_SET_ELEM_GET_DEAD: if set, return a dead/expired
element, or null.
This is used in a follow patch that will switch the current gc
collection scheme from 'collect expired elements' to 'collect
the keys of expired elements'.

The difference is that in the former case, extra assurances are needed
to prevent the collected pointers from being free'd, or (this is the
current solution) a way to detect when the element pointers might have
gone stale.

With this approach, we can just copy the key and then query those keys
later: If the element got removed (or replaced!) in between, we just
move on to the next candidate key.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_tables_api.c            | 12 ++++++++++--
 net/netfilter/nft_set_hash.c             |  9 +++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa4094ca2444..ec16bae890d8 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -428,6 +428,11 @@ enum nft_set_attributes {
 enum nft_set_elem_flags {
 	NFT_SET_ELEM_INTERVAL_END	= 0x1,
 	NFT_SET_ELEM_CATCHALL		= 0x2,
+
+#ifdef __KERNEL__
+	/* not visisble to userspace, should be rejected if seen */
+	NFT_SET_ELEM_GET_DEAD		= 0x80000000,
+#endif
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5b69b3f9153c..c390ffec9b7b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6007,7 +6007,8 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 }
 
 static void *nft_setelem_catchall_get(const struct net *net,
-				      const struct nft_set *set)
+				      const struct nft_set *set,
+				      u32 flags)
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
@@ -6016,6 +6017,13 @@ static void *nft_setelem_catchall_get(const struct net *net,
 
 	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if ((flags & NFT_SET_ELEM_GET_DEAD) &&
+		    nft_set_elem_expired(ext)) {
+			priv = catchall->elem;
+			break;
+		}
+
 		if (!nft_set_elem_active(ext, genmask) ||
 		    nft_set_elem_expired(ext))
 			continue;
@@ -6037,7 +6045,7 @@ static int nft_setelem_get(struct nft_ctx *ctx, const struct nft_set *set,
 		if (IS_ERR(priv))
 			return PTR_ERR(priv);
 	} else {
-		priv = nft_setelem_catchall_get(ctx->net, set);
+		priv = nft_setelem_catchall_get(ctx->net, set, flags & NFT_SET_ELEM_GET_DEAD);
 		if (!priv)
 			return -ENOENT;
 	}
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 2e116b1e966e..6bf53c7eb8cf 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -35,6 +35,7 @@ struct nft_rhash_elem {
 struct nft_rhash_cmp_arg {
 	const struct nft_set		*set;
 	const u32			*key;
+	bool				dead;
 	u8				genmask;
 	u64				tstamp;
 };
@@ -61,13 +62,16 @@ static inline int nft_rhash_cmp(struct rhashtable_compare_arg *arg,
 
 	if (memcmp(nft_set_ext_key(&he->ext), x->key, x->set->klen))
 		return 1;
+
 	if (nft_set_elem_is_dead(&he->ext))
 		return 1;
 	if (__nft_set_elem_expired(&he->ext, x->tstamp))
-		return 1;
+		return x->dead ? 0 : 1;
 	if (!nft_set_elem_active(&he->ext, x->genmask))
 		return 1;
-	return 0;
+
+	/* don't want valid element to shadow expired one */
+	return x->dead ? 1 : 0;
 }
 
 static const struct rhashtable_params nft_rhash_params = {
@@ -109,6 +113,7 @@ nft_rhash_get(const struct net *net, const struct nft_set *set,
 		.set	 = set,
 		.key	 = elem->key.val.data,
 		.tstamp  = get_jiffies_64(),
+		.dead	 = flags & NFT_SET_ELEM_GET_DEAD,
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
-- 
2.43.0

