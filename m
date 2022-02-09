Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F52BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 13:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiBINgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 08:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiBINgW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 08:36:22 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E2C1C0613C9;
        Wed,  9 Feb 2022 05:36:25 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8D860601CC;
        Wed,  9 Feb 2022 14:36:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/14] netfilter: nfqueue: enable to get skb->priority
Date:   Wed,  9 Feb 2022 14:36:04 +0100
Message-Id: <20220209133616.165104-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

This info could be useful to improve traffic analysis.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h | 1 +
 net/netfilter/nfnetlink_queue.c                | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index aed90c4df0c8..ef7c97f21a15 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -61,6 +61,7 @@ enum nfqnl_attr_type {
 	NFQA_SECCTX,			/* security context string */
 	NFQA_VLAN,			/* nested attribute: packet vlan info */
 	NFQA_L2HDR,			/* full L2 header */
+	NFQA_PRIORITY,			/* skb->priority */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index ea2d9c2a44cf..48d7a59c6482 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -402,6 +402,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 #endif
 		+ nla_total_size(sizeof(u_int32_t))	/* mark */
+		+ nla_total_size(sizeof(u_int32_t))	/* priority */
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
 		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
@@ -559,6 +560,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nla_put_be32(skb, NFQA_MARK, htonl(entskb->mark)))
 		goto nla_put_failure;
 
+	if (entskb->priority &&
+	    nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
+		goto nla_put_failure;
+
 	if (indev && entskb->dev &&
 	    skb_mac_header_was_set(entskb) &&
 	    skb_mac_header_len(entskb) != 0) {
-- 
2.30.2

