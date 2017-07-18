From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/3] monitor: Fix printing of range elements in named sets
Date: Tue, 18 Jul 2017 17:40:28 +0200
Message-ID: <20170718154029.23976-3-phil@nwl.cc>
References: <20170718154029.23976-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50443 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdGRPks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 11:40:48 -0400
In-Reply-To: <20170718154029.23976-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@netfilter.org>

If you add set elements to interval sets, the output is wrong.
Fix this by caching first element of the range (first event),
then wait for the second element of the range (second event) to
print them both at the same time.

We also avoid printing the first null element required in the RB tree.

Before this patch:

% nft add element t s {10-20, 30-40}
add element ip t s { 0 }
add element ip t s { 10 }
add element ip t s { ftp }
add element ip t s { 30 }
add element ip t s { 41 }

After this patch:

% nft add element t s {10-20, 30-40}
add element ip t s { 10-20 }
add element ip t s { 30-40 }

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Rewrite netlink_event_range_cache() so it correctly handles half-open
  ranges.
- Enable elem caching for NFT_MSG_DELSETELEM events also.
- Drop call to expr_free() for set->rg_cache since that will be done
  when freeing dummyset.
---
 include/rule.h |  2 ++
 src/netlink.c  | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 592c93ddd0e2f..ab376bdd5bcfd 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -217,6 +217,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
  * @datalen:	mapping data len
  * @objtype:	mapping object type
  * @init:	initializer
+ * @rg_cache:	cached range element (left)
  * @policy:	set mechanism policy
  * @desc:	set mechanism desc
  */
@@ -234,6 +235,7 @@ struct set {
 	unsigned int		datalen;
 	uint32_t		objtype;
 	struct expr		*init;
+	struct expr		*rg_cache;
 	uint32_t		policy;
 	struct {
 		uint32_t	size;
diff --git a/src/netlink.c b/src/netlink.c
index be26188e097aa..e1db8e7be923c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2228,6 +2228,51 @@ out:
 	return MNL_CB_OK;
 }
 
+/* returns true if the event should be ignored (i.e. null element) */
+static bool netlink_event_ignore_range_event(struct nftnl_set_elem *nlse)
+{
+        uint32_t flags = 0;
+
+	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_FLAGS))
+		flags = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
+	if (!(flags & NFT_SET_ELEM_INTERVAL_END))
+		return false;
+
+	if (nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_KEY) != 0)
+		return false;
+
+	return true;
+}
+
+/* returns true if the we cached the range element */
+static bool netlink_event_range_cache(struct set *cached_set,
+				      struct set *dummyset)
+{
+	struct expr *elem;
+
+	/* not an interval ? */
+	if (!(cached_set->flags & NFT_SET_INTERVAL))
+		return false;
+
+	/* if cache exists, dummyset must contain the other end of the range */
+	if (cached_set->rg_cache) {
+		compound_expr_add(dummyset->init, cached_set->rg_cache);
+		cached_set->rg_cache = NULL;
+		goto out_decompose;
+	}
+
+	/* don't cache half-open range elements */
+	elem = list_entry(dummyset->init->expressions.prev, struct expr, list);
+	if (!(elem->flags & EXPR_F_INTERVAL_OPEN)) {
+		cached_set->rg_cache = expr_clone(elem);
+		return true;
+	}
+
+out_decompose:
+	interval_map_decompose(dummyset->init);
+	return false;
+}
+
 static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 				     struct netlink_mon_handler *monh)
 {
@@ -2270,6 +2315,11 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 
 		nlse = nftnl_set_elems_iter_next(nlsei);
 		while (nlse != NULL) {
+			if (netlink_event_ignore_range_event(nlse)) {
+				set_free(dummyset);
+				nftnl_set_elems_iter_destroy(nlsei);
+				goto out;
+			}
 			if (netlink_delinearize_setelem(nlse, dummyset) < 0) {
 				set_free(dummyset);
 				nftnl_set_elems_iter_destroy(nlsei);
@@ -2279,6 +2329,11 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		}
 		nftnl_set_elems_iter_destroy(nlsei);
 
+		if (netlink_event_range_cache(set, dummyset)) {
+			set_free(dummyset);
+			goto out;
+		}
+
 		switch (type) {
 		case NFT_MSG_NEWSETELEM:
 			printf("add ");
-- 
2.13.1

