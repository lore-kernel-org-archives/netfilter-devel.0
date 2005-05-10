From: Patrick McHardy <kaber@trash.net>
Subject: [netfilter socket hooks 4/5]: Add struct sock * argument to match
 functions
Date: Tue, 10 May 2005 18:01:30 +0200
Message-ID: <4280DADA.6070306@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net> <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4280DA51.8090201@trash.net>
Content-Disposition: inline;
 filename="04.diff"
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

[NETFILTER]: Add struct sock * argument to match functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3e78de8c1e4b12407299b48cf9f024786415639f
tree a24014694fc1a7ed32010fe4524b2601c6516eaf
parent 2816668ea745b16e1da608bf4d7b638a75389bd6
author Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:37:19 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:37:19 +0200

 include/linux/netfilter_ipv4/ip_tables.h |    3 ++-
 net/ipv4/netfilter/ip_tables.c           |   14 +++++++++-----
 net/ipv4/netfilter/ipt_addrtype.c        |    6 +++---
 net/ipv4/netfilter/ipt_ah.c              |    3 ++-
 net/ipv4/netfilter/ipt_comment.c         |    3 ++-
 net/ipv4/netfilter/ipt_connmark.c        |    3 ++-
 net/ipv4/netfilter/ipt_conntrack.c       |    3 ++-
 net/ipv4/netfilter/ipt_dscp.c            |    6 +++---
 net/ipv4/netfilter/ipt_ecn.c             |    6 +++---
 net/ipv4/netfilter/ipt_esp.c             |    3 ++-
 net/ipv4/netfilter/ipt_hashlimit.c       |    3 ++-
 net/ipv4/netfilter/ipt_helper.c          |    3 ++-
 net/ipv4/netfilter/ipt_iprange.c         |    3 ++-
 net/ipv4/netfilter/ipt_length.c          |    3 ++-
 net/ipv4/netfilter/ipt_limit.c           |    3 ++-
 net/ipv4/netfilter/ipt_mac.c             |    3 ++-
 net/ipv4/netfilter/ipt_mark.c            |    3 ++-
 net/ipv4/netfilter/ipt_multiport.c       |    6 ++++--
 net/ipv4/netfilter/ipt_owner.c           |    3 ++-
 net/ipv4/netfilter/ipt_physdev.c         |    3 ++-
 net/ipv4/netfilter/ipt_pkttype.c         |   13 +++++++------
 net/ipv4/netfilter/ipt_realm.c           |    3 ++-
 net/ipv4/netfilter/ipt_recent.c          |    8 +++++---
 net/ipv4/netfilter/ipt_sctp.c            |    3 ++-
 net/ipv4/netfilter/ipt_state.c           |    3 ++-
 net/ipv4/netfilter/ipt_tcpmss.c          |    3 ++-
 net/ipv4/netfilter/ipt_tos.c             |    3 ++-
 net/ipv4/netfilter/ipt_ttl.c             |    6 +++---
 28 files changed, 77 insertions(+), 48 deletions(-)

Index: include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/include/linux/netfilter_ipv4/ip_tables.h  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/include/linux/netfilter_ipv4/ip_tables.h  (mode:100644)
@@ -368,7 +368,8 @@
 	/* Arguments changed since 2.4, as this must now handle
            non-linear skbs, using skb_copy_bits and
            skb_ip_make_writable. */
