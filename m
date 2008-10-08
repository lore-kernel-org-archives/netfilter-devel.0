From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 07/79: netns: remove nf_*_net() wrappers
Date: Wed,  8 Oct 2008 12:46:30 +0200 (MEST)
Message-ID: <20081008104630.10423.57692.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45870 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYJHKqc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:32 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 48dc7865aa3db9404aedc8677d9daf8f8f469ab0
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:01 2008 +0200

    netfilter: netns: remove nf_*_net() wrappers
    
    Now that dev_net() exists, the usefullness of them is even less. Also they're
    a big problem in resolving circular header dependencies necessary for
    NOTRACK-in-netns patch. See below.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index bf3afb0..48cfe51 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -5,13 +5,11 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/net.h>
-#include <linux/netdevice.h>
 #include <linux/if.h>
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/wait.h>
 #include <linux/list.h>
-#include <net/net_namespace.h>
 #endif
 #include <linux/types.h>
 #include <linux/compiler.h>
@@ -355,56 +353,5 @@ extern void (*nf_ct_destroy)(struct nf_conntrack *);
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
 
-static inline struct net *nf_pre_routing_net(const struct net_device *in,
-					     const struct net_device *out)
-{
-#ifdef CONFIG_NET_NS
-	return in->nd_net;
-#else
-	return &init_net;
-#endif
-}
-
-static inline struct net *nf_local_in_net(const struct net_device *in,
-					  const struct net_device *out)
-{
-#ifdef CONFIG_NET_NS
-	return in->nd_net;
-#else
-	return &init_net;
-#endif
-}
-
-static inline struct net *nf_forward_net(const struct net_device *in,
-					 const struct net_device *out)
-{
-#ifdef CONFIG_NET_NS
-	BUG_ON(in->nd_net != out->nd_net);
-	return in->nd_net;
-#else
-	return &init_net;
-#endif
-}
-
-static inline struct net *nf_local_out_net(const struct net_device *in,
-					   const struct net_device *out)
-{
-#ifdef CONFIG_NET_NS
-	return out->nd_net;
-#else
-	return &init_net;
-#endif
-}
-
-static inline struct net *nf_post_routing_net(const struct net_device *in,
-					      const struct net_device *out)
-{
-#ifdef CONFIG_NET_NS
-	return out->nd_net;
-#else
-	return &init_net;
-#endif
-}
-
 #endif /*__KERNEL__*/
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 1ea677d..c922431 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -70,7 +70,7 @@ ipt_local_in_hook(unsigned int hook,
 		  int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_local_in_net(in, out)->ipv4.iptable_filter);
+			    dev_net(in)->ipv4.iptable_filter);
 }
 
 static unsigned int
@@ -81,7 +81,7 @@ ipt_hook(unsigned int hook,
 	 int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_forward_net(in, out)->ipv4.iptable_filter);
+			    dev_net(in)->ipv4.iptable_filter);
 }
 
 static unsigned int
@@ -101,7 +101,7 @@ ipt_local_out_hook(unsigned int hook,
 	}
 
 	return ipt_do_table(skb, hook, in, out,
-			    nf_local_out_net(in, out)->ipv4.iptable_filter);
+			    dev_net(out)->ipv4.iptable_filter);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index da59182..69f2c42 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -81,7 +81,7 @@ ipt_pre_routing_hook(unsigned int hook,
 		     int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_pre_routing_net(in, out)->ipv4.iptable_mangle);
+			    dev_net(in)->ipv4.iptable_mangle);
 }
 
 static unsigned int
@@ -92,7 +92,7 @@ ipt_post_routing_hook(unsigned int hook,
 		      int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_post_routing_net(in, out)->ipv4.iptable_mangle);
+			    dev_net(out)->ipv4.iptable_mangle);
 }
 
 static unsigned int
@@ -103,7 +103,7 @@ ipt_local_in_hook(unsigned int hook,
 		  int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_local_in_net(in, out)->ipv4.iptable_mangle);
+			    dev_net(in)->ipv4.iptable_mangle);
 }
 
 static unsigned int
@@ -114,7 +114,7 @@ ipt_forward_hook(unsigned int hook,
 	 int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_forward_net(in, out)->ipv4.iptable_mangle);
+			    dev_net(in)->ipv4.iptable_mangle);
 }
 
 static unsigned int
