Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA92440C
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 01:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608952; cv=none; b=LcSSIynErZ9Ht3DJL8/458milp2nqz0eME2xMqPIV8hBS+GJQzByy+DFOq9jU0avRYMWWJO7NhRwWwWhojHu11fFgK4SjWbLiBU95iaqFm5UiI9Zd7sS8Z7ANRTgKYVF4+VcDr3asvxtUs0tgRdb6BZSvJy9Z/JNF8lXfUw80d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608952; c=relaxed/simple;
	bh=7MvVDQH2xo5HxHeQTPaYFrM7TrYbSG69wRDsXLIGO7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5fc5fWWo33ZmzEEwdVZKBz7gZYDRxqUPI8OkP0CxsLgthOAJMG8uFLSOzebceYQvjBIRxkOSNvnJ56raWfSmKPb0cvSQ7eH1kbrXM7IUKhg4VBX4fWiBZRSq8vsfHpNPaZaM0EgYX4uEioxgGDvvD1Xbynu+I1RLCO3yY6Xlvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sz49V-0006yR-8J; Fri, 11 Oct 2024 03:09:09 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 4/5] netfilter: nf_tables: switch trans_elem to real flex array
Date: Fri, 11 Oct 2024 02:33:02 +0200
Message-ID: <20241011003315.5017-5-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241011003315.5017-1-fw@strlen.de>
References: <20241011003315.5017-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When queueing a set element add or removal operation to the transaction
log, check if the previous operation already asks for a the identical
operation on the same set.

If so, store the element reference in the preeeding operation.
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
---
 net/netfilter/nf_tables_api.c | 79 ++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a6bb8eafdcd4..acd574986647 100644
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
2.45.2

