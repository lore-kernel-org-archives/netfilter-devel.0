From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 02/11] br_netfilter: default sysctl settings in init_brnf_net
Date: Mon, 12 May 2014 16:56:57 +0400
Message-ID: <5370C519.4040300@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:46992 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbaELM6H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:58:07 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 2acf7fa..3e81fd6 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -64,6 +64,18 @@ static int brnf_pass_vlan_indev __read_mostly = 0;
 #define brnf_pass_vlan_indev 0
 #endif
 
+#ifdef CONFIG_SYSCTL
+static struct brnf_net init_brnf_net = {
+	.hdr			= NULL,
+	.call_arptables		= brnf_call_arptables,
+	.call_iptables		= brnf_call_iptables,
+	.call_ip6tables		= brnf_call_ip6tables,
+	.filter_vlan_tagged	= brnf_filter_vlan_tagged,
+	.filter_pppoe_tagged	= brnf_filter_pppoe_tagged,
+	.pass_vlan_indev	= brnf_pass_vlan_indev,
+};
+#endif
+
 #define IS_IP(skb) \
 	(!vlan_tx_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
 
-- 
1.7.5.4

