From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 06/11] br_netfilter: switch sysctl filter_vlan_tagged
 to init_brnf_net
Date: Mon, 12 May 2014 16:57:30 +0400
Message-ID: <5370C53A.3020308@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:4310 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbaELM6j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:58:39 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index f34ed89..a3cd03d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -49,17 +49,16 @@
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_filter_vlan_tagged __read_mostly = 0;
 static int brnf_filter_pppoe_tagged __read_mostly = 0;
 static int brnf_pass_vlan_indev __read_mostly = 0;
 #else
-#define brnf_filter_vlan_tagged 0
 #define brnf_filter_pppoe_tagged 0
 #define brnf_pass_vlan_indev 0
 #endif
 #define brnf_call_arptables 1
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
+#define brnf_filter_vlan_tagged 0
 
 #ifdef CONFIG_SYSCTL
 static struct brnf_net init_brnf_net = {
@@ -100,15 +99,15 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 
 #define IS_VLAN_IP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+	 brnf_flag(skb, filter_vlan_tagged))
 
 #define IS_VLAN_IPV6(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	 brnf_flag(skb, filter_vlan_tagged))
 
 #define IS_VLAN_ARP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+	 brnf_flag(skb, filter_vlan_tagged))
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -1051,7 +1050,7 @@ static struct ctl_table brnf_table[] = {
 	},
 	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
-		.data		= &brnf_filter_vlan_tagged,
+		.data		= &init_brnf_net.filter_vlan_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
-- 
1.7.5.4

