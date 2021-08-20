Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53898C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 09:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F3E61075
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 09:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhHTJ7Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 05:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhHTJ7Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 05:59:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F39C061575
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 02:58:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mH1IJ-0002UN-QU; Fri, 20 Aug 2021 11:58:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Amish <anon.amish@gmail.com>
Subject: [PATCH nft] parser: permit symbolic defines for 'queue num' again
Date:   Fri, 20 Aug 2021 11:58:31 +0200
Message-Id: <20210820095831.7948-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <ffc4dd4e-bbb1-0380-2cf2-7053fc3ab39c@gmail.com>
References: <ffc4dd4e-bbb1-0380-2cf2-7053fc3ab39c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

WHen I simplified the parser to restrict 'queue num' I forgot that
instead of range and immediate value its also allowed to pass in
a symbolic constant, e.g.

define myq = 0
add rule ... 'queue num $myq bypass'

Allow those as well and add a test case for this.

Fixes: 767f0af82a389 ("parser: restrict queue num expressiveness")
Reported-by: Amish <anon.amish@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                         | 1 +
 tests/shell/testcases/nft-f/0012different_defines_0        | 7 +++++++
 .../testcases/nft-f/dumps/0012different_defines_0.nft      | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2634b90c559b..2c96ea69d0b2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3793,6 +3793,7 @@ queue_stmt_arg		:	QUEUENUM	queue_stmt_expr_simple
 
 queue_stmt_expr_simple	:	integer_expr
 			|	range_rhs_expr
+			|	symbol_expr
 			;
 
 queue_stmt_expr		:	numgen_expr
diff --git a/tests/shell/testcases/nft-f/0012different_defines_0 b/tests/shell/testcases/nft-f/0012different_defines_0
index 0bdbd1b5f147..fe22858791a1 100755
--- a/tests/shell/testcases/nft-f/0012different_defines_0
+++ b/tests/shell/testcases/nft-f/0012different_defines_0
@@ -14,6 +14,8 @@ define d_ipv4_2 = 10.0.0.2
 define d_ipv6 = fe0::1
 define d_ipv6_2 = fe0::2
 define d_ports = 100-222
+define d_qnum = 0
+define d_qnumr = 1-42
 
 table inet t {
 	chain c {
@@ -29,6 +31,11 @@ table inet t {
 		ip daddr . meta iif vmap { \$d_ipv4 . \$d_iif : accept }
 		tcp dport \$d_ports
 		udp dport vmap { \$d_ports : accept }
+		tcp dport 1 tcp sport 1 meta oifname \"foobar\" queue num \$d_qnum bypass
+		tcp dport 1 tcp sport 1 meta oifname \"foobar\" queue num \$d_qnumr
+		tcp dport 1 tcp sport 1 meta oifname \"foobar\" queue flags bypass,fanout num \$d_qnumr
+		tcp dport 1 tcp sport 1 meta oifname \"foobar\" queue to symhash mod 2
+		tcp dport 1 tcp sport 1 meta oifname \"foobar\" queue flags bypass to jhash tcp dport . tcp sport mod 4
 	}
 }"
 
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
index 28094387ebed..e690f322436d 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
@@ -12,5 +12,10 @@ table inet t {
 		ip daddr . iif vmap { 10.0.0.0 . "lo" : accept }
 		tcp dport 100-222
 		udp dport vmap { 100-222 : accept }
+		tcp sport 1 tcp dport 1 oifname "foobar" queue flags bypass num 0
+		tcp sport 1 tcp dport 1 oifname "foobar" queue num 1-42
+		tcp sport 1 tcp dport 1 oifname "foobar" queue flags bypass,fanout num 1-42
+		tcp sport 1 tcp dport 1 oifname "foobar" queue to symhash mod 2
+		tcp sport 1 tcp dport 1 oifname "foobar" queue flags bypass to jhash tcp dport . tcp sport mod 4
 	}
 }
-- 
2.31.1

