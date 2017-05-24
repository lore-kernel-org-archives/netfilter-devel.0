From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft PATCH] evaluate: prevent using sets in payload statements
Date: Wed, 24 May 2017 15:11:04 +0200
Message-ID: <149563146450.21555.7985467199304693684.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52519 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936660AbdEXNLN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 09:11:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id E93E951F2C5
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 13:11:10 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nkdBxBJLfjYu for <netfilter-devel@vger.kernel.org>;
        Wed, 24 May 2017 15:11:05 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 4299D51F1FD
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 15:11:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prevent this assert:

% nft [..] tcp dport set { 0 , 1 }
BUG: unknown expression type set reference
nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
Aborted

We can't use a set here because we will not known what value to use.

With this patch, this is produced:

% nft [..] tcp dport set {1, 2 }
<cmdline>:1:19-27: Error: you cannot use a set here
add rule ip nat c tcp dport set {1, 2 }
                  ^^^^^^^^^~~~~~~~~~~~~
% nft [..] tcp dport set @s
<cmdline>:1:19-27: Error: you cannot reference a set here
add rule ip nat c tcp dport set @s
                  ^^^^^^^^^~~~~~~~

Using maps is still allowed:

% nft [..] tcp dport set numgen inc mod 2 map { 0 : 4040 , 1 : 4050 }

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 0 files changed

diff --git a/src/evaluate.c b/src/evaluate.c
index 27cee98..f307f64 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1807,6 +1807,17 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 			      payload->byteorder, &stmt->payload.val) < 0)
 		return -1;
 
+	switch (stmt->payload.val->ops->type) {
+	case EXPR_SET:
+		return stmt_binary_error(ctx, stmt->payload.expr, stmt,
+					 "you cannot use a set here");
+	case EXPR_SET_REF:
+		return stmt_binary_error(ctx, stmt->payload.expr, stmt,
+					 "you cannot reference a set here");
+	default:
+		break;
+	}
+
 	need_csum = stmt_evaluate_payload_need_csum(payload);
 
 	if (!payload_needs_adjustment(payload)) {

