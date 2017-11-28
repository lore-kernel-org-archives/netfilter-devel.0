From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 2/3] netfilter: ctnetlink: use 64-bit conntrack ID
Date: Tue, 28 Nov 2017 03:13:08 +0100
Message-ID: <20171128021309.11277-2-pablo@netfilter.org>
References: <20171128021309.11277-1-pablo@netfilter.org>
Cc: richard@nod.at, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752889AbdK1CNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 21:13:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 70A6BE2C46
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:13:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F78EDA86F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:13:16 +0100 (CET)
In-Reply-To: <20171128021309.11277-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The older 32-bit conntrack ID is still exposed for backward
compatibility reasons, add new CTA_ID64 attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |  2 ++
 net/netfilter/nf_conntrack_netlink.c               | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 7397e022ce6e..dcd7b97eeeac 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -54,6 +54,8 @@ enum ctattr_type {
 	CTA_MARK_MASK,
 	CTA_LABELS,
 	CTA_LABELS_MASK,
+	CTA_ID64,
+	CTA_PAD,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b3b8249ced4a..7aecb8ae5ecc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -446,7 +446,8 @@ static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
 
 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
+	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)) ||
+	    nla_put_be64(skb, CTA_ID64, cpu_to_be64(nf_ct_id(ct)), CTA_PAD))
 		goto nla_put_failure;
 	return 0;
 
@@ -600,6 +601,7 @@ static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + 3 * nla_total_size(0) /* CTA_TUPLE_PROTO */
 	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_ID */
+	       + nla_total_size(sizeof(u64)) /* CTA_ID64 */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_STATUS */
 	       + ctnetlink_acct_size(ct)
 	       + ctnetlink_timestamp_size(ct)
@@ -1108,6 +1110,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 	[CTA_LABELS_MASK]	= { .type = NLA_BINARY,
 				    .len = NF_CT_LABELS_MAX_SIZE },
+	[CTA_ID64]		= { .type = NLA_U64 },
 };
 
 static int ctnetlink_flush_conntrack(struct net *net,
@@ -1174,6 +1177,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 			nf_ct_put(ct);
 			return -ENOENT;
 		}
+	} else if (cda[CTA_ID64]) {
+		u64 id = ntohl(nla_get_be64(cda[CTA_ID64]));
+
+		if (id != nf_ct_id(ct)) {
+			nf_ct_put(ct);
+			return -ENOENT;
+		}
 	}
 
 	nf_ct_delete(ct, NETLINK_CB(skb).portid, nlmsg_report(nlh));
@@ -1319,7 +1329,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 				if (!atomic_inc_not_zero(&ct->ct_general.use))
 					continue;
 				cb->args[0] = cpu;
-				cb->args[1] = (unsigned long)ct;
+				cb->args[1] = nf_ct_id(ct);
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
 			}
-- 
2.11.0

