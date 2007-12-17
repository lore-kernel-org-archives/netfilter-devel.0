From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/64]: ip6_tables: kill a few useless defines/forward declarations
Date: Tue, 18 Dec 2007 00:46:23 +0100 (MET)
Message-ID: <20071217234623.23601.27782.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38903 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbXLQXqY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:24 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: kill a few useless defines/forward declarations

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit de6db21852632a229cad718da30eb526b6b46da9
tree 126da5bbf294091699aada9feff9b0286a59d04f
parent 8803d89ba96c5169a1183647f2753822f36faeff
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:43 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 16:05:13 +0100

 net/ipv6/netfilter/ip6_tables.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d3e884a..b73e6b6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -31,9 +31,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv6 packet filter");
 
-#define IPV6_HDR_LEN	(sizeof(struct ipv6hdr))
-#define IPV6_OPTHDR_LEN	(sizeof(struct ipv6_opt_hdr))
-
 /*#define DEBUG_IP_FIREWALL*/
 /*#define DEBUG_ALLOW_ALL*/ /* Useful for remote debugging */
 /*#define DEBUG_IP_FIREWALL_USER*/
@@ -76,12 +73,6 @@ do {								\
 
    Hence the start of any table is given by get_table() below.  */
 
-#if 0
-#define down(x) do { printk("DOWN:%u:" #x "\n", __LINE__); down(x); } while(0)
-#define down_interruptible(x) ({ int __r; printk("DOWNi:%u:" #x "\n", __LINE__); __r = down_interruptible(x); if (__r != 0) printk("ABORT-DOWNi:%u\n", __LINE__); __r; })
-#define up(x) do { printk("UP:%u:" #x "\n", __LINE__); up(x); } while(0)
-#endif
-
 /* Check for an extension */
 int
 ip6t_ext_hdr(u8 nexthdr)
@@ -399,9 +390,8 @@ ip6t_do_table(struct sk_buff *skb,
 				goto no_match;
 
 			ADD_COUNTER(e->counters,
-				    ntohs(ipv6_hdr(skb)->payload_len)
-				    + IPV6_HDR_LEN,
-				    1);
+				    ntohs(ipv6_hdr(skb)->payload_len) +
+				    sizeof(struct ipv6hdr), 1);
 
 			t = ip6t_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
@@ -657,8 +647,6 @@ err:
 	return ret;
 }
 
-static struct xt_target ip6t_standard_target;
-
 static inline int
 check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	    unsigned int *i)
