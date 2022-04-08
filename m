Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EED4C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 12:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiDHNAp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiDHNAo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:00:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5695AF94E6
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 05:58:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 01437643B5;
        Fri,  8 Apr 2022 14:54:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next RFC 1/2] netfilter: conntrack: add nf_ct_iter_data object for nf_ct_iterate_cleanup*()
Date:   Fri,  8 Apr 2022 14:58:36 +0200
Message-Id: <20220408125837.221673-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a structure to collect all the context data that is
passed to the cleanup iterator.

 struct nf_ct_iter_data {
       struct net *net;
       void *data;
       u32 portid;
       int report;
 };

There is a netns field that allows to clean up conntrack entries
specifically owned by the specified netns.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
compile tested only.

 include/net/netfilter/nf_conntrack.h |  9 ++++-
 net/netfilter/nf_conntrack_core.c    | 51 +++++++++++-----------------
 net/netfilter/nf_conntrack_netlink.c |  8 +++--
 net/netfilter/nf_conntrack_proto.c   |  9 +++--
 net/netfilter/nf_conntrack_timeout.c |  6 +++-
 net/netfilter/nf_nat_masquerade.c    |  4 ++-
 6 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 69e6c6a218be..14dd6bbe360c 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -239,10 +239,17 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 /* Set all unconfirmed conntrack as dying */
 void nf_ct_unconfirmed_destroy(struct net *);
 
+struct nf_ct_iter_data {
+	struct net *net;
+	void *data;
+	u32 portid;
+	int report;
+};
+
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
-			       void *data, u32 portid, int report);
+			       struct nf_ct_iter_data *iter_data);
 
 /* also set unconfirmed conntracks as dying. Only use in module exit path. */
 void nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0164e5f522e8..93c30c16bade 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2319,7 +2319,7 @@ static bool nf_conntrack_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 /* Bring out ya dead! */
 static struct nf_conn *
 get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
-		void *data, unsigned int *bucket)
+		const struct nf_ct_iter_data *iter_data, unsigned int *bucket)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -2350,7 +2350,12 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 			 * tuple while iterating.
 			 */
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (iter(ct, data))
+
+			if (iter_data->net &&
+			    !net_eq(iter_data->net, nf_ct_net(ct)))
+				continue;
+
+			if (iter(ct, iter_data->data))
 				goto found;
 		}
 		spin_unlock(lockp);
@@ -2367,7 +2372,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 }
 
 static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
-				  void *data, u32 portid, int report)
+				  const struct nf_ct_iter_data *iter_data)
 {
 	unsigned int bucket = 0;
 	struct nf_conn *ct;
@@ -2375,32 +2380,16 @@ static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 	might_sleep();
 
 	mutex_lock(&nf_conntrack_mutex);
-	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
+	while ((ct = get_next_corpse(iter, iter_data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 
-		nf_ct_delete(ct, portid, report);
+		nf_ct_delete(ct, iter_data->portid, iter_data->report);
 		nf_ct_put(ct);
 		cond_resched();
 	}
 	mutex_unlock(&nf_conntrack_mutex);
 }
 
-struct iter_data {
-	int (*iter)(struct nf_conn *i, void *data);
-	void *data;
-	struct net *net;
-};
-
-static int iter_net_only(struct nf_conn *i, void *data)
-{
-	struct iter_data *d = data;
-
-	if (!net_eq(d->net, nf_ct_net(i)))
-		return 0;
-
-	return d->iter(i, d->data);
-}
-
 static void
 __nf_ct_unconfirmed_destroy(struct net *net)
 {
@@ -2445,21 +2434,18 @@ EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_destroy);
 
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
-			       void *data, u32 portid, int report)
+			       struct nf_ct_iter_data *iter_data)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-	struct iter_data d;
 
 	might_sleep();
 
 	if (atomic_read(&cnet->count) == 0)
 		return;
 
-	d.iter = iter;
-	d.data = data;
-	d.net = net;
+	iter_data->net = net;
 
