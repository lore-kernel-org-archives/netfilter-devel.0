From: Patrick McHardy <kaber@trash.net>
Subject: [netfilter socket hooks 3/5]: Add struct sock * argument to
	ipt_do_table()
Date: Tue, 10 May 2005 18:01:02 +0200
Message-ID: <4280DABE.9010105@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net> <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4280DA51.8090201@trash.net>
Content-Disposition: inline;
 filename="03.diff"
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Add struct sock * argument to ipt_do_table()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2816668ea745b16e1da608bf4d7b638a75389bd6
tree 8bd69ddefbecc96b2253453c6b4da15bbff92988
parent 03a2e97e71c3c9bfbfc3d357544348d393551658
author Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:36:10 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:36:10 +0200

 include/linux/netfilter_ipv4/ip_tables.h |    3 ++-
 net/ipv4/netfilter/ip_nat_rule.c         |    2 +-
 net/ipv4/netfilter/ip_tables.c           |    3 ++-
 net/ipv4/netfilter/iptable_filter.c      |    4 ++--
 net/ipv4/netfilter/iptable_mangle.c      |    4 ++--
 net/ipv4/netfilter/iptable_raw.c         |    2 +-
 6 files changed, 10 insertions(+), 8 deletions(-)

Index: include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- b53df6f327c03ec282a1b75326db321dbd2f0bc0/include/linux/netfilter_ipv4/ip_tables.h  (mode:100644)
+++ 8bd69ddefbecc96b2253453c6b4da15bbff92988/include/linux/netfilter_ipv4/ip_tables.h  (mode:100644)
@@ -478,7 +478,8 @@
 extern int ipt_register_table(struct ipt_table *table,
 			      const struct ipt_replace *repl);
 extern void ipt_unregister_table(struct ipt_table *table);
-extern unsigned int ipt_do_table(struct sk_buff **pskb,
+extern unsigned int ipt_do_table(struct sock *sk,
+				 struct sk_buff **pskb,
 				 unsigned int hook,
 				 const struct net_device *in,
 				 const struct net_device *out,
Index: net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/netfilter/ip_nat_rule.c  (mode:100644)
+++ 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ip_nat_rule.c  (mode:100644)
@@ -264,7 +264,7 @@
 {
 	int ret;
 
-	ret = ipt_do_table(pskb, hooknum, in, out, &nat_table, NULL);
+	ret = ipt_do_table(NULL, pskb, hooknum, in, out, &nat_table, NULL);
 
 	if (ret == NF_ACCEPT) {
 		if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
Index: net/ipv4/netfilter/ip_tables.c
===================================================================
--- b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/netfilter/ip_tables.c  (mode:100644)
+++ 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ip_tables.c  (mode:100644)
@@ -257,7 +257,8 @@
 
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
-ipt_do_table(struct sk_buff **pskb,
+ipt_do_table(struct sock *sk,
+	     struct sk_buff **pskb,
 	     unsigned int hook,
 	     const struct net_device *in,
 	     const struct net_device *out,
Index: net/ipv4/netfilter/iptable_filter.c
===================================================================
--- b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/netfilter/iptable_filter.c  (mode:100644)
+++ 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/iptable_filter.c  (mode:100644)
@@ -89,7 +89,7 @@
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return ipt_do_table(NULL, pskb, hook, in, out, &packet_filter, NULL);
 }
 
 static unsigned int
@@ -107,7 +107,7 @@
 		return NF_ACCEPT;
 	}
 
-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	return ipt_do_table(NULL, pskb, hook, in, out, &packet_filter, NULL);
 }
 
 static struct nf_hook_ops ipt_ops[] = {
Index: net/ipv4/netfilter/iptable_mangle.c
===================================================================
--- b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/netfilter/iptable_mangle.c  (mode:100644)
+++ 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/iptable_mangle.c  (mode:100644)
@@ -119,7 +119,7 @@
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(pskb, hook, in, out, &packet_mangler, NULL);
+	return ipt_do_table(NULL, pskb, hook, in, out, &packet_mangler, NULL);
 }
 
 static unsigned int
@@ -148,7 +148,7 @@
 	daddr = (*pskb)->nh.iph->daddr;
 	tos = (*pskb)->nh.iph->tos;
 
-	ret = ipt_do_table(pskb, hook, in, out, &packet_mangler, NULL);
+	ret = ipt_do_table(NULL, pskb, hook, in, out, &packet_mangler, NULL);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE
 	    && ((*pskb)->nh.iph->saddr != saddr
Index: net/ipv4/netfilter/iptable_raw.c
===================================================================
--- b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/netfilter/iptable_raw.c  (mode:100644)
+++ 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/iptable_raw.c  (mode:100644)
@@ -94,7 +94,7 @@
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ipt_do_table(pskb, hook, in, out, &packet_raw, NULL);
+	return ipt_do_table(NULL, pskb, hook, in, out, &packet_raw, NULL);
 }
 
 /* 'raw' is the very first table. */
