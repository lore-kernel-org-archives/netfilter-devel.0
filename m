Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08B2C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjKCQau (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjKCQat (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:30:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F1E111
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699028996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ik6t5Xv3KDPzihc7eITeVx9G68hx/T1C0bg7zuRs3cw=;
        b=eiZiX3FyjFxNNKFip6mXoPR4tnav8JOx3M2dcWdU7DrFmbFRLP2RKtPyyJkz59yJVZIMSQ
        hOqAL7bJMcp4QUWTFzda2kfoqhINi95IUs5mydbydP8BajwAEFYNBlY1GStW05dKMqiEtj
        AmzQfZ1Cwzq7JJ6nemUTiIN1kbrg1io=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-ibLTQAF2N4GLNHWsUFjcvg-1; Fri, 03 Nov 2023 12:29:50 -0400
X-MC-Unique: ibLTQAF2N4GLNHWsUFjcvg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0DE28110A7
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 16:29:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 714222166B26;
        Fri,  3 Nov 2023 16:29:49 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 2/2] json: drop warning on stderr for missing json() hook in stmt_print_json()
Date:   Fri,  3 Nov 2023 17:25:14 +0100
Message-ID: <20231103162937.3352069-3-thaller@redhat.com>
In-Reply-To: <20231103162937.3352069-1-thaller@redhat.com>
References: <20231103162937.3352069-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All "struct stmt_ops" really must have a json hook set, to handle the
statement. And almost all of them do, except "struct chain_stmt_ops".

Soon a unit test will be added, to check that all stmt_ops have a json()
hook. Also, the missing hook in "struct chain_stmt_ops" is a bug, that
is now understood and shall be fixed soon/later.

Note that we can already hit the bug, if we would call `nft -j list
ruleset` at the end of test "tests/shell/testcases/nft-f/sample-ruleset":

    warning: stmt ops chain have no json callback

Soon tests will be added, that hit this condition. Printing a message to
stderr breaks those tests, and blocks adding the tests.

Drop this warning on stderr, so we can add those other tests sooner, as
those tests are useful for testing JSON code in general. The warning
stderr was useful for finding the problem, but the problem is now
understood and will be addressed separately. Drop the message to unblock
adding those tests.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/json.c      | 10 ++++++++--
 src/statement.c |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/json.c b/src/json.c
index 25e349155394..8fff401dfb3e 100644
--- a/src/json.c
+++ b/src/json.c
@@ -83,8 +83,14 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 	if (stmt->ops->json)
 		return stmt->ops->json(stmt, octx);
 
-	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
-		stmt->ops->name);
+	/* In general, all "struct stmt_ops" must implement json() hook. Otherwise
+	 * we have a bug, and a unit test should check that all ops are correct.
+	 *
+	 * Currently, "chain_stmt_ops.json" is known to be NULL. That is a bug that
+	 * needs fixing.
+	 *
+	 * After the bug is fixed, and the unit test in place, this fallback code
+	 * can be dropped. */
 
 	fp = octx->output_fp;
 	octx->output_fp = fmemopen(buf, 1024, "w");
diff --git a/src/statement.c b/src/statement.c
index f5176e6d87f9..d52b01b9099a 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -141,6 +141,7 @@ static const struct stmt_ops chain_stmt_ops = {
 	.type		= STMT_CHAIN,
 	.name		= "chain",
 	.print		= chain_stmt_print,
+	.json		= NULL, /* BUG: must be implemented! */
 	.destroy	= chain_stmt_destroy,
 };
 
-- 
2.41.0

