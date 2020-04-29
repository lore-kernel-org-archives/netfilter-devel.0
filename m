Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092D1C83003
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 10:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FF5206F0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 10:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD2KiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 06:38:24 -0400
Received: from correo.us.es ([193.147.175.20]:48984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgD2KiY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 06:38:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9BB51C4423
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 12:38:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB2A22066B
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 12:38:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9D205BC; Wed, 29 Apr 2020 12:38:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3EBB53899
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 12:38:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 12:38:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B0F6342EF9E5
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 12:38:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: incorrect byteorder with typeof and integer_datatype
Date:   Wed, 29 Apr 2020 12:38:17 +0200
Message-Id: <20200429103817.29918-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 table bridge t {
         set s3 {
                 typeof meta ibrpvid
                 elements = { 2, 3, 103 }
         }
 }

 # nft --debug=netlink -f test.nft
 s3 t 0
 s3 t 0
        element 00000100  : 0 [end]     element 00000200  : 0 [end]     element 00000300  : 0 [end]
                ^^^^^^^^

The integer_type uses BYTEORDER_INVALID byteorder (which is implicitly
handled as BYTEORDER_BIG_ENDIAN).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                     | 3 ++-
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft | 5 +++++
 tests/shell/testcases/sets/typeof_sets_0           | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8c227eb11402..597141317000 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3544,7 +3544,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	ctx->set = set;
 	if (set->init != NULL) {
-		expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
+		__expr_set_context(&ctx->ectx, set->key->dtype,
+				   set->key->byteorder, set->key->len, 0);
 		if (expr_evaluate(ctx, &set->init) < 0)
 			return -1;
 	}
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index 44e11202d299..565369fb7be5 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -9,6 +9,11 @@ table inet t {
 		elements = { 2, 3, 103 }
 	}
 
+	set s3 {
+		typeof meta ibrpvid
+		elements = { 2, 3, 103 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 2a8b21c725c6..9b2712e56177 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -15,6 +15,11 @@ EXPECTED="table inet t {
 		elements = { 2, 3, 103 }
 	}
 
+	set s3 {
+		typeof meta ibrpvid
+		elements = { 2, 3, 103 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
-- 
2.20.1

