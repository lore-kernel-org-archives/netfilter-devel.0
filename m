From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] use nf_conntrack_get instead of atomic_inc
Date: Wed, 30 Jul 2008 13:03:17 +0200
Message-ID: <48904A75.90905@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090805040609010404000901"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39139 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758899AbYG3LDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:03:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090805040609010404000901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] use nf_conntrack_get instead of atomic_inc

Use nf_conntrack_get instead of the direct call to atomic_inc.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090805040609010404000901
Content-Type: text/x-diff;
 name="01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.patch"

[PATCH] use nf_conntrack_get instead of atomic_inc

Use nf_conntrack_get instead of the direct call to atomic_inc.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-29 14:21:50.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-29 14:24:33.000000000 +0200
@@ -1228,7 +1228,7 @@ ctnetlink_new_conntrack(struct sock *ctn
 				goto out_unlock;
 			}
 			master_ct = nf_ct_tuplehash_to_ctrack(master_h);
-			atomic_inc(&master_ct->ct_general.use);
+			nf_conntrack_get(&master_ct->ct_general);
 		}
 
 		spin_unlock_bh(&nf_conntrack_lock);

--------------090805040609010404000901--
