From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] netfilter: xtables: compact table hook functions (2/2)
Date: Wed, 10 Feb 2010 15:59:11 +0100
Message-ID: <1265813954-13854-3-git-send-email-jengelh@medozas.de>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49989 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab0BJO70 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:59:26 -0500
In-Reply-To: <1265813954-13854-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The calls to ip6t_do_table only show minimal differences, so it seems
like a good cleanup to merge them to a single one too.
Space saving obtained by both patches: 6807725->6807373
("Total" column from `size -A`.)

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
index 78bb72e..6e94b41 100644
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
index b320208..7f64ea5 100644
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
index 2e5d4fc..766c6fd 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -51,17 +51,15 @@ iptable_raw_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_PRE_ROUTING)
-		return ipt_do_table(skb, hook, in, out,
-				    dev_net(in)->ipv4.iptable_raw);
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
index 78aa2a3..02c5140 100644
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
index c442e33..51b79bf 100644
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
index 5ef3e1f..6b9e6dd 100644
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
index 456bd63..b45a616 100644
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
1.6.6.1

