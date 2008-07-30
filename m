From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] bump the expectation helper name
Date: Wed, 30 Jul 2008 13:06:16 +0200
Message-ID: <48904B28.7000609@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040508050206090205050107"
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40819 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752918AbYG3LGW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:06:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040508050206090205050107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] bump the expectation helper name

Include the expectation helper name at expectation dumping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040508050206090205050107
Content-Type: text/x-diff;
 name="06.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.patch"

[PATCH] bump the expectation helper name

Include the expectation helper name at expectation dumping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-30 09:09:03.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-30 09:34:47.000000000 +0200
@@ -1375,6 +1375,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
+	struct nf_conn_help *help = nfct_help(master);
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
 
 	if (timeout < 0)
@@ -1392,6 +1393,14 @@ ctnetlink_exp_dump_expect(struct sk_buff
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
 
+	if (help) {
+		struct nf_conntrack_helper *helper;
+
+		helper = rcu_dereference(help->helper);
+		if (helper)
+			NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
+	}
+
 	return 0;
 
 nla_put_failure:

--------------040508050206090205050107--
