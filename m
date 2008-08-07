From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] [PATCH] fix double helper assignation for NAT'ed
	conntracks
Date: Thu, 07 Aug 2008 12:08:03 +0200
Message-ID: <20080807100803.8036.8684.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37274 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753290AbYHGPXk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:23:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
---

 net/netfilter/nf_conntrack_netlink.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dd23339..a984b1c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1139,16 +1139,33 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
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
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
@@ -1156,19 +1173,6 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
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

