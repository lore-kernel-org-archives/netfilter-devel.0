Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FACC18E5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12B8620690
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgCKOa0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:30:26 -0400
Received: from correo.us.es ([193.147.175.20]:41066 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbgCKOaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:30:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1EE3EDA708
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:30:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F987DA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:30:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 04F53DA3A0; Wed, 11 Mar 2020 15:30:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BEBEDA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:30:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:30:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 27E4342EF42B
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:30:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 4/5] netfilter: nf_tables: add nft_set_elem_update_expr() helper function
Date:   Wed, 11 Mar 2020 15:30:15 +0100
Message-Id: <20200311143016.4414-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200311143016.4414-1-pablo@netfilter.org>
References: <20200311143016.4414-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This helper function runs the eval path of the stateful expression
of an existing set element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 12 ++++++++++++
 net/netfilter/nft_dynset.c        |  8 +-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 13c257f7dd44..f9f61905a485 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -897,6 +897,18 @@ static inline struct nft_userdata *nft_userdata(const struct nft_rule *rule)
 	return (void *)&rule->data[rule->dlen];
 }
 
+static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
+					    struct nft_regs *regs,
+					    const struct nft_pktinfo *pkt)
+{
+	struct nft_expr *expr;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
+		expr = nft_set_ext_expr(ext);
+		expr->ops->eval(expr, regs, pkt);
+	}
+}
+
 /*
  * The last pointer isn't really necessary, but the compiler isn't able to
  * determine that the result of nft_expr_last() is always the same since it
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e106cf1c5b8b..46ab28ec4b53 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -81,7 +81,6 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
-	const struct nft_expr *sexpr;
 	u64 timeout;
 
 	if (priv->op == NFT_DYNSET_OP_DELETE) {
@@ -91,18 +90,13 @@ void nft_dynset_eval(const struct nft_expr *expr,
 
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
-		sexpr = NULL;
-		if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-			sexpr = nft_set_ext_expr(ext);
-
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 			timeout = priv->timeout ? : set->timeout;
 			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
 		}
 
-		if (sexpr != NULL)
-			sexpr->ops->eval(sexpr, regs, pkt);
+		nft_set_elem_update_expr(ext, regs, pkt);
 
 		if (priv->invert)
 			regs->verdict.code = NFT_BREAK;
-- 
2.11.0

