Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC64C7EE29
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Jun 2023 12:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjFIMBr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Jun 2023 08:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjFIMBp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Jun 2023 08:01:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15B85198C
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Jun 2023 05:01:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 3/3] netfilter: nf_tables: disallow unbound chain from commit step
Date:   Fri,  9 Jun 2023 14:01:37 +0200
Message-Id: <20230609120137.66297-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230609120137.66297-1-pablo@netfilter.org>
References: <20230609120137.66297-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out if userspace creates a chain binding which remains unbound
after this transaction.

Use list of pending objects, which is already used by pending
anonymous set which are not yet bound to rule.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 1 +
 net/netfilter/nf_tables_api.c     | 8 ++++++++
 net/netfilter/nft_immediate.c     | 1 +
 3 files changed, 10 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d24146b526a1..161913fc098b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1085,6 +1085,7 @@ struct nft_chain {
 	struct nft_rule_blob		__rcu *blob_gen_0;
 	struct nft_rule_blob		__rcu *blob_gen_1;
 	struct list_head		rules;
+	struct list_head		pending_list;
 	struct list_head		list;
 	struct rhlist_head		rhlhead;
 	struct nft_table		*table;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 11beb6750531..f7917f678719 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2370,6 +2370,12 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
+	if (nft_chain_binding(chain)) {
+		struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+
+		list_add_tail(&chain->pending_list, &nft_net->pending_list);
+	}
+
 	table->use++;
 
 	return 0;
@@ -9694,6 +9700,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				if (nft_chain_is_bound(trans->ctx.chain)) {
 					nft_trans_destroy(trans);
 					break;
+				} else if (nft_chain_binding(trans->ctx.chain)) {
+					list_del(&trans->ctx.chain->pending_list);
 				}
 				trans->ctx.table->use--;
 				nft_chain_del(trans->ctx.chain);
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 054243b9b89e..929879d1c048 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -82,6 +82,7 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 					goto err1;
 				}
 				chain->bound = true;
+				list_del(&chain->pending_list);
 			}
 			break;
 		default:
-- 
2.30.2

