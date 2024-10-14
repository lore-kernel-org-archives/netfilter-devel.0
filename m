Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471661A4F1F;
	Mon, 14 Oct 2024 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904473; cv=none; b=Atcqu2cu1iByNjnKVqzkt7CqxwnF3zzUPnCIwRqMBqqrG64dQ4ciSqEjvNzlcHixeYcwW0LymTZg2U5U8dGtCGs6Q1Hvqphc7pMu+aWRZAMjJZpGBC1KeWgS8MVyoCWLQkJp7iZdoKCygAwXfNc/sUTnSVJOPQSLb3y6GtfKEeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904473; c=relaxed/simple;
	bh=bpChPdYewTAdlUJaEePXt4iQ+u8PdPuLKC8FPjqUDks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PaYG9b29TQkw7GAaNvAwLhaO7rpbNSyedsKTkFYBhNMrxXErw/Ef8qzrajZ43ROGY6FrKcYAkXVXW5H/nUeQP7PKvOSFHk4cXciRNqzvGHbGnQY/RgQvCIdNH4UuIffHb9wZE6W8H7cJQSKRU+lsoF1VW+jXnfamik2OO2iYQa8=
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
Subject: [PATCH net-next 7/9] netfilter: nf_tables: allocate element update information dynamically
Date: Mon, 14 Oct 2024 13:14:18 +0200
Message-Id: <20241014111420.29127-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241014111420.29127-1-pablo@netfilter.org>
References: <20241014111420.29127-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Move the timeout/expire/flag members from nft_trans_one_elem struct into
a dybamically allocated structure, only needed when timeout update was
requested.

This halves size of nft_trans_one_elem struct and allows to compact up to
124 elements in one transaction container rather than 62.

This halves memory requirements for a large flush or insert transaction,
where ->update remains NULL.

Care has to be taken to release the extra data in all spots, including
abort path.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 10 +++--
 net/netfilter/nf_tables_api.c     | 61 ++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2a2631edab2b..1caf142900fe 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1754,11 +1754,15 @@ enum nft_trans_elem_flags {
 	NFT_TRANS_UPD_EXPIRATION	= (1 << 1),
 };
 
-struct nft_trans_one_elem {
-	struct nft_elem_priv		*priv;
+struct nft_elem_update {
 	u64				timeout;
 	u64				expiration;
-	u8				update_flags;
+	u8				flags;
+};
+
+struct nft_trans_one_elem {
+	struct nft_elem_priv		*priv;
+	struct nft_elem_update		*update;
 };
 
 struct nft_trans_elem {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aa2e7c91f0cb..91a7b13b49ae 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6665,7 +6665,8 @@ static void nft_trans_set_elem_destroy(const struct nft_ctx *ctx, struct nft_tra
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
-		if (te->elems[i].update_flags)
+		/* skip update request, see nft_trans_elems_new_abort() */
+		if (!te->elems[i].priv)
 			continue;
 
 		__nft_set_elem_destroy(ctx, te->set, te->elems[i].priv, true);
@@ -6856,24 +6857,28 @@ static void nft_trans_elem_update(const struct nft_set *set,
 				  const struct nft_trans_one_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_elem_update *update = elem->update;
 
-	if (elem->update_flags & NFT_TRANS_UPD_TIMEOUT)
-		WRITE_ONCE(nft_set_ext_timeout(ext)->timeout, elem->timeout);
+	if (update->flags & NFT_TRANS_UPD_TIMEOUT)
+		WRITE_ONCE(nft_set_ext_timeout(ext)->timeout, update->timeout);
 
-	if (elem->update_flags & NFT_TRANS_UPD_EXPIRATION)
-		WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + elem->expiration);
+	if (update->flags & NFT_TRANS_UPD_EXPIRATION)
+		WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + update->expiration);
 }
 
 static void nft_trans_elems_activate(const struct nft_ctx *ctx,
-				     const struct nft_trans_elem *te)
+				     struct nft_trans_elem *te)
 {
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
-		const struct nft_trans_one_elem *elem = &te->elems[i];
+		struct nft_trans_one_elem *elem = &te->elems[i];
 
-		if (elem->update_flags) {
+		if (elem->update) {
 			nft_trans_elem_update(te->set, elem);
+			kfree(elem->update);
+			elem->update = NULL;
+			elem->priv = NULL;
 			continue;
 		}
 
@@ -6971,6 +6976,8 @@ static void nft_trans_elems_remove(const struct nft_ctx *ctx,
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
+		WARN_ON_ONCE(te->elems[i].update);
+
 		nf_tables_setelem_notify(ctx, te->set,
 					 te->elems[i].priv,
 					 te->nft_trans.msg_type);
@@ -7019,7 +7026,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
-	u8 update_flags;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7334,26 +7340,32 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			else if (!(nlmsg_flags & NLM_F_EXCL)) {
 				err = 0;
 				if (nft_set_ext_exists(ext2, NFT_SET_EXT_TIMEOUT)) {
-					struct nft_trans_one_elem *update;
-
-					update = &nft_trans_container_elem(trans)->elems[0];
+					struct nft_elem_update update = { };
 
-					update_flags = 0;
 					if (timeout != nft_set_ext_timeout(ext2)->timeout) {
-						update->timeout = timeout;
+						update.timeout = timeout;
 						if (expiration == 0)
 							expiration = timeout;
 
-						update_flags |= NFT_TRANS_UPD_TIMEOUT;
+						update.flags |= NFT_TRANS_UPD_TIMEOUT;
 					}
 					if (expiration) {
-						update->expiration = expiration;
-						update_flags |= NFT_TRANS_UPD_EXPIRATION;
+						update.expiration = expiration;
+						update.flags |= NFT_TRANS_UPD_EXPIRATION;
 					}
 
-					if (update_flags) {
-						update->priv = elem_priv;
-						update->update_flags = update_flags;
+					if (update.flags) {
+						struct nft_trans_one_elem *ue;
+
+						ue = &nft_trans_container_elem(trans)->elems[0];
+
+						ue->update = kmemdup(&update, sizeof(update), GFP_KERNEL);
+						if (!ue->update) {
+							err = -ENOMEM;
+							goto err_element_clash;
+						}
+
+						ue->priv = elem_priv;
 						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 						goto err_elem_free;
 					}
@@ -7521,14 +7533,19 @@ void nft_setelem_data_deactivate(const struct net *net,
  * Returns true if set had been added to (i.e., elements need to be removed again).
  */
 static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
-				      const struct nft_trans_elem *te)
+				      struct nft_trans_elem *te)
 {
 	bool removed = false;
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
-		if (te->elems[i].update_flags)
+		if (te->elems[i].update) {
+			kfree(te->elems[i].update);
+			te->elems[i].update = NULL;
+			/* Update request, so do not release this element */
+			te->elems[i].priv = NULL;
 			continue;
+		}
 
 		if (!te->set->ops->abort || nft_setelem_is_catchall(te->set, te->elems[i].priv))
 			nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
-- 
2.30.2

