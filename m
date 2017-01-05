From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] bridge: netfilter: Fix dropping packets that moving through bridge interface
Date: Thu,  5 Jan 2017 12:19:53 +0100
Message-ID: <1483615193-2931-7-git-send-email-pablo@netfilter.org>
References: <1483615193-2931-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761885AbdAELUM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 06:20:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19E3B52307
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 12:20:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08709DA878
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 12:20:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E432A7EE7
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 12:20:07 +0100 (CET)
In-Reply-To: <1483615193-2931-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Artur Molchanov <arturmolchanov@gmail.com>

Problem:
br_nf_pre_routing_finish() calls itself instead of
br_nf_pre_routing_finish_bridge(). Due to this bug reverse path filter drops
packets that go through bridge interface.

User impact:
Local docker containers with bridge network can not communicate with each
other.

Fixes: c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
Signed-off-by: Artur Molchanov <artur.molchanov@synesis.ru>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index b12501a77f18..135cc8ab813c 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -399,7 +399,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				br_nf_hook_thresh(NF_BR_PRE_ROUTING,
 						  net, sk, skb, skb->dev,
 						  NULL,
-						  br_nf_pre_routing_finish);
+						  br_nf_pre_routing_finish_bridge);
 				return 0;
 			}
 			ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
-- 
2.1.4

