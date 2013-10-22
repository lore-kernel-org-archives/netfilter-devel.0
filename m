From: Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: [PATCH v2] netfilter: skip checksum verification for outgoing
 rejected ipv6 packets
Date: Tue, 22 Oct 2013 16:43:23 +0400
Message-ID: <20131022124323.GB3255@stfomichev-desktop>
References: <20131022083631.GA28194@stfomichev-desktop>
 <20131022105540.GD12157@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:55396 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659Ab3JVMvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:51:17 -0400
Content-Disposition: inline
In-Reply-To: <20131022105540.GD12157@breakpoint.cc>
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
 net/ipv6/netfilter/ip6t_REJECT.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 70f9abc0efe9..0bf81ef80c90 100644
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
@@ -88,8 +88,7 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 	}
 
 	/* Check checksum. */
-	if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
-			    skb_checksum(oldskb, tcphoff, otcplen, 0))) {
+	if (nf_ip6_checksum(oldskb, hook, tcphoff, IPPROTO_TCP)) {
 		pr_debug("TCP checksum is invalid\n");
 		return;
 	}
@@ -209,7 +208,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
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
