Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DC2C61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbjKUMPD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbjKUMPC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:15:02 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E872188;
        Tue, 21 Nov 2023 04:14:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Pec-00056S-3s; Tue, 21 Nov 2023 13:14:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6.y 2/2] netfilter: nf_tables: split async and sync catchall in two functions
Date:   Tue, 21 Nov 2023 13:14:22 +0100
Message-ID: <20231121121431.8612-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121121431.8612-1-fw@strlen.de>
References: <20231121121431.8612-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8837ba3e58ea1e3d09ae36db80b1e80853aada95 ]

list_for_each_entry_safe() does not work for the async case which runs
under RCU, therefore, split GC logic for catchall in two functions
instead, one for each of the sync and async GC variants.

The catchall sync GC variant never sees a _DEAD bit set on ever, thus,
this handling is removed in such case, moreover, allocate GC sync batch
via GFP_KERNEL.

Fixes: 93995bf4af2c ("netfilter: nf_tables: remove catchall element in GC sync path")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 61 ++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d300e9fc5d62..f51876bc0947 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9639,16 +9639,14 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
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
@@ -9658,39 +9656,44 @@ static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 
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
-			struct nft_set_elem elem = {
-				.priv = elem_priv,
-			};
-
-			nft_setelem_data_deactivate(gc->net, gc->set, &elem);
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
+	struct nft_set_elem elem;
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
+		memset(&elem, 0, sizeof(elem));
+		elem.priv = catchall->elem;
+
+		nft_setelem_data_deactivate(gc->net, gc->set, &elem);
+		nft_setelem_catchall_destroy(catchall);
+		nft_trans_gc_elem_add(gc, elem.priv);
+	}
+
+	return gc;
 }
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
-- 
2.41.0

