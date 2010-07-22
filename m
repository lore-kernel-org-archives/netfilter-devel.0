From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: nfnetlink_log: Fix potential problem if skb->dev is null
Date: Thu, 22 Jul 2010 14:09:33 +0200
Message-ID: <1279800573-10679-1-git-send-email-eric@inl.fr>
References: <20100722115053.GF17585@bicker>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: Dan Carpenter <error27@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59090 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab0GVMJq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:09:46 -0400
In-Reply-To: <20100722115053.GF17585@bicker>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a potentiel problem pointed out by Dan Carpenter
using smatch: skb->dev is used but there is no test on nullity
of pointer. It may not express as if mac header is filled we can
think that the dev is also set.
---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6a1572b..b5617c2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -468,7 +468,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 		}
 	}
 
-	if (indev && skb_mac_header_was_set(skb)) {
+	if (indev && skb->dev && skb_mac_header_was_set(skb)) {
 		NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
 		NLA_PUT_BE16(inst->skb, NFULA_HWLEN,
 			     htons(skb->dev->hard_header_len));
-- 
1.6.1

