Return-Path: <SRS0=g4y9=6I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664C6C55196
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DEB720781
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgDXTzq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 15:55:46 -0400
Received: from correo.us.es ([193.147.175.20]:46100 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgDXTzq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 15:55:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39C59D28C3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A9EFBAAB5
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 20042BAAB4; Fri, 24 Apr 2020 21:55:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B1B2524FF
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Apr 2020 21:55:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 07AD042EF4E0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/5] netfilter: nf_tables: allow up to 64 bytes in the set element data area
Date:   Fri, 24 Apr 2020 21:55:33 +0200
Message-Id: <20200424195537.23975-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424195537.23975-1-pablo@netfilter.org>
References: <20200424195537.23975-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

So far, the set elements could store up to 128-bits in the data area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4ff7c81e6717..d4e29c952c40 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -243,6 +243,10 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data	val;
 	} key_end;
+	union {
+		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
+		struct nft_data val;
+	} data;
 	void			*priv;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9780bd93b7e4..3558e76e2733 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4669,6 +4669,25 @@ static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
+static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
+				  struct nft_data_desc *desc,
+				  struct nft_data *data,
+				  struct nlattr *attr)
+{
+	int err;
+
+	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
+	if (err < 0)
+		return err;
+
+	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+		nft_data_release(data, desc->type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -4946,7 +4965,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_expr *expr = NULL;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
-	struct nft_data data;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
 	u32 flags = 0;
@@ -5072,15 +5090,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
-		err = nft_data_init(ctx, &data, sizeof(data), &desc,
-				    nla[NFTA_SET_ELEM_DATA]);
+		err = nft_setelem_parse_data(ctx, set, &desc, &elem.data.val,
+					     nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
 			goto err_parse_key_end;
 
-		err = -EINVAL;
-		if (set->dtype != NFT_DATA_VERDICT && desc.len != set->dlen)
-			goto err_parse_data;
-
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
 			struct nft_ctx bind_ctx = {
@@ -5094,14 +5108,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 				continue;
 
 			err = nft_validate_register_store(&bind_ctx, dreg,
-							  &data,
+							  &elem.data.val,
 							  desc.type, desc.len);
 			if (err < 0)
 				goto err_parse_data;
 
 			if (desc.type == NFT_DATA_VERDICT &&
-			    (data.verdict.code == NFT_GOTO ||
-			     data.verdict.code == NFT_JUMP))
+			    (elem.data.val.verdict.code == NFT_GOTO ||
+			     elem.data.val.verdict.code == NFT_JUMP))
 				nft_validate_state_update(ctx->net,
 							  NFT_VALIDATE_NEED);
 		}
@@ -5123,7 +5137,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
-				      elem.key_end.val.data, data.data,
+				      elem.key_end.val.data, elem.data.val.data,
 				      timeout, expiration, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err_parse_data;
@@ -5201,7 +5215,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-		nft_data_release(&data, desc.type);
+		nft_data_release(&elem.data.val, desc.type);
 err_parse_key_end:
 	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
 err_parse_key:
-- 
2.20.1

