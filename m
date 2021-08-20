Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F4CC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 10:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286B7610D2
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 10:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbhHTKLA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 06:11:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52658 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbhHTKK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 06:10:59 -0400
Received: from localhost.localdomain (unknown [213.94.13.0])
        by mail.netfilter.org (Postfix) with ESMTPSA id C1E37601EB
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 12:09:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: restore variable expression in queue statement
Date:   Fri, 20 Aug 2021 12:10:14 +0200
Message-Id: <20210820101014.6182-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

define ips_queue = 0
add rule ip foo snortips queue num $ips_queue bypass

And it gave error in nftables 1.0.0:

/etc/nftables4.conf:19:49-54: Error: syntax error, unexpected bypass, expecting -
add rule ip foo snortips queue num $ips_queue bypass

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                                |  1 +
 tests/shell/testcases/nft-f/0022variables_0       |  2 ++
 .../testcases/nft-f/dumps/0022variables_0.nft     | 15 +++++++++++++++
 3 files changed, 18 insertions(+)
 create mode 100644 tests/shell/testcases/nft-f/dumps/0022variables_0.nft

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 83f0250a8744..6b87ece55a69 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3792,6 +3792,7 @@ queue_stmt_arg		:	QUEUENUM	queue_stmt_expr_simple
 
 queue_stmt_expr_simple	:	integer_expr
 			|	range_rhs_expr
+			|	variable_expr
 			;
 
 queue_stmt_expr		:	numgen_expr
diff --git a/tests/shell/testcases/nft-f/0022variables_0 b/tests/shell/testcases/nft-f/0022variables_0
index ee17a6272aa3..00ab550e4009 100755
--- a/tests/shell/testcases/nft-f/0022variables_0
+++ b/tests/shell/testcases/nft-f/0022variables_0
@@ -3,6 +3,7 @@
 set -e
 
 RULESET="define test1 = @y
+define ips_queue = 1
 
 table ip x {
 	set y {
@@ -15,6 +16,7 @@ table ip x {
 		add \$test1 { ip saddr }
 		update \$test1 { ip saddr timeout 30s }
 		ip saddr \$test1
+		queue flags bypass num \$ips_queue
 	}
 }"
 
diff --git a/tests/shell/testcases/nft-f/dumps/0022variables_0.nft b/tests/shell/testcases/nft-f/dumps/0022variables_0.nft
new file mode 100644
index 000000000000..6b87f8798287
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0022variables_0.nft
@@ -0,0 +1,15 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+	}
+
+	chain z {
+		type filter hook input priority filter; policy accept;
+		add @y { ip saddr }
+		update @y { ip saddr timeout 30s }
+		ip saddr @y
+		queue flags bypass num 1
+	}
+}
-- 
2.20.1

