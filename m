Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF59C433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Jan 2021 17:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84503238D6
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Jan 2021 17:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbhAORqK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 12:46:10 -0500
Received: from correo.us.es ([193.147.175.20]:53250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbhAORqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 12:46:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6ECECE34C3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2021 18:44:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DC40DA789
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2021 18:44:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 534B8DA73F; Fri, 15 Jan 2021 18:44:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4314DA78B
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2021 18:44:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Jan 2021 18:44:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CFDD442DF560
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2021 18:44:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: disallow ct original {s,d}ddr from maps
Date:   Fri, 15 Jan 2021 18:45:20 +0100
Message-Id: <20210115174520.28504-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

test.nft:6:55-71: Error: specify either ip or ip6 for address matching
add rule ip mangle manout ct direction reply mark set ct original daddr map { $ext1_ip : 0x11, $ext2_ip : 0x12 }
                                                      ^^^^^^^^^^^^^^^^^

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1489
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c           | 6 ++++++
 tests/py/ip/ct.t         | 3 +++
 tests/py/ip/ct.t.payload | 9 +++++++++
 3 files changed, 18 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 38dbc33d7826..c830dcdbd965 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1472,6 +1472,12 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	const struct datatype *dtype;
 	struct expr *key, *data;
 
+	if (map->map->etype == EXPR_CT &&
+	    (map->map->ct.key == NFT_CT_SRC ||
+	     map->map->ct.key == NFT_CT_DST))
+		return expr_error(ctx->msgs, map->map,
+				  "specify either ip or ip6 for address matching");
+
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index d3247f79113f..c5ce12747d42 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -21,3 +21,6 @@ ct original protocol 17 ct reply proto-src 53;ok;ct protocol 17 ct reply proto-s
 
 # wrong address family
 ct reply ip daddr dead::beef;fail
+
+meta mark set ct original daddr map { 1.1.1.1 : 0x00000011 };fail
+meta mark set ct original ip daddr map { 1.1.1.1 : 0x00000011 };ok
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index a7e08f98e6a3..3348d16ddc72 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -56,3 +56,12 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ ct load proto_src => reg 1 , dir reply ]
   [ cmp eq reg 1 0x00003500 ]
+
+# meta mark set ct original ip daddr map { 1.1.1.1 : 0x00000011 }
+__map%d test-ip4 b
+__map%d test-ip4 0
+        element 01010101  : 00000011 0 [end]
+ip
+  [ ct load dst_ip => reg 1 , dir original ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
-- 
2.20.1

