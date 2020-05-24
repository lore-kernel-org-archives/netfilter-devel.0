Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85ECEC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDE620776
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d+jUBJrK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgEXNAq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 09:00:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgEXNAp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 09:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590325245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V99fkelWIQWqXSHN4rM1HWWLAEMPaKKBjhox0AdFKPw=;
        b=d+jUBJrKJ6mFE1pvLcl9oi6m00P7wjmqkJGHSqA1iM+24innvGiaQwKwSDDmoTlkPO93QA
        UMoEplVNgYIBF6VUwccj/HPtG6Lkk05mfrIkWI4APtPLfKumS9mFWGXKQ/XZSpusvFp8wy
        W1aH6SBniyVdOTnezEZ1fXTzLoWOUpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-wJ38HEUxNFuVxywWTigO-A-1; Sun, 24 May 2020 09:00:43 -0400
X-MC-Unique: wJ38HEUxNFuVxywWTigO-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 399BA1800D42;
        Sun, 24 May 2020 13:00:42 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23BAB63F8C;
        Sun, 24 May 2020 13:00:40 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: Perform set evaluation on implicitly declared (anonymous) sets
Date:   Sun, 24 May 2020 15:00:26 +0200
Message-Id: <a2c6c6ba6295d9027fa149cc68b072a8e1209261.1590324033.git.sbrivio@redhat.com>
In-Reply-To: <cover.1590324033.git.sbrivio@redhat.com>
References: <cover.1590324033.git.sbrivio@redhat.com>
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
context, and instruct the same function to skip expression-wise set
evaluation if the set is anonymous, as that happens later anyway as
part of the general tree evaluation.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 src/evaluate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 506f2c6a257e..ee019bc98480 100644
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
 
@@ -3547,7 +3550,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	}
 
 	ctx->set = set;
-	if (set->init != NULL) {
+	if (!set_is_anonymous(set->flags) && set->init != NULL) {
 		__expr_set_context(&ctx->ectx, set->key->dtype,
 				   set->key->byteorder, set->key->len, 0);
 		if (expr_evaluate(ctx, &set->init) < 0)
-- 
2.26.2

