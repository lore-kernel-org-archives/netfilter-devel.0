From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/13: ip6table_filter in netns for real
Date: Mon,  7 Jul 2008 14:05:20 +0200 (MEST)
Message-ID: <20080707120519.4975.63516.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58376 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYGGMFV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:21 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ip6table_filter in netns for real

One still needs to remove checks in nf_hook_slow() and nf_sockopt_find()
to test this, though.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 92b669eedbfbca32d05723764afb243b6d8faeed
tree 9061315f95bb9a3d3a36bb14ec491ddd7d41f29c
parent fb5471afe6b8e29f1319ca85ecc830f6b8b54143
author Alexey Dobriyan <adobriyan@gmail.com> Mon, 07 Jul 2008 13:00:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:16 +0200

 net/ipv6/netfilter/ip6table_filter.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index f979e48..55a2c29 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -61,13 +61,25 @@ static struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6t_hook(unsigned int hook,
-	 struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 int (*okfn)(struct sk_buff *))
+ip6t_local_in_hook(unsigned int hook,
+		   struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   int (*okfn)(struct sk_buff *))
+{
+	return ip6t_do_table(skb, hook, in, out,
+			     nf_local_in_net(in, out)->ipv6.ip6table_filter);
+}
+
+static unsigned int
+ip6t_forward_hook(unsigned int hook,
+		  struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(skb, hook, in, out, init_net.ipv6.ip6table_filter);
+	return ip6t_do_table(skb, hook, in, out,
+			     nf_forward_net(in, out)->ipv6.ip6table_filter);
 }
 
 static unsigned int
@@ -87,19 +99,20 @@ ip6t_local_out_hook(unsigned int hook,
 	}
 #endif
 
-	return ip6t_do_table(skb, hook, in, out, init_net.ipv6.ip6table_filter);
+	return ip6t_do_table(skb, hook, in, out,
+			     nf_local_out_net(in, out)->ipv6.ip6table_filter);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-		.hook		= ip6t_hook,
+		.hook		= ip6t_local_in_hook,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
-		.hook		= ip6t_hook,
+		.hook		= ip6t_forward_hook,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_INET_FORWARD,
