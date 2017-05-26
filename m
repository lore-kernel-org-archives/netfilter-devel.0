From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft PATCH v2] evaluate: avoid reference to multiple src data in
 statements which set values
Date: Fri, 26 May 2017 13:00:21 +0200
Message-ID: <149579635553.24003.5991119396424133127.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48487 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935988AbdEZLAa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 07:00:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 03BC151F329
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 11:00:28 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KNUN7WKP5bDC for <netfilter-devel@vger.kernel.org>;
        Fri, 26 May 2017 13:00:22 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 7B0FA51F308
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 13:00:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prevent this assert:

% nft [..] tcp dport set { 0 , 1 }
BUG: unknown expression type set reference
nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
Aborted

We can't use a set here because we will not known which value to use.

With this patch, a proper error message is reported to users:

% nft add rule t c tcp dport set {1, 2, 3, 4, 5}
<cmdline>:1:28-42: Error: you cannot use a set here, unknown value to use
add rule t c tcp dport set {1, 2, 3, 4, 5}
             ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^

% nft add rule t c tcp dport set @s
<cmdline>:1:28-29: Error: you cannot reference a set here, unknown value to use
add rule t c tcp dport set @s
             ~~~~~~~~~~~~~~^^

This error is reported to all statements which set values.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
v2: check all statements which set values as well

 src/evaluate.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 27cee98..095d3fa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1759,6 +1759,21 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 "datatype mismatch: expected %s, "
 					 "expression has type %s",
 					 dtype->desc, (*expr)->dtype->desc);
+
+	/* we are setting a value, we can't use a set */
+	switch ((*expr)->ops->type) {
+	case EXPR_SET:
+		return stmt_binary_error(ctx, (*expr), stmt,
+					 "you cannot use a set here, unknown "
+					 "value to use");
+	case EXPR_SET_REF:
+		return stmt_binary_error(ctx, (*expr), stmt,
+					 "you cannot reference a set here, "
+					 "unknown value to use");
+	default:
+		break;
+	}
+
 	return 0;
 }
 

