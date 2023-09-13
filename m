Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A853FEE0213
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 21:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjIMV6R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjIMV6Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 17:58:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91A1F173A;
        Wed, 13 Sep 2023 14:58:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/9] netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
Date:   Wed, 13 Sep 2023 23:57:53 +0200
Message-Id: <20230913215800.107269-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230913215800.107269-1-pablo@netfilter.org>
References: <20230913215800.107269-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

rbtree GC does not modify the datastructure, instead it collects expired
elements and it enqueues a GC transaction. Use a read spinlock instead
to avoid data contention while GC worker is running.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index f250b5399344..70491ba98dec 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -622,8 +622,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 	if (!gc)
 		goto done;
 
-	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
+	read_lock_bh(&priv->lock);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 
 		/* Ruleset has been updated, try later. */
@@ -673,8 +672,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 	gc = nft_trans_gc_catchall(gc, gc_seq);
 
 try_later:
-	write_seqcount_end(&priv->count);
-	write_unlock_bh(&priv->lock);
+	read_unlock_bh(&priv->lock);
 
 	if (gc)
 		nft_trans_gc_queue_async_done(gc);
-- 
2.30.2

