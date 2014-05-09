From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 07/15] br_netfilter: switch sysctl filter_pppoe_tagged to
 init_brnf_net
Date: Sat, 10 May 2014 01:27:50 +0400
Message-ID: <536D4856.9000603@parallels.com>
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
Received: from mailhub.sw.ru ([195.214.232.25]:48298 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbaEIV3g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:29:36 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 16a69cf..3650f21 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -61,10 +61,8 @@ static struct brnf_net init_brnf_net = {
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_filter_pppoe_tagged __read_mostly = 0;
 static int brnf_pass_vlan_indev __read_mostly = 0;
 #else
-#define brnf_filter_pppoe_tagged 0
 #define brnf_pass_vlan_indev 0
 #endif
 
@@ -108,12 +106,12 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 #define IS_PPPOE_IP(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+	 init_brnf_net.filter_pppoe_tagged)
 
 #define IS_PPPOE_IPV6(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	 init_brnf_net.filter_pppoe_tagged)
 
 static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			     struct sk_buff *skb, u32 mtu)
@@ -1047,7 +1045,7 @@ static struct ctl_table brnf_table[] = {
 	},
 	{
 		.procname	= "bridge-nf-filter-pppoe-tagged",
-		.data		= &brnf_filter_pppoe_tagged,
+		.data		= &init_brnf_net.filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
-- 
1.7.5.4

