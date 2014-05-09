From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 11/15] br_netfilter: switch sysctl nf_call_arptables to per-netns
 processing
Date: Sat, 10 May 2014 01:28:31 +0400
Message-ID: <536D487F.3030004@parallels.com>
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
Received: from mailhub.sw.ru ([195.214.232.25]:27712 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808AbaEIVaS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:30:18 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

now sysctl nf_call_arptables uses per-netns setting
.data in sysctl tables now points to per-netns struct brnf_net 

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 16b68da..dbf73cb 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -834,13 +834,15 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	struct net_device **d = (struct net_device **)(skb->cb);
+	struct brnf_net *bn;
 
 	p = br_port_get_rcu(out);
 	if (p == NULL)
 		return NF_ACCEPT;
 	br = p->br;
+	bn = brnf_net(dev_net(skb->dev));
 
-	if (!init_brnf_net.nf_call_arptables && !br->nf_call_arptables)
+	if (!bn->nf_call_arptables && !br->nf_call_arptables)
 		return NF_ACCEPT;
 
 	if (!IS_ARP(skb)) {
@@ -1064,6 +1066,7 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 {
 	struct ctl_table *table;
 	struct ctl_table_header *hdr;
+	int i;
 
 	table = brnf_table;
 	if (!net_eq(bn->net, &init_net)) {
@@ -1072,6 +1075,9 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 		if (!table)
 			goto err_alloc;
 	}
+	for (i = 0; i < 1; i++)
+		table[i].data += (char *)bn - (char *)&init_brnf_net;
+
 	hdr = register_net_sysctl(bn->net, "net/bridge", table);
 	if (!hdr)
 		goto err_reg;
-- 
1.7.5.4

