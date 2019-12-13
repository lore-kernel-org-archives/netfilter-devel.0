Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B2FC751C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED2924728
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfLMQEN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:04:13 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40356 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728164AbfLMQEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 11:04:13 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ifnQJ-0004Dx-Ck; Fri, 13 Dec 2019 17:04:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 09/11] evaluate: print a hint about 'type,width' syntax on 0 keylen
Date:   Fri, 13 Dec 2019 17:03:43 +0100
Message-Id: <20191213160345.30057-10-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213160345.30057-1-fw@strlen.de>
References: <20191213160345.30057-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user says

'type integer; ...' in a set definition, don't just throw an error --
provide a hint that a width can be provided via ', bitsize'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 91d6b254c659..2e93100349d7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3307,6 +3307,32 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int set_key_error(struct eval_ctx *ctx, const struct set *set,
+			 const char *type)
+{
+	if (set->key->dtype == &integer_type ||
+	    set->key->dtype == &string_type)
+		return set_error(ctx, set, "unqualified key type "
+				 "specified in %s definition.  Did you mean \"type %s,%d\"?",
+				 type, set->key->dtype->name, 128);
+
+	return set_error(ctx, set, "unqualified key type %s "
+			 "specified in %s definition",
+			 set->key->dtype->name, type);
+}
+
+static int set_datamap_error(struct eval_ctx *ctx, const struct set *set)
+{
+	if (set->data->dtype == &integer_type ||
+	    set->data->dtype == &string_type)
+		return set_error(ctx, set, "unqualified mapping data type "
+				 "specified in map definition. Did you mean \"type %s,%d\"?",
+				 set->data->dtype->name, 128);
+
+	return set_error(ctx, set, "unqualified mapping data "
+			 "type specified in map definition");
+}
+
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	struct table *table;
@@ -3331,9 +3357,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return -1;
 
 		if (set->key->len == 0)
-			return set_error(ctx, set, "unqualified key type %s "
-					 "specified in %s definition",
-					 set->key->dtype->name, type);
+			return set_key_error(ctx, set, type);
 	}
 	if (set->flags & NFT_SET_INTERVAL &&
 	    set->key->etype == EXPR_CONCAT)
@@ -3345,8 +3369,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 					 "specify mapping data type");
 
 		if (set->data->len == 0 && set->data->dtype->type != TYPE_VERDICT)
-			return set_error(ctx, set, "unqualified mapping data "
-					 "type specified in map definition");
+			return set_datamap_error(ctx, set);
 	} else if (set_is_objmap(set->flags)) {
 		if (set->data) {
 			assert(set->data->etype == EXPR_VALUE);
-- 
2.23.0

