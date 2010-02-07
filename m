From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] netfilter: xtables: compact table hook functions (1/2)
Date: Sun,  7 Feb 2010 12:49:41 +0100
Message-ID: <1265543385-7420-2-git-send-email-jengelh@medozas.de>
References: <1265543385-7420-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50120 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab0BGLtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:49:49 -0500
In-Reply-To: <1265543385-7420-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch combines all the per-hook functions in a given table into
a single function. Together with the 2nd patch, further
simplifications are possible up to the point of output code reduction.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arptable_filter.c   |   23 ++++------
 net/ipv4/netfilter/iptable_filter.c    |   46 +++++++--------------
 net/ipv4/netfilter/iptable_mangle.c    |   71 +++++++++----------------------
 net/ipv4/netfilter/iptable_raw.c       |   20 +++------
 net/ipv4/netfilter/iptable_security.c  |   43 ++++++-------------
 net/ipv6/netfilter/ip6table_filter.c   |   34 ++++-----------
 net/ipv6/netfilter/ip6table_mangle.c   |   52 ++++++++++-------------
 net/ipv6/netfilter/ip6table_raw.c      |   20 +++------
 net/ipv6/netfilter/ip6table_security.c |   34 ++++------------
 9 files changed, 112 insertions(+), 231 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 9733760..78bb72e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -53,43 +53,38 @@ static const struct xt_table packet_filter = {
 };
 
 /* The work comes in here from netfilter.c */
-static unsigned int arpt_in_hook(unsigned int hook,
+static unsigned int arptable_filter_hook(unsigned int hook,
 				 struct sk_buff *skb,
 				 const struct net_device *in,
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
-	return arpt_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv4.arptable_filter);
-}
+	if (hook == NF_ARP_OUT)
+		return arpt_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv4.arptable_filter);
 
-static unsigned int arpt_out_hook(unsigned int hook,
-				  struct sk_buff *skb,
-				  const struct net_device *in,
-				  const struct net_device *out,
-				  int (*okfn)(struct sk_buff *))
-{
+	/* INPUT/FORWARD: */
 	return arpt_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv4.arptable_filter);
+			     dev_net(in)->ipv4.arptable_filter);
 }
 
 static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
-		.hook		= arpt_in_hook,
+		.hook		= arptable_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		= arpt_out_hook,
+		.hook		= arptable_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_OUT,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		= arpt_in_hook,
+		.hook		= arptable_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_FORWARD,
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index dee90eb..b320208 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -60,61 +60,45 @@ static const struct xt_table packet_filter = {
 	.af		= NFPROTO_IPV4,
 };
 
-/* The work comes in here from netfilter.c. */
 static unsigned int
-ipt_local_in_hook(unsigned int hook,
-		  struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  int (*okfn)(struct sk_buff *))
-{
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_filter);
-}
-
-static unsigned int
-ipt_hook(unsigned int hook,
+iptable_filter_hook(unsigned int hook,
 	 struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_filter);
-}
+	if (hook == NF_INET_LOCAL_OUT) {
+		if (skb->len < sizeof(struct iphdr) ||
+		    ip_hdrlen(skb) < sizeof(struct iphdr))
+			/* root is playing with raw sockets. */
+			return NF_ACCEPT;
+
+		return ipt_do_table(skb, hook, in, out,
+				    dev_net(out)->ipv4.iptable_filter);
+	}
 
-static unsigned int
-ipt_local_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
-{
-	/* root is playing with raw sockets. */
-	if (skb->len < sizeof(struct iphdr) ||
-	    ip_hdrlen(skb) < sizeof(struct iphdr))
-		return NF_ACCEPT;
+	/* LOCAL_IN/FORWARD: */
 	return ipt_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv4.iptable_filter);
+			    dev_net(in)->ipv4.iptable_filter);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
-		.hook		= ipt_local_in_hook,
+		.hook		= iptable_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		= ipt_hook,
+		.hook		= iptable_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		= ipt_local_out_hook,
+		.hook		= iptable_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index e07bf24..4e699cd 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -71,51 +71,6 @@ static const struct xt_table packet_mangler = {
 	.af		= NFPROTO_IPV4,
 };
 
