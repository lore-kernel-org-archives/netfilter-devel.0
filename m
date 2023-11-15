Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282B8C54FB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 18:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjKOSpY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 13:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjKOSpY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 13:45:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DBE9D53;
        Wed, 15 Nov 2023 10:45:20 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 1/6] netfilter: nft_set_rbtree: Remove unused variable nft_net
Date:   Wed, 15 Nov 2023 19:45:09 +0100
Message-Id: <20231115184514.8965-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231115184514.8965-1-pablo@netfilter.org>
References: <20231115184514.8965-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

The code that uses nft_net has been removed, and the nft_pernet function
is merely obtaining a reference to shared data through the net pointer.
The content of the net pointer is not modified or changed, so both of
them should be removed.

silence the warning:
net/netfilter/nft_set_rbtree.c:627:26: warning: variable ‘nft_net’ set but not used

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7103
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 6f1186abd47b..baa3fea4fe65 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -624,14 +624,12 @@ static void nft_rbtree_gc(struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe, *rbe_end = NULL;
-	struct nftables_pernet *nft_net;
 	struct rb_node *node, *next;
 	struct nft_trans_gc *gc;
 	struct net *net;
 
 	set  = nft_set_container_of(priv);
 	net  = read_pnet(&set->net);
-	nft_net = nft_pernet(net);
 
 	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
 	if (!gc)
-- 
2.30.2

