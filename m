From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 15/15] br_netfilter: switch sysctl pass_vlan_indev to per-netns
 processing
Date: Sat, 10 May 2014 01:29:08 +0400
Message-ID: <536D48A4.6070309@parallels.com>
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
Received: from mailhub.sw.ru ([195.214.232.25]:38903 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744AbaEIVaz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:30:55 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 44bae8e..5ca6010 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -532,9 +532,11 @@ bridged_dnat:
 static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct net_device *vlan, *br;
+	struct brnf_net *bn;
 
 	br = bridge_parent(dev);
-	if (init_brnf_net.pass_vlan_indev == 0 || !vlan_tx_tag_present(skb))
+	bn = brnf_net(dev_net(dev));
+	if (bn->pass_vlan_indev == 0 || !vlan_tx_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep(br, skb->vlan_proto,
@@ -1077,7 +1079,7 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 		if (!table)
 			goto err_alloc;
 	}
-	for (i = 0; i < 5; i++)
+	for (i = 0; table[i].data; i++)
 		table[i].data += (char *)bn - (char *)&init_brnf_net;
 
 	hdr = register_net_sysctl(bn->net, "net/bridge", table);
-- 
1.7.5.4

