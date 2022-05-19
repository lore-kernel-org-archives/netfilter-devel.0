Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF25C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 22:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiESWCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 18:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiESWCR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 18:02:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF99FE15D5;
        Thu, 19 May 2022 15:02:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 04/11] netfilter: ctnetlink: fix up for "netfilter: conntrack: remove unconfirmed list"
Date:   Fri, 20 May 2022 00:01:59 +0200
Message-Id: <20220519220206.722153-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

nf_conntrack_netlink.c:1717 warning: 'ctnetlink_dump_one_entry' defined but not used

Fixes: 8a75a2c17410 ("netfilter: conntrack: remove unconfirmed list")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e768f59741a6..722af5e309ba 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1714,6 +1714,7 @@ static int ctnetlink_done_list(struct netlink_callback *cb)
 	return 0;
 }
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 				    struct netlink_callback *cb,
 				    struct nf_conn *ct,
@@ -1754,6 +1755,7 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 
 	return res;
 }
+#endif
 
 static int
 ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
-- 
2.30.2

