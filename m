Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD9EC3F2D7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 20:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AFFA2173E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 20:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCBU7B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 15:59:01 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59282 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgCBU7A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 15:59:00 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j8s9S-0000av-WA; Mon, 02 Mar 2020 21:58:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: free flowtable hooks on hook register error
Date:   Mon,  2 Mar 2020 21:58:50 +0100
Message-Id: <20200302205850.29365-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
need to be freed.

We can't change the goto label to 'goto 5' -- while it does fix the memleak
it does cause a warning splat from the netfilter core (the hooks were not
registered).

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Reported-by: syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d1318bdf49ca..bb064aa4154b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6300,8 +6300,13 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		goto err4;
 
 	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
-	if (err < 0)
+	if (err < 0) {
+		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+			list_del_rcu(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
 		goto err4;
+	}
 
 	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)
-- 
2.24.1

