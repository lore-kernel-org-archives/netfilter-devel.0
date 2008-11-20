From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ip6table_filter: merge LOCAL_IN and FORWARD hooks
Date: Thu, 20 Nov 2008 12:00:23 +0300
Message-ID: <20081120090023.GB1927@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:28984 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbYKTI4k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:56:40 -0500
Received: by ug-out-1314.google.com with SMTP id 39so209114ugf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2008 00:56:38 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv6/netfilter/ip6table_filter.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -61,7 +61,7 @@ static struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6t_local_in_hook(unsigned int hook,
+ip6t_in_hook(unsigned int hook,
 		   struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
@@ -72,17 +72,6 @@ ip6t_local_in_hook(unsigned int hook,
 }
 
 static unsigned int
-ip6t_forward_hook(unsigned int hook,
-		  struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  int (*okfn)(struct sk_buff *))
-{
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_filter);
-}
-
-static unsigned int
 ip6t_local_out_hook(unsigned int hook,
 		   struct sk_buff *skb,
 		   const struct net_device *in,
@@ -105,14 +94,14 @@ ip6t_local_out_hook(unsigned int hook,
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-		.hook		= ip6t_local_in_hook,
+		.hook		= ip6t_in_hook,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
-		.hook		= ip6t_forward_hook,
+		.hook		= ip6t_in_hook,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_INET_FORWARD,
