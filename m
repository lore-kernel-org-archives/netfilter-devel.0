From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: ctnetlink: attach expectations to unconfirmed conntracks
Date: Thu, 23 May 2013 10:42:35 +0200
Message-ID: <1369298557-5351-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33599 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab3EWImr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 04:42:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the capability to attach expectations to unconfirmed
conntrack entries. This patch is required by the DHCPv6 helper in
user-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h               |    4 ++++
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_core.c                  |   20 ++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c               |   14 ++++++++++++--
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 644d9c2..d172fc5 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -180,6 +180,10 @@ extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(struct net *net, u16 zone,
 		    const struct nf_conntrack_tuple *tuple);
 
+struct nf_conntrack_tuple_hash *
+nf_ct_unconfirmed_find(struct net *net, u16 zone,
+		       const struct nf_conntrack_tuple *tuple);
+
 extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 extern void nf_ct_delete_from_lists(struct nf_conn *ct);
 extern void nf_ct_dying_timeout(struct nf_conn *ct);
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
index ebb81d6..a6e5764 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -401,6 +401,26 @@ nf_conntrack_find_get(struct net *net, u16 zone,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
 
+struct nf_conntrack_tuple_hash *
+nf_ct_unconfirmed_find(struct net *net, u16 zone,
+		       const struct nf_conntrack_tuple *tuple)
+{
+	struct nf_conntrack_tuple_hash *h, *ret = NULL;
+	struct hlist_nulls_node *n;
+
+	rcu_read_lock();
+	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.unconfirmed, hnnode) {
+		if (nf_ct_tuple_equal(tuple, &h->tuple) &&
+		    nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)) == zone) {
+			ret = h;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_find);
+
 static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 				       unsigned int hash,
 				       unsigned int repl_hash)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6d0f8a1..3596682 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2742,7 +2742,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper = NULL;
-	u_int32_t class = 0;
+	u_int32_t class = 0, master_status;
 	int err = 0;
 
 	/* caller guarantees that those three CTA_EXPECT_* exist */
@@ -2756,8 +2756,18 @@ ctnetlink_create_expect(struct net *net, u16 zone,
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
+		h = nf_ct_unconfirmed_find(net, zone, &master_tuple);
+
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
-- 
1.7.10.4