-	int (*match)(const struct sk_buff *skb,
+	int (*match)(const struct sock *sk,
+		     const struct sk_buff *skb,
 		     const struct net_device *in,
 		     const struct net_device *out,
 		     const void *matchinfo,
Index: net/ipv4/netfilter/ip_tables.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ip_tables.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ip_tables.c  (mode:100644)
@@ -236,6 +236,7 @@
 
 static inline
 int do_match(struct ipt_entry_match *m,
+             const struct sock *sk,
 	     const struct sk_buff *skb,
 	     const struct net_device *in,
 	     const struct net_device *out,
@@ -243,7 +244,7 @@
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->data, offset, hotdrop))
+	if (!m->u.kernel.match->match(sk, skb, in, out, m->data, offset, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -319,7 +320,7 @@
 			struct ipt_entry_target *t;
 
 			if (IPT_MATCH_ITERATE(e, do_match,
-					      *pskb, in, out,
+					      sk, *pskb, in, out,
 					      offset, &hotdrop) != 0)
 				goto no_match;
 
@@ -1569,7 +1570,8 @@
 }
 
 static int
-tcp_match(const struct sk_buff *skb,
+tcp_match(const struct sock *sk,
+	  const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  const void *matchinfo,
@@ -1650,7 +1652,8 @@
 }
 
 static int
-udp_match(const struct sk_buff *skb,
+udp_match(const struct sock *sk,
+	  const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  const void *matchinfo,
@@ -1723,7 +1726,8 @@
 }
 
 static int
-icmp_match(const struct sk_buff *skb,
+icmp_match(const struct sock *sk,
+	   const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
 	   const void *matchinfo,
Index: net/ipv4/netfilter/ipt_addrtype.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_addrtype.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_addrtype.c  (mode:100644)
@@ -27,9 +27,9 @@
 	return !!(mask & (1 << inet_addr_type(addr)));
 }
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
-		 int offset, int *hotdrop)
+static int match(const struct sock *sk, const struct sk_buff *skb,
+                 const struct net_device *in, const struct net_device *out,
+                 const void *matchinfo, int offset, int *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = skb->nh.iph;
Index: net/ipv4/netfilter/ipt_ah.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_ah.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_ah.c  (mode:100644)
@@ -36,7 +36,8 @@
 }
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_comment.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_comment.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_comment.c  (mode:100644)
@@ -14,7 +14,8 @@
 MODULE_LICENSE("GPL");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_connmark.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_connmark.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_connmark.c  (mode:100644)
@@ -31,7 +31,8 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_conntrack.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
@@ -19,7 +19,8 @@
 MODULE_DESCRIPTION("iptables connection tracking match module");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_dscp.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_dscp.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_dscp.c  (mode:100644)
@@ -19,9 +19,9 @@
 MODULE_DESCRIPTION("iptables DSCP matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
-		 int offset, int *hotdrop)
+static int match(const struct sock *sk, const struct sk_buff *skb,
+                 const struct net_device *in, const struct net_device *out,
+                 const void *matchinfo, int offset, int *hotdrop)
 {
 	const struct ipt_dscp_info *info = matchinfo;
 	const struct iphdr *iph = skb->nh.iph;
Index: net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_ecn.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_ecn.c  (mode:100644)
@@ -65,9 +65,9 @@
 	return 1;
 }
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
-		 int offset, int *hotdrop)
+static int match(const struct sock *sk, const struct sk_buff *skb,
+                 const struct net_device *in, const struct net_device *out,
+                 const void *matchinfo, int offset, int *hotdrop)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 
Index: net/ipv4/netfilter/ipt_esp.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_esp.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_esp.c  (mode:100644)
@@ -37,7 +37,8 @@
 }
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_hashlimit.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_hashlimit.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_hashlimit.c  (mode:100644)
@@ -425,7 +425,8 @@
 
 
 static int
-hashlimit_match(const struct sk_buff *skb,
+hashlimit_match(const struct sock *sk,
+		const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
 		const void *matchinfo,
Index: net/ipv4/netfilter/ipt_helper.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_helper.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_helper.c  (mode:100644)
@@ -30,7 +30,8 @@
 #endif
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_iprange.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_iprange.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_iprange.c  (mode:100644)
@@ -24,7 +24,8 @@
 #endif
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_length.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_length.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_length.c  (mode:100644)
@@ -17,7 +17,8 @@
 MODULE_LICENSE("GPL");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_limit.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_limit.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_limit.c  (mode:100644)
@@ -63,7 +63,8 @@
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static int
-ipt_limit_match(const struct sk_buff *skb,
+ipt_limit_match(const struct sock *sk,
+		const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
 		const void *matchinfo,
Index: net/ipv4/netfilter/ipt_mac.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_mac.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_mac.c  (mode:100644)
@@ -20,7 +20,8 @@
 MODULE_DESCRIPTION("iptables mac matching module");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_mark.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_mark.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_mark.c  (mode:100644)
@@ -18,7 +18,8 @@
 MODULE_DESCRIPTION("iptables mark matching module");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_multiport.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_multiport.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_multiport.c  (mode:100644)
@@ -92,7 +92,8 @@
 }
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
@@ -123,7 +124,8 @@
 }
 
 static int
-match_v1(const struct sk_buff *skb,
+match_v1(const struct sock *sk,
+	 const struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
 	 const void *matchinfo,
Index: net/ipv4/netfilter/ipt_owner.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_owner.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_owner.c  (mode:100644)
@@ -121,7 +121,8 @@
 }
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_physdev.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_physdev.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_physdev.c  (mode:100644)
@@ -21,7 +21,8 @@
 MODULE_DESCRIPTION("iptables bridge physical device match module");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_pkttype.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_pkttype.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_pkttype.c  (mode:100644)
@@ -17,12 +17,13 @@
 MODULE_AUTHOR("Michal Ludvig <michal@logix.cz>");
 MODULE_DESCRIPTION("IP tables match to match on linklayer packet type");
 
-static int match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
+static int match(const struct sock *sk,
+                 const struct sk_buff *skb,
+                 const struct net_device *in,
+                 const struct net_device *out,
+                 const void *matchinfo,
+                 int offset,
+                 int *hotdrop)
 {
     const struct ipt_pkttype_info *info = matchinfo;
 
Index: net/ipv4/netfilter/ipt_realm.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_realm.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_realm.c  (mode:100644)
@@ -22,7 +22,8 @@
 MODULE_DESCRIPTION("iptables realm match");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_recent.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_recent.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_recent.c  (mode:100644)
@@ -99,7 +99,8 @@
 
 /* Function declaration for later. */
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
@@ -317,7 +318,7 @@
 	skb->nh.iph->daddr = 0;
 	/* Clear ttl since we have no way of knowing it */
 	skb->nh.iph->ttl = 0;
-	match(skb,NULL,NULL,info,0,NULL);
+	match(NULL,skb,NULL,NULL,info,0,NULL);
 
 	kfree(skb->nh.iph);
 out_free_skb:
@@ -352,7 +353,8 @@
  * --seconds and --hitcount can be combined
  */
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_sctp.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_sctp.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_sctp.c  (mode:100644)
@@ -113,7 +113,8 @@
 }
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_state.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_state.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_state.c  (mode:100644)
@@ -19,7 +19,8 @@
 MODULE_DESCRIPTION("iptables connection tracking state match module");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_tcpmss.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_tcpmss.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_tcpmss.c  (mode:100644)
@@ -74,7 +74,8 @@
 }
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_tos.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_tos.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_tos.c  (mode:100644)
@@ -18,7 +18,8 @@
 MODULE_DESCRIPTION("iptables TOS match module");
 
 static int
-match(const struct sk_buff *skb,
+match(const struct sock *sk,
+      const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
Index: net/ipv4/netfilter/ipt_ttl.c
===================================================================
--- 8bd69ddefbecc96b2253453c6b4da15bbff92988/net/ipv4/netfilter/ipt_ttl.c  (mode:100644)
+++ a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/ipt_ttl.c  (mode:100644)
@@ -19,9 +19,9 @@
 MODULE_DESCRIPTION("IP tables TTL matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
-		 int offset, int *hotdrop)
+static int match(const struct sock *sk, const struct sk_buff *skb,
+                 const struct net_device *in, const struct net_device *out,
+                 const void *matchinfo, int offset, int *hotdrop)
 {
 	const struct ipt_ttl_info *info = matchinfo;
 
