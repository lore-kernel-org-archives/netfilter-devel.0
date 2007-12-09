From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] Add support for SCTP
Date: Sun, 09 Dec 2007 19:13:06 +0100
Message-ID: <475C3032.5040706@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060102000109010904090406"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52528 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbXLISNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:13:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060102000109010904090406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds support for SCTP to ctnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060102000109010904090406
Content-Type: text/x-patch;
 name="02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.patch"

[PATCH][CTNETLINK] Add support for SCTP

This patch adds support for SCTP to ctnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_proto_sctp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_proto_sctp.c	2007-12-08 19:47:47.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_proto_sctp.c	2007-12-08 19:47:52.000000000 +0100
@@ -619,6 +619,16 @@ static struct nf_conntrack_l4proto nf_co
 	.packet 		= sctp_packet,
 	.new 			= sctp_new,
 	.me 			= THIS_MODULE,
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
+#endif
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nla_policy		= nf_ct_port_nla_policy,
+#endif
 #ifdef CONFIG_SYSCTL
 	.ctl_table_users	= &sctp_sysctl_table_users,
 	.ctl_table_header	= &sctp_sysctl_header,

--------------060102000109010904090406--
