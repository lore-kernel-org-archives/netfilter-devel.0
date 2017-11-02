From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: conntrack: remove nlattr_size pointer from l4proto trackers
Date: Thu,  2 Nov 2017 19:41:10 +0100
Message-ID: <20171102184112.32584-3-fw@strlen.de>
References: <20171102184112.32584-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60420 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933748AbdKBSlC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2017 14:41:02 -0400
In-Reply-To: <20171102184112.32584-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

similar to previous commit, but instead compute this at compile time
and turn nlattr_size into an u16.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  7 +++----
 net/netfilter/nf_conntrack_netlink.c         |  2 +-
 net/netfilter/nf_conntrack_proto.c           |  6 +-----
 net/netfilter/nf_conntrack_proto_dccp.c      | 17 ++++++++---------
 net/netfilter/nf_conntrack_proto_sctp.c      | 15 +++++++--------
 net/netfilter/nf_conntrack_proto_tcp.c       | 16 ++++++++--------
 6 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 46e786ffcf2f..d5942da015ca 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -26,6 +26,9 @@ struct nf_conntrack_l4proto {
 	/* Resolve clashes on insertion races. */
 	bool allow_clash;
 
+	/* protoinfo nlattr size, closes a hole */
+	u16 nlattr_size;
+
 	/* Try to fill in the third arg: dataoff is offset past network protocol
            hdr.  Return true if possible. */
 	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int dataoff,
@@ -65,8 +68,6 @@ struct nf_conntrack_l4proto {
 	/* convert protoinfo to nfnetink attributes */
 	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
 			 struct nf_conn *ct);
-	/* Calculate protoinfo nlattr size */
-	int (*nlattr_size)(void);
 
 	/* convert nfnetlink attributes to protoinfo */
 	int (*from_nlattr)(struct nlattr *tb[], struct nf_conn *ct);
@@ -79,8 +80,6 @@ struct nf_conntrack_l4proto {
 			       struct nf_conntrack_tuple *t);
 	const struct nla_policy *nla_policy;
 
-	size_t nla_size;
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
 	struct {
 		int (*nlattr_to_obj)(struct nlattr *tb[],
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6e0adfefb9ed..71a43ed19a0f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -544,7 +544,7 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 	len *= 3u; /* ORIG, REPLY, MASTER */
 
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	len += l4proto->nla_size;
+	len += l4proto->nlattr_size;
 	if (l4proto->nlattr_tuple_size) {
 		len4 = l4proto->nlattr_tuple_size();
 		len4 *= 3u; /* ORIG, REPLY, MASTER */
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 3b06ff3f2dee..3f74bf001b31 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -359,7 +359,7 @@ int nf_ct_l4proto_register_one(struct nf_conntrack_l4proto *l4proto)
 	if (l4proto->l3proto >= ARRAY_SIZE(nf_ct_protos))
 		return -EBUSY;
 
-	if ((l4proto->to_nlattr && !l4proto->nlattr_size) ||
+	if ((l4proto->to_nlattr && l4proto->nlattr_size == 0) ||
 	    (l4proto->tuple_to_nlattr && !l4proto->nlattr_tuple_size))
 		return -EINVAL;
 
@@ -395,10 +395,6 @@ int nf_ct_l4proto_register_one(struct nf_conntrack_l4proto *l4proto)
 		goto out_unlock;
 	}
 
-	l4proto->nla_size = 0;
-	if (l4proto->nlattr_size)
-		l4proto->nla_size += l4proto->nlattr_size();
-
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   l4proto);
 out_unlock:
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 2a446f4a554c..2fee7c96ec09 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -654,6 +654,12 @@ static const struct nla_policy dccp_nla_policy[CTA_PROTOINFO_DCCP_MAX + 1] = {
 	[CTA_PROTOINFO_DCCP_PAD]	= { .type = NLA_UNSPEC },
 };
 
+#define DCCP_NLATTR_SIZE ( \
+	NLA_ALIGN(NLA_HDRLEN + 1) + \
+	NLA_ALIGN(NLA_HDRLEN + 1) + \
+	NLA_ALIGN(NLA_HDRLEN + sizeof(u64)) + \
+	NLA_ALIGN(NLA_HDRLEN + 0))
+
 static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 {
 	struct nlattr *attr = cda[CTA_PROTOINFO_DCCP];
@@ -691,13 +697,6 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 	spin_unlock_bh(&ct->lock);
 	return 0;
 }
-
-static int dccp_nlattr_size(void)
-{
-	return nla_total_size(0)	/* CTA_PROTOINFO_DCCP */
-		+ nla_policy_len(dccp_nla_policy, CTA_PROTOINFO_DCCP_MAX + 1);
-}
-
 #endif
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
@@ -876,8 +875,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 __read_mostly = {
 	.print_conntrack	= dccp_print_conntrack,
 #endif
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.nlattr_size		= DCCP_NLATTR_SIZE,
 	.to_nlattr		= dccp_to_nlattr,
-	.nlattr_size		= dccp_nlattr_size,
 	.from_nlattr		= nlattr_to_dccp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
@@ -912,8 +911,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 __read_mostly = {
 	.print_conntrack	= dccp_print_conntrack,
 #endif
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.nlattr_size		= DCCP_NLATTR_SIZE,
 	.to_nlattr		= dccp_to_nlattr,
-	.nlattr_size		= dccp_nlattr_size,
 	.from_nlattr		= nlattr_to_dccp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 80faf04ddf15..f5bff4de0386 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -578,6 +578,11 @@ static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
 	[CTA_PROTOINFO_SCTP_VTAG_REPLY]     = { .type = NLA_U32 },
 };
 
+#define SCTP_NLATTR_SIZE ( \
+		NLA_ALIGN(NLA_HDRLEN + 1) + \
+		NLA_ALIGN(NLA_HDRLEN + 4) + \
+		NLA_ALIGN(NLA_HDRLEN + 4))
+
 static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 {
 	struct nlattr *attr = cda[CTA_PROTOINFO_SCTP];
@@ -608,12 +613,6 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 
 	return 0;
 }
-
-static int sctp_nlattr_size(void)
-{
-	return nla_total_size(0)	/* CTA_PROTOINFO_SCTP */
-		+ nla_policy_len(sctp_nla_policy, CTA_PROTOINFO_SCTP_MAX + 1);
-}
 #endif
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
@@ -793,8 +792,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 	.can_early_drop		= sctp_can_early_drop,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.nlattr_size		= SCTP_NLATTR_SIZE,
 	.to_nlattr		= sctp_to_nlattr,
-	.nlattr_size		= sctp_nlattr_size,
 	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
@@ -830,8 +829,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.can_early_drop		= sctp_can_early_drop,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.nlattr_size		= SCTP_NLATTR_SIZE,
 	.to_nlattr		= sctp_to_nlattr,
-	.nlattr_size		= sctp_nlattr_size,
 	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b12fc07111d0..a61a6b7b4fc5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1219,6 +1219,12 @@ static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
 	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len =  sizeof(struct nf_ct_tcp_flags) },
 };
 
