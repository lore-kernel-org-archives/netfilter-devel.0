From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/06: ctnetlink: fix double helper assignation for NAT'ed conntracks
Date: Mon, 18 Aug 2008 18:51:52 +0200 (MEST)
Message-ID: <20080818165151.18978.90816.sendpatchset@localhost.localdomain>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59349 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYHRQvy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:54 -0400
In-Reply-To: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ctnetlink: fix double helper assignation for NAT'ed conntracks

If we create a conntrack that has NAT handlings and a helper, the helper
is assigned twice. This happens because nf_nat_setup_info() - via
nf_conntrack_alter_reply() - sets the helper before ctnetlink, which
indeed does not check if the conntrack already has a helper as it thinks that
it is a brand new conntrack.

The fix moves the helper assignation before the set of the status flags.
This avoids a bogus assertion in __nf_ct_ext_add (if netfilter assertions are
enabled) which checks that the conntrack must not be confirmed.

This problem was introduced in 2.6.23 with the netfilter extension
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4a58ff2a369c6020ece596812f819641f9d19820
tree 7c640e1ffb18d61e9ef3a097e2b2ab00eb529c52
parent 132fbda27191848d809ac4c4e5841581371aafd8
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 18 Aug 2008 13:17:03 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Aug 2008 13:17:03 +0200

 net/netfilter/nf_conntrack_netlink.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 105a616..d1fb2f8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1136,16 +1136,33 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
+	rcu_read_lock();
+	helper = __nf_ct_helper_find(rtuple);
+	if (helper) {
+		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		if (help == NULL) {
+			rcu_read_unlock();
+			err = -ENOMEM;
+			goto err;
+		}
+		/* not in hash table yet so not strictly necessary */
+		rcu_assign_pointer(help->helper, helper);
+	}
+
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
-		if (err < 0)
+		if (err < 0) {
+			rcu_read_unlock();
 			goto err;
+		}
 	}
 
 	if (cda[CTA_PROTOINFO]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
-		if (err < 0)
+		if (err < 0) {
+			rcu_read_unlock();
 			goto err;
+		}
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_KERNEL);
@@ -1155,19 +1172,6 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
 #endif
 
-	rcu_read_lock();
-	helper = __nf_ct_helper_find(rtuple);
-	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
-		if (help == NULL) {
-			rcu_read_unlock();
-			err = -ENOMEM;
-			goto err;
-		}
-		/* not in hash table yet so not strictly necessary */
-		rcu_assign_pointer(help->helper, helper);
-	}
-
 	/* setup master conntrack: this is a confirmed expectation */
 	if (master_ct) {
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
