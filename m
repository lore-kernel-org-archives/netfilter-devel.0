From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 022/103] netfilter: xtables: compact table hook functions
Date: Tue,  4 Aug 2009 09:25:06 +0200
Message-ID: <1249370787-17583-23-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50624 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549AbZHDH05 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:57 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arptable_filter.c   |    9 ++-------
 net/ipv4/netfilter/iptable_filter.c    |   12 +++++-------
 net/ipv4/netfilter/iptable_mangle.c    |    9 ++-------
 net/ipv4/netfilter/iptable_raw.c       |   19 +++++++++----------
 net/ipv4/netfilter/iptable_security.c  |   12 +++++-------
 net/ipv6/netfilter/ip6table_filter.c   |    9 ++-------
 net/ipv6/netfilter/ip6table_mangle.c   |    9 ++-------
 net/ipv6/netfilter/ip6table_raw.c      |    9 ++-------
 net/ipv6/netfilter/ip6table_security.c |    9 ++-------
 9 files changed, 31 insertions(+), 66 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index e46123e..3092d74 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -59,13 +59,8 @@ static unsigned int arptable_filter_hook(unsigned int hook,
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_ARP_OUT)
-		return arpt_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv4.arptable_filter);
-
-	/* INPUT/FORWARD: */
-	return arpt_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv4.arptable_filter);
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	return arpt_do_table(skb, hook, in, out, net->ipv4.arptable_filter);
 }
 
 static struct nf_hook_ops arpt_ops[] __read_mostly = {
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 26a4ff5..8eaef4a 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -67,18 +67,16 @@ iptable_filter_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT) {
+	const struct net *net;
+
+	if (hook == NF_INET_LOCAL_OUT)
 		/* root is playing with raw sockets. */
 		if (skb->len < sizeof(struct iphdr) ||
 		    ip_hdrlen(skb) < sizeof(struct iphdr))
 			return NF_ACCEPT;
-		return ipt_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv4.iptable_filter);
-	}
 
-	/* LOCAL_IN/FORWARD: */
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_filter);
+	net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_filter);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index e5e4233..c55c371 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -79,13 +79,8 @@ iptable_mangle_hook(unsigned int hook,
 		     const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_POST_ROUTING)
-		return ipt_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv4.iptable_mangle);
-
-	/* PREROUTING/INPUT/FORWARD: */
-	return ipt_do_table(skb, hook, in, out,
-	       dev_net(in)->ipv4.iptable_mangle);
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_mangle);
 }
 
 static unsigned int
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index e7021d1..b7d5257 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -51,17 +51,16 @@ iptable_raw_hook(unsigned int hook,
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
-		return NF_ACCEPT;
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv4.iptable_raw);
+	const struct net *net;
+
+	if (hook == NF_INET_LOCAL_OUT)
+		/* root is playing with raw sockets. */
+		if (skb->len < sizeof(struct iphdr) ||
+		    ip_hdrlen(skb) < sizeof(struct iphdr))
+			return NF_ACCEPT;
+
+	net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_raw);
 }
 
 /* 'raw' is the very first table. */
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 1686f90..d8ceb64 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -71,18 +71,16 @@ iptable_security_hook(unsigned int hook,
 		  const struct net_device *out,
 		  int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT) {
+	const struct net *net;
+
+	if (hook == NF_INET_LOCAL_OUT)
 		/* Somebody is playing with raw sockets. */
 		if (skb->len < sizeof(struct iphdr)
 		    || ip_hdrlen(skb) < sizeof(struct iphdr))
 			return NF_ACCEPT;
-		return ipt_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv4.iptable_security);
-	}
 
-	/* INPUT/FORWARD: */
-	return ipt_do_table(skb, hook, in, out,
-			    dev_net(in)->ipv4.iptable_security);
+	net = dev_net((in != NULL) ? in : out);
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_security);
 }
 
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 1b8c64f..79a302e 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -66,13 +66,8 @@ ip6table_filter_hook(unsigned int hook,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
-		return ip6t_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv6.ip6table_filter);
-
-	/* INPUT/FORWARD: */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_filter);
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 17bb452..6fd2c37 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -72,13 +72,8 @@ ip6table_mangle_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_POST_ROUTING)
-		return ip6t_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv6.ip6table_mangle);
-
-	/* INPUT/FORWARD */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_mangle);
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_mangle);
 }
 
 static unsigned int
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 2b758ec..75c5c44 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -50,13 +50,8 @@ ip6table_raw_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_PRE_ROUTING)
-		return ip6t_do_table(skb, hook, in, out,
-		       dev_net(in)->ipv6.ip6table_raw);
-
-	/* OUTPUT: */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv6.ip6table_raw);
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_raw);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 51223eb..7d9781e 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -70,13 +70,8 @@ ip6table_security_hook(unsigned int hook,
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
-		return ip6t_do_table(skb, hook, in, out,
-		       dev_net(out)->ipv6.ip6table_security);
-
-	/* INPUT/FORWARD: */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_security);
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_security);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
-- 
1.6.3.3

