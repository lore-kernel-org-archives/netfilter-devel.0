From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/11: ctnetlink: add full support for SCTP to ctnetlink
Date: Fri,  6 Jun 2008 17:17:47 +0200 (MEST)
Message-ID: <20080606151746.25286.16991.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48137 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961AbYFFPRu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:50 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ctnetlink: add full support for SCTP to ctnetlink

This patch adds full support for SCTP to ctnetlink. This includes three
new attributes: state, original vtag and reply vtag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f3cca975999eb8009c2e912cd11948e0208a2de7
tree 4cbc50244dd073e8230d078817cccedc833181e2
parent aed5c546c63f757b44cd55d279b88a118a5cc485
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 06 Jun 2008 17:08:24 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:08:24 +0200

 include/linux/netfilter/nfnetlink_conntrack.h |   10 +++
 net/netfilter/nf_conntrack_proto_sctp.c       |   80 +++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 0a383ac..759bc04 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -81,6 +81,7 @@ enum ctattr_protoinfo {
 	CTA_PROTOINFO_UNSPEC,
 	CTA_PROTOINFO_TCP,
 	CTA_PROTOINFO_DCCP,
+	CTA_PROTOINFO_SCTP,
 	__CTA_PROTOINFO_MAX
 };
 #define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
@@ -103,6 +104,15 @@ enum ctattr_protoinfo_dccp {
 };
 #define CTA_PROTOINFO_DCCP_MAX (__CTA_PROTOINFO_DCCP_MAX - 1)
 
+enum ctattr_protoinfo_sctp {
+	CTA_PROTOINFO_SCTP_UNSPEC,
+	CTA_PROTOINFO_SCTP_STATE,
+	CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
+	CTA_PROTOINFO_SCTP_VTAG_REPLY,
+	__CTA_PROTOINFO_SCTP_MAX
+};
+#define CTA_PROTOINFO_SCTP_MAX (__CTA_PROTOINFO_SCTP_MAX - 1)
+
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
 	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index cbf2e27..41183a4 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -463,6 +463,82 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
+			  const struct nf_conn *ct)
+{
+	struct nlattr *nest_parms;
+
+	read_lock_bh(&sctp_lock);
+	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_SCTP | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+
+	NLA_PUT_U8(skb, CTA_PROTOINFO_SCTP_STATE, ct->proto.sctp.state);
+
+	NLA_PUT_BE32(skb,
+		     CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
+		     htonl(ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL]));
+
+	NLA_PUT_BE32(skb,
+		     CTA_PROTOINFO_SCTP_VTAG_REPLY,
+		     htonl(ct->proto.sctp.vtag[IP_CT_DIR_REPLY]));
+
+	read_unlock_bh(&sctp_lock);
+
+	nla_nest_end(skb, nest_parms);
+
+	return 0;
+
+nla_put_failure:
+	read_unlock_bh(&sctp_lock);
+	return -1;
+}
+
+static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
+	[CTA_PROTOINFO_SCTP_STATE]	    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]  = { .type = NLA_U32 },
+	[CTA_PROTOINFO_SCTP_VTAG_REPLY]     = { .type = NLA_U32 },
+};
+
+static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
+{
+	struct nlattr *attr = cda[CTA_PROTOINFO_SCTP];
+	struct nlattr *tb[CTA_PROTOINFO_SCTP_MAX+1];
+	int err;
+
+	/* updates may not contain the internal protocol info, skip parsing */
+	if (!attr)
+		return 0;
+
+	err = nla_parse_nested(tb,
+			       CTA_PROTOINFO_SCTP_MAX,
+			       attr,
+			       sctp_nla_policy);
+	if (err < 0)
+		return err;
+
+	if (!tb[CTA_PROTOINFO_SCTP_STATE] ||
+	    !tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL] ||
+	    !tb[CTA_PROTOINFO_SCTP_VTAG_REPLY])
+		return -EINVAL;
+
+	write_lock_bh(&sctp_lock);
+	ct->proto.sctp.state = nla_get_u8(tb[CTA_PROTOINFO_SCTP_STATE]);
+	ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] =
+		ntohl(nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]));
+	ct->proto.sctp.vtag[IP_CT_DIR_REPLY] =
+		ntohl(nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY]));
+	write_unlock_bh(&sctp_lock);
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_SYSCTL
 static unsigned int sctp_sysctl_table_users;
 static struct ctl_table_header *sctp_sysctl_header;
@@ -591,6 +667,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 	.new 			= sctp_new,
 	.me 			= THIS_MODULE,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nlattr		= sctp_to_nlattr,
+	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
@@ -617,6 +695,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.new 			= sctp_new,
 	.me 			= THIS_MODULE,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nlattr		= sctp_to_nlattr,
+	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
