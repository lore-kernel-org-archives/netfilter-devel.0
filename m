From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 11/11] br_netfilter: switch all sysctls to per-netns
 processing
Date: Mon, 12 May 2014 16:58:17 +0400
Message-ID: <5370C569.6010708@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:10097 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbaELM70 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:59:26 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ed3b6ce..f4b6b43 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -71,10 +71,9 @@ static inline struct brnf_net *brnf_net(const struct net *net)
 {
 	return net_generic(net, brnf_net_id);
 }
-#endif
 
-#ifdef CONFIG_SYSCTL
-#define brnf_flag(skb, flag)		init_brnf_net.flag
+#define skb_netns(skb)			dev_net((skb)->dev)
+#define brnf_flag(skb, flag)		brnf_net(skb_netns(skb))->flag
 #else
 #define brnf_flag(skb, flag)		brnf_##flag
 #endif
@@ -1086,6 +1085,9 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 		if (!table)
 			goto err_alloc;
 	}
+	for (i = 0; table[i].data; i++)
+		table[i].data += (char *)bn - (char *)&init_brnf_net;
+
 	hdr = register_net_sysctl(bn->net, "net/bridge", table);
 	if (!hdr)
 		goto err_reg;
-- 
1.7.5.4

