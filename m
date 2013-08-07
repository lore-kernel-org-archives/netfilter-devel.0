From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v3, -next] netfilter: ctnetlink: attach expectations to unconfirmed conntracks
Date: Wed,  7 Aug 2013 15:43:30 +0200
Message-ID: <1375883010-21852-1-git-send-email-pablo@netfilter.org>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60994 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187Ab3HGNno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:43:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the capability to attach expectations to unconfirmed
conntrack entries. I'm using this from nfqueue, in that case the packet
is retained until the user-space application returns the verdict on it.
This patch is required by conntrack helpers that trigger expectations
based on the first packet seen like the TFTP and the DHCPv6 user-space
helpers.

I don't see any practical use for this out of the nfqueue context as
you won't likely find what you look for. But if that ever happens,
we have to bump the refcount to avoid holding a reference to an
invalid conntrack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h          |    4 ++
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_core.c                  |   46 ++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c               |   14 +++++-
 4 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index fb2b623..75e8a30 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -62,6 +62,10 @@ extern struct nf_conntrack_tuple_hash *
 nf_conntrack_find_get(struct net *net, u16 zone,
 		      const struct nf_conntrack_tuple *tuple);
 
+extern struct nf_conntrack_tuple_hash *
+nf_ct_unconfirmed_find_get(struct net *net, u16 zone,
+			   const struct nf_conntrack_tuple *tuple);
+
 extern int __nf_conntrack_confirm(struct sk_buff *skb);
 
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 08fabc6..8f7c2fe 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -187,6 +187,7 @@ enum ctattr_expect {
 	CTA_EXPECT_CLASS,
 	CTA_EXPECT_NAT,
 	CTA_EXPECT_FN,
+	CTA_EXPECT_MASTER_STATUS,
 	__CTA_EXPECT_MAX
 };
 #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0934611..7e9a257 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -406,6 +406,52 @@ nf_conntrack_find_get(struct net *net, u16 zone,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
 
+static struct nf_conntrack_tuple_hash *
+__nf_ct_unconfirmed_find(struct net *net, u16 zone,
+			 const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_tuple_hash *h, *ret = NULL;
+	struct hlist_nulls_node *n;
+
+	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.unconfirmed, hnnode) {
+		if (nf_ct_tuple_equal(tuple, &h->tuple) &&
+		    nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)) == zone) {
+			ret = h;
+			break;
+		}
+	}
+	return ret;
+}
+
+struct nf_conntrack_tuple_hash *
+nf_ct_unconfirmed_find_get(struct net *net, u16 zone,
+			   const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
+
+	rcu_read_lock();
+begin:
+	h = __nf_ct_unconfirmed_find(net, zone, tuple);
+	if (h) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (unlikely(nf_ct_is_dying(ct) ||
+			     !atomic_inc_not_zero(&ct->ct_general.use)))
+			h = NULL;
+		else {
+			if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple) ||
+				     nf_ct_zone(ct) != zone)) {
+				nf_ct_put(ct);
+				goto begin;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	return h;
+}
+EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_find_get);
+
 static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 				       unsigned int hash,
 				       unsigned int repl_hash)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e842c0d..c578e76 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2747,7 +2747,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper = NULL;
-	u_int32_t class = 0;
+	u_int32_t class = 0, master_status;
 	int err = 0;
 
 	/* caller guarantees that those three CTA_EXPECT_* exist */
@@ -2761,8 +2761,18 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	if (err < 0)
 		return err;
 
+	if (cda[CTA_EXPECT_MASTER_STATUS]) {
+		master_status =
+			ntohl(nla_get_be32(cda[CTA_EXPECT_MASTER_STATUS]));
+	} else
+		master_status = IPS_CONFIRMED;
+
 	/* Look for master conntrack of this expectation */
-	h = nf_conntrack_find_get(net, zone, &master_tuple);
+	if (master_status & IPS_CONFIRMED)
+		h = nf_conntrack_find_get(net, zone, &master_tuple);
+	else
+		h = nf_ct_unconfirmed_find_get(net, zone, &master_tuple);
+
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
-- 
1.7.10.4

