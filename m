From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/3] netfilter: restart nf ct cleanup if hash resize happen
Date: Sun, 21 May 2017 13:39:07 +0800
Message-ID: <1495345149-57674-2-git-send-email-zlpnobody@163.com>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:51137 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdEUFjr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 01:39:47 -0400
In-Reply-To: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Similar to commit 474803d37e7f ("netfilter: cttimeout: unlink timeout
obj again when hash resize happen"), when hash resize happen, we should
try to do cleanup work from the 0#bucket again, so we will never miss
the conntrack entries which we are intrested in. This is important for
the module removal.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e847dba..dec4c2a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1587,7 +1587,7 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 /* Bring out ya dead! */
 static struct nf_conn *
 get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
-		void *data, unsigned int *bucket)
+		void *data, unsigned int *bucket, unsigned int *hsize)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -1595,20 +1595,28 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 	int cpu;
 	spinlock_t *lockp;
 
-	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
+	for (; *bucket < *hsize; (*bucket)++) {
 		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
 		local_bh_disable();
 		nf_conntrack_lock(lockp);
-		if (*bucket < nf_conntrack_htable_size) {
-			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-					continue;
-				ct = nf_ct_tuplehash_to_ctrack(h);
-				if (net_eq(nf_ct_net(ct), net) &&
-				    iter(ct, data))
-					goto found;
-			}
+
+		/* nf conntrack hash resize happened. */
+		if (*hsize != nf_conntrack_htable_size) {
+			*hsize = nf_conntrack_htable_size;
+			*bucket = 0;
+			goto cont;
+		}
+
+		hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket],
+					   hnnode) {
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				continue;
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (net_eq(nf_ct_net(ct), net) &&
+			    iter(ct, data))
+				goto found;
 		}
+cont:
 		spin_unlock(lockp);
 		local_bh_enable();
 		cond_resched();
@@ -1640,13 +1648,16 @@ void nf_ct_iterate_cleanup(struct net *net,
 {
 	struct nf_conn *ct;
 	unsigned int bucket = 0;
+	unsigned int hsize;
 
 	might_sleep();
 
 	if (atomic_read(&net->ct.count) == 0)
 		return;
 
-	while ((ct = get_next_corpse(net, iter, data, &bucket)) != NULL) {
+	hsize = nf_conntrack_htable_size;
+	while ((ct = get_next_corpse(net, iter, data, &bucket,
+				     &hsize)) != NULL) {
 		/* Time to push up daises... */
 
 		nf_ct_delete(ct, portid, report);
-- 
2.5.5


