From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 06/15] br_netfilter: switch sysctl filter_vlan_tagged to init_brnf_net
Date: Sat, 10 May 2014 01:27:39 +0400
Message-ID: <536D484B.5060509@parallels.com>
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
Received: from mailhub.sw.ru ([195.214.232.25]:23989 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757847AbaEIV30 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:29:26 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 94c0dcb..16a69cf 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -61,11 +61,9 @@ static struct brnf_net init_brnf_net = {
 
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
@@ -91,15 +89,15 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 
 #define IS_VLAN_IP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+	 init_brnf_net.filter_vlan_tagged)
 
 #define IS_VLAN_IPV6(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	 init_brnf_net.filter_vlan_tagged)
 
 #define IS_VLAN_ARP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+	 init_brnf_net.filter_vlan_tagged)
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -1042,7 +1040,7 @@ static struct ctl_table brnf_table[] = {
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

