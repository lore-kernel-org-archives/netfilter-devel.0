Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF428C77B62
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 14:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDDOev (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjDDOeq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 10:34:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6151A1BEA
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 07:34:45 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] evaluate: bogus missing transport protocol
Date:   Tue,  4 Apr 2023 16:34:35 +0200
Message-Id: <20230404143437.133493-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230404143437.133493-1-pablo@netfilter.org>
References: <20230404143437.133493-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Users have to specify a transport protocol match such as

	meta protocol tcp

before the redirect statement, even if the redirect statement already
implicitly refers to the transport protocol, for instance:

test.nft:3:16-53: Error: transport protocol mapping is only valid after transport protocol match
                redirect to :tcp dport map { 83 : 8083, 84 : 8084 }
                ~~~~~~~~     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Evaluate the redirect expression before the mandatory check for the
transport protocol match, so protocol context already provides a
transport protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c4ddb007ef44..fe15d7ace5dd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3569,6 +3569,13 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 				  struct expr **expr)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
+	int err;
+
+	err = stmt_evaluate_arg(ctx, stmt,
+				&inet_service_type, 2 * BITS_PER_BYTE,
+				BYTEORDER_BIG_ENDIAN, expr);
+	if (err < 0)
+		return err;
 
 	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
 	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr))
@@ -3576,9 +3583,7 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 					 "transport protocol mapping is only "
 					 "valid after transport protocol match");
 
-	return stmt_evaluate_arg(ctx, stmt,
-				 &inet_service_type, 2 * BITS_PER_BYTE,
-				 BYTEORDER_BIG_ENDIAN, expr);
+	return 0;
 }
 
 static const char *stmt_name(const struct stmt *stmt)
-- 
2.30.2

