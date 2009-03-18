From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] netfilter: ctnetlink: remove remaining module refcounting
Date: Wed, 18 Mar 2009 16:42:02 +0100
Message-ID: <1237390923-3122-2-git-send-email-fw@strlen.de>
References: <1237390923-3122-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53678 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbZCRPmL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:42:11 -0400
In-Reply-To: <1237390923-3122-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

convert the remaining refcount users.
As pointed out by Patrick McHardy, the protocols
can be accessed safely using RCU.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9fb7cf7..735ea9c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -599,7 +599,8 @@ ctnetlink_parse_tuple_ip(struct nlattr *attr, struct nf_conntrack_tuple *tuple)
 
 	nla_parse_nested(tb, CTA_IP_MAX, attr, NULL);
 
-	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
+	rcu_read_lock();
+	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
 
 	if (likely(l3proto->nlattr_to_tuple)) {
 		ret = nla_validate_nested(attr, CTA_IP_MAX,
@@ -608,7 +609,7 @@ ctnetlink_parse_tuple_ip(struct nlattr *attr, struct nf_conntrack_tuple *tuple)
 			ret = l3proto->nlattr_to_tuple(tb, tuple);
 	}
 
-	nf_ct_l3proto_put(l3proto);
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -633,7 +634,8 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 		return -EINVAL;
 	tuple->dst.protonum = nla_get_u8(tb[CTA_PROTO_NUM]);
 
-	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	rcu_read_lock();
+	l4proto = __nf_ct_l4proto_find(tuple->src.l3num, tuple->dst.protonum);
 
 	if (likely(l4proto->nlattr_to_tuple)) {
 		ret = nla_validate_nested(attr, CTA_PROTO_MAX,
@@ -642,7 +644,7 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 			ret = l4proto->nlattr_to_tuple(tb, tuple);
 	}
 
-	nf_ct_l4proto_put(l4proto);
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -989,10 +991,11 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, struct nlattr *cda[])
 
 	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, NULL);
 
-	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	rcu_read_lock();
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (l4proto->from_nlattr)
 		err = l4proto->from_nlattr(tb, ct);
-	nf_ct_l4proto_put(l4proto);
+	rcu_read_unlock();
 
 	return err;
 }
-- 
1.5.6.5

