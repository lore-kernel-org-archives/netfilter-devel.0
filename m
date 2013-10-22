From: Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: [PATCH] netfilter: skip checksum verification for outgoing rejected
 ipv6 packets
Date: Tue, 22 Oct 2013 12:36:31 +0400
Message-ID: <20131022083631.GA28194@stfomichev-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35788 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab3JVInF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:43:05 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't verify checksum for outgoing packets because checksum calculation
may be done by the device.

Without this patch:
$ ip6tables -I OUTPUT -p tcp --dport 80 -j REJECT --reject-with tcp-reset
$ time telnet ipv6.google.com 80
Trying 2a00:1450:4010:c03::67...
telnet: Unable to connect to remote host: Connection timed out

real    0m7.201s
user    0m0.000s
sys     0m0.000s

With the patch applied:
$ ip6tables -I OUTPUT -p tcp --dport 80 -j REJECT --reject-with tcp-reset
$ time telnet ipv6.google.com 80
Trying 2a00:1450:4010:c03::67...
telnet: Unable to connect to remote host: Connection refused

real    0m0.085s
user    0m0.000s
sys     0m0.000s

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 net/ipv6/netfilter/ip6t_REJECT.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 56eef30ee5f6..3ef2b834bca3 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -39,7 +39,7 @@ MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv6");
 MODULE_LICENSE("GPL");
 
 /* Send RST reply */
-static void send_reset(struct net *net, struct sk_buff *oldskb)
+static void send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
 	struct tcphdr otcph, *tcph;
@@ -88,8 +88,10 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 	}
 
 	/* Check checksum. */
-	if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
+	if (hook != NF_INET_LOCAL_OUT &&
+	    csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
 			    skb_checksum(oldskb, tcphoff, otcplen, 0))) {
+
 		pr_debug("TCP checksum is invalid\n");
 		return;
 	}
@@ -227,7 +229,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		/* Do nothing */
 		break;
 	case IP6T_TCP_RESET:
-		send_reset(net, skb);
+		send_reset(net, skb, par->hooknum);
 		break;
 	default:
 		net_info_ratelimited("case %u not handled yet\n", reject->with);
-- 
1.8.1.2
