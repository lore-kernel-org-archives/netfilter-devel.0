From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/06: arptables in netns for real
Date: Sun, 27 Jul 2008 01:37:12 +0200 (MEST)
Message-ID: <20080726233711.15283.14873.sendpatchset@localhost.localdomain>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43537 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYGZXhN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:13 -0400
In-Reply-To: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: arptables in netns for real

IN, FORWARD -- grab netns from in device, OUT -- from out device.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ea52606851cacfc5bcd6437ac0d97a22494279ac
tree 7929d1eb7468fd9f875bc1d248c0610a9197fe88
parent 3e7770f4574672e7e6122b0dee21faf325d7b6a3
author Alexey Dobriyan <adobriyan@gmail.com> Sun, 27 Jul 2008 00:40:13 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:40:13 +0200

 net/ipv4/netfilter/arptable_filter.c |   39 ++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 3be4d07..082f5dd 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -55,32 +55,53 @@ static struct xt_table packet_filter = {
 };
 
 /* The work comes in here from netfilter.c */
-static unsigned int arpt_hook(unsigned int hook,
-			      struct sk_buff *skb,
-			      const struct net_device *in,
-			      const struct net_device *out,
-			      int (*okfn)(struct sk_buff *))
+static unsigned int arpt_in_hook(unsigned int hook,
+				 struct sk_buff *skb,
+				 const struct net_device *in,
+				 const struct net_device *out,
+				 int (*okfn)(struct sk_buff *))
 {
-	return arpt_do_table(skb, hook, in, out, init_net.ipv4.arptable_filter);
+	return arpt_do_table(skb, hook, in, out,
+			     dev_net(in)->ipv4.arptable_filter);
+}
+
+static unsigned int arpt_out_hook(unsigned int hook,
+				  struct sk_buff *skb,
+				  const struct net_device *in,
+				  const struct net_device *out,
+				  int (*okfn)(struct sk_buff *))
+{
+	return arpt_do_table(skb, hook, in, out,
+			     dev_net(out)->ipv4.arptable_filter);
+}
+
+static unsigned int arpt_forward_hook(unsigned int hook,
+				      struct sk_buff *skb,
+				      const struct net_device *in,
+				      const struct net_device *out,
+				      int (*okfn)(struct sk_buff *))
+{
+	return arpt_do_table(skb, hook, in, out,
+			     dev_net(in)->ipv4.arptable_filter);
 }
 
 static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
-		.hook		= arpt_hook,
+		.hook		= arpt_in_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		= arpt_hook,
+		.hook		= arpt_out_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_OUT,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		= arpt_hook,
+		.hook		= arpt_forward_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_FORWARD,
