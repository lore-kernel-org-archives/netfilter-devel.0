From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/6]: Remove skb_linearize in ip6tables
Date: Tue, 11 Jan 2005 13:49:51 +0100
Message-ID: <41E3CB6F.9090001@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080104000607040007030108"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------080104000607040007030108
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------080104000607040007030108
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 03:42:12+01:00 kaber@coreworks.de 
#   [NETFILTER]: Remove skb_linearize in ip6tables
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6table_mangle.c
#   2005/01/11 03:42:05+01:00 kaber@coreworks.de +0 -4
#   [NETFILTER]: Remove skb_linearize in ip6tables
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/01/11 03:42:05+01:00 kaber@coreworks.de +0 -4
#   [NETFILTER]: Remove skb_linearize in ip6tables
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:39:42 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:39:42 +01:00
@@ -366,10 +366,6 @@
 	void *table_base;
 	struct ip6t_entry *e, *back;
 
-	/* FIXME: Push down to extensions --RR */
-	if (skb_is_nonlinear(*pskb) && skb_linearize(*pskb, GFP_ATOMIC) != 0)
-		return NF_DROP;
-
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
 	outdev = out ? out->name : nulldevname;
diff -Nru a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
--- a/net/ipv6/netfilter/ip6table_mangle.c	2005-01-11 13:39:42 +01:00
+++ b/net/ipv6/netfilter/ip6table_mangle.c	2005-01-11 13:39:42 +01:00
@@ -165,10 +165,6 @@
 	}
 #endif
 
-	/* FIXME: Push down to extensions --RR */
-	if (skb_is_nonlinear(*pskb) && skb_linearize(*pskb, GFP_ATOMIC) != 0)
-		return NF_DROP;
-
 	/* save source/dest address, nfmark, hoplimit, flowlabel, priority,  */
 	memcpy(&saddr, &(*pskb)->nh.ipv6h->saddr, sizeof(saddr));
 	memcpy(&daddr, &(*pskb)->nh.ipv6h->daddr, sizeof(daddr));

--------------080104000607040007030108--
