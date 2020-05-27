Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DE6C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA6F2088E
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izuNofmM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgE0Uvr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 16:51:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728571AbgE0Uvq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 16:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590612705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oh4H839+SxmSLDEwccxLq90SaWwJvHB2N7qu0JEJSIA=;
        b=izuNofmM8rcbMgLUx9u0wH+F9y0r5aVmDtvuuQDuj9LFV2EmJbffWfkUhOiUNuQuk3ajuD
        r3ZIpoyR8CgK4FWgd5X2/lXHreAZC0bUn2Mr/79kh4OsxOw6soG/uC9fWtyVP7l1NwrEvB
        vT4J1TGP1Hyyam6SiiZon2LIW+x0mgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-TA0HlPYMNMew9a5pYJyfYQ-1; Wed, 27 May 2020 16:51:41 -0400
X-MC-Unique: TA0HlPYMNMew9a5pYJyfYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0B681005510;
        Wed, 27 May 2020 20:51:40 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94EFF78B33;
        Wed, 27 May 2020 20:51:34 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2 1/2] evaluate: Perform set evaluation on implicitly declared (anonymous) sets
Date:   Wed, 27 May 2020 22:51:21 +0200
Message-Id: <03583cfdf6ad252f3c0472616a9e63178ee9d6ae.1590612113.git.sbrivio@redhat.com>
In-Reply-To: <cover.1590612113.git.sbrivio@redhat.com>
References: <cover.1590612113.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a set is implicitly declared, set_evaluate() is not called as a
result of cmd_evaluate_add(), because we're adding in fact something
else (e.g. a rule). Expression-wise, evaluation still happens as the
implicit set expression is eventually found in the tree and handled
by expr_evaluate_set(), but context-wise evaluation (set_evaluate())
is skipped, and this might be relevant instead.

This is visible in the reported case of an anonymous set including
concatenated ranges:

  # nft add rule t c ip saddr . tcp dport { 192.0.2.1 . 20-30 } accept
  BUG: invalid range expression type concat
  nft: expression.c:1160: range_expr_value_low: Assertion `0' failed.
  Aborted

because we reach do_add_set() without properly evaluated flags and
set description, and eventually end up in expr_to_intervals(), which
can't handle that expression.

Explicitly call set_evaluate() as we add anonymous sets into the
context, and instruct the same function to:
- skip expression-wise set evaluation if the set is anonymous, as
  that happens later anyway as part of the general tree evaluation
- skip the insertion in the set cache, as it makes no sense to have
  sets that shouldn't be referenced there

For object maps, the allocation of the expression for set->data is
already handled by set_evaluate(), so we can now drop that from
stmt_evaluate_objref_map().

v2:
 - skip insertion of set in cache (Pablo Neira Ayuso)
 - drop double allocation of expression (and leak of the first
   one) for object maps (Pablo Neira Ayuso)

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 src/evaluate.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 506f2c6a257e..9019458be53e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -76,6 +76,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
 	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
 }
 
+static int set_evaluate(struct eval_ctx *ctx, struct set *set);
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     struct expr *key,
@@ -107,6 +108,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 		list_add_tail(&cmd->list, &ctx->cmd->list);
 	}
 
+	set_evaluate(ctx, set);
+
 	return set_ref_expr_alloc(&expr->location, set);
 }
 
@@ -3316,12 +3319,6 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, mappings);
-
-		mappings->set->data = constant_expr_alloc(&netlink_location,
-							  &string_type,
-							  BYTEORDER_HOST_ENDIAN,
-							  NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE,
-							  NULL);
 		mappings->set->objtype  = stmt->objref.type;
 
 		map->mappings = mappings;
@@ -3546,6 +3543,13 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	}
 
+	/* Default timeout value implies timeout support */
+	if (set->timeout)
+		set->flags |= NFT_SET_TIMEOUT;
+
+	if (set_is_anonymous(set->flags))
+		return 0;
+
 	ctx->set = set;
 	if (set->init != NULL) {
 		__expr_set_context(&ctx->ectx, set->key->dtype,
@@ -3558,10 +3562,6 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (set_lookup(table, set->handle.set.name) == NULL)
 		set_add_hash(set_get(set), table);
 
-	/* Default timeout value implies timeout support */
-	if (set->timeout)
-		set->flags |= NFT_SET_TIMEOUT;
-
 	return 0;
 }
 
-- 
2.26.2

