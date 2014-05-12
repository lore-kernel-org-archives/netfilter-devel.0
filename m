From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 01/11] br_netfilter: brnf_net structure for sysctl
 setting
Date: Mon, 12 May 2014 16:56:49 +0400
Message-ID: <5370C511.1040907@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:30136 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbaELM5g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:57:36 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_private.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06811d7..25a785e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -312,6 +312,19 @@ struct br_input_skb_cb {
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
 #endif
 
+#if defined CONFIG_BRIDGE_NETFILTER && defined CONFIG_SYSCTL
+struct brnf_net {
+	struct net *net;
+	struct ctl_table_header	*hdr;
+	int call_arptables;
+	int call_iptables;
+	int call_ip6tables;
+	int filter_vlan_tagged;
+	int filter_pppoe_tagged;
+	int pass_vlan_indev;
+};
+#endif
+
 #define br_printk(level, br, format, args...)	\
 	printk(level "%s: " format, (br)->dev->name, ##args)
 
-- 
1.7.5.4

