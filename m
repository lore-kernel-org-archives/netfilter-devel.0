From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/33]: nf_conntrack: remove unused struct list_head
	from protocols
Date: Wed, 29 Nov 2006 03:08:59 +0100 (MET)
Message-ID: <20061129020859.21082.42993.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: remove unused struct list_head from protocols

Remove unused struct list_head from struct nf_conntrack_l3proto and
nf_conntrack_l4proto as all protocols are kept in arrays, not linked
lists.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4bbe725325797bfbe6366209b9e974fe4ef0e83b
tree d38cbcd9876606366933dfe10d88dc8129270f4a
parent 01d88c08b8b25a08c7e2b3520ebc8e83ec4b3888
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:13:04 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:57:09 +0100

 include/net/netfilter/nf_conntrack_l3proto.h |    3 ---
 include/net/netfilter/nf_conntrack_l4proto.h |    3 ---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |    1 -
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 11b4b29..6364df0 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -18,9 +18,6 @@ struct nfattr;
 
 struct nf_conntrack_l3proto
 {
-	/* Next pointer. */
-	struct list_head list;
-
 	/* L3 Protocol Family number. ex) PF_INET */
 	u_int16_t l3proto;
 
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 5193e48..c22804a 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -16,9 +16,6 @@ struct nfattr;
 
 struct nf_conntrack_l4proto
 {
-	/* Next pointer. */
-	struct list_head list;
-
 	/* L3 Protocol number. */
 	u_int16_t l3proto;
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 08223a5..95fc22b 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -323,7 +323,6 @@ #endif
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
-	.list			= { NULL, NULL },
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_ICMP,
 	.name			= "icmp",
