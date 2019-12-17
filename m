Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FE9C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 823F521739
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfLQL1z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57360 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfLQL1y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:54 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB17-0006mJ-3r; Tue, 17 Dec 2019 12:27:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 08/10] evaluate: print a hint about 'typeof' syntax on 0 keylen
Date:   Tue, 17 Dec 2019 12:27:11 +0100
Message-Id: <20191217112713.6017-9-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user says

'type integer; ...' in a set definition, don't just throw an error --
provide a hint that the typeof keyword can be used to provide
the needed size information.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 91d6b254c659..817b23220bb9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3307,6 +3307,20 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int set_key_data_error(struct eval_ctx *ctx, const struct set *set,
+			      const struct datatype *dtype,
+			      const char *name)
+{
+	const char *hint = "";
+
+	if (dtype->size == 0)
+		hint = ". Try \"typeof expression\" instead of \"type datatype\".";
+
+	return set_error(ctx, set, "unqualified type %s "
+			 "specified in %s definition%s",
+			 dtype->name, name, hint);
+}
+
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	struct table *table;
@@ -3331,9 +3345,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return -1;
 
 		if (set->key->len == 0)
-			return set_error(ctx, set, "unqualified key type %s "
-					 "specified in %s definition",
-					 set->key->dtype->name, type);
+			return set_key_data_error(ctx, set,
+						  set->key->dtype, type);
 	}
 	if (set->flags & NFT_SET_INTERVAL &&
 	    set->key->etype == EXPR_CONCAT)
@@ -3345,8 +3358,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 					 "specify mapping data type");
 
 		if (set->data->len == 0 && set->data->dtype->type != TYPE_VERDICT)
-			return set_error(ctx, set, "unqualified mapping data "
-					 "type specified in map definition");
+			return set_key_data_error(ctx, set,
+						  set->data->dtype, type);
 	} else if (set_is_objmap(set->flags)) {
 		if (set->data) {
 			assert(set->data->etype == EXPR_VALUE);
-- 
2.24.1

