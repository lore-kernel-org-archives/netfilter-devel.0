Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502B4C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A999238E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLQQlU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:41:20 -0500
Received: from correo.us.es ([193.147.175.20]:59506 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbgLQQlT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 11:41:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11BFDC0B2A
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:40:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02A9EDA722
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:40:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EBF1BDA855; Thu, 17 Dec 2020 17:40:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84B71DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:40:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 17:40:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6EA45426CC84
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:40:16 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] src: disallow burst 0 in ratelimits
Date:   Thu, 17 Dec 2020 17:40:29 +0100
Message-Id: <20201217164029.24304-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ratelimiter in nftables is similar to the one in iptables, and
iptables disallows a zero burst.

Update the byte rate limiter not to print burst 5 (default value).

Update tests/py to use burst 5 instead of zero.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: update tests/py
    do not print default burst when listing

 doc/statements.txt           |  3 ++-
 src/parser_bison.y           | 25 ++++++++++++++++++--
 src/statement.c              |  2 +-
 tests/py/any/limit.t.payload | 44 ++++++++++++++++++------------------
 4 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index beebba1611a8..aac7c7d6b009 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -324,7 +324,8 @@ ____
 A limit statement matches at a limited rate using a token bucket filter. A rule
 using this statement will match until this limit is reached. It can be used in
 combination with the log statement to give limited logging. The optional
