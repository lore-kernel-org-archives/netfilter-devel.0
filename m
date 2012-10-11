From: pablo@netfilter.org
Subject: [PATCH 1/1] netfilter: nfnetlink_log: fix NLA_PUT macro removal bug
Date: Thu, 11 Oct 2012 12:09:54 +0200
Message-ID: <1349950194-12422-2-git-send-email-pablo@netfilter.org>
References: <1349950194-12422-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333Ab2JKKKI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:10:08 -0400
In-Reply-To: <1349950194-12422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Commit 1db20a52 (nfnetlink_log: Stop using NLA_PUT*().) incorrectly
converted a NLA_PUT_BE16 macro to nla_put_be32() in nfnetlink_log:

-               NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
+               if (nla_put_be32(inst->skb, NFULA_HWTYPE, htons(skb->dev->type))

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 169ab59..592091c1 100644
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
1.7.10.4

