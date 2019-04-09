Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835B6C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 10:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C442084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 10:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfDIK7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:59:45 -0400
Received: from mail.us.es ([193.147.175.20]:56386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfDIK7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 06:59:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63DD74FFE0D
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 12:59:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50585DA701
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 12:59:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F64EDA70C; Tue,  9 Apr 2019 12:59:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 437A0DA701;
        Tue,  9 Apr 2019 12:59:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 12:59:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0E17D4265A5B;
        Tue,  9 Apr 2019 12:59:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, arturo@netfilter.org, phil@nwl.cc
Subject: [PATCH nft] evaluate: disallow anonymous set with empty elements
Date:   Tue,  9 Apr 2019 12:59:36 +0200
Message-Id: <20190409105936.23422-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Restrict this, the brackets have explicit semantics since they tell the
kernel to represent this value as a set, which is too costly. Set for
one single element are overkill.

 # nft add rule x y ct state { established } counter
 Error: anonymous set with single element makes no sense, remove brackets wrapping this value
 add rule x y ct state { established } counter
                       ^^^^^^^^^^^^^^^

Instead, the preferred way to express this is:

 # nft add rule x y ct state established counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I know this may break stuff outthere, but probably it's still early to
fix this. If we keep allowing this and transparently turn this into a
value, people will likely never understand the bracket semantics.
Brackets are not just syntaxic sugar.

 src/evaluate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3a3f2468c826..aa42c69127a2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1253,8 +1253,11 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
+	unsigned int count = 0;
 
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
+		count++;
+
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
@@ -1288,6 +1291,11 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= NFT_SET_INTERVAL;
 	}
 
+	if (set->flags & NFT_SET_ANONYMOUS &&
+	    count == 1)
+		return expr_error(ctx->msgs, set,
+				  "anonymous set with one single element makes no sense, remove brackets wrapping this value");
+
 	set->set_flags |= NFT_SET_CONSTANT;
 
 	set->dtype = ctx->ectx.dtype;
-- 
2.11.0

