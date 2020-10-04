Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD326C47095
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97AAF2067D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgJDTuO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:50:14 -0400
Received: from correo.us.es ([193.147.175.20]:34936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgJDTuN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 235BAEF43C
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13889DA78D
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08CF5DA78B; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFEC4DA789;
        Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id B861E42EF9E2;
        Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 04/11] netfilter: nf_tables: fix userdata memleak
Date:   Sun,  4 Oct 2020 21:49:33 +0200
Message-Id: <20201004194940.7368-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

When userdata was introduced for tables and objects its allocation was
only freed inside the error path of the new{table, object} functions.

Free user data inside corresponding destroy functions for tables and
objects.

Fixes: b131c96496b3 ("netfilter: nf_tables: add userdata support for nft_object")
Fixes: 7a81575b806e ("netfilter: nf_tables: add userdata attributes to nft_table")
Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.20.1

