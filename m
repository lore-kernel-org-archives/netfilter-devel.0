Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FF21A2875;
	Mon, 14 Oct 2024 11:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904472; cv=none; b=sWeg/VHJS71mxpOsGDB4UF9YTTy1ja3odL983sNXCfzcY91CgzMcXezyI8ipEwpogq3L0m+T62AQPTCutBRxcNEj81aqshizmEwF9CQ6LxqFv+wIX29vhDxpfOK2ZEVdOZGvgs8PAipz7+hfPKPRnXHxK4+Bca1lG2+T261BXpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904472; c=relaxed/simple;
	bh=CZiddXZ4+QmeIlJrfjZH00yryHl8xDhlDvXMgLh6glY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KpKs2o336EVxc5hJKtW51LCFAndteyUYohOCs6ThvaqOGigDybF+MqfwFexUMflpy/FXNVR9jaivsI98yScIS9mNosvtFlYUfjMMdXRnXkSb84THfqHCjjrlE6w8YbBEVUtohTHvzc5VgykyXAiv7O/RaRnhkn8bbk25OPUBYaU=
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
Subject: [PATCH net-next 6/9] netfilter: nf_tables: switch trans_elem to real flex array
Date: Mon, 14 Oct 2024 13:14:17 +0200
Message-Id: <20241014111420.29127-7-pablo@netfilter.org>
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

When queueing a set element add or removal operation to the transaction
log, check if the previous operation already asks for a the identical
operation on the same set.

If so, store the element reference in the preceeding operation.
This significantlty reduces memory consumption when many set add/delete
operations appear in a single transaction.

Example: 10k elements require 937kb of memory (10k allocations from
kmalloc-96 slab).

Assuming we can compact 4 elements in the same set, 468 kbytes
are needed (64 bytes for base struct, nft_trans_elemn, 32 bytes
for nft_trans_one_elem structure, so 2500 allocations from kmalloc-192
slab).

For large batch updates we can compact up to 62 elements
into one single nft_trans_elem structure (~65% mem reduction):
(64 bytes for base struct, nft_trans_elem, 32 byte for nft_trans_one_elem
 struct).

We can halve size of nft_trans_one_elem struct by moving
timeout/expire/update_flags into a dynamically allocated structure,
this allows to store 124 elements in a 2k slab nft_trans_elem struct.
This is done in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 79 ++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 11247e149f17..aa2e7c91f0cb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -25,6 +25,7 @@
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 #define NFT_SET_MAX_ANONLEN 16
+#define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
 
 unsigned int nf_tables_net_id __read_mostly;
 
@@ -391,6 +392,69 @@ static void nf_tables_unregister_hook(struct net *net,
 	return __nf_tables_unregister_hook(net, table, chain, false);
 }
 
+static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a, const struct nft_trans_elem *b)
+{
+	return a->set == b->set && a->bound == b->bound && a->nelems < NFT_MAX_SET_NELEMS;
+}
+
+static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
+					struct nft_trans_elem *tail,
+					struct nft_trans_elem *trans,
+					gfp_t gfp)
+{
+	unsigned int nelems, old_nelems = tail->nelems;
+	struct nft_trans_elem *new_trans;
+
+	if (!nft_trans_collapse_set_elem_allowed(tail, trans))
+		return false;
+
+	if (WARN_ON_ONCE(trans->nelems != 1))
+		return false;
+
+	if (check_add_overflow(old_nelems, trans->nelems, &nelems))
+		return false;
+
+	/* krealloc might free tail which invalidates list pointers */
+	list_del_init(&tail->nft_trans.list);
+
+	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
+	if (!new_trans) {
+		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
+		return false;
+	}
+
+	INIT_LIST_HEAD(&new_trans->nft_trans.list);
+	new_trans->nelems = nelems;
+	new_trans->elems[old_nelems] = trans->elems[0];
+	list_add_tail(&new_trans->nft_trans.list, &nft_net->commit_list);
+
+	return true;
+}
+
+static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
+				   struct nft_trans *trans, gfp_t gfp)
+{
+	struct nft_trans *tail;
+
+	if (list_empty(&nft_net->commit_list))
+		return false;
+
+	tail = list_last_entry(&nft_net->commit_list, struct nft_trans, list);
+
+	if (tail->msg_type != trans->msg_type)
+		return false;
+
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWSETELEM:
+	case NFT_MSG_DELSETELEM:
+		return nft_trans_collapse_set_elem(nft_net,
+						   nft_trans_container_elem(tail),
+						   nft_trans_container_elem(trans), gfp);
+	}
+
+	return false;
+}
+
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -424,11 +488,18 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
 					   gfp_t gfp)
 {
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
 	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
 	             trans->msg_type != NFT_MSG_DELSETELEM);
 
 	might_alloc(gfp);
 
+	if (nft_trans_try_collapse(nft_net, trans, gfp)) {
+		kfree(trans);
+		return;
+	}
+
 	nft_trans_commit_list_add_tail(net, trans);
 }
 
@@ -6424,13 +6495,17 @@ static struct nft_trans *nft_trans_elem_alloc(const struct nft_ctx *ctx,
 					      int msg_type,
 					      struct nft_set *set)
 {
+	struct nft_trans_elem *te;
 	struct nft_trans *trans;
 
-	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_elem));
+	trans = nft_trans_alloc(ctx, msg_type, struct_size(te, elems, 1));
 	if (trans == NULL)
 		return NULL;
 
-	nft_trans_elem_set(trans) = set;
+	te = nft_trans_container_elem(trans);
+	te->nelems = 1;
+	te->set = set;
+
 	return trans;
 }
 
-- 
2.30.2