-/* The work comes in here from netfilter.c. */
-static unsigned int
-ipt_pre_routing_hook(unsigned int hook,
-		     struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
-{
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_mangle);
-}
-
-static unsigned int
-ipt_post_routing_hook(unsigned int hook,
-		      struct sk_buff *skb,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      int (*okfn)(struct sk_buff *))
-{
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv4.iptable_mangle);
-}
-
-static unsigned int
-ipt_local_in_hook(unsigned int hook,
-		  struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  int (*okfn)(struct sk_buff *))
-{
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_mangle);
-}
-
-static unsigned int
-ipt_forward_hook(unsigned int hook,
-	 struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 int (*okfn)(struct sk_buff *))
-{
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_mangle);
-}
-
 static unsigned int
 ipt_local_hook(unsigned int hook,
 		   struct sk_buff *skb,
@@ -158,37 +113,53 @@ ipt_local_hook(unsigned int hook,
 	return ret;
 }
 
+/* The work comes in here from netfilter.c. */
+static unsigned int
+iptable_mangle_hook(unsigned int hook,
+		     struct sk_buff *skb,
+		     const struct net_device *in,
+		     const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
+{
+	if (hook == NF_INET_LOCAL_OUT)
+		return ipt_local_hook(hook, skb, in, out, okfn);
+
+	/* PREROUTING/INPUT/FORWARD: */
+	return ipt_do_table(skb, hook, in, out,
+			    dev_net(in)->ipv4.iptable_mangle);
+}
+
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
-		.hook		= ipt_pre_routing_hook,
+		.hook		= iptable_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		= ipt_local_in_hook,
+		.hook		= iptable_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		= ipt_forward_hook,
+		.hook		= iptable_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		= ipt_local_hook,
+		.hook		= iptable_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		= ipt_post_routing_hook,
+		.hook		= iptable_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 40f2b9f..2e5d4fc 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -45,23 +45,17 @@ static const struct xt_table packet_raw = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ipt_hook(unsigned int hook,
+iptable_raw_hook(unsigned int hook,
 	 struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_raw);
-}
+	if (hook == NF_INET_PRE_ROUTING)
+		return ipt_do_table(skb, hook, in, out,
+				    dev_net(in)->ipv4.iptable_raw);
 
-static unsigned int
-ipt_local_hook(unsigned int hook,
-	       struct sk_buff *skb,
-	       const struct net_device *in,
-	       const struct net_device *out,
-	       int (*okfn)(struct sk_buff *))
-{
+	/* OUTPUT: */
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct iphdr) ||
 	    ip_hdrlen(skb) < sizeof(struct iphdr))
@@ -73,14 +67,14 @@ ipt_local_hook(unsigned int hook,
 /* 'raw' is the very first table. */
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
-		.hook = ipt_hook,
+		.hook = iptable_raw_hook,
 		.pf = NFPROTO_IPV4,
 		.hooknum = NF_INET_PRE_ROUTING,
 		.priority = NF_IP_PRI_RAW,
 		.owner = THIS_MODULE,
 	},
 	{
-		.hook = ipt_local_hook,
+		.hook = iptable_raw_hook,
 		.pf = NFPROTO_IPV4,
 		.hooknum = NF_INET_LOCAL_OUT,
 		.priority = NF_IP_PRI_RAW,
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 7ce2366..78aa2a3 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -65,59 +65,44 @@ static const struct xt_table security_table = {
 };
 
 static unsigned int
-ipt_local_in_hook(unsigned int hook,
+iptable_security_hook(unsigned int hook,
 		  struct sk_buff *skb,
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_security);
-}
+	if (hook == NF_INET_LOCAL_OUT) {
+		if (skb->len < sizeof(struct iphdr) ||
+		    ip_hdrlen(skb) < sizeof(struct iphdr))
+			/* Somebody is playing with raw sockets. */
+			return NF_ACCEPT;
 
-static unsigned int
-ipt_forward_hook(unsigned int hook,
-		 struct sk_buff *skb,
-		 const struct net_device *in,
-		 const struct net_device *out,
-		 int (*okfn)(struct sk_buff *))
-{
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_security);
-}
+		return ipt_do_table(skb, hook, in, out,
+				    dev_net(out)->ipv4.iptable_security);
+	}
 
-static unsigned int
-ipt_local_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
-{
-	/* Somebody is playing with raw sockets. */
-	if (skb->len < sizeof(struct iphdr) ||
-	    ip_hdrlen(skb) < sizeof(struct iphdr))
-		return NF_ACCEPT;
+	/* INPUT/FORWARD: */
 	return ipt_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv4.iptable_security);
+			    dev_net(in)->ipv4.iptable_security);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
-		.hook		= ipt_local_in_hook,
+		.hook		= iptable_security_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_SECURITY,
 	},
 	{
-		.hook		= ipt_forward_hook,
+		.hook		= iptable_security_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP_PRI_SECURITY,
 	},
 	{
-		.hook		= ipt_local_out_hook,
+		.hook		= iptable_security_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 33ddfe5..c442e33 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -60,54 +60,38 @@ static const struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6t_in_hook(unsigned int hook,
+ip6table_filter_hook(unsigned int hook,
 		   struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_filter);
-}
-
-static unsigned int
-ip6t_local_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
-{
-#if 0
-	/* root is playing with raw sockets. */
-	if (skb->len < sizeof(struct iphdr) ||
-	    ip_hdrlen(skb) < sizeof(struct iphdr)) {
-		if (net_ratelimit())
-			printk("ip6t_hook: happy cracking.\n");
-		return NF_ACCEPT;
-	}
-#endif
+	if (hook == NF_INET_LOCAL_OUT)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv6.ip6table_filter);
 
+	/* INPUT/FORWARD: */
 	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv6.ip6table_filter);
