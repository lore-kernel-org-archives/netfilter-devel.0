Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD893F44C1;
	Mon, 17 Aug 2026 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009416; cv=none; b=m1uYKJNfRX5/kmpJOzBaCop0I8/wQaqxe+B/5FuXh/8wZIMsEtlSWyNp1X8rlNVFV4CnasFdtTd89chTGr2vI/6ppRF6Qg/6GTfxbk7zJfBkd0WcMsH0mtiqLMBYncVOnNdJjHDEQ7fverOkpFgV/sXSfhOocIfsRxVQCu3mTt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009416; c=relaxed/simple;
	bh=03fynwDrmu7rjMs9+flZQ/1OOhWUC7vFhD+jHV1nKQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFKkfXeGqDNaQ6F13BgyaMzeZf2i8uDDHLp4bPeBuXywUKuLSFPE0N9Zvf1qk4xJFCmXulwrOD9SSqxYJVjT3ZBSkpg83XbB1mR0UJgYKlQrUdXH/URJGuRP3TRr+DkzKwD8fDtZbQAOUtGF7/kxUo4zW7OCsBUZP4Pqm6YjRag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=elQBGz5e; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="elQBGz5e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009412;
	bh=27PYV21ltCPhfRWH2vzF+yvioOWOJYKxCTJzpiXz36s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elQBGz5ehIBlaQQB5CADvY7AN/Xqw/C9NpXF6l206sX10Sl4IA7vd6e/hAcn72vxm
	 xtAlZruCDr5Re5YEIUBSOYXosUv3LLinHCCj1YC81Vvq71umGLylQBrz+Gaxk4e1eQ
	 HFZnhEIb9DFjYLSYsjy1qr493morTlO3wU5XIV4aLU8PaSzsSXd2wmo25bEKkbn201
	 7tLPZZjAjjZR3mnFf7ckUbteubNWwRZfQRwRB5hx5khift1hba0xuC3n5EFewZeVYw
	 O11ObA4X+/GgsOym7Ly0TzsqbWznmLReOeB+3OMofsSYvDWwlB6GdhVP+Ru78fVXtx
	 vZRlX4RnFBfLA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8093D60091;
	Tue, 18 Aug 2026 01:30:11 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 6/8] netfilter: nf_tables: move set_update_list to nftables per-netns
Date: Tue, 18 Aug 2026 01:29:55 +0200
Message-ID: <20260817232957.1281637-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This list is used to invoke the set .commit and .abort ops for the
rbtree and pipapo to run GC on expired elements and replace the current
datastructure view by the clone. For the rbtree, this also rebuild the
datapath b-search array.

From abort path, remove the set from the update_list if it is already
bound to rule, then the rule itself takes care of releasing the set and
its elements, otherwise, memleak is possible because set ops .abort
only deals with removing the set data structure, not the elements.

This is a preparation patch to call set .commit before processing the
transaction list for the rbtree, no functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 49 ++++++++++---------------------
 2 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3be612145c13..238f6ecb90e9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1949,6 +1949,7 @@ struct nftables_pernet {
 	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
+	struct list_head	set_update_list;
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	u64			tstamp;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3a7c8f7a6304..b51ba77b5151 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -595,10 +595,15 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_trans_elem *te;
 
 	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
 		     trans->msg_type != NFT_MSG_DELSETELEM);
 
+	te = nft_trans_container_elem(trans);
+	if (te->set->ops->commit && list_empty(&te->set->pending_update))
+		list_add_tail(&te->set->pending_update, &nft_net->set_update_list);
+
 	if (nft_trans_try_collapse(nft_net, trans)) {
 		kfree(trans);
 		return;
@@ -10858,11 +10863,11 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
 	}
 }
 
-static void nft_set_commit_update(struct list_head *set_update_list)
+static void nft_set_commit_update(struct nftables_pernet *nft_net)
 {
 	struct nft_set *set, *next;
 
-	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
+	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
 
 		if (!set->ops->commit || set->dead)
@@ -10895,7 +10900,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_binding *trans_binding;
 	struct nft_trans *trans, *next;
 	unsigned int base_seq, gc_seq;
-	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
@@ -11101,27 +11105,13 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWSETELEM:
 			te = nft_trans_container_elem(trans);
-
 			nft_trans_elems_add(&ctx, te);
-
-			if (te->set->ops->commit &&
-			    list_empty(&te->set->pending_update)) {
-				list_add_tail(&te->set->pending_update,
-					      &set_update_list);
-			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
-
 			nft_trans_elems_remove(&ctx, te);
-
-			if (te->set->ops->commit &&
-			    list_empty(&te->set->pending_update)) {
-				list_add_tail(&te->set->pending_update,
-					      &set_update_list);
-			}
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
@@ -11190,7 +11180,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	nft_set_commit_update(&set_update_list);
+	nft_set_commit_update(nft_net);
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
@@ -11257,11 +11247,11 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static void nft_set_abort_update(struct list_head *set_update_list)
+static void nft_set_abort_update(struct nftables_pernet *nft_net)
 {
 	struct nft_set *set, *next;
 
-	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
+	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
 
 		if (!set->ops->abort)
@@ -11396,33 +11386,22 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
+			te = nft_trans_container_elem(trans);
 			if (nft_trans_elem_set_bound(trans)) {
+				list_del_init(&te->set->pending_update);
 				nft_trans_destroy(trans);
 				break;
 			}
-			te = nft_trans_container_elem(trans);
 			if (!nft_trans_elems_new_abort(&ctx, te)) {
 				nft_trans_destroy(trans);
 				break;
 			}
-
-			if (te->set->ops->abort &&
-			    list_empty(&te->set->pending_update)) {
-				list_add_tail(&te->set->pending_update,
-					      &set_update_list);
-			}
 			break;
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
 
 			nft_trans_elems_destroy_abort(&ctx, te);
-
-			if (te->set->ops->abort &&
-			    list_empty(&te->set->pending_update)) {
-				list_add_tail(&te->set->pending_update,
-					      &set_update_list);
-			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWOBJ:
@@ -11468,7 +11447,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_set_list));
 
-	nft_set_abort_update(&set_update_list);
+	nft_set_abort_update(nft_net);
 
 	synchronize_rcu();
 
@@ -12152,6 +12131,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
+	INIT_LIST_HEAD(&nft_net->set_update_list);
 	mutex_init(&nft_net->commit_mutex);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
@@ -12196,6 +12176,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->set_update_list));
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)
-- 
2.47.3

