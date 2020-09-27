Return-Path: <SRS0=8C00=DE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77BDC4346E
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Sep 2020 08:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7525D207BC
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Sep 2020 08:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="WAOyKzyk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgI0IhU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Sep 2020 04:37:20 -0400
Received: from mx1.riseup.net ([198.252.153.129]:59512 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727263AbgI0IhT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Sep 2020 04:37:19 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BzfCg5Fy0zDt1D;
        Sun, 27 Sep 2020 01:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1601195839; bh=pjTp4QBVot3yYmrSdvrxcaOV0q4MNbP1whRripFSRSI=;
        h=From:To:Cc:Subject:Date:From;
        b=WAOyKzykviiF/12vnT6gnPBZkzXDCiVdRO6kUf5PT287/W9AShLmXj1taagJzB3qM
         ztob97fVuoPKRw8PVP47Bw0Z/pcaH7war1T+tBERLew8A9riHxTmR4RnfsDTV7BcUl
         mcQyMeLiOdgPH+gyIoz93u5b3Io7lTIBngYMy3YQ=
X-Riseup-User-ID: 891D3262CF59A06408F4EFA64830AF7224799407CD4F11F0082A5ADDE620E995
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BzfCf6WffzJnBf;
        Sun, 27 Sep 2020 01:37:18 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: fix userdata memleak
Date:   Sun, 27 Sep 2020 10:36:22 +0200
Message-Id: <20200927083621.9822-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When userdata was introduced for tables and objects its allocation was
only freed inside the error path of the new{table, object} functions.

Free user data inside corresponding destroy functions for tables and
objects.

Fixes: b131c96496b3 ("netfilter: nf_tables: add userdata support for nft_object")
Fixes: 7a81575b806e ("netfilter: nf_tables: add userdata attributes to nft_table")
Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 84c0c1aaae99..b3c3c3fc1969 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1211,6 +1211,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 
 	rhltable_destroy(&ctx->table->chains_ht);
 	kfree(ctx->table->name);
+	kfree(ctx->table->udata);
 	kfree(ctx->table);
 }
 
@@ -6231,6 +6232,7 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 
 	module_put(obj->ops->type->owner);
 	kfree(obj->key.name);
+	kfree(obj->udata);
 	kfree(obj);
 }
 
-- 
2.27.0

