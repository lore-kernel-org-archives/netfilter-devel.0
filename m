From: Andreas Herz <andi@geekosphere.org>
Subject: [PATCH nf-next] add missing icmpv6 codes (rfc4443) in REJECT
Date: Fri, 21 Aug 2015 10:59:00 +0200
Message-ID: <1440147540-27296-1-git-send-email-andi@geekosphere.org>
Cc: Andreas Herz <andi@geekosphere.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:57905 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbbHUI7H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2015 04:59:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

RFC 4443 added two new codes values for ICMPv6 type 1:

 5 - Source address failed ingress/egress policy
 6 - Reject route to destination

And RFC 7084 states in L-14 that IPv6 Router MUST send ICMPv6 Destination
Unreachable with code 5 for packets forwarded to it that use an address 
from a prefix that has been invalidated.

Signed-off-by: Andreas Herz <andi@geekosphere.org>
---
 include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h | 2 ++
 net/ipv6/netfilter/ip6t_REJECT.c                | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h b/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h
index 205ed62..8bd5f4b 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h
@@ -9,6 +9,8 @@ enum ip6t_reject_with {
 	IP6T_ICMP6_NOT_NEIGHBOUR,
 	IP6T_ICMP6_ADDR_UNREACH,
 	IP6T_ICMP6_PORT_UNREACH,
+	IP6T_ICMP6_POLICY_FAIL,
+	IP6T_ICMP6_REJECT_ROUTE,
 	IP6T_ICMP6_ECHOREPLY,
 	IP6T_TCP_RESET
 };
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 567367a..d39b647 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -57,6 +57,12 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	case IP6T_ICMP6_PORT_UNREACH:
 		nf_send_unreach6(net, skb, ICMPV6_PORT_UNREACH, par->hooknum);
 		break;
+	case IP6T_ICMP6_POLICY_FAIL:
+		nf_send_unreach6(net, skb, ICMPV6_POLICY_FAIL, par->hooknum);
+		break;
+	case IP6T_ICMP6_REJECT_ROUTE:
+		nf_send_unreach6(net, skb, ICMPV6_REJECT_ROUTE, par->hooknum);
+		break;
 	case IP6T_ICMP6_ECHOREPLY:
 		/* Do nothing */
 		break;
-- 
2.4.6

