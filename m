Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A764C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 18:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiKBSrJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 14:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiKBSrI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E3A22FFCB;
        Wed,  2 Nov 2022 11:47:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/7] netfilter: nf_tables: netlink notifier might race to release objects
Date:   Wed,  2 Nov 2022 19:46:53 +0100
Message-Id: <20221102184659.2502-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102184659.2502-1-pablo@netfilter.org>
References: <20221102184659.2502-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit release path is invoked via call_rcu and it runs lockless to
release the objects after rcu grace period. The netlink notifier handler
might win race to remove objects that the transaction context is still
referencing from the commit release path.

Call rcu_barrier() to ensure pending rcu callbacks run to completion
if the list of transactions to be destroyed is not empty.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58d9cbc9ccdc..2197118aa7b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10030,6 +10030,8 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	nft_net = nft_pernet(net);
 	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
+	if (!list_empty(&nf_tables_destroy_list))
+		rcu_barrier();
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
-- 
2.30.2

