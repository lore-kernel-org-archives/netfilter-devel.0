Return-Path: <SRS0=S2pA=AZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B98C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 16:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1203D2242B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 16:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGNQvs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgGNQvs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 12:51:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD23C061755
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2020 09:51:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jvO9i-0001Jl-7K; Tue, 14 Jul 2020 18:51:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com,
        syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: fix nat hook table deletion
Date:   Tue, 14 Jul 2020 18:51:39 +0200
Message-Id: <20200714165139.14385-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sybot came up with following transaction:
 add table ip syz0
 add chain ip syz0 syz2 { type nat hook prerouting priority 0; policy accept; }
 add table ip syz0 { flags dormant; }
 delete chain ip syz0 syz2
 delete table ip syz0

which yields:
hook not found, pf 2 num 0
WARNING: CPU: 0 PID: 6775 at net/netfilter/core.c:413 __nf_unregister_net_hook+0x3e6/0x4a0 net/netfilter/core.c:413
[..]
 nft_unregister_basechain_hooks net/netfilter/nf_tables_api.c:206 [inline]
 nft_table_disable net/netfilter/nf_tables_api.c:835 [inline]
 nf_tables_table_disable net/netfilter/nf_tables_api.c:868 [inline]
 nf_tables_commit+0x32d3/0x4d70 net/netfilter/nf_tables_api.c:7550
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:486 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:544 [inline]
 nfnetlink_rcv+0x14a5/0x1e50 net/netfilter/nfnetlink.c:562
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]

Problem is that when I added ability to override base hook registration
to make nat basechains register with the nat core instead of netfilter
core, I forgot to update nft_table_disable() to use that instead of
the 'raw' hook register interface.

In syzbot transaction, the basechain is of 'nat' type. Its registered
with the nat core.  The switch to 'dormant mode' attempts to delete from
netfilter core instead.

After updating nft_table_disable/enable to use the correct helper,
nft_(un)register_basechain_hooks can be folded into the only remaining
caller.

Because nft_trans_table_enable() won't do anything when the DORMANT flag
is set, remove the flag first, then re-add it in case re-enablement
fails, else this patch breaks sequence:

add table ip x { flags dormant; }
/* add base chains */
add table ip x

The last 'add' will remove the dormant flags, but won't have any other
effect -- base chains are not registered.
Then, next 'set dormant flag' will create another 'hook not found'
splat.

Reported-by: syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com
Fixes: 4e25ceb80b58 ("netfilter: nf_tables: allow chain type to override hook register")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 41 ++++++++++++-----------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7647ecfa0d40..88325b264737 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -188,24 +188,6 @@ static void nft_netdev_unregister_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 }
 
-static int nft_register_basechain_hooks(struct net *net, int family,
-					struct nft_base_chain *basechain)
-{
-	if (family == NFPROTO_NETDEV)
-		return nft_netdev_register_hooks(net, &basechain->hook_list);
-
-	return nf_register_net_hook(net, &basechain->ops);
-}
-
-static void nft_unregister_basechain_hooks(struct net *net, int family,
-					   struct nft_base_chain *basechain)
-{
-	if (family == NFPROTO_NETDEV)
-		nft_netdev_unregister_hooks(net, &basechain->hook_list);
-	else
-		nf_unregister_net_hook(net, &basechain->ops);
-}
-
 static int nf_tables_register_hook(struct net *net,
 				   const struct nft_table *table,
 				   struct nft_chain *chain)
@@ -223,7 +205,10 @@ static int nf_tables_register_hook(struct net *net,
 	if (basechain->type->ops_register)
 		return basechain->type->ops_register(net, ops);
 
-	return nft_register_basechain_hooks(net, table->family, basechain);
+	if (table->family == NFPROTO_NETDEV)
+		return nft_netdev_register_hooks(net, &basechain->hook_list);
+
+	return nf_register_net_hook(net, &basechain->ops);
 }
 
 static void nf_tables_unregister_hook(struct net *net,
@@ -242,7 +227,10 @@ static void nf_tables_unregister_hook(struct net *net,
 	if (basechain->type->ops_unregister)
 		return basechain->type->ops_unregister(net, ops);
 
-	nft_unregister_basechain_hooks(net, table->family, basechain);
+	if (table->family == NFPROTO_NETDEV)
+		nft_netdev_unregister_hooks(net, &basechain->hook_list);
+	else
+		nf_unregister_net_hook(net, &basechain->ops);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -832,8 +820,7 @@ static void nft_table_disable(struct net *net, struct nft_table *table, u32 cnt)
 		if (cnt && i++ == cnt)
 			break;
 
-		nft_unregister_basechain_hooks(net, table->family,
-					       nft_base_chain(chain));
+		nf_tables_unregister_hook(net, table, chain);
 	}
 }
 
@@ -848,8 +835,7 @@ static int nf_tables_table_enable(struct net *net, struct nft_table *table)
 		if (!nft_is_base_chain(chain))
 			continue;
 
-		err = nft_register_basechain_hooks(net, table->family,
-						   nft_base_chain(chain));
+		err = nf_tables_register_hook(net, table, chain);
 		if (err < 0)
 			goto err_register_hooks;
 
@@ -894,11 +880,12 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		nft_trans_table_enable(trans) = false;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
+		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 		ret = nf_tables_table_enable(ctx->net, ctx->table);
-		if (ret >= 0) {
-			ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
+		if (ret >= 0)
 			nft_trans_table_enable(trans) = true;
-		}
+		else
+			ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	}
 	if (ret < 0)
 		goto err;
-- 
2.26.2

