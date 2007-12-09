From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5] Set expected bit for related conntracks
Date: Sun, 09 Dec 2007 19:13:19 +0100
Message-ID: <475C303F.50402@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070000090103000504060407"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52530 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751099AbXLISNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:13:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070000090103000504060407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is a fix. It sets IPS_EXPECTED for related conntracks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070000090103000504060407
Content-Type: text/x-patch;
 name="04.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.patch"

[PATCH][CTNETLINK] Set expected bit for related conntracks

This patch is a fix. It sets IPS_EXPECTED for related conntracks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-12-08 20:10:04.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-12-08 20:11:08.000000000 +0100
@@ -1146,8 +1146,10 @@ ctnetlink_create_conntrack(struct nlattr
 	}
 
 	/* setup master conntrack: this is a confirmed expectation */
-	if (master_ct)
+	if (master_ct) {
+		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
+	}
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);

--------------070000090103000504060407--
