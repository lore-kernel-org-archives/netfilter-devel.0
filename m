Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A1FC38A2D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Oct 2022 21:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiJXVTs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Oct 2022 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiJXVT0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2022 17:19:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0767C2A977
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Oct 2022 12:25:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1omxXr-0001Kw-77; Mon, 24 Oct 2022 15:31:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: avoid access to free'd chain info in nft_commit_release
Date:   Mon, 24 Oct 2022 14:31:04 +0100
Message-Id: <20221024133104.77813-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot found following KASAN splat:
  use-after-free in nft_commit_release net/netfilter/nf_tables_api.c:8467 [inline]

This is the ctx.chain-> deref:
 case NFT_MSG_DELRULE:
   if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)

in nft_commit_release.  That function runs asynchonously after the
commit mutex has been released.

In the syzbot case, chain has already been released from netdev
notifier chain:

 kfree+0xe2/0x580 mm/slub.c:4567
 nf_tables_chain_destroy+0x4ec/0x640 net/netfilter/nf_tables_api.c:1889
 __nft_release_table+0x96c/0xcd0 net/netfilter/nf_tables_api.c:9996
 nft_rcv_nl_event+0x3f6/0x5b0 net/netfilter/nf_tables_api.c:10047
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87

Fix this by stashing the "is offloaded" information
in the transaction object while we're still in the
transaction mutex protected code and then use it in the
async part.

Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Fixes: 9dd732e0bdf5 ("netfilter: nf_tables: memleak flow rule from commit path")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 3 +++
 net/netfilter/nf_tables_api.c     | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cdb7db9b0e25..b65d9880cab0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1539,6 +1539,7 @@ struct nft_trans_rule {
 	struct nft_rule			*rule;
 	struct nft_flow_rule		*flow;
 	u32				rule_id;
+	bool				chain_hw_offloaded;
 };
 
 #define nft_trans_rule(trans)	\
@@ -1547,6 +1548,8 @@ struct nft_trans_rule {
 	(((struct nft_trans_rule *)trans->data)->flow)
 #define nft_trans_rule_id(trans)	\
 	(((struct nft_trans_rule *)trans->data)->rule_id)
+#define nft_trans_rule_chain_hw_offloaded(trans)	\
+	(((struct nft_trans_rule *)trans->data)->chain_hw_offloaded)
 
 struct nft_trans_set {
 	struct nft_set			*set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58d9cbc9ccdc..92a03ae0256f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8465,7 +8465,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
-		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+		if (nft_trans_rule_chain_hw_offloaded(trans))
 			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -8966,6 +8966,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELRULE:
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_trans_rule_chain_hw_offloaded(trans) = true;
 			list_del_rcu(&nft_trans_rule(trans)->list);
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
-- 
2.37.3

