From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nf_reject_ipv4: Fix use-after-free in send_reset
Date: Wed,  1 Nov 2017 19:48:12 +0100
Message-ID: <20171101184812.4813-3-pablo@netfilter.org>
References: <20171101184812.4813-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933135AbdKASsY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Nov 2017 14:48:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFA8453AA29
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2017 19:48:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B11A2DA38E
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2017 19:48:22 +0100 (CET)
In-Reply-To: <20171101184812.4813-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Tejaswi Tanikella <tejaswit@codeaurora.org>

niph is not updated after pskb_expand_head changes the skb head. It
still points to the freed data, which is then used to update tot_len and
checksum. This could cause use-after-free poison crash.

Update niph, if ip_route_me_harder does not fail.

This only affects the interaction with REJECT targets and br_netfilter.

Signed-off-by: Tejaswi Tanikella <tejaswit@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index eeacbdaf7cdf..5cd06ba3535d 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -132,6 +132,8 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
+	niph = ip_hdr(nskb);
+
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(skb_dst(nskb)))
 		goto free_nskb;
-- 
2.11.0

