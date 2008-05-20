From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 00:29:39 +0200
Message-ID: <483350D3.50103@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010505030004080609070401"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41086 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762119AbYETW3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:29:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010505030004080609070401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

As for now we only support dumping. This patch adds support to change
the secmark from ctnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010505030004080609070401
Content-Type: text/x-patch;
 name="04.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.patch"

[PATCH] add support for modifying secmark via ctnetlink

As for now we only support dumping. This patch adds support to change
the secmark from ctnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-05-20 22:10:31.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-05-20 22:10:56.000000000 +0200
@@ -1121,6 +1121,11 @@ ctnetlink_change_conntrack(struct nf_con
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
 #endif
 
+#if defined(CONFIG_NF_CONNTRACK_SECMARK)
+	if (cda[CTA_SECMARK])
+		ct->secmark = ntohl(nla_get_be32(cda[CTA_SECMARK]));
+#endif
+
 #ifdef CONFIG_NF_NAT_NEEDED
 	if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
 		err = ctnetlink_change_nat_seq_adj(ct, cda);

--------------010505030004080609070401--
