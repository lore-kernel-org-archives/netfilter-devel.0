From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/4] netlink: rework NFTNL_SET_USERDATA to accomodate new attributes
Date: Tue, 28 Feb 2017 01:01:01 +0100
Message-ID: <1488240062-27366-3-git-send-email-pablo@netfilter.org>
References: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47530 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751341AbdB1ACd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 19:02:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A481CE632
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96113DA729
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AE65DA729
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:09 +0100 (CET)
In-Reply-To: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rework the NFTNL_SET_USERDATA in netlink_delinearize_set() to accomodate
rhs datatype byteorder in mappings.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 60d86d61c504..d643034f77ca 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1122,40 +1122,27 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
-static uint32_t set_udata_get_key_byteorder(const void *data, uint32_t data_len)
-{
-	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
-
-	if (nftnl_udata_parse(data, data_len, set_parse_udata_cb, tb) < 0)
-		return BYTEORDER_INVALID;
-
-	if (!tb[UDATA_SET_KEYBYTEORDER])
-		return BYTEORDER_INVALID;
-
-	return *((uint32_t *)nftnl_udata_get(tb[UDATA_SET_KEYBYTEORDER]));
-}
-
-static enum byteorder set_key_byteorder(const struct nftnl_set *nls)
-{
-	enum byteorder byteorder = BYTEORDER_INVALID;
-	const void *data;
-	uint32_t len;
-
-	if (nftnl_set_is_set(nls, NFTNL_SET_USERDATA)) {
-		data = nftnl_set_get_data(nls, NFTNL_SET_USERDATA, &len);
-		byteorder = set_udata_get_key_byteorder(data, len);
-	}
-
-	return byteorder;
-}
-
 static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					   const struct nftnl_set *nls)
 {
-	struct set *set;
-	const struct datatype *keytype, *datatype;
+	const struct nftnl_udata *ud[UDATA_SET_MAX + 1] = {};
 	uint32_t flags, key, data, data_len, objtype = 0;
-	enum byteorder byteorder;
+	enum byteorder keybyteorder = BYTEORDER_INVALID;
+	const struct datatype *keytype, *datatype;
+	const char *udata;
+	struct set *set;
+	uint32_t ulen;
+
+	if (nftnl_set_is_set(nls, NFTNL_SET_USERDATA)) {
+		udata = nftnl_set_get_data(nls, NFTNL_SET_USERDATA, &ulen);
+		if (nftnl_udata_parse(udata, ulen, set_parse_udata_cb, ud) < 0) {
+			netlink_io_error(ctx, NULL, "Cannot parse userdata");
+			return NULL;
+		}
+
+		if (ud[UDATA_SET_KEYBYTEORDER])
+			keybyteorder = *((uint32_t *)nftnl_udata_get(ud[UDATA_SET_KEYBYTEORDER]));
+	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
 	keytype = dtype_map_from_kernel(key);
@@ -1164,7 +1151,6 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				 key);
 		return NULL;
 	}
-	byteorder = set_key_byteorder(nls);
 
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	if (flags & NFT_SET_MAP) {
@@ -1189,7 +1175,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
 	set->handle.set    = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 
-	set->keytype = set_datatype_alloc(keytype, byteorder);
+	set->keytype = set_datatype_alloc(keytype, keybyteorder);
 	set->keylen  = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 
-- 
2.1.4

