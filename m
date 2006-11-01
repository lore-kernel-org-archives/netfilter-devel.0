From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 10/11] Remove unused struct list_head from protocols
Date: Wed, 01 Nov 2006 22:08:55 +0100
Message-ID: <20061101210914.693243726@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=l3l4-no-list
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

Remove unused struct list_head from struct nf_conntrack_l3proto
and nf_conntrack_l4proto as all protocols are kept in arrays, not linked lists.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 include/net/netfilter/nf_conntrack_l3proto.h |    3 ---
 include/net/netfilter/nf_conntrack_l4proto.h |    3 ---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |    1 -
 3 files changed, 7 deletions(-)

Index: linux-2.6.17-git22.quilt/include/net/netfilter/nf_conntrack_l3proto.h
===================================================================
--- linux-2.6.17-git22.quilt.orig/include/net/netfilter/nf_conntrack_l3proto.h	2006-07-21 23:32:45.000000000 +0200
+++ linux-2.6.17-git22.quilt/include/net/netfilter/nf_conntrack_l3proto.h	2006-07-21 23:35:46.000000000 +0200
@@ -18,9 +18,6 @@ struct nfattr;
 
 struct nf_conntrack_l3proto
 {
-	/* Next pointer. */
-	struct list_head list;
-
 	/* L3 Protocol Family number. ex) PF_INET */
 	u_int16_t l3proto;
 
Index: linux-2.6.17-git22.quilt/include/net/netfilter/nf_conntrack_l4proto.h
===================================================================
--- linux-2.6.17-git22.quilt.orig/include/net/netfilter/nf_conntrack_l4proto.h	2006-07-21 23:32:33.000000000 +0200
+++ linux-2.6.17-git22.quilt/include/net/netfilter/nf_conntrack_l4proto.h	2006-07-21 23:35:46.000000000 +0200
@@ -16,9 +16,6 @@ struct nfattr;
 
 struct nf_conntrack_l4proto
 {
-	/* Next pointer. */
-	struct list_head list;
-
 	/* L3 Protocol number. */
 	u_int16_t l3proto;
 
Index: linux-2.6.17-git22.quilt/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
===================================================================
--- linux-2.6.17-git22.quilt.orig/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2006-07-21 23:32:33.000000000 +0200
+++ linux-2.6.17-git22.quilt/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2006-07-21 23:35:46.000000000 +0200
@@ -323,7 +323,6 @@ static int icmp_nfattr_to_tuple(struct n
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
-	.list			= { NULL, NULL },
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_ICMP,
 	.name			= "icmp",

--
/Martin
