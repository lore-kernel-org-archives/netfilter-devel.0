Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3491CD214;
	Fri, 15 Nov 2024 13:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677545; cv=none; b=aAQU2pcnsYyr1j1MuWUKclqmm6i9nQ4YM8ObozZoeDpF2F7eQgAQ4nvYZ6u1zGMYBb0gn0KbH2DTOnWxzBXgt/R6rU4MXiDE2bWqSb+qPHlyCaU8wWuQDMge6IMRVNM22uZQjpDtpiNd6yGlkfaTwgbipNCo3ScLPJRgUMggD5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677545; c=relaxed/simple;
	bh=Sj45/yAP8FW0CXeUrL4Ak6V5Ne0/KjRwcAoPkRGn0rE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BYuTwQlA0Um0lPkUWB3Gv4iiqO7aCJI8xLN0eMxcYOLtCH9QHHMaturIXgUBTeZQjyev2gveU4l51dt5h7bxhhis34FKvm75rOeAlhkHcl9nEh6T6ER3q10CH+9tPtG5tJOxuQk9UMhJKsSb9MctGC7PjO6ne5cBJ1YJxVkFrbo=
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
Subject: [PATCH net-next 06/14] netfilter: nf_tables: switch trans_elem to real flex array
Date: Fri, 15 Nov 2024 14:31:59 +0100
Message-Id: <20241115133207.8907-7-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 90 +++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5b5178841553..679312d71bbe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -26,6 +26,9 @@
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 #define NFT_SET_MAX_ANONLEN 16
 
+/* limit compaction to avoid huge kmalloc/krealloc sizes. */
+#define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
+
 unsigned int nf_tables_net_id __read_mostly;
 
 static LIST_HEAD(nf_tables_expressions);
@@ -391,6 +394,86 @@ static void nf_tables_unregister_hook(struct net *net,
 	return __nf_tables_unregister_hook(net, table, chain, false);
 }
 
+static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a, const struct nft_trans_elem *b)
+{
+	/* NB: the ->bound equality check is defensive, at this time we only merge
+	 * a new nft_trans_elem transaction request with the transaction tail
+	 * element, but a->bound != b->bound would imply a NEWRULE transaction
+	 * is queued in-between.
+	 *
+	 * The set check is mandatory, the NFT_MAX_SET_NELEMS check prevents
+	 * huge krealloc() requests.
+	 */
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
+	/* "cannot happen", at this time userspace element add
+	 * requests always allocate a new transaction element.
+	 *
+	 * This serves as a reminder to adjust the list_add_tail
+	 * logic below in case this ever changes.
+	 */
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
+	/*
+	 * new_trans->nft_trans.list contains garbage, but
+	 * list_add_tail() doesn't care.
+	 */
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
@@ -424,11 +507,18 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
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
2.30.2

