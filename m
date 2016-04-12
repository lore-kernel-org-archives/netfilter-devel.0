From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/4] netfilter: nf_tables: parse element flags from nft_del_setelem()
Date: Tue, 12 Apr 2016 23:50:35 +0200
Message-ID: <1460497837-20693-3-git-send-email-pablo@netfilter.org>
References: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59305 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559AbcDLVuu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:50:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AE51FE665A
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 947791B309D
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 105621B30B9
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:46 +0200 (CEST)
In-Reply-To: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Parse flags and pass them to the set via ->deactivate() to check if we
remove the right element from the intervals.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 428c1f8..f988019 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3636,9 +3636,13 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 			   const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
+	struct nft_set_ext_tmpl tmpl;
 	struct nft_data_desc desc;
 	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
 	struct nft_trans *trans;
+	u32 flags = 0;
+	void *priv;
 	int err;
 
 	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
@@ -3650,6 +3654,14 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_KEY] == NULL)
 		goto err1;
 
+	nft_set_ext_prepare(&tmpl);
+
+	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
+	if (err < 0)
+		return err;
+	if (flags != 0)
+		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+
 	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
 			    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
@@ -3659,24 +3671,40 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
 		goto err2;
 
+	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, desc.len);
+
+	err = -ENOMEM;
+	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
+				      GFP_KERNEL);
+	if (elem.priv == NULL)
+		goto err2;
+
+	ext = nft_set_elem_ext(set, elem.priv);
+	if (flags)
+		*nft_set_ext_flags(ext) = flags;
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err2;
+		goto err3;
 	}
 
-	elem.priv = set->ops->deactivate(set, &elem);
-	if (elem.priv == NULL) {
+	priv = set->ops->deactivate(set, &elem);
+	if (priv == NULL) {
 		err = -ENOENT;
-		goto err3;
+		goto err4;
 	}
+	kfree(elem.priv);
+	elem.priv = priv;
 
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err3:
+err4:
 	kfree(trans);
+err3:
+	kfree(elem.priv);
 err2:
 	nft_data_uninit(&elem.key.val, desc.type);
 err1:
-- 
2.1.4

