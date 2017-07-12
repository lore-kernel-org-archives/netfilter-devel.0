From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/4] monitor: Fix printing of range elements in named sets
Date: Wed, 12 Jul 2017 14:36:55 +0200
Message-ID: <20170712123658.25363-2-phil@nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41189 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756759AbdGLMhb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:37:31 -0400
In-Reply-To: <20170712123658.25363-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When adding or removing ranges from named sets, the kernel sends
separate netlink events for the lower and upper boundary of the range,
so 'nft monitor' incorrectly treated them as separate elements.

An intuitive approach to fix this is to cache the first element reported
for sets with 'interval' flag set and use it to reconstruct the range
when the second one is reported. Though this does not work for unclosed
intervals: If a range's upper boundary aligns with the maximum value
allowed for the given set datatype, an unclosed interval is created
which consists of only the lower boundary. The kernel then reports this
range as a single element (which does not have EXPR_F_INTERVAL_END flag
set).

This patch solves both cases: netlink_events_setelem_cb() caches the
first reported element of a range. If the upper boundary is reported
afterwards, the same function takes care of the reassembling and cache
removal. If not, 'nft monitor' will eventually receive a NEWGEN message
indicating the end of the transaction. To convert the cached lower
boundary into an unclosed range element, a new callback
netlink_events_setelem_newgen_cb() is introduced which after printing
the element also clears the cache.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2e30622de4bb1..65c6f05a57649 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2196,6 +2196,14 @@ out:
 	return MNL_CB_OK;
 }
 
+static struct {
+	int type;
+	uint32_t family;
+	char *table;
+	char *setname;
+	struct set *set;
+} setelem_cache;
+
 static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 				     struct netlink_mon_handler *monh)
 {
@@ -2227,10 +2235,15 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		 * modify the original cached set. This path is only
 		 * used by named sets, so use a dummy set.
 		 */
-		dummyset = set_alloc(monh->loc);
-		dummyset->keytype = set->keytype;
-		dummyset->datatype = set->datatype;
-		dummyset->init = set_expr_alloc(monh->loc, set);
+		if (setelem_cache.set) {
+			dummyset = setelem_cache.set;
+		} else {
+			dummyset = set_alloc(monh->loc);
+			dummyset->keytype = set->keytype;
+			dummyset->datatype = set->datatype;
+			dummyset->flags = set->flags;
+			dummyset->init = set_expr_alloc(monh->loc, set);
+		}
 
 		nlsei = nftnl_set_elems_iter_create(nls);
 		if (nlsei == NULL)
@@ -2247,6 +2260,22 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		}
 		nftnl_set_elems_iter_destroy(nlsei);
 
+		if (set->flags & NFT_SET_INTERVAL) {
+			if (setelem_cache.set) {
+				interval_map_decompose(dummyset->init);
+				setelem_cache.set = NULL;
+				free(setelem_cache.table);
+				free(setelem_cache.setname);
+			} else {
+				setelem_cache.type = type;
+				setelem_cache.family = family;
+				setelem_cache.table = xstrdup(table);
+				setelem_cache.setname = xstrdup(setname);
+				setelem_cache.set = dummyset;
+				goto out;
+			}
+		}
+
 		switch (type) {
 		case NFT_MSG_NEWSETELEM:
 			printf("add ");
@@ -2276,6 +2305,39 @@ out:
 	return MNL_CB_OK;
 }
 
+static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
+					    int type,
+					    struct netlink_mon_handler *monh)
+{
+	if (!setelem_cache.set ||
+	    monh->format != NFTNL_OUTPUT_DEFAULT)
+		return MNL_CB_OK;
+
+	interval_map_decompose(setelem_cache.set->init);
+
+	switch (setelem_cache.type) {
+	case NFT_MSG_NEWSETELEM:
+		printf("add ");
+		break;
+	case NFT_MSG_DELSETELEM:
+		printf("delete ");
+		break;
+	default:
+		goto out;
+	}
+	printf("element %s %s %s ", family2str(setelem_cache.family),
+	       setelem_cache.table, setelem_cache.setname);
+	expr_print(setelem_cache.set->init, monh->ctx->octx);
+	printf("\n");
+
+out:
+	set_free(setelem_cache.set);
+	free(setelem_cache.table);
+	free(setelem_cache.setname);
+	setelem_cache.set = NULL;
+	return MNL_CB_OK;
+}
+
 static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 				 struct netlink_mon_handler *monh)
 {
@@ -2914,6 +2976,8 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELOBJ:
 		ret = netlink_events_obj_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWGEN:
+		ret = netlink_events_setelem_newgen_cb(nlh, type, monh);
 	}
 	fflush(stdout);
 
-- 
2.13.1

