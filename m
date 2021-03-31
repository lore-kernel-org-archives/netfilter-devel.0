Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42AEC43460
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B40A2610A5
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbhCaUKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbhCaUKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:10:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B88C061762
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 13:10:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRhAa-00059O-B7; Wed, 31 Mar 2021 22:10:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 01/11] netfilter: nfnetlink: add and use nfnetlink_broadcast
Date:   Wed, 31 Mar 2021 22:10:04 +0200
Message-Id: <20210331201014.23293-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210331201014.23293-1-fw@strlen.de>
References: <20210331201014.23293-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This removes the only reference of net->nfnl outside of the nfnetlink
module.  This allows to move net->nfnl to net_generic infra.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nfnetlink.h | 2 ++
 net/netfilter/nfnetlink.c           | 7 +++++++
 net/netfilter/nfnetlink_acct.c      | 3 +--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 791d516e1e88..d4c14257db5d 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -51,6 +51,8 @@ int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags);
 int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error);
 int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid);
+void nfnetlink_broadcast(struct net *net, struct sk_buff *skb, __u32 portid,
+			 __u32 group, gfp_t allocation);
 
 static inline u16 nfnl_msg_type(u8 subsys, u8 msg_type)
 {
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index d3df66a39b5e..06e106b3ed85 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -178,6 +178,13 @@ int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 
+void nfnetlink_broadcast(struct net *net, struct sk_buff *skb, __u32 portid,
+			 __u32 group, gfp_t allocation)
+{
+	netlink_broadcast(net->nfnl, skb, portid, group, allocation);
+}
+EXPORT_SYMBOL_GPL(nfnetlink_broadcast);
+
 /* Process one complete nfnetlink message. */
 static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index bb930f3b06c7..6895f31c5fbb 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -469,8 +469,7 @@ static void nfnl_overquota_report(struct net *net, struct nf_acct *nfacct)
 		kfree_skb(skb);
 		return;
 	}
-	netlink_broadcast(net->nfnl, skb, 0, NFNLGRP_ACCT_QUOTA,
-			  GFP_ATOMIC);
+	nfnetlink_broadcast(net, skb, 0, NFNLGRP_ACCT_QUOTA, GFP_ATOMIC);
 }
 
 int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct)
-- 
2.26.3

