From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/11: ctnetlink: group errors into logical errno sets
Date: Fri,  6 Jun 2008 17:17:46 +0200 (MEST)
Message-ID: <20080606151744.25286.101.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbYFFPRt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:49 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ctnetlink: group errors into logical errno sets

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
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aed5c546c63f757b44cd55d279b88a118a5cc485
tree 696cc590645bde00e74341241795575c7769b25d
parent b6e858ce9cfbf1779380ba9bb1b3e27b3b4db8b7
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 06 Jun 2008 17:08:16 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:08:16 +0200

 net/netfilter/nf_conntrack_netlink.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0edefcf..13918c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -891,20 +891,19 @@ ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
 
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
 
@@ -945,7 +944,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 
 	/* don't change helper of sibling connections */
 	if (ct->master)
-		return -EINVAL;
+		return -EBUSY;
 
 	err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
 	if (err < 0)
@@ -963,7 +962,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 
 	helper = __nf_conntrack_helper_find_byname(helpname);
 	if (helper == NULL)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (help) {
 		if (help->helper == helper)
@@ -1258,12 +1257,12 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
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
@@ -1608,7 +1607,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		h = __nf_conntrack_helper_find_byname(name);
 		if (!h) {
 			spin_unlock_bh(&nf_conntrack_lock);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
 			hlist_for_each_entry_safe(exp, n, next,
