From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 01/15] br_netfilter: brnf_net structure
Date: Sat, 10 May 2014 01:26:50 +0400
Message-ID: <536D481A.1060700@parallels.com>
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
Received: from mailhub.sw.ru ([195.214.232.25]:13789 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbaEIV2m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:28:42 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

struct brnf_net for per-netns settings in br_netfilters

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_private.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06811d7..e29ae83 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -312,6 +312,21 @@ struct br_input_skb_cb {
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
 #endif
 
+#ifdef CONFIG_BRIDGE_NETFILTER
+struct brnf_net {
+	struct net *net;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header	*hdr;
+#endif
+	int nf_call_arptables;
+	int nf_call_iptables;
+	int nf_call_ip6tables;
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

