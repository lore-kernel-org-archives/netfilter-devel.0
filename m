From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 03/11] br_netfilter: brnf_flag macro
Date: Mon, 12 May 2014 16:57:05 +0400
Message-ID: <5370C521.2080507@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27828 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbaELM6P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:58:15 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 3e81fd6..e70cbd1 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -76,6 +76,12 @@ static struct brnf_net init_brnf_net = {
 };
 #endif
 
+#ifdef CONFIG_SYSCTL
+#define brnf_flag(skb, flag)		init_brnf_net.flag
+#else
+#define brnf_flag(skb, flag)		brnf_##flag
+#endif
+
 #define IS_IP(skb) \
 	(!vlan_tx_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
 
-- 
1.7.5.4