-	nf_ct_iterate_cleanup(iter_net_only, &d, portid, report);
+	nf_ct_iterate_cleanup(iter, iter_data);
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 
@@ -2477,6 +2463,7 @@ EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 void
 nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
+	struct nf_ct_iter_data iter_data = {};
 	struct net *net;
 
 	down_read(&net_rwsem);
@@ -2503,13 +2490,14 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	 */
 	synchronize_net();
 
-	nf_ct_iterate_cleanup(iter, data, 0, 0);
+	iter_data.data = data;
+	nf_ct_iterate_cleanup(iter, &iter_data);
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
 
 static int kill_all(struct nf_conn *i, void *data)
 {
-	return net_eq(nf_ct_net(i), data);
+	return 1;
 }
 
 void nf_conntrack_cleanup_start(void)
@@ -2544,8 +2532,9 @@ void nf_conntrack_cleanup_net(struct net *net)
 
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 {
-	int busy;
+	struct nf_ct_iter_data iter_data = {};
 	struct net *net;
+	int busy;
 
 	/*
 	 * This makes sure all current packets have passed through
@@ -2558,7 +2547,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
-		nf_ct_iterate_cleanup(kill_all, net, 0, 0);
+		nf_ct_iterate_cleanup_net(net, kill_all, &iter_data);
 		if (atomic_read(&cnet->count) != 0)
 			busy = 1;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 924d766e6c53..8cdbaafe4d73 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1559,6 +1559,10 @@ static int ctnetlink_flush_conntrack(struct net *net,
 				     u32 portid, int report, u8 family)
 {
 	struct ctnetlink_filter *filter = NULL;
+	struct nf_ct_iter_data iter = {
+		.portid		= portid,
+		.report		= report,
+	};
 
 	if (ctnetlink_needs_filter(family, cda)) {
 		if (cda[CTA_FILTER])
@@ -1569,8 +1573,8 @@ static int ctnetlink_flush_conntrack(struct net *net,
 			return PTR_ERR(filter);
 	}
 
-	nf_ct_iterate_cleanup_net(net, ctnetlink_flush_iterate, filter,
-				  portid, report);
+	iter.data = filter;
+	nf_ct_iterate_cleanup_net(net, ctnetlink_flush_iterate, &iter);
 	kfree(filter);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index d1f2d3c8d2b1..7a7139c55af4 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -538,9 +538,12 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
  out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
 
-	if (fixup_needed)
-		nf_ct_iterate_cleanup_net(net, nf_ct_tcp_fixup,
-					  (void *)(unsigned long)nfproto, 0, 0);
+	if (fixup_needed) {
+		struct nf_ct_iter_data iter = {
+			.data	= (void *)(unsigned long)nfproto,
+		};
+		nf_ct_iterate_cleanup_net(net, nf_ct_tcp_fixup, &iter);
+	}
 
 	return err;
 }
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index cec166ecba77..922c2a0e8649 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -38,7 +38,11 @@ static int untimeout(struct nf_conn *ct, void *timeout)
 
 void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout)
 {
-	nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
+	struct nf_ct_iter_data iter = {
+		.data	= timeout,
+	};
+
+	nf_ct_iterate_cleanup_net(net, untimeout, &iter);
 }
 EXPORT_SYMBOL_GPL(nf_ct_untimeout);
 
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index e32fac374608..35ab1082f3bd 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -77,11 +77,13 @@ EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
 
 static void iterate_cleanup_work(struct work_struct *work)
 {
+	struct nf_ct_iter_data iter = {};
 	struct masq_dev_work *w;
 
 	w = container_of(work, struct masq_dev_work, work);
 
-	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
+	iter.data = (void *)w;
+	nf_ct_iterate_cleanup_net(w->net, w->iter, &iter);
 
 	put_net_track(w->net, &w->ns_tracker);
 	kfree(w);
-- 
2.30.2

