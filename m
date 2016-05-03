From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 3/4,v2] netfilter: conntrack: introduce clash resolution on insertion race
Date: Tue,  3 May 2016 13:48:42 +0200
Message-ID: <1462276122-3532-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42245 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870AbcECLsw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 07:48:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5AE831B7F80
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 13:48:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47FA8ADE2
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 13:48:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C3C7F64473
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 13:48:46 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces nf_ct_resolve_clash() to resolve race condition on
conntrack insertions.

This is particularly a problem for connection-less protocols such as
UDP, with no initial handshake. Two or more packets may race to insert
the entry resulting in packet drops.

Another problematic scenario are packets enqueued to userspace via
NFQUEUE after the raw table, that make it easier to trigger this
race.

To resolve this, the idea is to reset the conntrack entry to the one
that won race. Packet and bytes counters are also merged.

The 'insert_failed' stats still accounts for this situation, after
this patch, the drop counter is bumped whenever we drop packets, so we
can watch for unresolved clashes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: drop refcount of the old conntrack entry, otherwise we leak this.
    Call nf_ct_add_to_dying_list() before clash resolution.

 include/net/netfilter/nf_conntrack_l4proto.h |  3 ++
 net/netfilter/nf_conntrack_core.c            | 46 +++++++++++++++++++++++++++-
 net/netfilter/nf_conntrack_proto_udp.c       |  2 ++
 net/netfilter/nf_conntrack_proto_udplite.c   |  2 ++
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 956d8a6..1a5fb36 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -23,6 +23,9 @@ struct nf_conntrack_l4proto {
 	/* L4 Protocol number. */
 	u_int8_t l4proto;
 
+	/* Resolve clashes on insertion races. */
+	bool allow_clash;
+
 	/* Try to fill in the third arg: dataoff is offset past network protocol
            hdr.  Return true if possible. */
 	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8462b54..bb6d837 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -616,6 +616,48 @@ static inline void nf_ct_acct_update(struct nf_conn *ct,
 	}
 }
 
+static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+			     const struct nf_conn *old_ct)
+{
+	struct nf_conn_acct *acct;
+
+	acct = nf_conn_acct_find(old_ct);
+	if (acct) {
+		struct nf_conn_counter *counter = acct->counter;
+		enum ip_conntrack_info ctinfo;
+		unsigned int bytes;
+
+		/* u32 should be fine since we must have seen one packet. */
+		bytes = atomic64_read(&counter[CTINFO2DIR(ctinfo)].bytes);
+		nf_ct_acct_update(ct, ctinfo, bytes);
+	}
+}
+
+/* Resolve race on insertion if this protocol allows this. */
+static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
+			       struct nf_conn *old_ct,
+			       enum ip_conntrack_info ctinfo,
+			       struct nf_conntrack_tuple_hash *h)
+{
+	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+	struct nf_conntrack_l4proto *l4proto;
+
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	if (l4proto->allow_clash &&
+	    !nf_ct_is_dying(ct) &&
+	    atomic_inc_not_zero(&ct->ct_general.use)) {
+		/* Don't modify skb->nfctinfo, we're at POSTROUTING so this
+		 * packet is already leaving our framework, it is too late.
+		 */
+		skb->nfct = &ct->ct_general;
+		nf_ct_acct_merge(ct, ctinfo, old_ct);
+		nf_ct_put(old_ct);
+		return NF_ACCEPT;
+	}
+	NF_CT_STAT_INC(net, drop);
+	return NF_DROP;
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __nf_conntrack_confirm(struct sk_buff *skb)
@@ -630,6 +672,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
 	unsigned int sequence;
+	int ret;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	net = nf_ct_net(ct);
@@ -727,10 +770,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 out:
 	nf_ct_add_to_dying_list(ct);
+	ret = nf_ct_resolve_clash(net, skb, ct, ctinfo, h);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert_failed);
 	local_bh_enable();
-	return NF_DROP;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_confirm);
 
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 478f92f..4fd0405 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -309,6 +309,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDP,
 	.name			= "udp",
+	.allow_clash		= true,
 	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.invert_tuple		= udp_invert_tuple,
 	.print_tuple		= udp_print_tuple,
@@ -341,6 +342,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDP,
 	.name			= "udp",
+	.allow_clash		= true,
 	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.invert_tuple		= udp_invert_tuple,
 	.print_tuple		= udp_print_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 1ac8ee1..9d692f5 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -274,6 +274,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDPLITE,
 	.name			= "udplite",
+	.allow_clash		= true,
 	.pkt_to_tuple		= udplite_pkt_to_tuple,
 	.invert_tuple		= udplite_invert_tuple,
 	.print_tuple		= udplite_print_tuple,
@@ -306,6 +307,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDPLITE,
 	.name			= "udplite",
+	.allow_clash		= true,
 	.pkt_to_tuple		= udplite_pkt_to_tuple,
 	.invert_tuple		= udplite_invert_tuple,
 	.print_tuple		= udplite_print_tuple,
-- 
2.1.4

