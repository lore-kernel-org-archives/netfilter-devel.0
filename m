Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE56C64E7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 17:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A479217A0
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 17:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgLBRdz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:33:55 -0500
Received: from correo.us.es ([193.147.175.20]:47174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgLBRdz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 12:33:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E70BEB6B88
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 18:33:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8159DA730
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 18:33:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD9BCDA722; Wed,  2 Dec 2020 18:33:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C284DA789
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 18:33:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Dec 2020 18:33:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2A3D442EF42D
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 18:33:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: allow to restore limit from dynamic set
Date:   Wed,  2 Dec 2020 18:33:06 +0100
Message-Id: <20201202173306.23871-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update parser to allow to restore limit per set element in dynamic set.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1477
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                            | 32 +++++++++++++++++++
 .../shell/testcases/sets/0056dynamic_limit_0  | 19 +++++++++++
 2 files changed, 51 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0056dynamic_limit_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a88844661af5..fb329919ea95 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4097,6 +4097,38 @@ set_elem_expr_option	:	TIMEOUT			time_spec
 				stmt->counter.bytes = $5;
 				$<expr>0->stmt = stmt;
 			}
+			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts
+			{
+				struct stmt *stmt;
+
+				stmt = limit_stmt_alloc(&@$);
+				stmt->limit.rate  = $4;
+				stmt->limit.unit  = $6;
+				stmt->limit.burst = $7;
+				stmt->limit.type  = NFT_LIMIT_PKTS;
+				stmt->limit.flags = $3;
+				$<expr>0->stmt = stmt;
+			}
+			|       LIMIT   RATE    limit_mode      NUM     STRING  limit_burst_bytes
+			{
+				struct error_record *erec;
+				uint64_t rate, unit;
+				struct stmt *stmt;
+
+				erec = rate_parse(&@$, $5, &rate, &unit);
+				xfree($5);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				stmt = limit_stmt_alloc(&@$);
+				stmt->limit.rate  = rate * $4;
+				stmt->limit.unit  = unit;
+				stmt->limit.burst = $6;
+				stmt->limit.type  = NFT_LIMIT_PKT_BYTES;
+				stmt->limit.flags = $3;
+                        }
 			|	comment_spec
 			{
 				if (already_set($<expr>0->comment, &@1, state)) {
diff --git a/tests/shell/testcases/sets/0056dynamic_limit_0 b/tests/shell/testcases/sets/0056dynamic_limit_0
new file mode 100755
index 000000000000..21fa0bff5a61
--- /dev/null
+++ b/tests/shell/testcases/sets/0056dynamic_limit_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+RULESET="table inet filter {
+        set ssh_meter {
+                type ipv4_addr
+                size 65535
+                flags dynamic,timeout
+                timeout 1m
+                elements = { 127.0.0.1 expires 52s44ms limit rate over 1/minute }
+        }
+
+        chain output {
+                type filter hook output priority filter; policy accept;
+                ip protocol icmp add @ssh_meter { ip saddr timeout 1m limit rate over 1/minute }
+        }
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
-- 
2.20.1

