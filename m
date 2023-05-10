Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655BFC77B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 08:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbjEJIqh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 04:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236731AbjEJIqX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 04:46:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87AF06EA7;
        Wed, 10 May 2023 01:46:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/7] netfilter: nf_tables: always release netdev hooks from notifier
Date:   Wed, 10 May 2023 10:33:07 +0200
Message-Id: <20230510083313.152961-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230510083313.152961-1-pablo@netfilter.org>
References: <20230510083313.152961-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

