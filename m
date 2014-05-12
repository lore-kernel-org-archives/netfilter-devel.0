From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 08/11] br_netfilter: switch sysctl pass_vlan_indev
 to init_brnf_net
Date: Mon, 12 May 2014 16:57:50 +0400
Message-ID: <5370C54E.9020002@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:21041 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbaELM7X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:59:23 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ae970ff..55794c4 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -49,15 +49,13 @@
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_pass_vlan_indev __read_mostly = 0;
-#else
-#define brnf_pass_vlan_indev 0
 #endif
 #define brnf_call_arptables 1
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
 #define brnf_filter_vlan_tagged 0
 #define brnf_filter_pppoe_tagged 0
+#define brnf_pass_vlan_indev 0
 
 #ifdef CONFIG_SYSCTL
 static struct brnf_net init_brnf_net = {
@@ -545,7 +543,7 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 	struct net_device *vlan, *br;
 
 	br = bridge_parent(dev);
-	if (brnf_pass_vlan_indev == 0 || !vlan_tx_tag_present(skb))
+	if (brnf_flag(skb, pass_vlan_indev) == 0 || !vlan_tx_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep(br, skb->vlan_proto,
@@ -1063,7 +1061,7 @@ static struct ctl_table brnf_table[] = {
 	},
 	{
 		.procname	= "bridge-nf-pass-vlan-input-dev",
-		.data		= &brnf_pass_vlan_indev,
+		.data		= &init_brnf_net.pass_vlan_indev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
-- 
1.7.5.4

