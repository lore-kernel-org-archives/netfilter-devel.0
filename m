Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085A120C008
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089123; cv=none; b=WNnleQT2JZE2/2yzYLDhvYSWsZJVaEDJZQ9dqVtE9XDhAl7rmmPSWezf88beNW7iYoUK2yP5kp6LIgwRiIhhDUidY1zj2mGeo1yXwcy9JPR2vfJcU0UgovkdyyN7oJicmnSWSaha+07a08r6V53N+hxS4LXaaRnSJQq0G4FvpPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089123; c=relaxed/simple;
	bh=1czqXAOmH5x1JD75X5X+F+XqgU/kwa9rKBLONGeMuvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgiC/lHubkHzenCej7IgM3nTcQ2l4jUgt7UPCazA9gEF7P4XAbvhRg2tDU7D35UO0EOo+R8rjpzRRF7kzenaaXmL29Oir/WV7f17r32wu7bgx7XGJEjYhF3ZSt7InuPjKR9KruYlK3Lmg3mMVTDvsBYFKQs2dQxvty1mSW/vEr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t154C-0002BT-DQ; Wed, 16 Oct 2024 16:32:00 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 5/5] netfilter: nf_tables: allocate element update information dynamically
Date: Wed, 16 Oct 2024 15:19:12 +0200
Message-ID: <20241016131917.17193-6-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241016131917.17193-1-fw@strlen.de>
References: <20241016131917.17193-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 v3: adjust for changes in earlier patch, nft_trans_elems_add() can
 now kfree() the update pointer unconditionally.

 include/net/netfilter/nf_tables.h | 10 ++++--
 net/netfilter/nf_tables_api.c     | 57 +++++++++++++++++++------------
 2 files changed, 43 insertions(+), 24 deletions(-)

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
index 5e038051c112..8662df68b03f 100644
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
@@ -6856,12 +6857,13 @@ static void nft_trans_elem_update(const struct nft_set *set,
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
 
 static void nft_trans_elems_add(const struct nft_ctx *ctx,
@@ -6870,15 +6872,16 @@ static void nft_trans_elems_add(const struct nft_ctx *ctx,
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
-		const struct nft_trans_one_elem *elem = &te->elems[i];
+		struct nft_trans_one_elem *elem = &te->elems[i];
 
-		if (elem->update_flags)
+		if (elem->update)
 			nft_trans_elem_update(te->set, elem);
 		else
 			nft_setelem_activate(ctx->net, te->set, elem->priv);
 
 		nf_tables_setelem_notify(ctx, te->set, elem->priv,
 					 NFT_MSG_NEWSETELEM);
+		kfree(elem->update);
 	}
 }
 
@@ -6970,6 +6973,8 @@ static void nft_trans_elems_remove(const struct nft_ctx *ctx,
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
+		WARN_ON_ONCE(te->elems[i].update);
+
 		nf_tables_setelem_notify(ctx, te->set,
 					 te->elems[i].priv,
 					 te->nft_trans.msg_type);
@@ -7018,7 +7023,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
-	u8 update_flags;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7333,26 +7337,32 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -7520,14 +7530,19 @@ void nft_setelem_data_deactivate(const struct net *net,
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
2.45.2

