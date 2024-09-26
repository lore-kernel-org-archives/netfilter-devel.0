Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEBD1AF4F4;
	Thu, 26 Sep 2024 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348859; cv=none; b=SnBENiD7XNPaBs0THuTWdbWBFz4cLq6r1GR3GgO9t6EERKFJ1NftgBWRBPQPx7RfJSlZbwMe/ia/O8mAq5iQupizAva39msS3sVuLH8edPVNBabv74wPqP282BYVFr7zUoqjGr+Exr6gE8M4NaWE2dNXsM13X3umtm5q3WrGo9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348859; c=relaxed/simple;
	bh=mKkE6S19DKhdFD9pV4wguIfAYkvqf6jVoDbU1CvR4Mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rckS4JfGNGyjiLGhh+ve00R4Gzkx4IjJiN+Ca5t8LCrJeUcdxlPheq5kpQOO3B/A1DFqdHmO5mT+PILptipVnSCEFl707/VGnjk8JhJTKPtJsN1fobFb1tyE2vC1TA/1LiuqjEt5pA9quubxrFy3jE5WntVevqTs566ORjn/jJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 11/14] netfilter: nf_tables: missing objects with no memcg accounting
Date: Thu, 26 Sep 2024 13:07:14 +0200
Message-Id: <20240926110717.102194-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several ruleset objects are still not using GFP_KERNEL_ACCOUNT for
memory accounting, update them. This includes:

- catchall elements
- compat match large info area
- log prefix
- meta secctx
- numgen counters
- pipapo set backend datastructure
- tunnel private objects

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c  |  2 +-
 net/netfilter/nft_compat.c     |  6 +++---
 net/netfilter/nft_log.c        |  2 +-
 net/netfilter/nft_meta.c       |  2 +-
 net/netfilter/nft_numgen.c     |  2 +-
 net/netfilter/nft_set_pipapo.c | 13 +++++++------
 net/netfilter/nft_tunnel.c     |  5 +++--
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8f073e6c772a..a24fe62650a7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6684,7 +6684,7 @@ static int nft_setelem_catchall_insert(const struct net *net,
 		}
 	}
 
-	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL);
+	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL_ACCOUNT);
 	if (!catchall)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 52cdfee17f73..7ca4f0d21fe2 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -535,7 +535,7 @@ nft_match_large_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_match *m = expr->ops->data;
 	int ret;
 
-	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL);
+	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL_ACCOUNT);
 	if (!priv->info)
 		return -ENOMEM;
 
@@ -808,7 +808,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
@@ -898,7 +898,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 5defe6e4fd98..e35588137995 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -163,7 +163,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 
 	nla = tb[NFTA_LOG_PREFIX];
 	if (nla != NULL) {
-		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
+		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL_ACCOUNT);
 		if (priv->prefix == NULL)
 			return -ENOMEM;
 		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8c8eb14d647b..05cd1e6e6a2f 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -952,7 +952,7 @@ static int nft_secmark_obj_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_SECMARK_CTX] == NULL)
 		return -EINVAL;
 
-	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL);
+	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL_ACCOUNT);
 	if (!priv->ctx)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 7d29db7c2ac0..bd058babfc82 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -66,7 +66,7 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL);
+	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL_ACCOUNT);
 	if (!priv->counter)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index eb4c4a4ac7ac..7be342b495f5 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,7 +663,7 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
-	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL);
+	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
 
@@ -936,7 +936,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL);
+	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1212,7 +1212,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		scratch = kzalloc_node(struct_size(scratch, map,
 						   bsize_max * 2) +
 				       NFT_PIPAPO_ALIGN_HEADROOM,
-				       GFP_KERNEL, cpu_to_node(i));
+				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
 			 * allocations: this means that some scratch maps have
@@ -1427,7 +1427,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	struct nft_pipapo_match *new;
 	int i;
 
-	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL);
+	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return NULL;
 
@@ -1457,7 +1457,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
 				  src->bsize * sizeof(*dst->lt) +
 				  NFT_PIPAPO_ALIGN_HEADROOM,
-				  GFP_KERNEL);
+				  GFP_KERNEL_ACCOUNT);
 		if (!new_lt)
 			goto out_lt;
 
@@ -1470,7 +1470,8 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
 		if (src->rules > 0) {
 			dst->mt = kvmalloc_array(src->rules_alloc,
-						 sizeof(*src->mt), GFP_KERNEL);
+						 sizeof(*src->mt),
+						 GFP_KERNEL_ACCOUNT);
 			if (!dst->mt)
 				goto out_mt;
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 60a76e6e348e..5c6ed68cc6e0 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -509,13 +509,14 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
-	md = metadata_dst_alloc(priv->opts.len, METADATA_IP_TUNNEL, GFP_KERNEL);
+	md = metadata_dst_alloc(priv->opts.len, METADATA_IP_TUNNEL,
+				GFP_KERNEL_ACCOUNT);
 	if (!md)
 		return -ENOMEM;
 
 	memcpy(&md->u.tun_info, &info, sizeof(info));
 #ifdef CONFIG_DST_CACHE
-	err = dst_cache_init(&md->u.tun_info.dst_cache, GFP_KERNEL);
+	err = dst_cache_init(&md->u.tun_info.dst_cache, GFP_KERNEL_ACCOUNT);
 	if (err < 0) {
 		metadata_dst_free(md);
 		return err;
-- 
2.30.2

