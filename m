Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D9C6CDDB
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133761; cv=none; b=PU5sM8+o+nNGpbdwXlzJUVW5nyZaLEEv8y6SttwwtVTGYxn/yfP3yG1iQ6Jt5YAXI56mS6a4nOz8EstT8X5qqxUOmrnaGd05bRskJl602JX5HJBBmi04CYX8k65V5wHJdLYVw2GwHwaf2Wxx8neUFqD9fRwzXSY1sEyxLHs57lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133761; c=relaxed/simple;
	bh=i1DSRNRAHRHJ97A86xhf72bNNzPysyMPqCTDTxPsFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7ZGDvekhyZ1zEkASAVbelEzzAVIhTNxT/n8LzMpjwn8VwkLCnfVeci/ymouduH8h0qonbzhPCYHTidv5kzuICsCeLCsk3xl668MdZ4WGvphvQzh6uPfvHBQV9JyAh4yqxgPM64l7aINw18J4qehFbszFIH+tvgh1ycRZ0hXxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rrwCc-0005yI-47; Wed, 03 Apr 2024 10:42:38 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/9] netfilter: nf_tables: pass new nft_iter_type hint to walker
Date: Wed,  3 Apr 2024 10:41:05 +0200
Message-ID: <20240403084113.18823-6-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240403084113.18823-1-fw@strlen.de>
References: <20240403084113.18823-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be needed by the 'pipapo' set backend.  If this is set, then
it needs to perform copy-on-write of the active set data storage.

Its not possible to use genmask test, the walker function is also used by
(rcu locked) set listing which can run in parallel to set updates.

If priv->clone is null, then fallback to the active data storeage is
safe EXCEPT for the flush case, which must do the copy.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 12 +++++++++++
 net/netfilter/nf_tables_api.c     |  1 +
 net/netfilter/nft_set_pipapo.c    | 35 +++++++++++++++++++++----------
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e27c28b612e4..9912a2621344 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -307,9 +307,21 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
 	return (void *)priv;
 }
 
+
+/**
+ * enum nft_iter_type - nftables set iterator type
+ *
+ * @NFT_ITER_FLUSH: destructive iteration, transaction mutex must be held
+ */
+enum nft_iter_type {
+	/* undef == 0 */
+	NFT_ITER_FLUSH = 1,
+};
+
 struct nft_set;
 struct nft_set_iter {
 	u8		genmask;
+	enum nft_iter_type type:8;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd86f2720c9e..facd33e97dfe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7369,6 +7369,7 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
 		.fn		= nft_setelem_flush,
+		.type		= NFT_ITER_FLUSH,
 	};
 
 	set->ops->walk(ctx, set, &iter);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 57b1508d3502..eca81c5e5810 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2161,21 +2161,34 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	struct net *net = read_pnet(&set->net);
 	const struct nft_pipapo_match *m;
 
-	rcu_read_lock();
-	if (iter->genmask == nft_genmask_cur(net)) {
-		m = rcu_dereference(priv->match);
-	} else {
+	switch (iter->type) {
+	case NFT_ITER_FLUSH:
 		m = priv->clone;
-		if (!m) /* no pending updates */
-			m = rcu_dereference(priv->match);
-	}
+		if (!m) {
+			iter->err = -ENOMEM;
+			return;
+		}
 
-	if (m)
 		__nft_pipapo_walk(ctx, set, m, iter);
-	else
-		WARN_ON_ONCE(1);
+		break;
+	default:
+		rcu_read_lock();
+		if (iter->genmask == nft_genmask_cur(net)) {
+			m = rcu_dereference(priv->match);
+		} else {
+			m = priv->clone;
+			if (!m) /* no pending updates */
+				m = rcu_dereference(priv->match);
+		}
 
-	rcu_read_unlock();
+		if (m)
+			__nft_pipapo_walk(ctx, set, m, iter);
+		else
+			WARN_ON_ONCE(1);
+
+		rcu_read_unlock();
+		break;
+	}
 }
 
 /**
-- 
2.43.2

