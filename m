Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6E1CD4846
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 16:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjIVQnr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbjIVQni (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 12:43:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18B60CE7;
        Fri, 22 Sep 2023 09:43:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.15 14/17] netfilter: nft_set_pipapo: call nft_trans_gc_queue_sync() in catchall GC
Date:   Fri, 22 Sep 2023 18:43:10 +0200
Message-Id: <20230922164313.151564-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230922164313.151564-1-pablo@netfilter.org>
References: <20230922164313.151564-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit 4a9e12ea7e70223555ec010bec9f711089ce96f6 upstream.

pipapo needs to enqueue GC transactions for catchall elements through
nft_trans_gc_queue_sync(). Add nft_trans_gc_catchall_sync() and
nft_trans_gc_catchall_async() to handle GC transaction queueing
accordingly.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 +++--
 net/netfilter/nf_tables_api.c     | 22 +++++++++++++++++++---
 net/netfilter/nft_set_hash.c      |  2 +-
 net/netfilter/nft_set_pipapo.c    |  2 +-
 net/netfilter/nft_set_rbtree.c    |  2 +-
 5 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index af703d295f0c..d543078c43f9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1623,8 +1623,9 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans);
 
 void nft_trans_gc_elem_add(struct nft_trans_gc *gc, void *priv);
 
-struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
-					   unsigned int gc_seq);
+struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
+						 unsigned int gc_seq);
+struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
 
 void nft_setelem_data_deactivate(const struct net *net,
 				 const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ac266dc2c31b..58fec8806ec5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9027,8 +9027,9 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 	call_rcu(&trans->rcu, nft_trans_gc_trans_free);
 }
 
-struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
-					   unsigned int gc_seq)
+static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
+						  unsigned int gc_seq,
+						  bool sync)
 {
 	struct nft_set_elem_catchall *catchall;
 	const struct nft_set *set = gc->set;
@@ -9044,7 +9045,11 @@ struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 
 		nft_set_elem_dead(ext);
 dead_elem:
-		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
+		if (sync)
+			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
+		else
+			gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
+
 		if (!gc)
 			return NULL;
 
@@ -9054,6 +9059,17 @@ struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 	return gc;
 }
 
+struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
+						 unsigned int gc_seq)
+{
+	return nft_trans_gc_catchall(gc, gc_seq, false);
+}
+
+struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
+{
+	return nft_trans_gc_catchall(gc, 0, true);
+}
+
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 524763659f25..eca20dc60138 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -372,7 +372,7 @@ static void nft_rhash_gc(struct work_struct *work)
 		nft_trans_gc_elem_add(gc, he);
 	}
 
-	gc = nft_trans_gc_catchall(gc, gc_seq);
+	gc = nft_trans_gc_catchall_async(gc, gc_seq);
 
 try_later:
 	/* catchall list iteration requires rcu read side lock. */
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 58bd514260b9..7248a1737ee1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1611,7 +1611,7 @@ static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
 		}
 	}
 
-	gc = nft_trans_gc_catchall(gc, 0);
+	gc = nft_trans_gc_catchall_sync(gc);
 	if (gc) {
 		nft_trans_gc_queue_sync_done(gc);
 		priv->last_gc = jiffies;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 70491ba98dec..487572dcd614 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -669,7 +669,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 		nft_trans_gc_elem_add(gc, rbe);
 	}
 
-	gc = nft_trans_gc_catchall(gc, gc_seq);
+	gc = nft_trans_gc_catchall_async(gc, gc_seq);
 
 try_later:
 	read_unlock_bh(&priv->lock);
-- 
2.30.2

