Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70045C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 12:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5823C61353
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 12:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhKSMgT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 07:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhKSMgS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 07:36:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28572C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 04:33:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo34s-0004eV-Aa; Fri, 19 Nov 2021 13:33:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_queue: remove leftover synchronize_rcu
Date:   Fri, 19 Nov 2021 13:33:09 +0100
Message-Id: <20211119123309.22041-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its no longer needed after commit 870299707436
("netfilter: nf_queue: move hookfn registration out of struct net").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 4acc4b8e9fe5..b61165e97252 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1527,15 +1527,9 @@ static void __net_exit nfnl_queue_net_exit(struct net *net)
 		WARN_ON_ONCE(!hlist_empty(&q->instance_table[i]));
 }
 
-static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
-{
-	synchronize_rcu();
-}
-
 static struct pernet_operations nfnl_queue_net_ops = {
 	.init		= nfnl_queue_net_init,
 	.exit		= nfnl_queue_net_exit,
-	.exit_batch	= nfnl_queue_net_exit_batch,
 	.id		= &nfnl_queue_net_id,
 	.size		= sizeof(struct nfnl_queue_net),
 };
-- 
2.32.0

