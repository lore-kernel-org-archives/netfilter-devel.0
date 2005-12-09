From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/3] nfctnetlink: add support for ICMPv6
Date: Fri, 09 Dec 2005 11:46:19 +0900 (JST)
Message-ID: <200512090246.jB92kKZe023544@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Dec__9_11_46_19_2005_057)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
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

----Next_Part(Fri_Dec__9_11_46_19_2005_057)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This adds support for ICMPv6 to nf_conntrack_netlink.

The reason why I added new CTA_PROTO_ICMPV6_* is because ICMP and ICMPv6
has different protocol number and the means of type/code are different, too.

----Next_Part(Fri_Dec__9_11_46_19_2005_057)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-nfctnetlink-icmpv6.patch"

[NETFILTER] nfctnetlink: add support for ICMPv6

This adds support for ICMPv6 to nf_conntrack_netlink.

The reason why I added new CTA_PROTO_ICMPV6_* is because ICMP and ICMPv6
has different protocol number and the means of type/code are different, too.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit f8292e30683470bda8611925ee256ddc3262dae2
tree 38ecddc9491f285e3bbe934369a17891ee809112
parent 27993a8d4f8b6b6fef00dd745762ce17452f2025
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 01:08:32 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 09 Dec 2005 01:08:32 +0900

 include/linux/netfilter/nfnetlink_conntrack.h  |    3 +
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   75 +++++++++++++++++++++---
 2 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 116fcac..b8e9a5b 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -64,6 +64,9 @@ enum ctattr_l4proto {
 	CTA_PROTO_ICMP_ID,
 	CTA_PROTO_ICMP_TYPE,
 	CTA_PROTO_ICMP_CODE,
+	CTA_PROTO_ICMPV6_ID,
+	CTA_PROTO_ICMPV6_TYPE,
+	CTA_PROTO_ICMPV6_CODE,
 	__CTA_PROTO_MAX
 };
 #define CTA_PROTO_MAX (__CTA_PROTO_MAX - 1)
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 3b55085..55a3be0 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -57,17 +57,17 @@ static int icmpv6_pkt_to_tuple(const str
 	return 1;
 }
 
+/* Add 1; spaces filled with 0. */
+static const u_int8_t invmap[] = {
+	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
+	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
+	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
+	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY +1
+};
+
 static int icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
 			       const struct nf_conntrack_tuple *orig)
 {
-	/* Add 1; spaces filled with 0. */
-	static u_int8_t invmap[] = {
-		[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
-		[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
-		[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
-		[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY +1
-	};
-
 	int type = orig->dst.u.icmp.type - 128;
 	if (type < 0 || type >= sizeof(invmap) || !invmap[type])
 		return 0;
@@ -255,6 +255,60 @@ skipped:
 	return icmpv6_error_message(skb, dataoff, ctinfo, hooknum);
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+static int icmpv6_tuple_to_nfattr(struct sk_buff *skb,
+				  const struct nf_conntrack_tuple *t)
+{
+	NFA_PUT(skb, CTA_PROTO_ICMPV6_ID, sizeof(u_int16_t),
+		&t->src.u.icmp.id);
+	NFA_PUT(skb, CTA_PROTO_ICMPV6_TYPE, sizeof(u_int8_t),
+		&t->dst.u.icmp.type);
+	NFA_PUT(skb, CTA_PROTO_ICMPV6_CODE, sizeof(u_int8_t),
+		&t->dst.u.icmp.code);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static const size_t cta_min_proto[CTA_PROTO_MAX] = {
+	[CTA_PROTO_ICMPV6_TYPE-1] = sizeof(u_int8_t),
+	[CTA_PROTO_ICMPV6_CODE-1] = sizeof(u_int8_t),
+	[CTA_PROTO_ICMPV6_ID-1]   = sizeof(u_int16_t)
+};
+
+static int icmpv6_nfattr_to_tuple(struct nfattr *tb[],
+				struct nf_conntrack_tuple *tuple)
+{
+	if (!tb[CTA_PROTO_ICMPV6_TYPE-1]
+	    || !tb[CTA_PROTO_ICMPV6_CODE-1]
+	    || !tb[CTA_PROTO_ICMPV6_ID-1])
+		return -EINVAL;
+
+	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
+		return -EINVAL;
+
+	tuple->dst.u.icmp.type =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_TYPE-1]);
+	tuple->dst.u.icmp.code =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
+	tuple->src.u.icmp.id =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
+
+	if (tuple->dst.u.icmp.type < 128
+	    || tuple->dst.u.icmp.type - 128 >= sizeof(invmap)
+	    || !invmap[tuple->dst.u.icmp.type - 128])
+		return -EINVAL;
+
+	return 0;
+}
+#endif
+
 struct nf_conntrack_protocol nf_conntrack_protocol_icmpv6 =
 {
 	.l3proto		= PF_INET6,
@@ -267,6 +321,11 @@ struct nf_conntrack_protocol nf_conntrac
 	.packet			= icmpv6_packet,
 	.new			= icmpv6_new,
 	.error			= icmpv6_error,
+#if defined(CONFIG_NF_CT_NETLINK) || \
+    defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nfattr	= icmpv6_tuple_to_nfattr,
+	.nfattr_to_tuple	= icmpv6_nfattr_to_tuple,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_protocol_icmpv6);

----Next_Part(Fri_Dec__9_11_46_19_2005_057)----
