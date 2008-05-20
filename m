From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/4] group errors into logical errno sets
Date: Wed, 21 May 2008 00:29:26 +0200
Message-ID: <483350C6.2020006@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050907020003090505030806"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34435 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933085AbYETW3d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:29:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050907020003090505030806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] group errors into logical errno sets

This patch groups ctnetlink errors into three logical sets:

* Malformed messages: if ctnetlink receives a message without some
mandatory attribute, then it returns EINVAL.
* Unsupported operations: if userspace tries to perform an unsupported
operation, then it returns EOPNOTSUPP.
* Unchangeable: if userspace tries to change some attribute of the
conntrack object that can only be set once, then it returns EBUSY.

This patch reduces the number of -EINVAL from 23 to 14 and it results in
5 -EBUSY and 6 -EOPNOTSUPP.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------050907020003090505030806
Content-Type: text/x-patch;
 name="01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.patch"

[PATCH] group errors into logical errno sets

This patch groups ctnetlink errors into three logical sets:

* Malformed messages: if ctnetlink receives a message without some mandatory
attribute, then it returns EINVAL.
* Unsupported operations: if userspace tries to perform an unsupported 
operation, then it returns EOPNOTSUPP.
* Unchangeable: if userspace tries to change some attribute of the 
conntrack object that can only be set once, then it returns EBUSY.

This patch reduces the number of -EINVAL from 23 to 14 and it results in 
5 -EBUSY and 6 -EOPNOTSUPP.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-04-18 02:57:34.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-04-18 03:11:51.000000000 +0200
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -899,20 +899,19 @@ ctnetlink_change_status(struct nf_conn *
 
 	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
 		/* unchangeable */
-		return -EINVAL;
+		return -EBUSY;
 
 	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
 		/* SEEN_REPLY bit can only be set */
-		return -EINVAL;
-
+		return -EBUSY;
 
 	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
 		/* ASSURED bit can only be set */
-		return -EINVAL;
+		return -EBUSY;
 
 	if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 #ifndef CONFIG_NF_NAT_NEEDED
-		return -EINVAL;
+		return -EOPNOTSUPP;
 #else
 		struct nf_nat_range range;
 
@@ -953,7 +952,7 @@ ctnetlink_change_helper(struct nf_conn *
 
 	/* don't change helper of sibling connections */
 	if (ct->master)
-		return -EINVAL;
+		return -EBUSY;
 
 	err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
 	if (err < 0)
@@ -971,7 +970,7 @@ ctnetlink_change_helper(struct nf_conn *
 
 	helper = __nf_conntrack_helper_find_byname(helpname);
 	if (helper == NULL)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (help) {
 		if (help->helper == helper)
@@ -1269,12 +1268,12 @@ ctnetlink_new_conntrack(struct sock *ctn
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
 		/* we only allow nat config for new conntracks */
 		if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
-			err = -EINVAL;
+			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
 		/* can't link an existing conntrack to a master */
 		if (cda[CTA_TUPLE_MASTER]) {
-			err = -EINVAL;
+			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
 		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
@@ -1619,7 +1618,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 		h = __nf_conntrack_helper_find_byname(name);
 		if (!h) {
 			spin_unlock_bh(&nf_conntrack_lock);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
 			hlist_for_each_entry_safe(exp, n, next,

--------------050907020003090505030806--
