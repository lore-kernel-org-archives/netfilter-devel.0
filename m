Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC27C77B7A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 12:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjFFMI6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 08:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjFFMI5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 08:08:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9EAE7E
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 05:08:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1q6VUc-0006QQ-6c; Tue, 06 Jun 2023 14:08:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: permit update of set size
Date:   Tue,  6 Jun 2023 14:08:49 +0200
Message-Id: <20230606120849.12582-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that set->nelems is always updated permit update of the sets max size.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 3 +++
 net/netfilter/nf_tables_api.c     | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2e24ea1d744c..89b1ac4e6d4a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1589,6 +1589,7 @@ struct nft_trans_set {
 	u64				timeout;
 	bool				update;
 	bool				bound;
+	u32				size;
 };
 
 #define nft_trans_set(trans)	\
@@ -1603,6 +1604,8 @@ struct nft_trans_set {
 	(((struct nft_trans_set *)trans->data)->timeout)
 #define nft_trans_set_gc_int(trans)	\
 	(((struct nft_trans_set *)trans->data)->gc_int)
+#define nft_trans_set_size(trans)	\
+	(((struct nft_trans_set *)trans->data)->size)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0396fd8f4e71..dfd441ff1e3e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -483,6 +483,7 @@ static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 		nft_trans_set_update(trans) = true;
 		nft_trans_set_gc_int(trans) = desc->gc_int;
 		nft_trans_set_timeout(trans) = desc->timeout;
+		nft_trans_set_size(trans) = desc->size;
 	}
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
@@ -9428,6 +9429,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 				WRITE_ONCE(set->timeout, nft_trans_set_timeout(trans));
 				WRITE_ONCE(set->gc_int, nft_trans_set_gc_int(trans));
+
+				if (nft_trans_set_size(trans))
+					WRITE_ONCE(set->size, nft_trans_set_size(trans));
 			} else {
 				nft_clear(net, nft_trans_set(trans));
 				/* This avoids hitting -EBUSY when deleting the table
-- 
2.39.3

