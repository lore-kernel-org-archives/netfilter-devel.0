From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: ip6table_filter in netns for real
Date: Tue, 17 Jun 2008 06:30:57 +0400
Message-ID: <20080617023057.GA22003@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, den@openvz.org, xemul@openvz.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:62824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYFQCe6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 22:34:58 -0400
Received: by fg-out-1718.google.com with SMTP id 19so3434943fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2008 19:34:56 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One still needs to remove checks in nf_hook_slow() and nf_sockopt_find()
to test this, though.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv6/netfilter/ip6table_filter.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

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

