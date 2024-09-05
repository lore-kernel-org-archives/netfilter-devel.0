Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B171BBBD8;
	Thu,  5 Sep 2024 23:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578986; cv=none; b=r8jRMvmVEz/diKypZq3ft71SmUFgfUi5DPn/OuOms6S0u4wA+0subYKJ4q3mmaKN8ZfosYNp2HZUEhk7nJ0fHJUZOyLF3oiTaQwjUTgmWCgCQSbVBvCmQGcyp0n+tsgv4NbV+SoVsKX1hOCVDIVNvRgD+h4nz82yu8l876jqDn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578986; c=relaxed/simple;
	bh=J6dOzpIDNNjDaWuUt8IT8SxdXus7OImN16rvQbQWzxo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SA8zjrXiWIRPsQIKZxpRbutKCA8sAmr61NbDPnG1sV3TdFhUSv+Wz7xgCwc0P6QHNiO38ZP8lLZbozZIoaEJDrcOGJHtd5WzhACeJbF0lGzDgccbA3bZ+hTvaHgLtt/r4SAMp5yidHxkGcSBiJ/XaVfhNwZCJHiaq0k30q1ifGQ=
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
Subject: [PATCH net-next 14/16] netfilter: nf_tables: consolidate timeout extension for elements
Date: Fri,  6 Sep 2024 01:29:18 +0200
Message-Id: <20240905232920.5481-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240905232920.5481-1-pablo@netfilter.org>
References: <20240905232920.5481-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expiration and timeout are stored in separated set element extensions,
but they are tightly coupled. Consolidate them in a single extension to
simplify and prepare for set element updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 18 ++++++-------
 net/netfilter/nf_tables_api.c     | 43 ++++++++++++-------------------
 net/netfilter/nft_dynset.c        | 13 ++++------
 3 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1528af3fe26f..1e9b5e1659a1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -687,7 +687,6 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  *	@NFT_SET_EXT_DATA: mapping data
  *	@NFT_SET_EXT_FLAGS: element flags
  *	@NFT_SET_EXT_TIMEOUT: element timeout
- *	@NFT_SET_EXT_EXPIRATION: element expiration time
  *	@NFT_SET_EXT_USERDATA: user data associated with the element
  *	@NFT_SET_EXT_EXPRESSIONS: expressions associated with the element
  *	@NFT_SET_EXT_OBJREF: stateful object reference associated with element
@@ -699,7 +698,6 @@ enum nft_set_extensions {
 	NFT_SET_EXT_DATA,
 	NFT_SET_EXT_FLAGS,
 	NFT_SET_EXT_TIMEOUT,
-	NFT_SET_EXT_EXPIRATION,
 	NFT_SET_EXT_USERDATA,
 	NFT_SET_EXT_EXPRESSIONS,
 	NFT_SET_EXT_OBJREF,
@@ -811,14 +809,14 @@ static inline u8 *nft_set_ext_flags(const struct nft_set_ext *ext)
 	return nft_set_ext(ext, NFT_SET_EXT_FLAGS);
 }
 
-static inline u64 *nft_set_ext_timeout(const struct nft_set_ext *ext)
-{
-	return nft_set_ext(ext, NFT_SET_EXT_TIMEOUT);
-}
+struct nft_timeout {
+	u64	timeout;
+	u64	expiration;
+};
 
-static inline u64 *nft_set_ext_expiration(const struct nft_set_ext *ext)
+static inline struct nft_timeout *nft_set_ext_timeout(const struct nft_set_ext *ext)
 {
-	return nft_set_ext(ext, NFT_SET_EXT_EXPIRATION);
+	return nft_set_ext(ext, NFT_SET_EXT_TIMEOUT);
 }
 
 static inline struct nft_userdata *nft_set_ext_userdata(const struct nft_set_ext *ext)
@@ -834,8 +832,8 @@ static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ex
 static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
-	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_after_eq64(tstamp, READ_ONCE(*nft_set_ext_expiration(ext)));
+	return nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+	       time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 77dce3d61ae6..c295d6e6c1fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5694,12 +5694,8 @@ const struct nft_set_ext_type nft_set_ext_types[] = {
 		.align	= __alignof__(u8),
 	},
 	[NFT_SET_EXT_TIMEOUT]		= {
-		.len	= sizeof(u64),
-		.align	= __alignof__(u64),
-	},
-	[NFT_SET_EXT_EXPIRATION]	= {
-		.len	= sizeof(u64),
-		.align	= __alignof__(u64),
+		.len	= sizeof(struct nft_timeout),
+		.align	= __alignof__(struct nft_timeout),
 	},
 	[NFT_SET_EXT_USERDATA]		= {
 		.len	= sizeof(struct nft_userdata),
@@ -5818,16 +5814,16 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		         htonl(*nft_set_ext_flags(ext))))
 		goto nla_put_failure;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
-	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
-			 NFTA_SET_ELEM_PAD))
-		goto nla_put_failure;
-
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
 		u64 expires, now = get_jiffies_64();
 
-		expires = READ_ONCE(*nft_set_ext_expiration(ext));
+		if (nft_set_ext_timeout(ext)->timeout != READ_ONCE(set->timeout) &&
+		    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
+				 nf_jiffies64_to_msecs(nft_set_ext_timeout(ext)->timeout),
+				 NFTA_SET_ELEM_PAD))
+			goto nla_put_failure;
+
+		expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
 		if (time_before64(now, expires))
 			expires -= now;
 		else
@@ -6499,13 +6495,14 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 			       nft_set_ext_data(ext), data, set->dlen) < 0)
 		goto err_ext_check;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
-		*nft_set_ext_expiration(ext) = get_jiffies_64() + expiration;
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
+		nft_set_ext_timeout(ext)->timeout = timeout;
+
 		if (expiration == 0)
-			*nft_set_ext_expiration(ext) += timeout;
+			expiration = timeout;
+
+		nft_set_ext_timeout(ext)->expiration = get_jiffies_64() + expiration;
 	}
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT))
-		*nft_set_ext_timeout(ext) = timeout;
 
 	return elem;
 
@@ -7019,15 +7016,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (timeout > 0) {
-		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 		if (err < 0)
 			goto err_parse_key_end;
-
-		if (timeout != set->timeout) {
-			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
-			if (err < 0)
-				goto err_parse_key_end;
-		}
 	}
 
 	if (num_exprs) {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index ca4b52e68295..ed8d692bebe3 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -94,9 +94,9 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
-		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
+		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
 			timeout = priv->timeout ? : READ_ONCE(set->timeout);
-			WRITE_ONCE(*nft_set_ext_expiration(ext), get_jiffies_64() + timeout);
+			WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + timeout);
 		}
 
 		nft_set_elem_update_expr(ext, regs, pkt);
@@ -312,12 +312,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (priv->num_exprs)
 		nft_dynset_ext_add_expr(priv);
 
-	if (set->flags & NFT_SET_TIMEOUT) {
-		if (timeout || READ_ONCE(set->timeout)) {
-			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
-			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
-		}
-	}
+	if (set->flags & NFT_SET_TIMEOUT &&
+	    (timeout || READ_ONCE(set->timeout)))
+		nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
 
 	priv->timeout = timeout;
 
-- 
2.30.2

