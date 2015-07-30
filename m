From: subashab@codeaurora.org
Subject: [PATCH nf-next] netfilter: ip6t_REJECT: Remove debug messages from
 reject_tg6()
Date: Thu, 30 Jul 2015 16:53:45 -0000
Message-ID: <cb3d7201ff88e22c845965487ad9a870.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbbG3Qxq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 12:53:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make it similar to reject_tg() in ipt_REJECT.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv6/netfilter/ip6t_REJECT.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c
b/net/ipv6/netfilter/ip6t_REJECT.c
index 544b0a9..9501e14 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -42,7 +42,6 @@ reject_tg6(struct sk_buff *skb, const struct
xt_action_param *par)
 	const struct ip6t_reject_info *reject = par->targinfo;
 	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);

-	pr_debug("%s: medium point\n", __func__);
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
 		nf_send_unreach6(net, skb, ICMPV6_NOROUTE, par->hooknum);
@@ -65,9 +64,6 @@ reject_tg6(struct sk_buff *skb, const struct
xt_action_param *par)
 	case IP6T_TCP_RESET:
 		nf_send_reset6(net, skb, par->hooknum);
 		break;
-	default:
-		net_info_ratelimited("case %u not handled yet\n", reject->with);
-		break;
 	}

 	return NF_DROP;
--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
Foundation Collaborative Project

