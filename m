Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133E1917E6
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001616; cv=none; b=hl7dc4cx4OG87IJFBWKS0HYCBXc1BvcIJCYqc9wcA0ds/skWCzy81b0torliNKIGjfMTGiy1/wxz/EVCWi49ymdjBelGNVMQqs7+aRez5/00vTpgvoyb0tzLVtGy4Se8uVTITVJ6EhXCxDsUgNqb8kmpO5Iko9ANt1RHikzJ2Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001616; c=relaxed/simple;
	bh=4+D/k0RRFfGXkqubqv/Ps5txX1e04O6idE8Uaz3xCa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mg4hw7vgTMEr68QSfiF6Ty9GHuCLIlwO/9Zv6gtbZtlFcmIOwXYbGYPVg3eA4Y0KXIiFWS7Aj/FceAdeXvHyE0NJwQfO9yD6XLfzOxGgJDJhgANvcZt+PA7ZxFFOygWqjMJnF+3tl209pLQhX5ovnkAZE4dpAhm74YG3miwEm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t96aq-0007LZ-TP; Thu, 07 Nov 2024 18:46:52 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 4/5] netfilter: nf_tables: switch trans_elem to real flex array
Date: Thu,  7 Nov 2024 18:44:08 +0100
Message-ID: <20241107174415.4690-5-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241107174415.4690-1-fw@strlen.de>
References: <20241107174415.4690-1-fw@strlen.de>
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

If so, store the element reference in the preceding operation.
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
 net/netfilter/nf_tables_api.c | 71 +++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bdf5ba21c76d..e96e538fe2eb 100644
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
 
-- 
2.45.2

