From: subashab@codeaurora.org
Subject: [PATCH nf-next] netfilter: ip6t_REJECT: Log reject reason in
 reject_tg6()
Date: Thu, 30 Jul 2015 02:34:13 -0000
Message-ID: <283e896df54b88cc7446fc2cde7a5df3.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56735 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbbG3CeO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jul 2015 22:34:14 -0400
Received: from www.codeaurora.org (unknown [198.145.29.65])
	by smtp.codeaurora.org (Postfix) with ESMTP id 4CAC714121E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2015 02:34:13 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The existing message is not very useful, so add the reject reason
to help in debug.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv6/netfilter/ip6t_REJECT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c
b/net/ipv6/netfilter/ip6t_REJECT.c
index 544b0a9..f956513 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -42,7 +42,7 @@ reject_tg6(struct sk_buff *skb, const struct
xt_action_param *par)
 	const struct ip6t_reject_info *reject = par->targinfo;
 	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);

-	pr_debug("%s: medium point\n", __func__);
+	pr_debug("%s: case %u\n", __func__, reject->with);
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
 		nf_send_unreach6(net, skb, ICMPV6_NOROUTE, par->hooknum);
--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
Foundation Collaborative Project


