From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] netfilter: nfnetlink_log: fix NLA_PUT macro removal bug
Date: Sun, 19 Aug 2012 22:16:08 +0200
Message-ID: <1345407370-30009-2-git-send-email-kaber@trash.net>
References: <1345407370-30009-1-git-send-email-kaber@trash.net>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32829 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2HSUQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Aug 2012 16:16:12 -0400
In-Reply-To: <1345407370-30009-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 1db20a52 (nfnetlink_log: Stop using NLA_PUT*().) incorrectly
converted a NLA_PUT_BE16 macro to nla_put_be32() in nfnetlink_log:

-               NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
+               if (nla_put_be32(inst->skb, NFULA_HWTYPE, htons(skb->dev->type))

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 169ab59..592091c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -480,7 +480,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 	}
 
 	if (indev && skb_mac_header_was_set(skb)) {
-		if (nla_put_be32(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
+		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
 		    nla_put_be16(inst->skb, NFULA_HWLEN,
 				 htons(skb->dev->hard_header_len)) ||
 		    nla_put(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
-- 
1.7.1

