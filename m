Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3ADC19437
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10FC62389F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgLGSRj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:17:39 -0500
Received: from correo.us.es ([193.147.175.20]:40672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgLGSRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 13:17:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1E0CCEB460
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E6E1DA789
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 038EADA73D; Mon,  7 Dec 2020 19:16:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1079DA789
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 07 Dec 2020 19:16:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AF3F941FF201
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/5] netfilter: nftables: move nft_expr before nft_set
Date:   Mon,  7 Dec 2020 19:16:48 +0100
Message-Id: <20201207181651.18771-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201207181651.18771-1-pablo@netfilter.org>
References: <20201207181651.18771-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the nft_expr structure definition before nft_set. Expressions are
used by rules and sets, remove unnecessary forward declarations. This
comes as preparation to support for multiple expressions per set element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 54 +++++++++++++++----------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index aad7e1381200..0f4ae16a0c42 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -305,8 +305,33 @@ struct nft_set_estimate {
 	enum nft_set_class	space;
 };
 
+#define NFT_EXPR_MAXATTR		16
+#define NFT_EXPR_SIZE(size)		(sizeof(struct nft_expr) + \
+					 ALIGN(size, __alignof__(struct nft_expr)))
+
+/**
+ *	struct nft_expr - nf_tables expression
+ *
+ *	@ops: expression ops
+ *	@data: expression private data
+ */
+struct nft_expr {
+	const struct nft_expr_ops	*ops;
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
+};
+
+static inline void *nft_expr_priv(const struct nft_expr *expr)
+{
+	return (void *)expr->data;
+}
+
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
+int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
+		  const struct nft_expr *expr);
+
 struct nft_set_ext;
-struct nft_expr;
 
 /**
  *	struct nft_set_ops - nf_tables set operations
@@ -797,7 +822,6 @@ struct nft_offload_ctx;
  *	@validate: validate expression, called during loop detection
  *	@data: extra data to attach to this expression operation
  */
-struct nft_expr;
 struct nft_expr_ops {
 	void				(*eval)(const struct nft_expr *expr,
 						struct nft_regs *regs,
@@ -833,32 +857,6 @@ struct nft_expr_ops {
 	void				*data;
 };
 
-#define NFT_EXPR_MAXATTR		16
-#define NFT_EXPR_SIZE(size)		(sizeof(struct nft_expr) + \
-					 ALIGN(size, __alignof__(struct nft_expr)))
-
-/**
- *	struct nft_expr - nf_tables expression
- *
- *	@ops: expression ops
- *	@data: expression private data
- */
-struct nft_expr {
-	const struct nft_expr_ops	*ops;
-	unsigned char			data[]
-		__attribute__((aligned(__alignof__(u64))));
-};
-
-static inline void *nft_expr_priv(const struct nft_expr *expr)
-{
-	return (void *)expr->data;
-}
-
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
-void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
-int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr);
-
 /**
  *	struct nft_rule - nf_tables rule
  *
-- 
2.20.1

