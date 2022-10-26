Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0CBC38A2D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Oct 2022 07:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiJZH4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbiJZH4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2022 03:56:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AD128E72F
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Oct 2022 00:56:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf 2/2] netfilter: nf_tables: release flow rule object from commit path
Date:   Wed, 26 Oct 2022 09:56:13 +0200
Message-Id: <20221026075613.2560-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026075613.2560-1-pablo@netfilter.org>
References: <20221026075613.2560-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to postpone this to the commit release path, since no packets
are walking over this object, this is accessed from control plane only.
This helped uncovered UAF triggered by races with the netlink notifier.

Fixes: 9dd732e0bdf5 ("netfilter: nf_tables: memleak flow rule from commit path")
Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2197118aa7b0..76bd4d03dbda 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8465,9 +8465,6 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
-		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
-			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
-
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
@@ -8973,6 +8970,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_rule_expr_deactivate(&trans->ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_COMMIT);
+
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
 			nft_clear(net, nft_trans_set(trans));
-- 
2.30.2

