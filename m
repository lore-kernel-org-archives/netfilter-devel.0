From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 14/15] br_netfilter: switch sysctl filter_pppoe_tagged to
 per-netns processing
Date: Sat, 10 May 2014 01:28:59 +0400
Message-ID: <536D489B.6020303@parallels.com>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:10669 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744AbaEIVaq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:30:46 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 680d60d..44bae8e 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -106,12 +106,12 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 #define IS_PPPOE_IP(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 init_brnf_net.filter_pppoe_tagged)
+	 brnf_net(dev_net(skb->dev))->filter_pppoe_tagged)
 
 #define IS_PPPOE_IPV6(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 init_brnf_net.filter_pppoe_tagged)
+	 brnf_net(dev_net(skb->dev))->filter_pppoe_tagged)
 
 static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			     struct sk_buff *skb, u32 mtu)
@@ -1077,7 +1077,7 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 		if (!table)
 			goto err_alloc;
 	}
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < 5; i++)
 		table[i].data += (char *)bn - (char *)&init_brnf_net;
 
 	hdr = register_net_sysctl(bn->net, "net/bridge", table);
-- 
1.7.5.4

