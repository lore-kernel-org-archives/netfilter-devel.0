From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/10] netfilter: ingress: fix wrong input interface on hook
Date: Wed, 11 Nov 2015 18:33:35 +0100
Message-ID: <1447263223-22662-3-git-send-email-pablo@netfilter.org>
References: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48385 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbbKKRdy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 12:33:54 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 693841392AD
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 18:33:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5B44812301A
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 18:33:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7314A123023
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 18:33:51 +0100 (CET)
In-Reply-To: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The input and output interfaces in nf_hook_state_init() are flipped.
This fixes iif matching on nftables.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ingress.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index ba7ce88..5fcd375 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -19,8 +19,8 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	struct nf_hook_state state;
 
 	nf_hook_state_init(&state, &skb->dev->nf_hooks_ingress,
-			   NF_NETDEV_INGRESS, INT_MIN, NFPROTO_NETDEV, NULL,
-			   skb->dev, NULL, dev_net(skb->dev), NULL);
+			   NF_NETDEV_INGRESS, INT_MIN, NFPROTO_NETDEV,
+			   skb->dev, NULL, NULL, dev_net(skb->dev), NULL);
 	return nf_hook_slow(skb, &state);
 }
 
-- 
2.1.4

