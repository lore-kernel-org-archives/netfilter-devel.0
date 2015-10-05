From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 1/3] netfilter: conntrack: fix crash on timeout object removal
Date: Mon,  5 Oct 2015 16:51:01 +0200
Message-ID: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Cc: stephen@networkplumber.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46822 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbbJEOoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 10:44:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The object and module refcounts are updated for each conntrack template,
however, if we delete the iptables rules and we flush the timeout
database, we may end up with invalid references to timeout object that
are just gone.

Resolve this race by setting the timeout reference to NULL when the
custom timeout entry is removed from our base. This patch requires some
RCU trickery to ensure safe pointer handling.

This handling is similer to what we already do with conntrack helpers,
the idea is to avoid bumping the timeout object reference counter from
the packet path to avoid the cost of atomic ops.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_timeout.h | 25 ++++++++++++++++-----
 net/netfilter/nf_conntrack_core.c            |  9 +++++---
 net/netfilter/nfnetlink_cttimeout.c          | 33 ++++++++++++++++++++++++++++
 net/netfilter/xt_CT.c                        |  4 +++-
 4 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 6230871..f72be38 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -20,10 +20,20 @@ struct ctnl_timeout {
 };
 
 struct nf_conn_timeout {
-	struct ctnl_timeout	*timeout;
+	struct ctnl_timeout __rcu *timeout;
 };
 
-#define NF_CT_TIMEOUT_EXT_DATA(__t) (unsigned int *) &((__t)->timeout->data)
+static inline unsigned int *
+nf_ct_timeout_data(struct nf_conn_timeout *t)
+{
+	struct ctnl_timeout *timeout;
+
+	timeout = rcu_dereference(t->timeout);
+	if (timeout == NULL)
+		return NULL;
+
+	return (unsigned int *)timeout->data;
+}
 
 static inline
 struct nf_conn_timeout *nf_ct_timeout_find(const struct nf_conn *ct)
@@ -47,7 +57,7 @@ struct nf_conn_timeout *nf_ct_timeout_ext_add(struct nf_conn *ct,
 	if (timeout_ext == NULL)
 		return NULL;
 
-	timeout_ext->timeout = timeout;
+	rcu_assign_pointer(timeout_ext->timeout, timeout);
 
 	return timeout_ext;
 #else
@@ -64,10 +74,13 @@ nf_ct_timeout_lookup(struct net *net, struct nf_conn *ct,
 	unsigned int *timeouts;
 
 	timeout_ext = nf_ct_timeout_find(ct);
-	if (timeout_ext)
-		timeouts = NF_CT_TIMEOUT_EXT_DATA(timeout_ext);
-	else
+	if (timeout_ext) {
+		timeouts = nf_ct_timeout_data(timeout_ext);
+		if (unlikely(!timeouts))
+			timeouts = l4proto->get_timeouts(net);
+	} else {
 		timeouts = l4proto->get_timeouts(net);
+	}
 
 	return timeouts;
 #else
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 09d1d19..6fc89d8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -940,10 +940,13 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	}
 
 	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
-	if (timeout_ext)
-		timeouts = NF_CT_TIMEOUT_EXT_DATA(timeout_ext);
-	else
+	if (timeout_ext) {
+		timeouts = nf_ct_timeout_data(timeout_ext);
+		if (unlikely(!timeouts))
+			timeouts = l4proto->get_timeouts(net);
+	} else {
 		timeouts = l4proto->get_timeouts(net);
+	}
 
 	if (!l4proto->new(ct, skb, dataoff, timeouts)) {
 		nf_conntrack_free(ct);
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 476accd..138cd0a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -291,6 +291,34 @@ cttimeout_get_timeout(struct sock *ctnl, struct sk_buff *skb,
 	return ret;
 }
 
+static void untimeout(struct nf_conntrack_tuple_hash *i,
+		      struct ctnl_timeout *timeout)
+{
+	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
+	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
+
+	if (timeout_ext && (!timeout || timeout_ext->timeout == timeout))
+                RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+}
+
+static void ctnl_untimeout(struct ctnl_timeout *timeout)
+{
+	struct nf_conntrack_tuple_hash *h;
+	const struct hlist_nulls_node *nn;
+	int i;
+
+	local_bh_disable();
+	for (i = 0; i < init_net.ct.htable_size; i++) {
+		spin_lock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+		if (i < init_net.ct.htable_size) {
+			hlist_nulls_for_each_entry(h, nn, &init_net.ct.hash[i], hnnode)
+				untimeout(h, timeout);
+		}
+		spin_unlock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+	}
+	local_bh_enable();
+}
+
 /* try to delete object, fail if it is still in use. */
 static int ctnl_timeout_try_del(struct ctnl_timeout *timeout)
 {
@@ -301,6 +329,7 @@ static int ctnl_timeout_try_del(struct ctnl_timeout *timeout)
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
 		nf_ct_l4proto_put(timeout->l4proto);
+		ctnl_untimeout(timeout);
 		kfree_rcu(timeout, rcu_head);
 	} else {
 		/* still in use, restore reference counter. */
@@ -567,6 +596,10 @@ static void __exit cttimeout_exit(void)
 	pr_info("cttimeout: unregistering from nfnetlink.\n");
 
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
+
+	/* Make sure no conntrack objects refer to custom timeouts anymore. */
+	ctnl_untimeout(NULL);
+
 	list_for_each_entry_safe(cur, tmp, &cttimeout_list, head) {
 		list_del_rcu(&cur->head);
 		/* We are sure that our objects have no clients at this point,
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index faf32d8..b43bf13 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -318,8 +318,10 @@ static void xt_ct_destroy_timeout(struct nf_conn *ct)
 
 	if (timeout_put) {
 		timeout_ext = nf_ct_timeout_find(ct);
-		if (timeout_ext)
+		if (timeout_ext) {
 			timeout_put(timeout_ext->timeout);
+			RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+		}
 	}
 	rcu_read_unlock();
 #endif
-- 
2.1.4

