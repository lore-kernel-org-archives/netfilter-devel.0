From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] nf_conntrack: Fix missing check for ICMPv6 type
Date: Sun, 04 Dec 2005 01:22:06 +0900 (JST)
Message-ID: <200512031622.jB3GM6IS014305@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Dec__4_01_22_06_2005_026)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Sun_Dec__4_01_22_06_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This makes nf_conntrack_icmpv6 check that ICMPv6 type isn't < 128
to avoid access out of valid_new[] and invmap[].

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sun_Dec__4_01_22_06_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-nfct-icmpv6.patch"

[NETFILTER] nf_conntrack: Fix missing check for ICMPv6 type.

This makes nf_conntrack_icmpv6 check that ICMPv6 type isn't < 128
to avoid accessing out of array valid_new[] and invmap[].

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit b80e4873d096c32b1c941b66cbfdaf1cf9bf8d8d
tree 24cb10c90a97884f59e06129383a8d354c057555
parent 76dbe24325d4e4fb4e7da76498bd0d168a14bf40
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 26 Nov 2005 22:49:17 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 26 Nov 2005 22:49:17 +0900

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

----Next_Part(Sun_Dec__4_01_22_06_2005_026)----
