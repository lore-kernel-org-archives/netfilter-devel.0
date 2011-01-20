From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] netfilter: implement ctnetlink_dump_ruleid()
Date: Thu, 20 Jan 2011 23:47:07 +0100
Message-ID: <1295563629-14996-4-git-send-email-richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
 <1295563629-14996-2-git-send-email-richard@nod.at>
 <1295563629-14996-3-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:39947 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1ATWr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:47:29 -0500
In-Reply-To: <1295563629-14996-3-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ctnetlink_dump_ruleid() dumps the rule ids within a
connection tracking entry via netlink.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/netfilter/nfnetlink_conntrack.h |    4 ++++
 net/netfilter/nf_conntrack_netlink.c          |   23 ++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 19711e3..8f48b99 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -42,6 +42,10 @@ enum ctattr_type {
 	CTA_SECMARK,		/* obsolete */
 	CTA_ZONE,
 	CTA_SECCTX,
+	CTA_RULEID_ESTABLISHED,
+	CTA_RULEID_RELATED,
+	CTA_RULEID_NEW,
+	CTA_RULEID_REPLY,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b729ace..4bded09 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -42,6 +42,7 @@
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_conntrack_ruleid.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -132,6 +133,25 @@ nla_put_failure:
 }
 
 static inline int
+ctnetlink_dump_ruleid(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	struct nf_conn_ruleid *nfcr = nf_ct_ext_find(ct, NF_CT_EXT_RULEID);
+
+	if (!nfcr)
+		return 0;
+
+	NLA_PUT_BE16(skb, CTA_RULEID_ESTABLISHED, htons(nfcr->rule[IP_CT_ESTABLISHED]));
+	NLA_PUT_BE16(skb, CTA_RULEID_RELATED, htons(nfcr->rule[IP_CT_RELATED]));
+	NLA_PUT_BE16(skb, CTA_RULEID_NEW, htons(nfcr->rule[IP_CT_NEW]));
+	NLA_PUT_BE16(skb, CTA_RULEID_REPLY, htons(nfcr->rule[IP_CT_IS_REPLY]));
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static inline int
 ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	long timeout = (ct->timeout.expires - jiffies) / HZ;
@@ -411,7 +431,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
-	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
+	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0 ||
+	    ctnetlink_dump_ruleid(skb, ct) < 0)
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
-- 
1.6.6.1

