Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F69C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Jan 2021 18:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC1E22472
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Jan 2021 18:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbhAPSEC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Jan 2021 13:04:02 -0500
Received: from correo.us.es ([193.147.175.20]:33334 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbhAPSEB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Jan 2021 13:04:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7EBE2FB431
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 19:02:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 704D7DA78A
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 19:02:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 65D60DA789; Sat, 16 Jan 2021 19:02:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18216DA704
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 19:02:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 16 Jan 2021 19:02:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0617C426CC84
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2021 19:02:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_dynset: honor stateful expressions in set definition
Date:   Sat, 16 Jan 2021 19:03:13 +0100
Message-Id: <20210116180313.16943-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the set definition contains stateful expressions, allocate them for
the newly added entries from the packet path.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 5 ++---
 net/netfilter/nft_dynset.c        | 6 ++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f4af8362d234..4b6ecf532623 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -721,6 +721,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
+int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_expr *expr_array[]);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15c467f1a9dd..8d3aa97b52e7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5235,9 +5235,8 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem);
 }
 
-static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
-				   struct nft_set *set,
-				   struct nft_expr *expr_array[])
+int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_expr *expr_array[])
 {
 	struct nft_expr *expr;
 	int err, i, k;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 0b053f75cd60..86204740f6c7 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -295,6 +295,12 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			err = -EOPNOTSUPP;
 			goto err_expr_free;
 		}
+	} else if (set->num_exprs > 0) {
+		err = nft_set_elem_expr_clone(ctx, set, priv->expr_array);
+		if (err < 0)
+			return err;
+
+		priv->num_exprs = set->num_exprs;
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
-- 
2.20.1

