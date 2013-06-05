From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 2/2] netfilter: nfnetlink_queue: only add CAP_LEN attr when needed
Date: Wed,  5 Jun 2013 10:22:16 +0200
Message-ID: <1370420536-9626-2-git-send-email-fw@strlen.de>
References: <1370420536-9626-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39372 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab3FEIWH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:22:07 -0400
In-Reply-To: <1370420536-9626-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

CAP_LEN contains the size of the network packet we're queueing to
userspace, i.e. normally it is the same as the NFQA_PAYLOAD attribute len.

Include it only in the unlikely case when NFQA_PAYLOAD is truncated due
to copy_range limitations.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Tested with examples/nf-queue.c from libnfqueue, it still
 prints 'truncated packet' on 1st packet sent from tracepath.

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 3c42181..eb2cde8 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -472,7 +472,8 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
 		goto nla_put_failure;
 
-	if (cap_len > 0 && nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
+	if (cap_len > data_len &&
+	    nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
 		goto nla_put_failure;
 
 	if (nfqnl_put_packet_info(skb, entskb))
-- 
1.7.8.6

