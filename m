From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/4] openvswitch: __nf_ct_l{3,4}proto_find() always return a valid pointer
Date: Tue,  3 May 2016 12:54:23 +0200
Message-ID: <1462272863-23946-1-git-send-email-pablo@netfilter.org>
Cc: dev@openvswitch.org, joestringer@nicira.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51653 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbcECKye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 06:54:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D321113C0DF
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:54:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C5005A865
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:54:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 81BD2A862
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:54:30 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the protocol is not natively supported, this assigns generic protocol
tracker so we can always assume a valid pointer after these calls.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/openvswitch/conntrack.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 9741a76..9f0bc49 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -439,20 +439,12 @@ ovs_ct_find_existing(struct net *net, const struct nf_conntrack_zone *zone,
 	u8 protonum;
 
 	l3proto = __nf_ct_l3proto_find(l3num);
-	if (!l3proto) {
-		pr_debug("ovs_ct_find_existing: Can't get l3proto\n");
-		return NULL;
-	}
 	if (l3proto->get_l4proto(skb, skb_network_offset(skb), &dataoff,
 				 &protonum) <= 0) {
 		pr_debug("ovs_ct_find_existing: Can't get protonum\n");
 		return NULL;
 	}
 	l4proto = __nf_ct_l4proto_find(l3num, protonum);
-	if (!l4proto) {
-		pr_debug("ovs_ct_find_existing: Can't get l4proto\n");
-		return NULL;
-	}
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
 			     protonum, net, &tuple, l3proto, l4proto)) {
 		pr_debug("ovs_ct_find_existing: Can't get tuple\n");
-- 
2.1.4

