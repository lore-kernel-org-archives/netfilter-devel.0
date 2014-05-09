From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 13/15] br_netfilter: switch sysctl filter_vlan_tagged to per-netns
 processing
Date: Sat, 10 May 2014 01:28:49 +0400
Message-ID: <536D4891.5050805@parallels.com>
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
Received: from mailhub.sw.ru ([195.214.232.25]:10246 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757692AbaEIVag (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:30:36 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 5043b1e..680d60d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -87,15 +87,15 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 
 #define IS_VLAN_IP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 init_brnf_net.filter_vlan_tagged)
+	 brnf_net(dev_net(skb->dev))->filter_vlan_tagged)
 
 #define IS_VLAN_IPV6(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 init_brnf_net.filter_vlan_tagged)
+	 brnf_net(dev_net(skb->dev))->filter_vlan_tagged)
 
 #define IS_VLAN_ARP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 init_brnf_net.filter_vlan_tagged)
+	 brnf_net(dev_net(skb->dev))->filter_vlan_tagged)
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -1077,7 +1077,7 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 		if (!table)
 			goto err_alloc;
 	}
-	for (i = 0; i < 3; i++)
+	for (i = 0; i < 4; i++)
 		table[i].data += (char *)bn - (char *)&init_brnf_net;
 
 	hdr = register_net_sysctl(bn->net, "net/bridge", table);
-- 
1.7.5.4