+#define TCP_NLATTR_SIZE	( \
+	NLA_ALIGN(NLA_HDRLEN + 1) + \
+	NLA_ALIGN(NLA_HDRLEN + 1) + \
+	NLA_ALIGN(NLA_HDRLEN + sizeof(sizeof(struct nf_ct_tcp_flags))) + \
+	NLA_ALIGN(NLA_HDRLEN + sizeof(sizeof(struct nf_ct_tcp_flags))))
+
 static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 {
 	struct nlattr *pattr = cda[CTA_PROTOINFO_TCP];
@@ -1271,12 +1277,6 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 	return 0;
 }
 
-static int tcp_nlattr_size(void)
-{
-	return nla_total_size(0)	   /* CTA_PROTOINFO_TCP */
-		+ nla_policy_len(tcp_nla_policy, CTA_PROTOINFO_TCP_MAX + 1);
-}
-
 static unsigned int tcp_nlattr_tuple_size(void)
 {
 	static unsigned int size __read_mostly;
@@ -1554,11 +1554,11 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= tcp_to_nlattr,
-	.nlattr_size		= tcp_nlattr_size,
 	.from_nlattr		= nlattr_to_tcp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nlattr_tuple_size	= tcp_nlattr_tuple_size,
+	.nlattr_size		= TCP_NLATTR_SIZE,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
@@ -1591,8 +1591,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 __read_mostly =
 	.error			= tcp_error,
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.nlattr_size		= TCP_NLATTR_SIZE,
 	.to_nlattr		= tcp_to_nlattr,
-	.nlattr_size		= tcp_nlattr_size,
 	.from_nlattr		= nlattr_to_tcp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-- 
2.13.6

