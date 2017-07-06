From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [PATCH] monitor: fix printing of range elements in named sets
Date: Thu, 06 Jul 2017 16:36:45 +0200
Message-ID: <149935174634.19966.16018870027671610502.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41675 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750970AbdGFPsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2017 11:48:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

CC: Phil Sutter <phil@nwl.cc>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---

This was discussed during Netfilter Workshop 2017 in Faro, Portugal.
I think Phil has another patch to address this issue from a different
approach.

 include/rule.h |    2 ++
 src/netlink.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 7424b21..1b44e4c 100644
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
index 880502c..ad0e712 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2198,6 +2198,46 @@ out:
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
+	/* cache first element of the range */
+	elem = list_entry(dummyset->init->expressions.prev, struct expr, list);
+	if (!(elem->flags & EXPR_F_INTERVAL_END)) {
+		cached_set->rg_cache = expr_clone(elem);
+		return true;
+	}
+
+	/* we have all the information now */
+	compound_expr_add(dummyset->init, cached_set->rg_cache);
+	interval_map_decompose(dummyset->init);
+
+	return false;
+}
+
 static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 				     struct netlink_mon_handler *monh)
 {
@@ -2240,6 +2280,11 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 
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
@@ -2251,6 +2296,10 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 
 		switch (type) {
 		case NFT_MSG_NEWSETELEM:
+			if (netlink_event_range_cache(set, dummyset)) {
+				set_free(dummyset);
+				goto out;
+			}
 			printf("add ");
 			break;
 		case NFT_MSG_DELSETELEM:
@@ -2264,6 +2313,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		expr_print(dummyset->init, monh->ctx->octx);
 		printf("\n");
 
+		expr_free(set->rg_cache);
 		set_free(dummyset);
 		break;
 	case NFTNL_OUTPUT_XML:

