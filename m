Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795D21CDA2E;
	Fri, 15 Nov 2024 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677545; cv=none; b=q25V+0x8Dn7Ob/7YucUNEH3AVB6SsykeTQon5ijzet7f0Rp/d5lcuseimlRf6wXjJ9HbwQDNqq1hRTPiXlebfbHWJgDt6Jp1vb7v3wFIgQSgwz0GxRnXgOt0L7DhPLIOymbHGTnwZQg73o3gsYeuTNFjPYevP7XP+xl68Ed8t0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677545; c=relaxed/simple;
	bh=S+clLxb7batkMC5APhbL5tvEfocFJ8gukUdUlSC4Q5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EpeFl250BBM3bjpWefwek0J7cz9wvw3zNTNVmDGLx/JOD0fKL4U/TZ++nc6fzAmJ8czfvAFYCb1epfH58MBdsIoGeTlgM4O/8DRNU7EKvfHloQC1fiu4PG5jG6pnCs+NKZ4j7SadFyZVrQ5+UmtkeIZITt6AhdLThM4Jv1cWo8k=
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
Subject: [PATCH net-next 07/14] netfilter: nf_tables: allocate element update information dynamically
Date: Fri, 15 Nov 2024 14:32:00 +0100
Message-Id: <20241115133207.8907-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_tables.h | 10 ++++--
 net/netfilter/nf_tables_api.c     | 57 +++++++++++++++++++------------
 2 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 37af0b174c39..80a537ac26cd 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1759,11 +1759,15 @@ enum nft_trans_elem_flags {
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
index 679312d71bbe..21b6f7410a1f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6706,7 +6706,8 @@ static void nft_trans_set_elem_destroy(const struct nft_ctx *ctx, struct nft_tra
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
-		if (te->elems[i].update_flags)
+		/* skip update request, see nft_trans_elems_new_abort() */
+		if (!te->elems[i].priv)
 			continue;
 
 		__nft_set_elem_destroy(ctx, te->set, te->elems[i].priv, true);
@@ -6897,12 +6898,13 @@ static void nft_trans_elem_update(const struct nft_set *set,
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
@@ -6911,15 +6913,16 @@ static void nft_trans_elems_add(const struct nft_ctx *ctx,
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
 
@@ -7011,6 +7014,8 @@ static void nft_trans_elems_remove(const struct nft_ctx *ctx,
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
+		WARN_ON_ONCE(te->elems[i].update);
+
 		nf_tables_setelem_notify(ctx, te->set,
 					 te->elems[i].priv,
 					 te->nft_trans.msg_type);
@@ -7059,7 +7064,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
-	u8 update_flags;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7374,26 +7378,32 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -7561,14 +7571,19 @@ void nft_setelem_data_deactivate(const struct net *net,
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

