From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] netfilter: xtables: consolidate table hook functions
Date: Mon, 10 Aug 2009 21:19:47 +0200
Message-ID: <1249931992-18761-2-git-send-email-jengelh@medozas.de>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33976 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHJTUA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:20:00 -0400
In-Reply-To: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46or a following patch in this series ("generate nf hook ops on
demand"), we will be requiring that a single hook entry function per
table does the processing. Would this not be done would I need to
pass multiple hook functions as arguments in that later patch, which
would have been not so nice.

This also removes exact duplicates of some hook functions=C2=A0=E2=80=94
ipt_pre_routing_hook, ipt_local_in_hook and ipt_forward_hook in
iptable_mangle.c all did the same.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arptable_filter.c   |   23 ++++------
 net/ipv4/netfilter/iptable_filter.c    |   46 +++++++--------------
 net/ipv4/netfilter/iptable_mangle.c    |   71 +++++++++---------------=
-------
 net/ipv4/netfilter/iptable_raw.c       |   20 +++------
 net/ipv4/netfilter/iptable_security.c  |   43 ++++++-------------
 net/ipv6/netfilter/ip6table_filter.c   |   34 ++++-----------
 net/ipv6/netfilter/ip6table_mangle.c   |   49 +++++++++------------
 net/ipv6/netfilter/ip6table_raw.c      |   20 +++------
 net/ipv6/netfilter/ip6table_security.c |   34 ++++------------
 9 files changed, 111 insertions(+), 229 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/=
arptable_filter.c
index 6ecfdae..c9b3b71 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -53,43 +53,38 @@ static struct xt_table packet_filter =3D {
 };
=20
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
+	if (hook =3D=3D NF_ARP_OUT)
+		return arpt_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv4.arptable_filter);
=20
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
=20
 static struct nf_hook_ops arpt_ops[] __read_mostly =3D {
 	{
-		.hook		=3D arpt_in_hook,
+		.hook		=3D arptable_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_ARP,
 		.hooknum	=3D NF_ARP_IN,
 		.priority	=3D NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		=3D arpt_out_hook,
+		.hook		=3D arptable_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_ARP,
 		.hooknum	=3D NF_ARP_OUT,
 		.priority	=3D NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		=3D arpt_in_hook,
+		.hook		=3D arptable_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_ARP,
 		.hooknum	=3D NF_ARP_FORWARD,
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/i=
ptable_filter.c
index 97dbd94..84f197a 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -60,61 +60,45 @@ static struct xt_table packet_filter =3D {
 	.af		=3D NFPROTO_IPV4,
 };
=20
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
+	if (hook =3D=3D NF_INET_LOCAL_OUT) {
+		if (skb->len < sizeof(struct iphdr) ||
+		    ip_hdrlen(skb) < sizeof(struct iphdr))
+			/* root is playing with raw sockets. */
+			return NF_ACCEPT;
+
+		return ipt_do_table(skb, hook, in, out,
+				    dev_net(out)->ipv4.iptable_filter);
+	}
=20
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
=20
 static struct nf_hook_ops ipt_ops[] __read_mostly =3D {
 	{
-		.hook		=3D ipt_local_in_hook,
+		.hook		=3D iptable_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_LOCAL_IN,
 		.priority	=3D NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		=3D ipt_hook,
+		.hook		=3D iptable_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_FORWARD,
 		.priority	=3D NF_IP_PRI_FILTER,
 	},
 	{
-		.hook		=3D ipt_local_out_hook,
+		.hook		=3D iptable_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_LOCAL_OUT,
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/i=
ptable_mangle.c
index 28647f1..0dd4c67 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -71,51 +71,6 @@ static struct xt_table packet_mangler =3D {
 	.af		=3D NFPROTO_IPV4,
 };
=20
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
=20
+/* The work comes in here from netfilter.c. */
+static unsigned int
+iptable_mangle_hook(unsigned int hook,
+		     struct sk_buff *skb,
+		     const struct net_device *in,
+		     const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
+{
+	if (hook =3D=3D NF_INET_LOCAL_OUT)
+		return ipt_local_hook(hook, skb, in, out, okfn);
+
+	/* PREROUTING/INPUT/FORWARD: */
+	return ipt_do_table(skb, hook, in, out,
+	       dev_net(in)->ipv4.iptable_mangle);
+}
+
 static struct nf_hook_ops ipt_ops[] __read_mostly =3D {
 	{
-		.hook		=3D ipt_pre_routing_hook,
+		.hook		=3D iptable_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_PRE_ROUTING,
 		.priority	=3D NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ipt_local_in_hook,
+		.hook		=3D iptable_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_LOCAL_IN,
 		.priority	=3D NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ipt_forward_hook,
+		.hook		=3D iptable_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_FORWARD,
 		.priority	=3D NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ipt_local_hook,
+		.hook		=3D iptable_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_LOCAL_OUT,
 		.priority	=3D NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ipt_post_routing_hook,
+		.hook		=3D iptable_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_POST_ROUTING,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/ipta=
ble_raw.c
index 494784c..c6733c8 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -45,23 +45,17 @@ static struct xt_table packet_raw =3D {
=20
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
+	if (hook =3D=3D NF_INET_PRE_ROUTING)
+		return ipt_do_table(skb, hook, in, out,
+		       dev_net(in)->ipv4.iptable_raw);
=20
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
 static struct nf_hook_ops ipt_ops[] __read_mostly =3D {
 	{
-		.hook =3D ipt_hook,
+		.hook =3D iptable_raw_hook,
 		.pf =3D NFPROTO_IPV4,
 		.hooknum =3D NF_INET_PRE_ROUTING,
 		.priority =3D NF_IP_PRI_RAW,
 		.owner =3D THIS_MODULE,
 	},
 	{
-		.hook =3D ipt_local_hook,
+		.hook =3D iptable_raw_hook,
 		.pf =3D NFPROTO_IPV4,
 		.hooknum =3D NF_INET_LOCAL_OUT,
 		.priority =3D NF_IP_PRI_RAW,
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter=
/iptable_security.c
index 8804e1a..aef8ba9 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -65,59 +65,44 @@ static struct xt_table security_table =3D {
 };
=20
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
+	if (hook =3D=3D NF_INET_LOCAL_OUT) {
+		if (skb->len < sizeof(struct iphdr) ||
+		    ip_hdrlen(skb) < sizeof(struct iphdr))
+			/* Somebody is playing with raw sockets. */
+			return NF_ACCEPT;
=20
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
=20
-static unsigned int
-ipt_local_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
-{
-	/* Somebody is playing with raw sockets. */
-	if (skb->len < sizeof(struct iphdr)
-	    || ip_hdrlen(skb) < sizeof(struct iphdr))
-		return NF_ACCEPT;
+	/* INPUT/FORWARD: */
 	return ipt_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv4.iptable_security);
+			    dev_net(in)->ipv4.iptable_security);
 }
=20
 static struct nf_hook_ops ipt_ops[] __read_mostly =3D {
 	{
-		.hook		=3D ipt_local_in_hook,
+		.hook		=3D iptable_security_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_LOCAL_IN,
 		.priority	=3D NF_IP_PRI_SECURITY,
 	},
 	{
-		.hook		=3D ipt_forward_hook,
+		.hook		=3D iptable_security_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_FORWARD,
 		.priority	=3D NF_IP_PRI_SECURITY,
 	},
 	{
-		.hook		=3D ipt_local_out_hook,
+		.hook		=3D iptable_security_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV4,
 		.hooknum	=3D NF_INET_LOCAL_OUT,
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/=
ip6table_filter.c
index 0a3ae48..175e408 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -60,54 +60,38 @@ static struct xt_table packet_filter =3D {
=20
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
-	if (skb->len < sizeof(struct iphdr)
-	    || ip_hdrlen(skb) < sizeof(struct iphdr)) {
-		if (net_ratelimit())
-			printk("ip6t_hook: happy cracking.\n");
-		return NF_ACCEPT;
-	}
-#endif
+	if (hook =3D=3D NF_INET_LOCAL_OUT)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv6.ip6table_filter);
=20
+	/* INPUT/FORWARD: */
 	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(out)->ipv6.ip6table_filter);
+			     dev_net(in)->ipv6.ip6table_filter);
 }
=20
 static struct nf_hook_ops ip6t_ops[] __read_mostly =3D {
 	{
-		.hook		=3D ip6t_in_hook,
+		.hook		=3D ip6table_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_LOCAL_IN,
 		.priority	=3D NF_IP6_PRI_FILTER,
 	},
 	{
-		.hook		=3D ip6t_in_hook,
+		.hook		=3D ip6table_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_FORWARD,
 		.priority	=3D NF_IP6_PRI_FILTER,
 	},
 	{
-		.hook		=3D ip6t_local_out_hook,
+		.hook		=3D ip6table_filter_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_LOCAL_OUT,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/=
ip6table_mangle.c
index 0f49e00..63abcec 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -64,29 +64,6 @@ static struct xt_table packet_mangler =3D {
 	.af		=3D NFPROTO_IPV6,
 };
=20
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
@@ -132,37 +109,53 @@ ip6t_local_out_hook(unsigned int hook,
 	return ret;
 }
=20
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ip6table_mangle_hook(unsigned int hook,
+	 struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sk_buff *))
+{
+	if (hook =3D=3D NF_INET_LOCAL_OUT)
+		return ip6t_loacl_out_hook(hook, skb, hook, in, okfn);
+
+	/* INPUT/FORWARD */
+	return ip6t_do_table(skb, hook, in, out,
+			     dev_net(in)->ipv6.ip6table_mangle);
+}
+
 static struct nf_hook_ops ip6t_ops[] __read_mostly =3D {
 	{
-		.hook		=3D ip6t_in_hook,
+		.hook		=3D ip6table_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_PRE_ROUTING,
 		.priority	=3D NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ip6t_in_hook,
+		.hook		=3D ip6table_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_LOCAL_IN,
 		.priority	=3D NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ip6t_in_hook,
+		.hook		=3D ip6table_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_FORWARD,
 		.priority	=3D NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ip6t_local_out_hook,
+		.hook		=3D ip6table_mangle_out_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_LOCAL_OUT,
 		.priority	=3D NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ip6t_post_routing_hook,
+		.hook		=3D ip6table_mangle_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_POST_ROUTING,
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6=
table_raw.c
index 679865e..4bef7a1 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -44,37 +44,31 @@ static struct xt_table packet_raw =3D {
=20
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
+	if (hook =3D=3D NF_INET_PRE_ROUTING)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(in)->ipv6.ip6table_raw);
=20
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
=20
 static struct nf_hook_ops ip6t_ops[] __read_mostly =3D {
 	{
-	  .hook =3D ip6t_pre_routing_hook,
+	  .hook =3D ip6table_raw_hook,
 	  .pf =3D NFPROTO_IPV6,
 	  .hooknum =3D NF_INET_PRE_ROUTING,
 	  .priority =3D NF_IP6_PRI_FIRST,
 	  .owner =3D THIS_MODULE,
 	},
 	{
-	  .hook =3D ip6t_local_out_hook,
+	  .hook =3D ip6table_raw_hook,
 	  .pf =3D NFPROTO_IPV6,
 	  .hooknum =3D NF_INET_LOCAL_OUT,
 	  .priority =3D NF_IP6_PRI_FIRST,
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilte=
r/ip6table_security.c
index 822afab..a01c3c0 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -64,56 +64,38 @@ static struct xt_table security_table =3D {
 };
=20
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
+	if (hook =3D=3D NF_INET_LOCAL_OUT)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv6.ip6table_security);
=20
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
=20
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
 static struct nf_hook_ops ip6t_ops[] __read_mostly =3D {
 	{
-		.hook		=3D ip6t_local_in_hook,
+		.hook		=3D ip6table_security_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_LOCAL_IN,
 		.priority	=3D NF_IP6_PRI_SECURITY,
 	},
 	{
-		.hook		=3D ip6t_forward_hook,
+		.hook		=3D ip6table_security_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_FORWARD,
 		.priority	=3D NF_IP6_PRI_SECURITY,
 	},
 	{
-		.hook		=3D ip6t_local_out_hook,
+		.hook		=3D ip6table_security_hook,
 		.owner		=3D THIS_MODULE,
 		.pf		=3D NFPROTO_IPV6,
 		.hooknum	=3D NF_INET_LOCAL_OUT,
--=20
1.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
