Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AB0C10F29
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F6F21D7E
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgCKON1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:13:27 -0400
Received: from correo.us.es ([193.147.175.20]:59644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgCKON1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:13:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66C89DA399
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 575F4DA3C4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4CEC4DA8E6; Wed, 11 Mar 2020 15:13:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BAA0DA3A5
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:13:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 67D5E42EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/4] netfilter: nf_tables: add elements with stateful expressions
Date:   Wed, 11 Mar 2020 15:13:16 +0100
Message-Id: <20200311141318.3633-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200311141318.3633-1-pablo@netfilter.org>
References: <20200311141318.3633-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update nft_add_set_elem() to handle the NFTA_SET_ELEM_EXPR netlink
attribute. This patch allows users to to add elements with stateful
expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0f670d13ae27..a90bf8d0b9ea 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4913,6 +4913,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
+	struct nft_expr *expr = NULL;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	struct nft_data data;
@@ -4980,10 +4981,17 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	}
 
+	if (nla[NFTA_SET_ELEM_EXPR] != NULL) {
+		expr = nft_set_elem_expr_alloc(ctx, set,
+					       nla[NFTA_SET_ELEM_EXPR]);
+		if (IS_ERR(expr))
+			return PTR_ERR(expr);
+	}
+
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
 				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		return err;
+		goto err_set_elem_expr;
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
 
@@ -5002,6 +5010,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 	}
 
+	if (expr)
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPR,
+				       expr->ops->size);
+
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
 			err = -EINVAL;
@@ -5086,6 +5098,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
+	if (expr) {
+		memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
+		kfree(expr);
+	}
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
@@ -5141,6 +5157,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
 err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
+err_set_elem_expr:
+	if (expr != NULL)
+		nft_expr_destroy(ctx, expr);
 
 	return err;
 }
-- 
2.11.0

