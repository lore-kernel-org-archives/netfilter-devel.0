Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F247AC7EE29
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 May 2023 19:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjESTaN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 May 2023 15:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjESTaN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2023 15:30:13 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8B611F;
        Fri, 19 May 2023 12:30:12 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 53B2C41795;
        Fri, 19 May 2023 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684524607;
        bh=N1eNuhThdMoo9NApE/JI/5TNGiZESwjXJSRhYLRUSvQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=M+d9K0YyfZkBjY+mBkzi0kn8Vp4CUvdPoCzvB8fQBbCo4SbSGkhnsEr95MYswjCXE
         j17BH7/vcYJbP1DWzMpV/yUoTBv5vrV9GVzte4q7CcUnkSV3e/47YXFQ40EAJ0PrXp
         koMWt9yfB7BFPC2eFIM3OHvviREkDOBB6az2XDlmXKUbakhENt6koKdJ2clkFIayN2
         Aa0Tmgg7BDp1lKLw8Yu6k9iaLw/qbODFrjuHX1TYeX64ewgeIxBu6viBh5ZprFVCbn
         09tK+Vb1xPzgalfIgkN9ozX5Wy7EbdD82vgBZpt2A8T64RL7/2gMIuvD1fCUnydA/a
         DlFrKyPVskQgg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: [PATCH 4.14 1/1] netfilter: nf_tables: bogus EBUSY in helper removal from transaction
Date:   Fri, 19 May 2023 16:28:59 -0300
Message-Id: <20230519192859.2272157-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230519192859.2272157-1-cascardo@canonical.com>
References: <20230519192859.2272157-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 8ffcd32f64633926163cdd07a7d295c500a947d1 upstream.

Proper use counter updates when activating and deactivating the object,
otherwise, this hits bogus EBUSY error.

Fixes: cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate and destroy phase")
Reported-by: Laura Garcia <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 net/netfilter/nft_objref.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 49a067a67e72..5deb997db9bb 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -64,21 +64,34 @@ static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static void nft_objref_destroy(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr)
+static void nft_objref_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  enum nft_trans_phase phase)
 {
 	struct nft_object *obj = nft_objref_priv(expr);
 
+	if (phase == NFT_TRANS_COMMIT)
+		return;
+
 	obj->use--;
 }
 
+static void nft_objref_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	obj->use++;
+}
+
 static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object *)),
 	.eval		= nft_objref_eval,
 	.init		= nft_objref_init,
-	.destroy	= nft_objref_destroy,
+	.activate	= nft_objref_activate,
+	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
 };
 
-- 
2.34.1

