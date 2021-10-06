Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3096C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Oct 2021 14:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDAD6610A5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Oct 2021 14:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhJFOWe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Oct 2021 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238226AbhJFOWe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Oct 2021 10:22:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB85CC061749
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Oct 2021 07:20:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mY7mh-0002Hy-Ps; Wed, 06 Oct 2021 16:20:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>,
        syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nftables: skip netdev events generated on netns removal
Date:   Wed,  6 Oct 2021 16:20:34 +0200
Message-Id: <20211006142034.10362-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <0000000000008ce91e05bf9f62bc@google.com>
References: <0000000000008ce91e05bf9f62bc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reported following (harmless) WARN:

 WARNING: CPU: 1 PID: 2648 at net/netfilter/core.c:468
  nft_netdev_unregister_hooks net/netfilter/nf_tables_api.c:230 [inline]
  nf_tables_unregister_hook include/net/netfilter/nf_tables.h:1090 [inline]
  __nft_release_basechain+0x138/0x640 net/netfilter/nf_tables_api.c:9524
  nft_netdev_event net/netfilter/nft_chain_filter.c:351 [inline]
  nf_tables_netdev_event+0x521/0x8a0 net/netfilter/nft_chain_filter.c:382

reproducer:
unshare -n bash -c 'ip link add br0 type bridge; nft add table netdev t ; \
 nft add chain netdev t ingress \{ type filter hook ingress device "br0" \
 priority 0\; policy drop\; \}'

Problem is that when netns device exit hooks create the UNREGISTER
event, the .pre_exit hook for nf_tables core has already removed the
base hook.  Notifier attempts to do this again.

The need to do base hook unregister unconditionally was needed in the past,
because notifier was last stage where reg->dev dereference was safe.

Now that nf_tables does the hook removal in .pre_exit, this isn't
needed anymore.

Reported-and-tested-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
Fixes: 767d1216bff825 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_chain_filter.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 5b02408a920b..3ced0eb6b7c3 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -342,12 +342,6 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		return;
 	}
 
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
 	__nft_release_basechain(ctx);
 }
 
@@ -366,6 +360,9 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
+	if (!check_net(ctx.net))
+		return NOTIFY_DONE;
+
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-- 
2.32.0

