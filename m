Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849E4C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 21:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62730207FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 21:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgCaVDH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 17:03:07 -0400
Received: from correo.us.es ([193.147.175.20]:58280 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgCaVDG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 17:03:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A29EEF429
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 23:03:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AFDDDA736
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 23:03:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 50B1E12B67D; Tue, 31 Mar 2020 23:03:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47829DA736
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 23:03:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 23:03:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 31C534301DE2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 23:03:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: do not update stateful expressions if lookup is inverted
Date:   Tue, 31 Mar 2020 23:02:59 +0200
Message-Id: <20200331210259.2579-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Initialize set lookup matching element to NULL. Otherwise, the
NFT_LOOKUP_F_INV flag reverses the matching logic and it leads to
deference an uninitialized pointer to the matching element. Make sure
element data area and stateful expression are accessed if there is a
matching set element.

This patch undoes 24791b9aa1ab ("netfilter: nft_set_bitmap: initialize set
element extension in lookups") which is not required anymore.

Fixes: 339706bc21c1 ("netfilter: nft_lookup: update element stateful expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nft_lookup.c        | 12 +++++++-----
 net/netfilter/nft_set_bitmap.c    |  1 -
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6eb627b3c99b..4ff7c81e6717 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -901,7 +901,7 @@ static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
 {
 	struct nft_expr *expr;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
+	if (__nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
 		expr = nft_set_ext_expr(ext);
 		expr->ops->eval(expr, regs, pkt);
 	}
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 1e70359d633c..f1363b8aabba 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -29,7 +29,7 @@ void nft_lookup_eval(const struct nft_expr *expr,
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
-	const struct nft_set_ext *ext;
+	const struct nft_set_ext *ext = NULL;
 	bool found;
 
 	found = set->ops->lookup(nft_net(pkt), set, &regs->data[priv->sreg],
@@ -39,11 +39,13 @@ void nft_lookup_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	if (set->flags & NFT_SET_MAP)
-		nft_data_copy(&regs->data[priv->dreg],
-			      nft_set_ext_data(ext), set->dlen);
+	if (ext) {
+		if (set->flags & NFT_SET_MAP)
+			nft_data_copy(&regs->data[priv->dreg],
+				      nft_set_ext_data(ext), set->dlen);
 
-	nft_set_elem_update_expr(ext, regs, pkt);
+		nft_set_elem_update_expr(ext, regs, pkt);
+	}
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 32f0fc8be3a4..2a81ea421819 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -81,7 +81,6 @@ static bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
 	u32 idx, off;
 
 	nft_bitmap_location(set, key, &idx, &off);
-	*ext = NULL;
 
 	return nft_bitmap_active(priv->bitmap, idx, off, genmask);
 }
-- 
2.11.0

