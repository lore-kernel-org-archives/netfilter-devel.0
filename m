Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB06C77B7C
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 May 2023 12:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjEDMU5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 May 2023 08:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjEDMU4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2023 08:20:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE4365B0
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2023 05:20:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1puXwg-00062R-Gt; Thu, 04 May 2023 14:20:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: always release netdev hooks from notifier
Date:   Thu,  4 May 2023 14:20:21 +0200
Message-Id: <20230504122021.21058-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts "netfilter: nf_tables: skip netdev events generated on netns removal".

The problem is that when a veth device is released, the veth release
callback will also queue the peer netns device for removal.

Its possible that the peer netns is also slated for removal.  In this
case, the device memory is already released before the pre_exit hook of
the peer netns runs:

BUG: KASAN: slab-use-after-free in nf_hook_entry_head+0x1b8/0x1d0
Read of size 8 at addr ffff88812c0124f0 by task kworker/u8:1/45
Workqueue: netns cleanup_net
Call Trace:
 nf_hook_entry_head+0x1b8/0x1d0
 __nf_unregister_net_hook+0x76/0x510
 nft_netdev_unregister_hooks+0xa0/0x220
 __nft_release_hook+0x184/0x490
 nf_tables_pre_exit_net+0x12f/0x1b0
 ..

Order is:
1. First netns is released, veth_dellink() queues peer netns device
   for removal
2. peer netns is queued for removal
3. peer netns device is released, unreg event is triggered
4. unreg event is ignored because netns is going down
5. pre_exit hook calls nft_netdev_unregister_hooks but device memory
   might be free'd already.

Fixes: 68a3765c659f ("netfilter: nf_tables: skip netdev events generated on netns removal")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_chain_filter.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index c3563f0be269..680fe557686e 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -344,6 +344,12 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		return;
 	}
 
+	/* UNREGISTER events are also happening on netns exit.
+	 *
+	 * Although nf_tables core releases all tables/chains, only this event
+	 * handler provides guarantee that hook->ops.dev is still accessible,
+	 * so we cannot skip exiting net namespaces.
+	 */
 	__nft_release_basechain(ctx);
 }
 
@@ -362,9 +368,6 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-	if (!check_net(ctx.net))
-		return NOTIFY_DONE;
-
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-- 
2.39.2

