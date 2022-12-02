Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C64C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Dec 2022 08:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiLBIgH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Dec 2022 03:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiLBIfm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2022 03:35:42 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2B771759A;
        Fri,  2 Dec 2022 00:34:10 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 96A9E1E80D27;
        Fri,  2 Dec 2022 16:30:06 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tHXrPYcJdepW; Fri,  2 Dec 2022 16:30:03 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 204621E80CCF;
        Fri,  2 Dec 2022 16:30:03 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] netfilter: nfnetlink: check 'skb->dev' pointer in nfulnl_log_packet()
Date:   Fri,  2 Dec 2022 16:33:04 +0800
Message-Id: <20221202083304.9005-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'skb->dev' may be NULL, it should be better to check it.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 net/netfilter/nfnetlink_log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d97eb280cb2e..74ac9fa40137 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -572,7 +572,7 @@ __build_packet_message(struct nfnl_log_net *log,
 		}
 	}
 
-	if (indev && skb_mac_header_was_set(skb)) {
+	if (indev && skb->dev && skb_mac_header_was_set(skb)) {
 		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
 		    nla_put_be16(inst->skb, NFULA_HWLEN,
 				 htons(skb->dev->hard_header_len)))
@@ -724,7 +724,7 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
 		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
-	if (in && skb_mac_header_was_set(skb)) {
+	if (in && skb->dev && skb_mac_header_was_set(skb)) {
 		size += nla_total_size(skb->dev->hard_header_len)
 			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
 			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
-- 
2.11.0

