From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] netfilter: xtables: compact table hook functions
Date: Mon, 10 Aug 2009 21:19:48 +0200
Message-ID: <1249931992-18761-3-git-send-email-jengelh@medozas.de>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33979 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZHJTUB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:20:01 -0400
In-Reply-To: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The calls to ip6t_do_table only show minimal differences, so it seems
like a good cleanup to merge them to a single one too.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arptable_filter.c   |    8 ++------
 net/ipv4/netfilter/iptable_filter.c    |   18 +++++++-----------
 net/ipv4/netfilter/iptable_raw.c       |   16 +++++++---------
 net/ipv4/netfilter/iptable_security.c  |   18 +++++++-----------
 net/ipv6/netfilter/ip6table_filter.c   |    8 ++------
 net/ipv6/netfilter/ip6table_raw.c      |    8 ++------
 net/ipv6/netfilter/ip6table_security.c |    8 ++------
 7 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c9b3b71..b48ac6f 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -59,13 +59,9 @@ static unsigned int arptable_filter_hook(unsigned int hook,
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_ARP_OUT)
-		return arpt_do_table(skb, hook, in, out,
-				     dev_net(out)->ipv4.arptable_filter);
+	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	/* INPUT/FORWARD: */
-	return arpt_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv4.arptable_filter);
+	return arpt_do_table(skb, hook, in, out, net->ipv4.arptable_filter);
 }
 
 static struct nf_hook_ops arpt_ops[] __read_mostly = {
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 84f197a..73bda90 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -67,19 +67,15 @@ iptable_filter_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT) {
-		if (skb->len < sizeof(struct iphdr) ||
-		    ip_hdrlen(skb) < sizeof(struct iphdr))
-			/* root is playing with raw sockets. */
-			return NF_ACCEPT;
-
-		return ipt_do_table(skb, hook, in, out,
-				    dev_net(out)->ipv4.iptable_filter);
-	}
+	const struct net *net;
+
+	if (hook == NF_INET_LOCAL_OUT && (skb->len < sizeof(struct iphdr) ||
+	    ip_hdrlen(skb) < sizeof(struct iphdr)))
+		/* root is playing with raw sockets. */
+		return NF_ACCEPT;
 
-	/* LOCAL_IN/FORWARD: */
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_filter);
+	net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_filter);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index c6733c8..5fe83b2 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -51,17 +51,15 @@ iptable_raw_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_PRE_ROUTING)
-		return ipt_do_table(skb, hook, in, out,
-		       dev_net(in)->ipv4.iptable_raw);
-
-	/* OUTPUT: */
-	/* root is playing with raw sockets. */
-	if (skb->len < sizeof(struct iphdr) ||
-	    ip_hdrlen(skb) < sizeof(struct iphdr))
+	const struct net *net;
+
+	if (hook == NF_INET_LOCAL_OUT && (skb->len < sizeof(struct iphdr) ||
+	    ip_hdrlen(skb) < sizeof(struct iphdr)))
+		/* root is playing with raw sockets. */
 		return NF_ACCEPT;
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv4.iptable_raw);
+
+	net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_raw);
 }
 
 /* 'raw' is the very first table. */
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index aef8ba9..a308219 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -71,19 +71,15 @@ iptable_security_hook(unsigned int hook,
 		  const struct net_device *out,
 		  int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT) {
-		if (skb->len < sizeof(struct iphdr) ||
-		    ip_hdrlen(skb) < sizeof(struct iphdr))
-			/* Somebody is playing with raw sockets. */
-			return NF_ACCEPT;
-
-		return ipt_do_table(skb, hook, in, out,
-				    dev_net(out)->ipv4.iptable_security);
-	}
-
-	/* INPUT/FORWARD: */
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_security);
+	const struct net *net;
+
+	if (hook == NF_INET_LOCAL_OUT && (skb->len < sizeof(struct iphdr) ||
+	    ip_hdrlen(skb) < sizeof(struct iphdr)))
+		/* Somebody is playing with raw sockets. */
+		return NF_ACCEPT;
+
+	net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_security);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 175e408..c6ad7cd 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -66,13 +66,9 @@ ip6table_filter_hook(unsigned int hook,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
-		return ip6t_do_table(skb, hook, in, out,
-				     dev_net(out)->ipv6.ip6table_filter);
+	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	/* INPUT/FORWARD: */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_filter);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 4bef7a1..f7eaf54 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -50,13 +50,9 @@ ip6table_raw_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_PRE_ROUTING)
-		return ip6t_do_table(skb, hook, in, out,
-				     dev_net(in)->ipv6.ip6table_raw);
+	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	/* OUTPUT: */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv6.ip6table_raw);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_raw);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index a01c3c0..9c9fe7e 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -70,13 +70,9 @@ ip6table_security_hook(unsigned int hook,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
-		return ip6t_do_table(skb, hook, in, out,
-				     dev_net(out)->ipv6.ip6table_security);
+	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	/* INPUT/FORWARD: */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_security);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_security);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
-- 
1.6.4

