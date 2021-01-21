Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3477FC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 16:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E97D323A57
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 16:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbhAUPzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:55:41 -0500
Received: from correo.us.es ([193.147.175.20]:34716 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbhAUPzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 10:55:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 76927396268
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 16:53:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 668F6DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 16:53:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C242DA84A; Thu, 21 Jan 2021 16:53:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3F92DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 16:53:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Jan 2021 16:53:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 91FC042EF9E1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 16:53:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: disallow ct original {s,d}ddr from concatenations
Date:   Thu, 21 Jan 2021 16:54:13 +0100
Message-Id: <20210121155413.8251-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend 8b043938e77b ("evaluate: disallow ct original {s,d}ddr from
maps") to cover concatenations too.

Error: specify either ip or ip6 for address matching
add rule x y meta mark set ct original saddr . meta mark map { 1.1.1.1 . 20 : 30 }
                           ^^^^^^^^^^^^^^^^^

The old syntax for ct original saddr without either ip or ip6 results
in unknown key size, which breaks the listing. The old syntax is only
allowed in simple rules for backward compatibility.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1489
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c           | 17 +++++++++++++++++
 tests/py/ip/ct.t         |  4 ++++
 tests/py/ip/ct.t.payload | 19 +++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index c830dcdbd965..53f636b7ebe7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1266,6 +1266,12 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
 		unsigned dsize_bytes;
 
+		if (i->etype == EXPR_CT &&
+		    (i->ct.key == NFT_CT_SRC ||
+		     i->ct.key == NFT_CT_DST))
+			return expr_error(ctx->msgs, i,
+					  "specify either ip or ip6 for address matching");
+
 		if (expr_is_constant(*expr) && dtype && off == 0)
 			return expr_binary_error(ctx->msgs, i, *expr,
 						 "unexpected concat component, "
@@ -1477,6 +1483,17 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	     map->map->ct.key == NFT_CT_DST))
 		return expr_error(ctx->msgs, map->map,
 				  "specify either ip or ip6 for address matching");
+	else if (map->map->etype == EXPR_CONCAT) {
+		struct expr *i;
+
+		list_for_each_entry(i, &map->map->expressions, list) {
+			if (i->etype == EXPR_CT &&
+			    (i->ct.key == NFT_CT_SRC ||
+			     i->ct.key == NFT_CT_DST))
+				return expr_error(ctx->msgs, i,
+					  "specify either ip or ip6 for address matching");
+		}
+	}
 
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index c5ce12747d42..a387863e0d8e 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -24,3 +24,7 @@ ct reply ip daddr dead::beef;fail
 
 meta mark set ct original daddr map { 1.1.1.1 : 0x00000011 };fail
 meta mark set ct original ip daddr map { 1.1.1.1 : 0x00000011 };ok
+meta mark set ct original saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e };fail
+meta mark set ct original ip saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e };ok
+ct original saddr . meta mark { 1.1.1.1 . 0x00000014 };fail
+ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 };ok
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 3348d16ddc72..49f06a8401f5 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -65,3 +65,22 @@ ip
   [ ct load dst_ip => reg 1 , dir original ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
+
+# meta mark set ct original ip saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e }
+__map%d test-ip4 b
+__map%d test-ip4 0
+        element 01010101 00000014  : 0000001e 0 [end]
+ip
+  [ ct load src_ip => reg 1 , dir original ]
+  [ meta load mark => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
+# ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 }
+__set%d test-ip4 3
+__set%d test-ip4 0
+        element 01010101 00000014  : 0 [end]
+ip
+  [ ct load src_ip => reg 1 , dir original ]
+  [ meta load mark => reg 9 ]
+  [ lookup reg 1 set __set%d ]
-- 
2.20.1

