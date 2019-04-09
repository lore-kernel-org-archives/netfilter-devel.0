Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDCEC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 21:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9694220645
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 21:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfDIVBD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 17:01:03 -0400
Received: from mail.us.es ([193.147.175.20]:41938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfDIVBD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 17:01:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D87AA11FBE9
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 23:01:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0937DA706
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 23:01:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6314DA705; Tue,  9 Apr 2019 23:01:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCF3BDA706
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 23:00:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 23:00:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9D0EE4265A31
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 23:00:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: memleak in expressions
Date:   Tue,  9 Apr 2019 23:00:55 +0200
Message-Id: <20190409210055.12147-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix memleak in set element and hash expressions destroy path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 1 +
 src/hash.c       | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 0edc1d22ffce..eece12e4fd2d 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1097,6 +1097,7 @@ static void set_elem_expr_destroy(struct expr *expr)
 {
 	xfree(expr->comment);
 	expr_free(expr->key);
+	stmt_free(expr->stmt);
 }
 
 static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/hash.c b/src/hash.c
index 208f4b6b6779..08e09099024e 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -56,6 +56,11 @@ static void hash_expr_clone(struct expr *new, const struct expr *expr)
 	new->hash.type = expr->hash.type;
 }
 
+static void hash_expr_destroy(struct expr *expr)
+{
+	expr_free(expr->hash.expr);
+}
+
 const struct expr_ops hash_expr_ops = {
 	.type		= EXPR_HASH,
 	.name		= "hash",
@@ -63,6 +68,7 @@ const struct expr_ops hash_expr_ops = {
 	.json		= hash_expr_json,
 	.cmp		= hash_expr_cmp,
 	.clone		= hash_expr_clone,
+	.destroy	= hash_expr_destroy,
 };
 
 struct expr *hash_expr_alloc(const struct location *loc,
-- 
2.11.0

