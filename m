Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F1EC77B73
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 22:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjDTWf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 18:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbjDTWf4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 18:35:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01E7D2100
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 15:35:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v6 3/7] netfilter: nf_tables: rename function to destroy hook list
Date:   Fri, 21 Apr 2023 00:34:30 +0200
Message-Id: <20230420223434.256393-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230420223434.256393-1-pablo@netfilter.org>
References: <20230420223434.256393-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename nft_flowtable_hooks_destroy() by nft_hooks_destroy() to prepare
for netdev chain device updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: no changes

 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a47f94e377ac..e2bf9c0b03d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7779,7 +7779,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
-static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
+static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 
@@ -7960,7 +7960,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
-		nft_flowtable_hooks_destroy(&flowtable->hook_list);
+		nft_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
 
@@ -8794,7 +8794,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -9447,7 +9447,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
-- 
2.30.2

