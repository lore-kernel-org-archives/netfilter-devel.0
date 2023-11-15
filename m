Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D00C54FB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 18:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjKOSp3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 13:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjKOSp2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 13:45:28 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75A0710CE;
        Wed, 15 Nov 2023 10:45:23 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 6/6] netfilter: nf_tables: split async and sync catchall in two functions
Date:   Wed, 15 Nov 2023 19:45:14 +0100
Message-Id: <20231115184514.8965-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231115184514.8965-1-pablo@netfilter.org>
References: <20231115184514.8965-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

list_for_each_entry_safe() does not work for the async case which runs
under RCU, therefore, split GC logic for catchall in two functions
instead, one for each of the sync and async GC variants.

The catchall sync GC variant never sees a _DEAD bit set on ever, thus,
this handling is removed in such case, moreover, allocate GC sync batch
via GFP_KERNEL.

Fixes: 93995bf4af2c ("netfilter: nf_tables: remove catchall element in GC sync path")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 55 +++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index debea1c67701..c0a42989b982 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9680,16 +9680,14 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 	call_rcu(&trans->rcu, nft_trans_gc_trans_free);
 }
 
-static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
-						  unsigned int gc_seq,
-						  bool sync)
+struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
+						 unsigned int gc_seq)
 {
-	struct nft_set_elem_catchall *catchall, *next;
+	struct nft_set_elem_catchall *catchall;
 	const struct nft_set *set = gc->set;
-	struct nft_elem_priv *elem_priv;
 	struct nft_set_ext *ext;
 
-	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
 
 		if (!nft_set_elem_expired(ext))
@@ -9699,35 +9697,42 @@ static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 
 		nft_set_elem_dead(ext);
 dead_elem:
-		if (sync)
-			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
-		else
-			gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
-
+		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
 		if (!gc)
 			return NULL;
 
-		elem_priv = catchall->elem;
-		if (sync) {
-			nft_setelem_data_deactivate(gc->net, gc->set, elem_priv);
-			nft_setelem_catchall_destroy(catchall);
-		}
-
-		nft_trans_gc_elem_add(gc, elem_priv);
+		nft_trans_gc_elem_add(gc, catchall->elem);
 	}
 
 	return gc;
 }
 
-struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
-						 unsigned int gc_seq)
-{
-	return nft_trans_gc_catchall(gc, gc_seq, false);
-}
-
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
 {
-	return nft_trans_gc_catchall(gc, 0, true);
+	struct nft_set_elem_catchall *catchall, *next;
+	const struct nft_set *set = gc->set;
+	struct nft_elem_priv *elem_priv;
+	struct nft_set_ext *ext;
+
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(gc->net));
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if (!nft_set_elem_expired(ext))
+			continue;
+
+		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
+		if (!gc)
+			return NULL;
+
+		elem_priv = catchall->elem;
+		nft_setelem_data_deactivate(gc->net, gc->set, elem_priv);
+		nft_setelem_catchall_destroy(catchall);
+		nft_trans_gc_elem_add(gc, elem_priv);
+	}
+
+	return gc;
 }
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
-- 
2.30.2

