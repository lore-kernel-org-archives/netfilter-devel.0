From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] monitor: Rewrite SETELEM callback
Date: Mon, 17 Jul 2017 17:06:05 +0200
Message-ID: <20170717150606.32097-2-phil@nwl.cc>
References: <20170717150606.32097-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46637 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdGQPGb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:06:31 -0400
In-Reply-To: <20170717150606.32097-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Printing of SETELEM events for interval sets was broken as the
callback did not reassemble the two elements that (mostly) make up a
range. But since half-open ranges are represented by a single element
only and set flushes return the elements in reverse order, a fix was not
quite straightforward.

This patch implements an element cache needed for reassembly and makes
element printing dependent upon a number of conditions so that all cases
are treated correctly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 272 ++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 219 insertions(+), 53 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2e30622de4bb1..18ccf7e4f4f65 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2196,84 +2196,248 @@ out:
 	return MNL_CB_OK;
 }
 
-static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
-				     struct netlink_mon_handler *monh)
+static void setelem_print_default(struct set *set, int type,
+				  struct netlink_mon_handler *monh)
+{
+	switch (type) {
+		case NFT_MSG_NEWSETELEM:
+			printf("add ");
+			break;
+		case NFT_MSG_DELSETELEM:
+			printf("delete ");
+			break;
+		default:
+			return;
+	}
+	printf("element %s %s %s ", family2str(set->handle.family),
+	       set->handle.table, set->handle.set);
+	expr_print(set->init, monh->ctx->octx);
+	printf("\n");
+}
+
+static struct {
+	struct set *set;
+	int event_type;
+} setelem_cache;
+
+static unsigned int setelem_cache_size(void)
+{
+	if (!setelem_cache.set)
+		return 0;
+
+	return setelem_cache.set->init->size;
+}
+
+static void setelem_cache_print_default(struct netlink_mon_handler *monh)
+{
+	if (!setelem_cache.set)
+		return;
+
+	interval_map_decompose(setelem_cache.set->init);
+	setelem_print_default(setelem_cache.set,
+			      setelem_cache.event_type, monh);
+	set_free(setelem_cache.set);
+	setelem_cache.set = NULL;
+}
+
+static struct expr *setelem_cache_get_first(void)
+{
+	struct expr *expr;
+
+	if (!setelem_cache.set)
+		return NULL;
+
+	list_for_each_entry(expr, &setelem_cache.set->init->expressions, list)
+		return expr;
+
+	return NULL;
+}
+
+static bool setelem_cache_should_print(struct expr *new, int new_type)
+{
+	unsigned int cache_size = setelem_cache_size();
+	unsigned long new_val = mpz_get_ui(new->key->value);
+	struct expr *cache_elem = setelem_cache_get_first();
+
+	/* Check elem count:
+	 * - nothing to do if cache is empty,
+	 * - always print if cache is full.
+	 */
+	if (cache_size == 0)
+		return false;
+	if (cache_size >= 2)
+		return true;
+
+	/* Cache contains a single element, which may be part of a regular
+	 * range, or the single element identifying a half-open range. To find
+	 * that out, compare the new element with the existing one:
+	 * - If event type changed, elements are unrelated.
+	 * - If cached element is range end, wait for second one.
+	 * - If new element is range start as well, both are unrelated.
+	 * - If new element is range end but value is not bigger than cached
+	 *   one's, both are unrelated.
+	 */
+
+	if (setelem_cache.event_type != new_type)
+		return true;
+
+	if (cache_elem->flags & EXPR_F_INTERVAL_END)
+		return false;
+
+	if (!(new->flags & EXPR_F_INTERVAL_END))
+		return true;
+
+	if (new_val <= mpz_get_ui(cache_elem->key->value))
+		return true;
+
+	return false;
+}
+
+static void setelem_cache_init(struct netlink_mon_handler *monh,
+			       const struct set *set)
+{
+	struct set *cset;
+
+	if (setelem_cache.set)
+		return;
+
+	cset = set_alloc(monh->loc);
+	cset->keytype	= set->keytype;
+	cset->datatype	= set->datatype;
+	cset->flags	= set->flags;
+	cset->init		= set_expr_alloc(monh->loc, set);
+	cset->handle.family	= set->handle.family;
+	cset->handle.table	= xstrdup(set->handle.table);
+	cset->handle.set	= xstrdup(set->handle.set);
+
+	setelem_cache.set = cset;
+}
+
+static void setelem_cache_add(const struct expr *elem, int type)
+{
+	compound_expr_add(setelem_cache.set->init, expr_clone(elem));
+	setelem_cache.event_type = type;
+}
+
+static struct set *parse_nftnl_set(struct netlink_mon_handler *monh,
+				   const struct nftnl_set *nls)
 {
 	struct nftnl_set_elems_iter *nlsei;
 	struct nftnl_set_elem *nlse;
-	struct nftnl_set *nls;
-	struct set *dummyset;
-	struct set *set;
-	const char *setname, *table;
+	const char *table, *setname;
 	uint32_t family;
+	struct set *orig, *set;
 
-	nls = netlink_setelem_alloc(nlh);
 	table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
 	setname = nftnl_set_get_str(nls, NFTNL_SET_NAME);
 	family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 
-	set = set_lookup_global(family, table, setname);
-	if (set == NULL) {
-		fprintf(stderr, "W: Received event for an unknown set.");
-		goto out;
+	orig = set_lookup_global(family, table, setname);
+
+	if (orig == NULL) {
+		fprintf(stderr, "W: Received event for an unknown set.\n");
+		return NULL;
 	}
 
-	switch (monh->format) {
-	case NFTNL_OUTPUT_DEFAULT:
-		if (set->flags & NFT_SET_ANONYMOUS)
-			goto out;
+	set = set_alloc(monh->loc);
+	set->keytype	= orig->keytype;
+	set->datatype	= orig->datatype;
+	set->flags	= orig->flags;
+	set->init	= set_expr_alloc(monh->loc, orig);
+	set->handle.family	= family;
+	set->handle.table	= xstrdup(table);
+	set->handle.set		= xstrdup(setname);
 
-		/* we want to 'delinearize' the set_elem, but don't
-		 * modify the original cached set. This path is only
-		 * used by named sets, so use a dummy set.
-		 */
-		dummyset = set_alloc(monh->loc);
-		dummyset->keytype = set->keytype;
-		dummyset->datatype = set->datatype;
-		dummyset->init = set_expr_alloc(monh->loc, set);
-
-		nlsei = nftnl_set_elems_iter_create(nls);
-		if (nlsei == NULL)
-			memory_allocation_error();
+	nlsei = nftnl_set_elems_iter_create(nls);
+	if (nlsei == NULL)
+		memory_allocation_error();
 
-		nlse = nftnl_set_elems_iter_next(nlsei);
-		while (nlse != NULL) {
-			if (netlink_delinearize_setelem(nlse, dummyset) < 0) {
-				set_free(dummyset);
-				nftnl_set_elems_iter_destroy(nlsei);
-				goto out;
-			}
-			nlse = nftnl_set_elems_iter_next(nlsei);
+	nlse = nftnl_set_elems_iter_next(nlsei);
+	while (nlse != NULL) {
+		if (netlink_delinearize_setelem(nlse, set) < 0) {
+			fprintf(stderr, "W: Parsing nftnl set failed.\n");
+			set_free(set);
+			nftnl_set_elems_iter_destroy(nlsei);
+			return NULL;
 		}
-		nftnl_set_elems_iter_destroy(nlsei);
+		nlse = nftnl_set_elems_iter_next(nlsei);
+	}
+	nftnl_set_elems_iter_destroy(nlsei);
 
-		switch (type) {
-		case NFT_MSG_NEWSETELEM:
-			printf("add ");
-			break;
-		case NFT_MSG_DELSETELEM:
-			printf("delete ");
-			break;
-		default:
-			set_free(dummyset);
-			goto out;
-		}
-		printf("element %s %s %s ", family2str(family), table, setname);
-		expr_print(dummyset->init, monh->ctx->octx);
-		printf("\n");
+	return set;
+}
 
-		set_free(dummyset);
-		break;
+static bool expr_is_null_elem(const struct expr *expr)
+{
+	if (!(expr->flags & EXPR_F_INTERVAL_END))
+		return false;
+
+	if (mpz_cmp_ui(expr->key->value, 0))
+		return false;
+
+	return true;
+}
+
+static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
+				     struct netlink_mon_handler *monh)
+{
+	struct nftnl_set *nls;
+	struct set *dummyset;
+	struct expr *expr;
+
+	nls = netlink_setelem_alloc(nlh);
+
+	switch (monh->format) {
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
+		/* XXX: this still prints the null element */
 		nftnl_set_fprintf(stdout, nls, monh->format,
 				  netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
+		goto out_free_nftnl_set;
+	case NFTNL_OUTPUT_DEFAULT:
 		break;
 	}
-out:
+
+	dummyset = parse_nftnl_set(monh, nls);
+	if (!dummyset)
+		goto out_free_nftnl_set;
+
+	if (dummyset->flags & NFT_SET_ANONYMOUS)
+		goto out_free_dummyset;
+
+	if (!(dummyset->flags & NFT_SET_INTERVAL)) {
+		setelem_cache_print_default(monh);
+		setelem_print_default(dummyset, type, monh);
+		goto out_free_dummyset;
+	}
+
+	list_for_each_entry(expr, &dummyset->init->expressions, list) {
+		if (expr_is_null_elem(expr))
+			continue;
+
+		if (setelem_cache_should_print(expr, type))
+			setelem_cache_print_default(monh);
+
+		setelem_cache_init(monh, dummyset);
+		setelem_cache_add(expr, type);
+	}
+
+out_free_dummyset:
+	set_free(dummyset);
+out_free_nftnl_set:
 	nftnl_set_free(nls);
 	return MNL_CB_OK;
+
+}
+
+static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
+					    int type,
+					    struct netlink_mon_handler *monh)
+{
+	setelem_cache_print_default(monh);
+
+	return MNL_CB_OK;
 }
 
 static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
@@ -2914,6 +3078,8 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELOBJ:
 		ret = netlink_events_obj_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWGEN:
+		ret = netlink_events_setelem_newgen_cb(nlh, type, monh);
 	}
 	fflush(stdout);
 
-- 
2.13.1

