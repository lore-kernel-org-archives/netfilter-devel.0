Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD76C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71F3611ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhDZBPD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:15:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49714 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhDZBPD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Apr 2021 21:15:03 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C78463E34
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:13:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/4] netfilter: nftables: rename set element data activation/deactivation functions
Date:   Mon, 26 Apr 2021 03:14:15 +0200
Message-Id: <20210426011418.69330-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename:

- nft_set_elem_activate() to nft_set_elem_data_activate().
- nft_set_elem_deactivate() to nft_set_elem_data_deactivate().

To prepare for updates in the set element infrastructure to add support
for the special catch-all element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1050f23c0d29..d66be7d8f3e5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5263,8 +5263,8 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
-/* Only called from commit path, nft_set_elem_deactivate() already deals with
- * the refcounting from the preparation phase.
+/* Only called from commit path, nft_setelem_data_deactivate() already deals
+ * with the refcounting from the preparation phase.
  */
 static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 				       const struct nft_set *set, void *elem)
@@ -5733,9 +5733,9 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 	}
 }
 
-static void nft_set_elem_activate(const struct net *net,
-				  const struct nft_set *set,
-				  struct nft_set_elem *elem)
+static void nft_setelem_data_activate(const struct net *net,
+				      const struct nft_set *set,
+				      struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -5745,9 +5745,9 @@ static void nft_set_elem_activate(const struct net *net,
 		(*nft_set_ext_obj(ext))->use++;
 }
 
-static void nft_set_elem_deactivate(const struct net *net,
-				    const struct nft_set *set,
-				    struct nft_set_elem *elem)
+static void nft_setelem_data_deactivate(const struct net *net,
+					const struct nft_set *set,
+					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -5824,7 +5824,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(elem.priv);
 	elem.priv = priv;
 
-	nft_set_elem_deactivate(ctx->net, set, &elem);
+	nft_setelem_data_deactivate(ctx->net, set, &elem);
 
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -5858,7 +5858,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	}
 	set->ndeact++;
 
-	nft_set_elem_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -8479,7 +8479,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_set_elem_activate(net, te->set, &te->elem);
+			nft_setelem_data_activate(net, te->set, &te->elem);
 			te->set->ops->activate(net, te->set, &te->elem);
 			te->set->ndeact--;
 
-- 
2.30.2

