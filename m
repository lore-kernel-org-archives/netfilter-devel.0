From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/4] src: store byteorder for set data
Date: Tue, 28 Feb 2017 01:01:02 +0100
Message-ID: <1488240062-27366-4-git-send-email-pablo@netfilter.org>
References: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbdB1ACd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 19:02:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23608E633
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1480ADA7FA
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22E67DA801
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:10 +0100 (CET)
In-Reply-To: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new UDATA_SET_DATABYTEORDER attribute for NFTA_SET_UDATA to store
the datatype byteorder. This is required if integer_type is used on the
rhs of the mapping given that this datatype comes with no specific
byteorder.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  1 +
 src/evaluate.c |  4 +++-
 src/netlink.c  | 16 +++++++++++++++-
 src/rule.c     |  2 ++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index f5160daf4d8e..ed12774d0ba7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -479,6 +479,7 @@ enum udata_type {
 
 enum udata_set_type {
 	UDATA_SET_KEYBYTEORDER,
+	UDATA_SET_DATABYTEORDER,
 	__UDATA_SET_MAX,
 };
 #define UDATA_SET_MAX (__UDATA_SET_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 07a611804a90..5498516686ad 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1174,7 +1174,9 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 						    ctx->ectx.len,
 						    ctx->ectx.byteorder,
 						    mappings);
-		mappings->set->datatype = ectx.dtype;
+
+		mappings->set->datatype = set_datatype_alloc(ectx.dtype,
+							     ectx.byteorder);
 		mappings->set->datalen  = ectx.len;
 
 		map->mappings = mappings;
diff --git a/src/netlink.c b/src/netlink.c
index d643034f77ca..8b0fc9403361 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1112,6 +1112,7 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 
 	switch (type) {
 	case UDATA_SET_KEYBYTEORDER:
+	case UDATA_SET_DATABYTEORDER:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -1128,6 +1129,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	const struct nftnl_udata *ud[UDATA_SET_MAX + 1] = {};
 	uint32_t flags, key, data, data_len, objtype = 0;
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
+	enum byteorder databyteorder = BYTEORDER_INVALID;
 	const struct datatype *keytype, *datatype;
 	const char *udata;
 	struct set *set;
@@ -1142,6 +1144,8 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 		if (ud[UDATA_SET_KEYBYTEORDER])
 			keybyteorder = *((uint32_t *)nftnl_udata_get(ud[UDATA_SET_KEYBYTEORDER]));
+		if (ud[UDATA_SET_DATABYTEORDER])
+			databyteorder = *((uint32_t *)nftnl_udata_get(ud[UDATA_SET_DATABYTEORDER]));
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -1181,7 +1185,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 	set->objtype = objtype;
 
-	set->datatype = datatype;
+	if (datatype)
+		set->datatype = set_datatype_alloc(datatype, databyteorder);
+	else
+		set->datatype = NULL;
+
 	if (nftnl_set_is_set(nls, NFTNL_SET_DATA_LEN)) {
 		data_len = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN);
 		set->datalen = data_len * BITS_PER_BYTE;
@@ -1279,6 +1287,12 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	if (!nftnl_udata_put(udbuf, UDATA_SET_KEYBYTEORDER, sizeof(uint32_t),
 			     &set->keytype->byteorder))
 		memory_allocation_error();
+
+	if (set->flags & NFT_SET_MAP &&
+	    !nftnl_udata_put(udbuf, UDATA_SET_DATABYTEORDER, sizeof(uint32_t),
+			     &set->datatype->byteorder))
+		memory_allocation_error();
+
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
diff --git a/src/rule.c b/src/rule.c
index 6045747710db..f5ff1103c9f1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -211,6 +211,8 @@ void set_free(struct set *set)
 		expr_free(set->init);
 	handle_free(&set->handle);
 	set_datatype_destroy(set->keytype);
+	if (set->datatype)
+		set_datatype_destroy(set->datatype);
 	xfree(set);
 }
 
-- 
2.1.4

