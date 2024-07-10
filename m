Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3A816938C
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720602334; cv=none; b=feq74EYYcJdL635wSMDNvNDxQw3DvAr0Ql01c7/tgiyEOkcq+40/rSZvyEmdnnZT809nVDQD4m4jfefsAeszHA8ncu/w4Zx5xtHCyLVFJNqXvCZhOumcBhKbj0kZ3gUeKBhDl2rsf59IiyT/6OfQldRvi9O6TY8Fo+HLXJGSXuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720602334; c=relaxed/simple;
	bh=+DVRWZ3fYS4t3mHCEbgsWDYFZkEzEKASO78/eJc2Z8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F9FbL9CElmAQSZZWRmU0pjQ4SAWaCbSv9nGxNB1ACxuSZy4kXB4Yl4ejfP4I3blnohdtSPRREd5GTElJ6O2jBCKOmyuUHlfgJQqgMTnV/wyrF+eaeGusfDt3Ea6EXRJLAvOUsdzJtXwWh8vqIY27Cl6W/NXMCeJmxUYqw0ttc4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sRTGM-00038S-Aw; Wed, 10 Jul 2024 11:05:22 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: [PATCH nf-next] netfilter: nf_tables: store new sets in dedicated list
Date: Wed, 10 Jul 2024 10:58:29 +0200
Message-ID: <20240710085835.1957-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_set_lookup_byid() is very slow when transaction becomes large, due to
walk of the transaction list.

Add a dedicated list that contains only the new sets.

Before: nft -f ruleset 0.07s user 0.00s system 0% cpu 1:04.84 total
After: nft -f ruleset 0.07s user 0.00s system 0% cpu 30.115 total

.. where ruleset contains ~10 sets with ~100k elements.
The above number is for a combined flush+reload of the ruleset.

With previous flush, even the first NEWELEM has to walk through a few
hundred thousands of DELSET(ELEM) transactions before the first NEWSET
object. To cope with random-order-newset-newsetelem we'd need to replace
commit_set_list with a hashtable.

Expectation is that a NEWELEM operation refers to the most recently added
set, so last entry of the dedicated list should be the set we want.

NB: This is not a bug fix per se (functionality is fine), but with
larger transaction batches list search takes forever, so it would be
nice to speed this up for -stable too, hence adding a "fixes" tag.

Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Reported-by: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 29 ++++++++++++++++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1bfdd16890fa..2be4738eae1c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1674,6 +1674,7 @@ struct nft_trans_rule {
 
 struct nft_trans_set {
 	struct nft_trans_binding	nft_trans_binding;
+	struct list_head		list_trans_newset;
 	struct nft_set			*set;
 	u32				set_id;
 	u32				gc_int;
@@ -1875,6 +1876,7 @@ static inline int nft_request_module(struct net *net, const char *fmt, ...) { re
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	commit_set_list;
 	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 70d0bad029fd..b0d030b83c5a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -393,6 +393,7 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans_binding *binding;
+	struct nft_trans_set *trans_set;
 
 	list_add_tail(&trans->list, &nft_net->commit_list);
 
@@ -402,9 +403,13 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWSET:
+		trans_set = nft_trans_container_set(trans);
+
 		if (!nft_trans_set_update(trans) &&
 		    nft_set_is_anonymous(nft_trans_set(trans)))
 			list_add_tail(&binding->binding_list, &nft_net->binding_list);
+
+		list_add_tail(&trans_set->list_trans_newset, &nft_net->commit_set_list);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (!nft_trans_chain_update(trans) &&
@@ -611,6 +616,7 @@ static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 
 	trans_set = nft_trans_container_set(trans);
 	INIT_LIST_HEAD(&trans_set->nft_trans_binding.binding_list);
+	INIT_LIST_HEAD(&trans_set->list_trans_newset);
 
 	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
 		nft_trans_set_id(trans) =
@@ -4473,17 +4479,16 @@ static struct nft_set *nft_set_lookup_byid(const struct net *net,
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	u32 id = ntohl(nla_get_be32(nla));
-	struct nft_trans *trans;
+	struct nft_trans_set *trans;
 
-	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		if (trans->msg_type == NFT_MSG_NEWSET) {
-			struct nft_set *set = nft_trans_set(trans);
+	/* its likely the id we need is at the tail, not at start */
+	list_for_each_entry_reverse(trans, &nft_net->commit_set_list, list_trans_newset) {
+		struct nft_set *set = trans->set;
 
-			if (id == nft_trans_set_id(trans) &&
-			    set->table == table &&
-			    nft_active_genmask(set, genmask))
-				return set;
-		}
+		if (id == trans->set_id &&
+		    set->table == table &&
+		    nft_active_genmask(set, genmask))
+			return set;
 	}
 	return ERR_PTR(-ENOENT);
 }
@@ -10378,6 +10383,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
+			list_del(&nft_trans_container_set(trans)->list_trans_newset);
 			if (nft_trans_set_update(trans)) {
 				struct nft_set *set = nft_trans_set(trans);
 
@@ -10686,6 +10692,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
+			list_del(&nft_trans_container_set(trans)->list_trans_newset);
 			if (nft_trans_set_update(trans)) {
 				nft_trans_destroy(trans);
 				break;
@@ -10781,6 +10788,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		}
 	}
 
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_set_list));
+
 	nft_set_abort_update(&set_update_list);
 
 	synchronize_rcu();
@@ -11595,6 +11604,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->commit_set_list);
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
@@ -11625,6 +11635,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	gc_seq = nft_gc_seq_begin(nft_net);
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_set_list));
 
 	if (!list_empty(&nft_net->module_list))
 		nf_tables_module_autoload_cleanup(net);
-- 
2.44.2

