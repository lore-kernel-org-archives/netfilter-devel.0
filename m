Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4408C4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 13:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1848206C0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 13:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfDENqR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 09:46:17 -0400
Received: from mail.us.es ([193.147.175.20]:51796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfDENqR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 09:46:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5DE2DA705
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:46:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6C3EDA702
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:46:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B6334DA701; Fri,  5 Apr 2019 15:46:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C204DA702
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:46:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Apr 2019 15:46:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6E8CA4265A31
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 15:46:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: missing destroy function in statement definitions
Date:   Fri,  5 Apr 2019 15:46:09 +0200
Message-Id: <20190405134609.2949-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ct.c        | 12 ++++++++++++
 src/exthdr.c    |  7 +++++++
 src/meta.c      |  6 ++++++
 src/payload.c   |  7 +++++++
 src/statement.c | 21 +++++++++++++++++++++
 src/xt.c        |  1 +
 6 files changed, 54 insertions(+)

diff --git a/src/ct.c b/src/ct.c
index ca31f49850d4..02250f785c97 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -440,11 +440,17 @@ static void ct_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->ct.expr, octx);
 }
 
+static void ct_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->ct.expr);
+}
+
 static const struct stmt_ops ct_stmt_ops = {
 	.type		= STMT_CT,
 	.name		= "ct",
 	.print		= ct_stmt_print,
 	.json		= ct_stmt_json,
+	.destroy	= ct_stmt_destroy,
 };
 
 struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
@@ -484,10 +490,16 @@ static void flow_offload_stmt_print(const struct stmt *stmt,
 	printf("flow add @%s", stmt->flow.table_name);
 }
 
+static void flow_offload_stmt_destroy(struct stmt *stmt)
+{
+	xfree(stmt->flow.table_name);
+}
+
 static const struct stmt_ops flow_offload_stmt_ops = {
 	.type		= STMT_FLOW_OFFLOAD,
 	.name		= "flow_offload",
 	.print		= flow_offload_stmt_print,
+	.destroy	= flow_offload_stmt_destroy,
 };
 
 struct stmt *flow_offload_stmt_alloc(const struct location *loc,
diff --git a/src/exthdr.c b/src/exthdr.c
index 91d2430ab123..0cd031980073 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -104,11 +104,18 @@ static void exthdr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->exthdr.val, octx);
 }
 
+static void exthdr_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->exthdr.expr);
+	expr_free(stmt->exthdr.val);
+}
+
 static const struct stmt_ops exthdr_stmt_ops = {
 	.type		= STMT_EXTHDR,
 	.name		= "exthdr",
 	.print		= exthdr_stmt_print,
 	.json		= exthdr_stmt_json,
+	.destroy	= exthdr_stmt_destroy,
 };
 
 struct stmt *exthdr_stmt_alloc(const struct location *loc,
diff --git a/src/meta.c b/src/meta.c
index 7e44a2a3545c..583e790ff47d 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -607,11 +607,17 @@ static void meta_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->meta.expr, octx);
 }
 
+static void meta_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->meta.expr);
+}
+
 static const struct stmt_ops meta_stmt_ops = {
 	.type		= STMT_META,
 	.name		= "meta",
 	.print		= meta_stmt_print,
 	.json		= meta_stmt_json,
+	.destroy	= meta_stmt_destroy,
 };
 
 struct stmt *meta_stmt_alloc(const struct location *loc, enum nft_meta_keys key,
diff --git a/src/payload.c b/src/payload.c
index abe9315da389..338a4b762cf8 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -189,11 +189,18 @@ static void payload_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->payload.val, octx);
 }
 
+static void payload_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->payload.expr);
+	expr_free(stmt->payload.val);
+}
+
 static const struct stmt_ops payload_stmt_ops = {
 	.type		= STMT_PAYLOAD,
 	.name		= "payload",
 	.print		= payload_stmt_print,
 	.json		= payload_stmt_json,
+	.destroy	= payload_stmt_destroy,
 };
 
 struct stmt *payload_stmt_alloc(const struct location *loc,
diff --git a/src/statement.c b/src/statement.c
index b9324fd7b2ed..9b45b3c5bac3 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -136,6 +136,7 @@ static void meter_stmt_destroy(struct stmt *stmt)
 	expr_free(stmt->meter.key);
 	expr_free(stmt->meter.set);
 	stmt_free(stmt->meter.stmt);
+	xfree(stmt->meter.name);
 }
 
 static const struct stmt_ops meter_stmt_ops = {
@@ -234,11 +235,17 @@ static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->objref.expr, octx);
 }
 
+static void objref_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->objref.expr);
+}
+
 static const struct stmt_ops objref_stmt_ops = {
 	.type		= STMT_OBJREF,
 	.name		= "objref",
 	.print		= objref_stmt_print,
 	.json		= objref_stmt_json,
+	.destroy	= objref_stmt_destroy,
 };
 
 struct stmt *objref_stmt_alloc(const struct location *loc)
@@ -443,11 +450,17 @@ static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 }
 
+static void queue_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->queue.queue);
+}
+
 static const struct stmt_ops queue_stmt_ops = {
 	.type		= STMT_QUEUE,
 	.name		= "queue",
 	.print		= queue_stmt_print,
 	.json		= queue_stmt_json,
+	.destroy	= queue_stmt_destroy,
 };
 
 struct stmt *queue_stmt_alloc(const struct location *loc)
@@ -519,11 +532,17 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	}
 }
 
+static void reject_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->reject.expr);
+}
+
 static const struct stmt_ops reject_stmt_ops = {
 	.type		= STMT_REJECT,
 	.name		= "reject",
 	.print		= reject_stmt_print,
 	.json		= reject_stmt_json,
+	.destroy	= reject_stmt_destroy,
 };
 
 struct stmt *reject_stmt_alloc(const struct location *loc)
@@ -652,6 +671,7 @@ static void set_stmt_destroy(struct stmt *stmt)
 {
 	expr_free(stmt->set.key);
 	expr_free(stmt->set.set);
+	stmt_free(stmt->set.stmt);
 }
 
 static const struct stmt_ops set_stmt_ops = {
@@ -691,6 +711,7 @@ static void map_stmt_destroy(struct stmt *stmt)
 	expr_free(stmt->map.key);
 	expr_free(stmt->map.data);
 	expr_free(stmt->map.set);
+	stmt_free(stmt->map.stmt);
 }
 
 static const struct stmt_ops map_stmt_ops = {
diff --git a/src/xt.c b/src/xt.c
index c80e1fc0b2b0..906b2fde10e1 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -102,6 +102,7 @@ void xt_stmt_release(const struct stmt *stmt)
 	}
 #endif
 	xfree(stmt->xt.entry);
+	xfree(stmt->xt.name);
 }
 
 #ifdef HAVE_LIBXTABLES
-- 
2.11.0

