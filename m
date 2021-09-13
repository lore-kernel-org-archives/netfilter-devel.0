Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E2CC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ED8360FBF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbhIMMn4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhIMMnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E09C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mPlIE-00078V-8G; Mon, 13 Sep 2021 14:42:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>,
        syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: unlink table before deleting it
Date:   Mon, 13 Sep 2021 14:42:33 +0200
Message-Id: <20210913124233.16520-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <000000000000a3958805cbdb8102@google.com>
References: <000000000000a3958805cbdb8102@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reports following UAF:
BUG: KASAN: use-after-free in memcmp+0x18f/0x1c0 lib/string.c:955
 nla_strcmp+0xf2/0x130 lib/nlattr.c:836
 nft_table_lookup.part.0+0x1a2/0x460 net/netfilter/nf_tables_api.c:570
 nft_table_lookup net/netfilter/nf_tables_api.c:4064 [inline]
 nf_tables_getset+0x1b3/0x860 net/netfilter/nf_tables_api.c:4064
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504

Problem is that all get operations are lockless, so the commit_mutex
held by nft_rcv_nl_event() isn't enough to stop a parallel GET request
from doing read-accesses to the table object even after synchronize_rcu().

To avoid this, unlink the table first and store the table objects in
on-stack scratch space.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Reported-and-tested-by: syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: Can't repro locally, syzbot-tested only.

 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..33e771cd847c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9599,7 +9599,6 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		table->use--;
 		nf_tables_chain_destroy(&ctx);
 	}
-	list_del(&table->list);
 	nf_tables_table_destroy(&ctx);
 }
 
@@ -9612,6 +9611,8 @@ static void __nft_release_tables(struct net *net)
 		if (nft_table_has_owner(table))
 			continue;
 
+		list_del(&table->list);
+
 		__nft_release_table(net, table);
 	}
 }
@@ -9619,31 +9620,38 @@ static void __nft_release_tables(struct net *net)
 static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
+	struct nft_table *table, *to_delete[8];
 	struct nftables_pernet *nft_net;
 	struct netlink_notify *n = ptr;
-	struct nft_table *table, *nt;
 	struct net *net = n->net;
-	bool release = false;
+	unsigned int deleted;
+	bool restart = false;
 
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(net);
+	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
+again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
 			__nft_release_hook(net, table);
-			release = true;
+			list_del_rcu(&table->list);
+			to_delete[deleted++] = table;
+			if (deleted >= ARRAY_SIZE(to_delete))
+				break;
 		}
 	}
-	if (release) {
+	if (deleted) {
+		restart = deleted >= ARRAY_SIZE(to_delete);
 		synchronize_rcu();
-		list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
-			if (nft_table_has_owner(table) &&
-			    n->portid == table->nlpid)
-				__nft_release_table(net, table);
-		}
+		while (deleted)
+			__nft_release_table(net, to_delete[--deleted]);
+
+		if (restart)
+			goto again;
 	}
 	mutex_unlock(&nft_net->commit_mutex);
 
-- 
2.32.0

