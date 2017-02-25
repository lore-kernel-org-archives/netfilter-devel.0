From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] netlink: store set byteorder in NFTA_SET_USERDATA
Date: Sat, 25 Feb 2017 11:54:00 +0100
Message-ID: <1488020040-24025-2-git-send-email-pablo@netfilter.org>
References: <1488020040-24025-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbdBYKyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 05:54:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 94C46A417F
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:54:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85844DA7FA
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:54:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25DE7DA804
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:54:17 +0100 (CET)
In-Reply-To: <1488020040-24025-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The integer datatype has neither specific byteorder nor length. This
results in the following broken output:

 # nft list ruleset
 table ip x {
        chain y {
                mark set cpu map { 0 : 0x00000001, 16777216 : 0x00000002}
        }
 }

Currently, with BYTEORDER_INVALID, nft defaults on network byteorder,
hence the output above.

This patch stores the key byteorder in the userdata using a TLV
structure in the NFTA_SET_USERDATA area, so nft can interpret key
accordingly when dumping the set back to userspace.

Thus, after this patch the listing is correct:

 # nft list ruleset
 table ip x {
        chain y {
                mark set cpu map { 0 : 0x00000001, 1 : 0x00000002}
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Florian: You can rebase your ct zone patchset on top of this, so you don't
          need your original 5/8 anymore.

BTW, this uncovered a bug in the new bitmap set type that I'm addressing now.

 include/rule.h |  6 ++++++
 src/netlink.c  | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 878563d9fcbc..f5160daf4d8e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -477,4 +477,10 @@ enum udata_type {
 
 #define UDATA_COMMENT_MAXLEN 128
 
+enum udata_set_type {
+	UDATA_SET_KEYBYTEORDER,
+	__UDATA_SET_MAX,
+};
+#define UDATA_SET_MAX (__UDATA_SET_MAX - 1)
+
 #endif /* NFTABLES_RULE_H */
diff --git a/src/netlink.c b/src/netlink.c
index 0cc3a517cd90..1f3398225892 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1104,12 +1104,58 @@ void netlink_dump_set(const struct nftnl_set *nls)
 #endif
 }
 
+static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **tb = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case UDATA_SET_KEYBYTEORDER:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+	tb[type] = attr;
+	return 0;
+}
+
+static uint32_t set_udata_get_key_byteorder(const void *data, uint32_t data_len)
+{
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
+
+	if (nftnl_udata_parse(data, data_len, set_parse_udata_cb, tb) < 0)
+		return BYTEORDER_INVALID;
+
+	if (!tb[UDATA_SET_KEYBYTEORDER])
+		return BYTEORDER_INVALID;
+
+	return *((uint32_t *)nftnl_udata_get(tb[UDATA_SET_KEYBYTEORDER]));
+}
+
+static enum byteorder set_key_byteorder(const struct nftnl_set *nls)
+{
+	enum byteorder byteorder = BYTEORDER_INVALID;
+	const void *data;
+	uint32_t len;
+
+	if (nftnl_set_is_set(nls, NFTNL_SET_USERDATA)) {
+		data = nftnl_set_get_data(nls, NFTNL_SET_USERDATA, &len);
+		byteorder = set_udata_get_key_byteorder(data, len);
+	}
+
+	return byteorder;
+}
+
 static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					   const struct nftnl_set *nls)
 {
 	struct set *set;
 	const struct datatype *keytype, *datatype;
 	uint32_t flags, key, data, data_len, objtype = 0;
+	enum byteorder byteorder;
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
 	keytype = dtype_map_from_kernel(key);
@@ -1118,6 +1164,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				 key);
 		return NULL;
 	}
+	byteorder = set_key_byteorder(nls);
 
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	if (flags & NFT_SET_MAP) {
@@ -1142,7 +1189,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
 	set->handle.set    = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 
-	set->keytype = keytype;
+	set->keytype = set_keytype_alloc(keytype, byteorder);
 	set->keylen  = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 
@@ -1205,6 +1252,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 				 const struct handle *h, struct set *set,
 				 bool excl)
 {
+	struct nftnl_udata_buf *udbuf;
 	struct nftnl_set *nls;
 	int err;
 
@@ -1239,6 +1287,16 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 					  set->desc.size);
 	}
 
+	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+	if (!udbuf)
+		memory_allocation_error();
+	if (!nftnl_udata_put(udbuf, UDATA_SET_KEYBYTEORDER, sizeof(uint32_t),
+			     &set->keytype->byteorder))
+		memory_allocation_error();
+	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
+			   nftnl_udata_buf_len(udbuf));
+	nftnl_udata_buf_free(udbuf);
+
 	netlink_dump_set(nls);
 
 	err = mnl_nft_set_batch_add(nls, excl ? NLM_F_EXCL : 0, ctx->seqnum);
-- 
2.1.4

