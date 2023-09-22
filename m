Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95007CD484A
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 16:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjIVQno (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjIVQni (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 12:43:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14BE4CE1;
        Fri, 22 Sep 2023 09:43:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.15 11/17] netfilter: nf_tables: defer gc run if previous batch is still pending
Date:   Fri, 22 Sep 2023 18:43:07 +0200
Message-Id: <20230922164313.151564-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230922164313.151564-1-pablo@netfilter.org>
References: <20230922164313.151564-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 8e51830e29e12670b4c10df070a4ea4c9593e961 upstream.

Don't queue more gc work, else we may queue the same elements multiple
times.

If an element is flagged as dead, this can mean that either the previous
gc request was invalidated/discarded by a transaction or that the previous
request is still pending in the system work queue.

The latter will happen if the gc interval is set to a very low value,
e.g. 1ms, and system work queue is backlogged.

The sets refcount is 1 if no previous gc requeusts are queued, so add
a helper for this and skip gc run if old requests are pending.

Add a helper for this and skip the gc run in this case.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nft_set_hash.c      | 3 +++
 net/netfilter/nft_set_rbtree.c    | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a0c854e9dc6..af703d295f0c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -551,6 +551,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
+static inline bool nft_set_gc_is_pending(const struct nft_set *s)
+{
+	return refcount_read(&s->refs) != 1;
+}
+
 static inline struct nft_set *nft_set_container_of(const void *priv)
 {
 	return (void *)priv - offsetof(struct nft_set, data);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index cef5df846000..524763659f25 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -326,6 +326,9 @@ static void nft_rhash_gc(struct work_struct *work)
 	nft_net = nft_pernet(net);
 	gc_seq = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index f9d4c8fcbbf8..c6435e709231 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -611,6 +611,9 @@ static void nft_rbtree_gc(struct work_struct *work)
 	nft_net = nft_pernet(net);
 	gc_seq  = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;
-- 
2.30.2

