Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF793C18E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A29B720658
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgCQNN5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:13:57 -0400
Received: from correo.us.es ([193.147.175.20]:51612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgCQNN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 09:13:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D78BBF23A6
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C924CFC5E2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BECFDFC5E7; Tue, 17 Mar 2020 14:13:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05072FC5E2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Mar 2020 14:13:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E422F42EE399
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: move nft_expr_clone() to nf_tables_api.c
Date:   Tue, 17 Mar 2020 14:13:44 +0100
Message-Id: <20200317131346.30544-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200317131346.30544-1-pablo@netfilter.org>
References: <20200317131346.30544-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the nft_expr_clone() helper function to the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 18 ++++++++++++++++++
 net/netfilter/nft_dynset.c        | 17 -----------------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5d80e09f8148..af2ed70d7eed 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -846,6 +846,7 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 	return (void *)expr->data;
 }
 
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f92fb6003745..4f6245e7988e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2557,6 +2557,24 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+{
+	int err;
+
+	if (src->ops->clone) {
+		dst->ops = src->ops;
+		err = src->ops->clone(dst, src);
+		if (err < 0)
+			return err;
+	} else {
+		memcpy(dst, src, src->ops->size);
+	}
+
+	__module_get(src->ops->type->owner);
+
+	return 0;
+}
+
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr)
 {
 	nf_tables_expr_destroy(ctx, expr);
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 46ab28ec4b53..d1b64c8de585 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -24,23 +24,6 @@ struct nft_dynset {
 	struct nft_set_binding		binding;
 };
 
-static int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
-{
-	int err;
-
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
-
-	__module_get(src->ops->type->owner);
-	return 0;
-}
-
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
-- 
2.11.0

