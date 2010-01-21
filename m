From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ctnetlink: add missing netlink attribute policies
Date: Thu, 21 Jan 2010 11:19:26 +0100
Message-ID: <4B582A2E.7030500@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020408090709010603060200"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56642 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0AUKTb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:19:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020408090709010603060200
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


--------------020408090709010603060200
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit 455a889099234d405a0f033d32d90639aedf7b24
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jan 21 11:08:53 2010 +0100

    netfilter: ctnetlink: add missing netlink attribute policies
    
    Signed-off-by: Patirck McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5443a04..0ea6450 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -708,6 +708,11 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	return ret;
 }
 
+static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
+	[CTA_TUPLE_IP]		= { .type = NLA_NESTED },
+	[CTA_TUPLE_PROTO]	= { .type = NLA_NESTED },
+};
+
 static int
 ctnetlink_parse_tuple(const struct nlattr * const cda[],
 		      struct nf_conntrack_tuple *tuple,
@@ -718,7 +723,7 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 
 	memset(tuple, 0, sizeof(*tuple));
 
-	nla_parse_nested(tb, CTA_TUPLE_MAX, cda[type], NULL);
+	nla_parse_nested(tb, CTA_TUPLE_MAX, cda[type], tuple_nla_policy);
 
 	if (!tb[CTA_TUPLE_IP])
 		return -EINVAL;
@@ -745,12 +750,16 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	return 0;
 }
 
+static const struct nla_policy help_nla_policy[CTA_HELP_MAX+1] = {
+	[CTA_HELP_NAME]		= { .type = NLA_NUL_STRING },
+};
+
 static inline int
 ctnetlink_parse_help(const struct nlattr *attr, char **helper_name)
 {
 	struct nlattr *tb[CTA_HELP_MAX+1];
 
-	nla_parse_nested(tb, CTA_HELP_MAX, attr, NULL);
+	nla_parse_nested(tb, CTA_HELP_MAX, attr, help_nla_policy);
 
 	if (!tb[CTA_HELP_NAME])
 		return -EINVAL;
@@ -761,11 +770,17 @@ ctnetlink_parse_help(const struct nlattr *attr, char **helper_name)
 }
 
 static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
+	[CTA_TUPLE_ORIG]	= { .type = NLA_NESTED },
+	[CTA_TUPLE_REPLY]	= { .type = NLA_NESTED },
 	[CTA_STATUS] 		= { .type = NLA_U32 },
+	[CTA_PROTOINFO]		= { .type = NLA_NESTED },
+	[CTA_HELP]		= { .type = NLA_NESTED },
+	[CTA_NAT_SRC]		= { .type = NLA_NESTED },
 	[CTA_TIMEOUT] 		= { .type = NLA_U32 },
 	[CTA_MARK]		= { .type = NLA_U32 },
-	[CTA_USE]		= { .type = NLA_U32 },
 	[CTA_ID]		= { .type = NLA_U32 },
+	[CTA_NAT_DST]		= { .type = NLA_NESTED },
+	[CTA_TUPLE_MASTER]	= { .type = NLA_NESTED },
 };
 
 static int
@@ -1051,6 +1066,12 @@ ctnetlink_change_timeout(struct nf_conn *ct, const struct nlattr * const cda[])
 	return 0;
 }
 
+static const struct nla_policy protoinfo_policy[CTA_PROTOINFO_MAX+1] = {
+	[CTA_PROTOINFO_TCP]	= { .type = NLA_NESTED },
+	[CTA_PROTOINFO_DCCP]	= { .type = NLA_NESTED },
+	[CTA_PROTOINFO_SCTP]	= { .type = NLA_NESTED },
+};
+
 static inline int
 ctnetlink_change_protoinfo(struct nf_conn *ct, const struct nlattr * const cda[])
 {
@@ -1059,7 +1080,7 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, const struct nlattr * const cda[]
 	struct nf_conntrack_l4proto *l4proto;
 	int err = 0;
 
-	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, NULL);
+	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, protoinfo_policy);
 
 	rcu_read_lock();
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
@@ -1071,12 +1092,18 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, const struct nlattr * const cda[]
 }
 
 #ifdef CONFIG_NF_NAT_NEEDED
+static const struct nla_policy nat_seq_policy[CTA_NAT_SEQ_MAX+1] = {
+	[CTA_NAT_SEQ_CORRECTION_POS]	= { .type = NLA_U32 },
+	[CTA_NAT_SEQ_OFFSET_BEFORE]	= { .type = NLA_U32 },
+	[CTA_NAT_SEQ_OFFSET_AFTER]	= { .type = NLA_U32 },
+};
+
 static inline int
 change_nat_seq_adj(struct nf_nat_seq *natseq, const struct nlattr * const attr)
 {
 	struct nlattr *cda[CTA_NAT_SEQ_MAX+1];
 
-	nla_parse_nested(cda, CTA_NAT_SEQ_MAX, attr, NULL);
+	nla_parse_nested(cda, CTA_NAT_SEQ_MAX, attr, nat_seq_policy);
 
 	if (!cda[CTA_NAT_SEQ_CORRECTION_POS])
 		return -EINVAL;
@@ -1641,8 +1668,12 @@ out:
 }
 
 static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
+	[CTA_EXPECT_MASTER]	= { .type = NLA_NESTED },
+	[CTA_EXPECT_TUPLE]	= { .type = NLA_NESTED },
+	[CTA_EXPECT_MASK]	= { .type = NLA_NESTED },
 	[CTA_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
 	[CTA_EXPECT_ID]		= { .type = NLA_U32 },
+	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING },
 };
 
 static int

--------------020408090709010603060200--
