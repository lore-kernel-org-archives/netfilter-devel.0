From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH  4/4] add missing sizecheckings
Date: Thu, 10 Nov 2005 02:04:15 +0100
Message-ID: <43729C8F.7010708@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000702030705030909070104"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------000702030705030909070104
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Add missing sizecheckings. Thanks Patrick Mchardy for the hint.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000702030705030909070104
Content-Type: text/plain;
 name="07-sizechecking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07-sizechecking.patch"

Add missing sizecheckings. Thanks Patrick Mchardy for the hint.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-09 19:18:38.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-09 19:18:42.000000000 +0100
@@ -614,6 +614,11 @@ static int ctnetlink_parse_nat_proto(str
 	return 0;
 }
 
+static const size_t cta_min_nat[CTA_NAT_MAX] = {
+	[CTA_NAT_MINIP-1]       = sizeof(u_int32_t),
+	[CTA_NAT_MAXIP-1]       = sizeof(u_int32_t),
+};
+
 static inline int
 ctnetlink_parse_nat(struct nfattr *cda[],
 		    const struct ip_conntrack *ct, struct ip_nat_range *range)
@@ -627,6 +632,9 @@ ctnetlink_parse_nat(struct nfattr *cda[]
 	
 	nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]);
 
+	if (nfattr_bad_size(tb, CTA_NAT_MAX, cta_min_nat))
+		return -EINVAL;
+
 	if (tb[CTA_NAT_MINIP-1])
 		range->min_ip = *(u_int32_t *)NFA_DATA(tb[CTA_NAT_MINIP-1]);
 
@@ -667,6 +675,14 @@ ctnetlink_parse_help(struct nfattr *attr
 	return 0;
 }
 
+static const size_t cta_min[CTA_MAX] = {
+	[CTA_STATUS-1] 		= sizeof(u_int32_t),
+	[CTA_TIMEOUT-1] 	= sizeof(u_int32_t),
+	[CTA_MARK-1]		= sizeof(u_int32_t),
+	[CTA_USE-1]		= sizeof(u_int32_t),
+	[CTA_ID-1]		= sizeof(u_int32_t)
+};
+
 static int
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb, 
 			struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
@@ -678,6 +694,9 @@ ctnetlink_del_conntrack(struct sock *ctn
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
+	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
+		return -EINVAL;
+
 	if (cda[CTA_TUPLE_ORIG-1])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG);
 	else if (cda[CTA_TUPLE_REPLY-1])
@@ -760,6 +779,9 @@ ctnetlink_get_conntrack(struct sock *ctn
 		return 0;
 	}
 
+	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
+		return -EINVAL;
+
 	if (cda[CTA_TUPLE_ORIG-1])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG);
 	else if (cda[CTA_TUPLE_REPLY-1])
@@ -1053,6 +1075,9 @@ ctnetlink_new_conntrack(struct sock *ctn
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
+	if (nfattr_bad_size(cda, CTA_MAX, cta_min))
+		return -EINVAL;
+
 	if (cda[CTA_TUPLE_ORIG-1]) {
 		err = ctnetlink_parse_tuple(cda, &otuple, CTA_TUPLE_ORIG);
 		if (err < 0)
@@ -1258,6 +1283,11 @@ out:	
 	return skb->len;
 }
 
+static const size_t cta_min_exp[CTA_EXPECT_MAX] = {
+	[CTA_EXPECT_TIMEOUT-1]          = sizeof(u_int32_t),
+	[CTA_EXPECT_ID-1]               = sizeof(u_int32_t)
+};
+
 static int
 ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb, 
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
@@ -1269,6 +1299,9 @@ ctnetlink_get_expect(struct sock *ctnl, 
 
 	DEBUGP("entered %s\n", __FUNCTION__);
 
+	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
+		return -EINVAL;
+
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct nfgenmsg *msg = NLMSG_DATA(nlh);
 		u32 rlen;
@@ -1339,6 +1372,9 @@ ctnetlink_del_expect(struct sock *ctnl, 
 	struct ip_conntrack_helper *h;
 	int err;
 
+	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
+		return -EINVAL;
+
 	if (cda[CTA_EXPECT_TUPLE-1]) {
 		/* delete a single expect by tuple */
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
@@ -1468,6 +1504,9 @@ ctnetlink_new_expect(struct sock *ctnl, 
 
 	DEBUGP("entered %s\n", __FUNCTION__);	
 
+	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
+		return -EINVAL;
+
 	if (!cda[CTA_EXPECT_TUPLE-1]
 	    || !cda[CTA_EXPECT_MASK-1]
 	    || !cda[CTA_EXPECT_MASTER-1])
Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-11-09 19:02:47.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-11-09 19:18:42.000000000 +0100
@@ -357,6 +357,10 @@ nfattr_failure:
 	return -1;
 }
 
+static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
+	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+};
+
 static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
 {
 	struct nfattr *attr = cda[CTA_PROTOINFO_TCP-1];
@@ -369,6 +373,9 @@ static int nfattr_to_tcp(struct nfattr *
 
         nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
 
+	if (nfattr_bad_size(tb, CTA_PROTOINFO_TCP_MAX, cta_min_tcp))
+		return -EINVAL;
+
 	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
 		return -EINVAL;
 

--------------000702030705030909070104--
