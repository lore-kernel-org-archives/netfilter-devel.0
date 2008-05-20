From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4] add full support for SCTP to ctnetlink
Date: Wed, 21 May 2008 00:37:17 +0200
Message-ID: <4833529D.40807@netfilter.org>
References: <483350CA.10202@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050903050304030301000602"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43987 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934569AbYETWh3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:37:29 -0400
In-Reply-To: <483350CA.10202@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050903050304030301000602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> [PATCH] add full support for SCTP to ctnetlink
> 
> This patch adds full support for SCTP to ctnetlink. This includes three
> new attributes: state, original vtag and reply vtag.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I'm resending this patch because I've been working against an old kernel
tree. The patch attached should apply fine.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------050903050304030301000602
Content-Type: text/x-patch;
 name="03.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.patch"

[PATCH] add full support for SCTP to ctnetlink

This patch adds full support for SCTP to ctnetlink. This includes three new
attributes: state, original vtag and reply vtag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2008-04-27 09:55:53.000000000 +0200
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2008-04-27 10:10:07.000000000 +0200
@@ -80,6 +80,7 @@ enum ctattr_l4proto {
 enum ctattr_protoinfo {
 	CTA_PROTOINFO_UNSPEC,
 	CTA_PROTOINFO_TCP,
+	CTA_PROTOINFO_SCTP,
 	__CTA_PROTOINFO_MAX
 };
 #define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
@@ -95,6 +96,15 @@ enum ctattr_protoinfo_tcp {
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
 
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
Index: net-2.6.git/net/netfilter/nf_conntrack_proto_sctp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_proto_sctp.c	2008-04-27 09:55:53.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_proto_sctp.c	2008-05-20 23:09:57.000000000 +0200
@@ -459,6 +459,82 @@ static int sctp_new(struct nf_conn *ct, 
 	return 1;
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
@@ -587,6 +663,8 @@ static struct nf_conntrack_l4proto nf_co
 	.new 			= sctp_new,
 	.me 			= THIS_MODULE,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nlattr		= sctp_to_nlattr,
+	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
@@ -613,6 +691,8 @@ static struct nf_conntrack_l4proto nf_co
 	.new 			= sctp_new,
 	.me 			= THIS_MODULE,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.to_nlattr		= sctp_to_nlattr,
+	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,

--------------050903050304030301000602--