+			     dev_net(in)->ipv6.ip6table_filter);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-		.hook		= ip6t_in_hook,
+		.hook		= ip6table_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
-		.hook		= ip6t_in_hook,
+		.hook		= ip6table_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
-		.hook		= ip6t_local_out_hook,
+		.hook		= ip6table_filter_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 9bc483f..8e5f584 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -64,33 +64,9 @@ static const struct xt_table packet_mangler = {
 	.af		= NFPROTO_IPV6,
 };
 
-/* The work comes in here from netfilter.c. */
-static unsigned int
-ip6t_in_hook(unsigned int hook,
-	 struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 int (*okfn)(struct sk_buff *))
-{
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_mangle);
-}
-
-static unsigned int
-ip6t_post_routing_hook(unsigned int hook,
-		struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		int (*okfn)(struct sk_buff *))
-{
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv6.ip6table_mangle);
-}
-
 static unsigned int
 ip6t_local_out_hook(unsigned int hook,
 		   struct sk_buff *skb,
-		   const struct net_device *in,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
@@ -119,7 +95,7 @@ ip6t_local_out_hook(unsigned int hook,
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, hook, in, out,
+	ret = ip6t_do_table(skb, hook, NULL, out,
 			    dev_net(out)->ipv6.ip6table_mangle);
 
 	if (ret != NF_DROP && ret != NF_STOLEN &&
@@ -132,37 +108,53 @@ ip6t_local_out_hook(unsigned int hook,
 	return ret;
 }
 
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ip6table_mangle_hook(unsigned int hook,
+	 struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sk_buff *))
+{
+	if (hook == NF_INET_LOCAL_OUT)
+		return ip6t_local_out_hook(hook, skb, out, okfn);
+
+	/* INPUT/FORWARD */
+	return ip6t_do_table(skb, hook, in, out,
+			     dev_net(in)->ipv6.ip6table_mangle);
+}
+
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-		.hook		= ip6t_in_hook,
+		.hook		= ip6table_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		= ip6t_in_hook,
+		.hook		= ip6table_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		= ip6t_in_hook,
+		.hook		= ip6table_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		= ip6t_local_out_hook,
+		.hook		= ip6table_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		= ip6t_post_routing_hook,
+		.hook		= ip6table_mangle_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 4c90b55..5ef3e1f 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -44,37 +44,31 @@ static const struct xt_table packet_raw = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6t_pre_routing_hook(unsigned int hook,
+ip6table_raw_hook(unsigned int hook,
 	 struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_raw);
-}
+	if (hook == NF_INET_PRE_ROUTING)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(in)->ipv6.ip6table_raw);
 
-static unsigned int
-ip6t_local_out_hook(unsigned int hook,
-	 struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 int (*okfn)(struct sk_buff *))
-{
+	/* OUTPUT: */
 	return ip6t_do_table(skb, hook, in, out,
 			     dev_net(out)->ipv6.ip6table_raw);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-	  .hook = ip6t_pre_routing_hook,
+	  .hook = ip6table_raw_hook,
 	  .pf = NFPROTO_IPV6,
 	  .hooknum = NF_INET_PRE_ROUTING,
 	  .priority = NF_IP6_PRI_FIRST,
 	  .owner = THIS_MODULE,
 	},
 	{
-	  .hook = ip6t_local_out_hook,
+	  .hook = ip6table_raw_hook,
 	  .pf = NFPROTO_IPV6,
 	  .hooknum = NF_INET_LOCAL_OUT,
 	  .priority = NF_IP6_PRI_FIRST,
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index baa8d4e..456bd63 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -64,56 +64,38 @@ static const struct xt_table security_table = {
 };
 
 static unsigned int
-ip6t_local_in_hook(unsigned int hook,
+ip6table_security_hook(unsigned int hook,
 		   struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_security);
-}
+	if (hook == NF_INET_LOCAL_OUT)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv6.ip6table_security);
 
-static unsigned int
-ip6t_forward_hook(unsigned int hook,
-		  struct sk_buff *skb,
-		  const struct net_device *in,
-		  const struct net_device *out,
-		  int (*okfn)(struct sk_buff *))
-{
+	/* INPUT/FORWARD: */
 	return ip6t_do_table(skb, hook, in, out,
 			     dev_net(in)->ipv6.ip6table_security);
 }
 
-static unsigned int
-ip6t_local_out_hook(unsigned int hook,
-		    struct sk_buff *skb,
-		    const struct net_device *in,
-		    const struct net_device *out,
-		    int (*okfn)(struct sk_buff *))
-{
-	/* TBD: handle short packets via raw socket */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv6.ip6table_security);
-}
-
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-		.hook		= ip6t_local_in_hook,
+		.hook		= ip6table_security_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_SECURITY,
 	},
 	{
-		.hook		= ip6t_forward_hook,
+		.hook		= ip6table_security_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP6_PRI_SECURITY,
 	},
 	{
-		.hook		= ip6t_local_out_hook,
+		.hook		= ip6table_security_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
-- 
1.6.6.1

