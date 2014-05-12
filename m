From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 07/11] br_netfilter: switch sysctl filter_pppoe_tagged
 to init_brnf_net
Date: Mon, 12 May 2014 16:57:40 +0400
Message-ID: <5370C544.2040903@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:24074 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbaELM6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:58:50 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index a3cd03d..ae970ff 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -49,16 +49,15 @@
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_filter_pppoe_tagged __read_mostly = 0;
 static int brnf_pass_vlan_indev __read_mostly = 0;
 #else
-#define brnf_filter_pppoe_tagged 0
 #define brnf_pass_vlan_indev 0
 #endif
 #define brnf_call_arptables 1
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
 #define brnf_filter_vlan_tagged 0
+#define brnf_filter_pppoe_tagged 0
 
 #ifdef CONFIG_SYSCTL
 static struct brnf_net init_brnf_net = {
@@ -118,12 +117,12 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 #define IS_PPPOE_IP(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+	 brnf_flag(skb, filter_pppoe_tagged))
 
 #define IS_PPPOE_IPV6(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	 brnf_flag(skb, filter_pppoe_tagged))
 
 static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			     struct sk_buff *skb, u32 mtu)
@@ -1057,7 +1056,7 @@ static struct ctl_table brnf_table[] = {
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

