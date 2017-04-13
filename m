From: Jarno Rajahalme <jarno@ovn.org>
Subject: [PATCH nf] datapath: Delete conntrack entry clashing with an expectation.
Date: Thu, 13 Apr 2017 16:01:22 -0700
Message-ID: <1492124482-122989-1-git-send-email-jarno@ovn.org>
Cc: jarno@ovn.org, joe@ovn.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:39328 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbdDMXBg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:01:36 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 3FE8247A55F
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:01:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Conntrack helpers do not check for a potentially clashing conntrack
entry when creating a new expectation.  Also, nf_conntrack_in() will
check expectations (via init_conntrack()) only if a conntrack entry
can not be found.  The expectation for a packet which also matches an
existing conntrack entry will not be removed by conntrack, and is
currently handled inconsistently by OVS, as OVS expects the
expectation to be removed when the connection tracking entry matching
that expectation is confirmed.

It should be noted that normally an IP stack would not allow reuse of
a 5-tuple of an old (possibly lingering) connection for a new data
connection, so this is somewhat unlikely corner case.  However, it is
possible that a misbehaving source could cause conntrack entries be
created that could then interfere with new related connections.

Fix this in the OVS module by deleting the clashing conntrack entry
after an expectation has been matched.  This causes the following
nf_conntrack_in() call also find the expectation and remove it when
creating the new conntrack entry, as well as the forthcoming reply
direction packets to match the new related connection instead of the
old clashing conntrack entry.

Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
Reported-by: Yang Song <yangsong@vmware.com>
Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
---
 net/openvswitch/conntrack.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 7b2c2fc..e1a77be 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -514,10 +514,40 @@ ovs_ct_expect_find(struct net *net, const struct nf_conntrack_zone *zone,
 		   u16 proto, const struct sk_buff *skb)
 {
 	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_expect *exp;
 
 	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, net, &tuple))
 		return NULL;
-	return __nf_ct_expect_find(net, zone, &tuple);
+
+	exp = __nf_ct_expect_find(net, zone, &tuple);
+
+	if (exp) {
+		struct nf_conntrack_tuple_hash *h;
+
+		/* Delete existing conntrack entry, if it clashes with the
+		 * expectation.  This can happen since conntrack ALGs do not
+		 * check for clashes between (new) expectations and existing
+		 * conntrack entries.  nf_conntrack_in() will check the
+		 * expectations only if a conntrack entry can not be found,
+		 * which can lead to OVS finding the expectation (here) in the
+		 * init direction, but which will not be removed by the
+		 * nf_conntrack_in() call, if a matching conntrack entry is
+		 * found instead.  In this case all init direction packets
+		 * would be reported as new related packets, while reply
+		 * direction packets would be reported as un-related
+		 * established packets. */
+
+		h = nf_conntrack_find_get(net, zone, &tuple);
+		if (h) {
+			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
+			if (nf_ct_is_confirmed(ct))
+				nf_ct_delete(ct, 0, 0);
+			nf_conntrack_put(&ct->ct_general);
+		}
+	}
+
+	return exp;
 }
 
 /* This replicates logic from nf_conntrack_core.c that is not exported. */
-- 
2.1.4