-*over* keyword makes it match over the specified rate.
+*over* keyword makes it match over the specified rate. Default *burst* is 5.
+if you specify *burst*, it must be non-zero value.
 
 .limit statement values
 [options="header"]
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 58a5a4752002..15df215e8aa0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3038,6 +3038,11 @@ log_flag_tcp		:	SEQUENCE
 
 limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 	    		{
+				if ($7 == 0) {
+					erec_queue(error(&@7, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate	= $4;
 				$$->limit.unit	= $6;
@@ -3050,6 +3055,12 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 				struct error_record *erec;
 				uint64_t rate, unit;
 
+				if ($6 == 0) {
+					erec_queue(error(&@6, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
+
 				erec = rate_parse(&@$, $5, &rate, &unit);
 				xfree($5);
 				if (erec != NULL) {
@@ -3126,11 +3137,11 @@ limit_mode		:	OVER				{ $$ = NFT_LIMIT_F_INV; }
 			|	/* empty */			{ $$ = 0; }
 			;
 
-limit_burst_pkts	:	/* empty */			{ $$ = 0; }
+limit_burst_pkts	:	/* empty */			{ $$ = 5; }
 			|	BURST	NUM	PACKETS		{ $$ = $2; }
 			;
 
-limit_burst_bytes	:	/* empty */			{ $$ = 0; }
+limit_burst_bytes	:	/* empty */			{ $$ = 5; }
 			|	BURST	NUM	BYTES		{ $$ = $2; }
 			|	BURST	NUM	STRING
 			{
@@ -4121,6 +4132,11 @@ set_elem_stmt		:	COUNTER
 			}
 			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts
 			{
+				if ($7 == 0) {
+					erec_queue(error(&@7, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate  = $4;
 				$$->limit.unit  = $6;
@@ -4133,6 +4149,11 @@ set_elem_stmt		:	COUNTER
 				struct error_record *erec;
 				uint64_t rate, unit;
 
+				if ($6 == 0) {
+					erec_queue(error(&@6, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
 				erec = rate_parse(&@$, $5, &rate, &unit);
 				xfree($5);
 				if (erec != NULL) {
diff --git a/src/statement.c b/src/statement.c
index 39020857ae9c..f7f1c0c4d553 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -464,7 +464,7 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx,	"limit rate %s%" PRIu64 " %s/%s",
 			  inv ? "over " : "", rate, data_unit,
 			  get_unit(stmt->limit.unit));
-		if (stmt->limit.burst > 0) {
+		if (stmt->limit.burst != 5) {
 			uint64_t burst;
 
 			data_unit = get_rate(stmt->limit.burst, &burst);
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index b0cc84b42ff3..dc6cea9b2846 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -1,22 +1,22 @@
 # limit rate 400/minute
 ip test-ip4 output
-  [ limit rate 400/minute burst 0 type packets flags 0x0 ]
+  [ limit rate 400/minute burst 5 type packets flags 0x0 ]
 
 # limit rate 20/second
 ip test-ip4 output
-  [ limit rate 20/second burst 0 type packets flags 0x0 ]
+  [ limit rate 20/second burst 5 type packets flags 0x0 ]
 
 # limit rate 400/hour
 ip test-ip4 output
-  [ limit rate 400/hour burst 0 type packets flags 0x0 ]
+  [ limit rate 400/hour burst 5 type packets flags 0x0 ]
 
 # limit rate 400/week
 ip test-ip4 output
-  [ limit rate 400/week burst 0 type packets flags 0x0 ]
+  [ limit rate 400/week burst 5 type packets flags 0x0 ]
 
 # limit rate 40/day
 ip test-ip4 output
-  [ limit rate 40/day burst 0 type packets flags 0x0 ]
+  [ limit rate 40/day burst 5 type packets flags 0x0 ]
 
 # limit rate 1023/second burst 10 packets
 ip test-ip4 output
@@ -24,27 +24,27 @@ ip test-ip4 output
 
 # limit rate 1 kbytes/second
 ip test-ip4 output
-  [ limit rate 1024/second burst 0 type bytes flags 0x0 ]
+  [ limit rate 1024/second burst 5 type bytes flags 0x0 ]
 
 # limit rate 2 kbytes/second
 ip test-ip4 output
-  [ limit rate 2048/second burst 0 type bytes flags 0x0 ]
+  [ limit rate 2048/second burst 5 type bytes flags 0x0 ]
 
 # limit rate 1025 kbytes/second
 ip test-ip4 output
-  [ limit rate 1049600/second burst 0 type bytes flags 0x0 ]
+  [ limit rate 1049600/second burst 5 type bytes flags 0x0 ]
 
 # limit rate 1023 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248/second burst 0 type bytes flags 0x0 ]
+  [ limit rate 1072693248/second burst 5 type bytes flags 0x0 ]
 
 # limit rate 10230 mbytes/second
 ip test-ip4 output
-  [ limit rate 10726932480/second burst 0 type bytes flags 0x0 ]
+  [ limit rate 10726932480/second burst 5 type bytes flags 0x0 ]
 
 # limit rate 1023000 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248000/second burst 0 type bytes flags 0x0 ]
+  [ limit rate 1072693248000/second burst 5 type bytes flags 0x0 ]
 
 # limit rate 1025 bytes/second burst 512 bytes
 ip test-ip4 output
@@ -64,23 +64,23 @@ ip test-ip4 output
 
 # limit rate over 400/minute
 ip test-ip4 output
-  [ limit rate 400/minute burst 0 type packets flags 0x1 ]
+  [ limit rate 400/minute burst 5 type packets flags 0x1 ]
 
 # limit rate over 20/second
 ip test-ip4 output
-  [ limit rate 20/second burst 0 type packets flags 0x1 ]
+  [ limit rate 20/second burst 5 type packets flags 0x1 ]
 
 # limit rate over 400/hour
 ip test-ip4 output
-  [ limit rate 400/hour burst 0 type packets flags 0x1 ]
+  [ limit rate 400/hour burst 5 type packets flags 0x1 ]
 
 # limit rate over 400/week
 ip test-ip4 output
-  [ limit rate 400/week burst 0 type packets flags 0x1 ]
+  [ limit rate 400/week burst 5 type packets flags 0x1 ]
 
 # limit rate over 40/day
 ip test-ip4 output
-  [ limit rate 40/day burst 0 type packets flags 0x1 ]
+  [ limit rate 40/day burst 5 type packets flags 0x1 ]
 
 # limit rate over 1023/second burst 10 packets
 ip test-ip4 output
@@ -88,27 +88,27 @@ ip test-ip4 output
 
 # limit rate over 1 kbytes/second
 ip test-ip4 output
-  [ limit rate 1024/second burst 0 type bytes flags 0x1 ]
+  [ limit rate 1024/second burst 5 type bytes flags 0x1 ]
 
 # limit rate over 2 kbytes/second
 ip test-ip4 output
-  [ limit rate 2048/second burst 0 type bytes flags 0x1 ]
+  [ limit rate 2048/second burst 5 type bytes flags 0x1 ]
 
 # limit rate over 1025 kbytes/second
 ip test-ip4 output
-  [ limit rate 1049600/second burst 0 type bytes flags 0x1 ]
+  [ limit rate 1049600/second burst 5 type bytes flags 0x1 ]
 
 # limit rate over 1023 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248/second burst 0 type bytes flags 0x1 ]
+  [ limit rate 1072693248/second burst 5 type bytes flags 0x1 ]
 
 # limit rate over 10230 mbytes/second
 ip test-ip4 output
-  [ limit rate 10726932480/second burst 0 type bytes flags 0x1 ]
+  [ limit rate 10726932480/second burst 5 type bytes flags 0x1 ]
 
 # limit rate over 1023000 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248000/second burst 0 type bytes flags 0x1 ]
+  [ limit rate 1072693248000/second burst 5 type bytes flags 0x1 ]
 
 # limit rate over 1025 bytes/second burst 512 bytes
 ip test-ip4 output
-- 
2.20.1

