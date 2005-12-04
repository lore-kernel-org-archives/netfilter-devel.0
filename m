From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/9]: nf_conntrack: Fix missing check for ICMPv6 type
Date: Sun, 04 Dec 2005 22:01:17 +0100
Message-ID: <20051204210117.24032.63147.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: Fix missing check for ICMPv6 type

This makes nf_conntrack_icmpv6 check that ICMPv6 type isn't < 128
to avoid accessing out of array valid_new[] and invmap[].

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e512e47b2238a9e367f05a36b4ac2ba53f5ad12e
tree faa3dc22ceff3549bc211cc48da4d1d63a9fab35
parent 436b0f76f2cee6617f27a649637766628909dd5d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 04 Dec 2005 16:01:47 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 16:01:47 +0100

 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index c0f1da5..a7e03cf 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -68,8 +68,8 @@ static int icmpv6_invert_tuple(struct nf
 		[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY +1
 	};
 
-	__u8 type = orig->dst.u.icmp.type - 128;
-	if (type >= sizeof(invmap) || !invmap[type])
+	int type = orig->dst.u.icmp.type - 128;
+	if (type < 0 || type >= sizeof(invmap) || !invmap[type])
 		return 0;
 
 	tuple->src.u.icmp.id   = orig->src.u.icmp.id;
@@ -129,12 +129,12 @@ static int icmpv6_new(struct nf_conn *co
 		[ICMPV6_ECHO_REQUEST - 128] = 1,
 		[ICMPV6_NI_QUERY - 128] = 1
 	};
+	int type = conntrack->tuplehash[0].tuple.dst.u.icmp.type - 128;
 
-	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type - 128 >= sizeof(valid_new)
-	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type - 128]) {
+	if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
 		/* Can't create a new ICMPv6 `conn' with this. */
-		DEBUGP("icmp: can't create new conn with type %u\n",
-		       conntrack->tuplehash[0].tuple.dst.u.icmp.type);
+		DEBUGP("icmpv6: can't create new conn with type %u\n",
+		       type + 128);
 		NF_CT_DUMP_TUPLE(&conntrack->tuplehash[0].tuple);
 		return 0;
 	}
