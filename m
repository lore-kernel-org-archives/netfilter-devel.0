Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3FEEE4993
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 15:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjHWP1a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 11:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbjHWP13 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 11:27:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012CCE6D;
        Wed, 23 Aug 2023 08:27:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qYplU-0001jn-36; Wed, 23 Aug 2023 17:27:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net 2/6] netfilter: nf_tables: flush pending destroy work before netlink notifier
Date:   Wed, 23 Aug 2023 17:26:50 +0200
Message-ID: <20230823152711.15279-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230823152711.15279-1-fw@strlen.de>
References: <20230823152711.15279-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Destroy work waits for the RCU grace period then it releases the objects
with no mutex held. All releases objects follow this path for
transactions, therefore, order is guaranteed and references to top-level
objects in the hierarchy remain valid.

However, netlink notifier might interfer with pending destroy work.
rcu_barrier() is not correct because objects are not release via RCU
callback. Flush destroy work before releasing objects from netlink
notifier path.

Fixes: d4bc8271db21 ("netfilter: nf_tables: netlink notifier might race to release objects")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a76a62ebe9c9..d299e7aa1b96 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11073,7 +11073,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	gc_seq = nft_gc_seq_begin(nft_net);
 
 	if (!list_empty(&nf_tables_destroy_list))
-		rcu_barrier();
+		nf_tables_trans_destroy_flush_work();
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
-- 
2.41.0

