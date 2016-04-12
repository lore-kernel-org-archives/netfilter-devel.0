From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/4] netfilter: nf_tables: introduce nft_setelem_parse_flags() helper
Date: Tue, 12 Apr 2016 23:50:34 +0200
Message-ID: <1460497837-20693-2-git-send-email-pablo@netfilter.org>
References: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808AbcDLVut (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:50:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CDD72E6664
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B5D141B30BC
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 343A31B30A0
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:45 +0200 (CEST)
In-Reply-To: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function parses the set element flags, thus, we can reuse the same
handling when deleting elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 94d51cd..428c1f8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3419,6 +3419,22 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem)
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
+static int nft_setelem_parse_flags(const struct nft_set *set,
+				   const struct nlattr *attr, u32 *flags)
+{
+	if (attr == NULL)
+		return 0;
+
+	*flags = ntohl(nla_get_be32(attr));
+	if (*flags & ~NFT_SET_ELEM_INTERVAL_END)
+		return -EINVAL;
+	if (!(set->flags & NFT_SET_INTERVAL) &&
+	    *flags & NFT_SET_ELEM_INTERVAL_END)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -3432,8 +3448,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data data;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	u32 flags = 0;
 	u64 timeout;
-	u32 flags;
 	u8 ulen;
 	int err;
 
@@ -3447,17 +3463,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	nft_set_ext_prepare(&tmpl);
 
-	flags = 0;
-	if (nla[NFTA_SET_ELEM_FLAGS] != NULL) {
-		flags = ntohl(nla_get_be32(nla[NFTA_SET_ELEM_FLAGS]));
-		if (flags & ~NFT_SET_ELEM_INTERVAL_END)
-			return -EINVAL;
-		if (!(set->flags & NFT_SET_INTERVAL) &&
-		    flags & NFT_SET_ELEM_INTERVAL_END)
-			return -EINVAL;
-		if (flags != 0)
-			nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
-	}
+	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
+	if (err < 0)
+		return err;
+	if (flags != 0)
+		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
 
 	if (set->flags & NFT_SET_MAP) {
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
-- 
2.1.4