@@ -147,7 +147,7 @@ ipt_local_hook(unsigned int hook,
 	tos = iph->tos;
 
 	ret = ipt_do_table(skb, hook, in, out,
-			   nf_local_out_net(in, out)->ipv4.iptable_mangle);
+			   dev_net(out)->ipv4.iptable_mangle);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE) {
 		iph = ip_hdr(skb);
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index fddce77..8faebfe 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -53,7 +53,7 @@ ipt_hook(unsigned int hook,
 	 int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_pre_routing_net(in, out)->ipv4.iptable_raw);
+			    dev_net(in)->ipv4.iptable_raw);
 }
 
 static unsigned int
@@ -72,7 +72,7 @@ ipt_local_hook(unsigned int hook,
 		return NF_ACCEPT;
 	}
 	return ipt_do_table(skb, hook, in, out,
-			    nf_local_out_net(in, out)->ipv4.iptable_raw);
+			    dev_net(out)->ipv4.iptable_raw);
 }
 
 /* 'raw' is the very first table. */
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index db6d312..36f3be3 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -73,7 +73,7 @@ ipt_local_in_hook(unsigned int hook,
 		  int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_local_in_net(in, out)->ipv4.iptable_security);
+			    dev_net(in)->ipv4.iptable_security);
 }
 
 static unsigned int
@@ -84,7 +84,7 @@ ipt_forward_hook(unsigned int hook,
 		 int (*okfn)(struct sk_buff *))
 {
 	return ipt_do_table(skb, hook, in, out,
-			    nf_forward_net(in, out)->ipv4.iptable_security);
+			    dev_net(in)->ipv4.iptable_security);
 }
 
 static unsigned int
@@ -103,7 +103,7 @@ ipt_local_out_hook(unsigned int hook,
 		return NF_ACCEPT;
 	}
 	return ipt_do_table(skb, hook, in, out,
-			    nf_local_out_net(in, out)->ipv4.iptable_security);
+			    dev_net(out)->ipv4.iptable_security);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 55a2c29..b110a8a 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -68,7 +68,7 @@ ip6t_local_in_hook(unsigned int hook,
 		   int (*okfn)(struct sk_buff *))
 {
 	return ip6t_do_table(skb, hook, in, out,
-			     nf_local_in_net(in, out)->ipv6.ip6table_filter);
+			     dev_net(in)->ipv6.ip6table_filter);
 }
 
 static unsigned int
@@ -79,7 +79,7 @@ ip6t_forward_hook(unsigned int hook,
 		  int (*okfn)(struct sk_buff *))
 {
 	return ip6t_do_table(skb, hook, in, out,
-			     nf_forward_net(in, out)->ipv6.ip6table_filter);
+			     dev_net(in)->ipv6.ip6table_filter);
 }
 
 static unsigned int
@@ -100,7 +100,7 @@ ip6t_local_out_hook(unsigned int hook,
 #endif
 
 	return ip6t_do_table(skb, hook, in, out,
-			     nf_local_out_net(in, out)->ipv6.ip6table_filter);
+			     dev_net(out)->ipv6.ip6table_filter);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 6e71310..20bc52f 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -72,7 +72,7 @@ ip6t_local_in_hook(unsigned int hook,
 		   int (*okfn)(struct sk_buff *))
 {
 	return ip6t_do_table(skb, hook, in, out,
-			     nf_local_in_net(in, out)->ipv6.ip6table_security);
+			     dev_net(in)->ipv6.ip6table_security);
 }
 
 static unsigned int
@@ -83,7 +83,7 @@ ip6t_forward_hook(unsigned int hook,
 		  int (*okfn)(struct sk_buff *))
 {
 	return ip6t_do_table(skb, hook, in, out,
-			     nf_forward_net(in, out)->ipv6.ip6table_security);
+			     dev_net(in)->ipv6.ip6table_security);
 }
 
 static unsigned int
@@ -95,7 +95,7 @@ ip6t_local_out_hook(unsigned int hook,
 {
 	/* TBD: handle short packets via raw socket */
 	return ip6t_do_table(skb, hook, in, out,
-			     nf_local_out_net(in, out)->ipv6.ip6table_security);
+			     dev_net(out)->ipv6.ip6table_security);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
