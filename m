Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5022AC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbjH3SjK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245422AbjH3PMr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 11:12:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F39A31A3
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 08:12:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] rule: set internal_location for table and chain
Date:   Wed, 30 Aug 2023 17:12:39 +0200
Message-Id: <20230830151239.448463-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230830151239.448463-1-pablo@netfilter.org>
References: <20230830151239.448463-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

JSON parser does not seem to set on this, better provide a default
location.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index fa4c72adab06..bce728ab9b46 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -705,6 +705,7 @@ struct chain *chain_alloc(void)
 	struct chain *chain;
 
 	chain = xzalloc(sizeof(*chain));
+	chain->location = internal_location;
 	chain->refcnt = 1;
 	chain->handle.chain_id = ++chain_id;
 	init_list_head(&chain->rules);
@@ -1125,6 +1126,7 @@ struct table *table_alloc(void)
 	struct table *table;
 
 	table = xzalloc(sizeof(*table));
+	table->location = internal_location;
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
 	init_list_head(&table->objs);
-- 
2.30.2

