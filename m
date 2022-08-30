Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836A0ECAAD1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Aug 2022 15:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiH3Phw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 11:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiH3Phv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 11:37:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BA5B15C352
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 08:37:49 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] src: allow burst 0 for byte ratelimit and use it as default
Date:   Tue, 30 Aug 2022 17:37:46 +0200
Message-Id: <20220830153746.94996-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Packet-based limit burst is set to 5, as in iptables. However,
byte-based limit burst adds to the rate to calculate the bucket size,
and this is also sets this to 5 (... bytes in this case). Update it to
use zero byte burst by default instead.

This patch also updates manpage to describe how the burst value
influences the kernel module's token bucket in each of the two modes.
This documentation update is based on original text by Phil Sutter.

Adjust tests/py to silence warnings due to mismatching byte burst.

Fixes: 285baccfea46 ("src: disallow burst 0 in ratelimits")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/statements.txt               |  9 +++++++--
 src/parser_bison.y               |  9 ++-------
 src/parser_json.c                |  5 ++++-
 src/statement.c                  |  2 +-
 tests/py/any/limit.t.json        |  6 +++---
 tests/py/any/limit.t.json.output | 24 ++++++++++++------------
 tests/py/any/limit.t.payload     | 30 +++++++++++++++---------------
 7 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6aaf806bcff2..6c6b1d8712d4 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -332,8 +332,13 @@ ____
 A limit statement matches at a limited rate using a token bucket filter. A rule
 using this statement will match until this limit is reached. It can be used in
 combination with the log statement to give limited logging. The optional
-*over* keyword makes it match over the specified rate. Default *burst* is 5.
-if you specify *burst*, it must be non-zero value.
+*over* keyword makes it match over the specified rate.
+
+The *burst* value influences the bucket size, i.e. jitter tolerance. With
+packet-based *limit*, the bucket holds exactly *burst* packets, by default
+five. If you specify packet *burst*, it must be a non-zero value. With
+byte-based *limit*, the bucket's minimum size is the given rate's byte value
+and the *burst* value adds to that, by default zero bytes.
 
 .limit statement values
 [options="header"]
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ae14eb1a690b..0266819a779b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3203,7 +3203,7 @@ log_flag_tcp		:	SEQUENCE
 limit_stmt		:	LIMIT	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts	close_scope_limit
 	    		{
 				if ($5 == 0) {
-					erec_queue(error(&@5, "limit burst must be > 0"),
+					erec_queue(error(&@5, "packet limit burst must be > 0"),
 						   state->msgs);
 					YYERROR;
 				}
@@ -3216,11 +3216,6 @@ limit_stmt		:	LIMIT	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts	close_scope
 			}
 			|	LIMIT	RATE	limit_mode	limit_rate_bytes	limit_burst_bytes	close_scope_limit
 			{
-				if ($5 == 0) {
-					erec_queue(error(&@5, "limit burst must be > 0"),
-						   state->msgs);
-					YYERROR;
-				}
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate	= $4.rate;
 				$$->limit.unit	= $4.unit;
@@ -3301,7 +3296,7 @@ limit_rate_pkts		:	NUM     SLASH	time_unit
 			}
 			;
 
-limit_burst_bytes	:	/* empty */			{ $$ = 5; }
+limit_burst_bytes	:	/* empty */			{ $$ = 0; }
 			|	BURST	limit_bytes		{ $$ = $2; }
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 9e93927a9a2b..2437b1bae178 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1826,7 +1826,7 @@ static struct stmt *json_parse_limit_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
 	struct stmt *stmt;
-	uint64_t rate, burst = 5;
+	uint64_t rate, burst = 0;
 	const char *rate_unit = "packets", *time, *burst_unit = "bytes";
 	int inv = 0;
 
@@ -1840,6 +1840,9 @@ static struct stmt *json_parse_limit_stmt(struct json_ctx *ctx,
 		stmt = limit_stmt_alloc(int_loc);
 
 		if (!strcmp(rate_unit, "packets")) {
+			if (burst == 0)
+				burst = 5;
+
 			stmt->limit.type = NFT_LIMIT_PKTS;
 			stmt->limit.rate = rate;
 			stmt->limit.burst = burst;
diff --git a/src/statement.c b/src/statement.c
index 30caf9c7f6e1..327d00f99200 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -465,7 +465,7 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx,	"limit rate %s%" PRIu64 " %s/%s",
 			  inv ? "over " : "", rate, data_unit,
 			  get_unit(stmt->limit.unit));
-		if (stmt->limit.burst != 5) {
+		if (stmt->limit.burst != 0) {
 			uint64_t burst;
 
 			data_unit = get_rate(stmt->limit.burst, &burst);
diff --git a/tests/py/any/limit.t.json b/tests/py/any/limit.t.json
index b41ae60a3bd6..e001ba0fe9ac 100644
--- a/tests/py/any/limit.t.json
+++ b/tests/py/any/limit.t.json
@@ -129,7 +129,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1,
@@ -142,7 +142,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1,
@@ -155,7 +155,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1,
diff --git a/tests/py/any/limit.t.json.output b/tests/py/any/limit.t.json.output
index e6f26496e01c..5a95f5e10a86 100644
--- a/tests/py/any/limit.t.json.output
+++ b/tests/py/any/limit.t.json.output
@@ -57,7 +57,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1,
@@ -70,7 +70,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 2,
@@ -83,7 +83,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1025,
@@ -96,7 +96,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1023,
@@ -109,7 +109,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 10230,
@@ -122,7 +122,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "per": "second",
             "rate": 1023000,
@@ -195,7 +195,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "inv": true,
             "per": "second",
@@ -209,7 +209,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "inv": true,
             "per": "second",
@@ -223,7 +223,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "inv": true,
             "per": "second",
@@ -237,7 +237,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "inv": true,
             "per": "second",
@@ -251,7 +251,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "inv": true,
             "per": "second",
@@ -265,7 +265,7 @@
 [
     {
         "limit": {
-            "burst": 5,
+            "burst": 0,
             "burst_unit": "bytes",
             "inv": true,
             "per": "second",
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index 3bd85f4ebf45..0c7ee942927d 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -24,39 +24,39 @@ ip test-ip4 output
 
 # limit rate 1 kbytes/second
 ip test-ip4 output
-  [ limit rate 1024/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1024/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 2 kbytes/second
 ip test-ip4 output
-  [ limit rate 2048/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 2048/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1025 kbytes/second
 ip test-ip4 output
-  [ limit rate 1049600/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1049600/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1023 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1072693248/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 10230 mbytes/second
 ip test-ip4 output
-  [ limit rate 10726932480/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 10726932480/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1023000 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248000/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1072693248000/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1 bytes / second
 ip
-  [ limit rate 1/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1 kbytes / second
 ip
-  [ limit rate 1024/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1024/second burst 0 type bytes flags 0x0 ]
 
 # limit rate 1 mbytes / second
 ip
-  [ limit rate 1048576/second burst 5 type bytes flags 0x0 ]
+  [ limit rate 1048576/second burst 0 type bytes flags 0x0 ]
 
 
 # limit rate 1025 bytes/second burst 512 bytes
@@ -101,27 +101,27 @@ ip test-ip4 output
 
 # limit rate over 1 kbytes/second
 ip test-ip4 output
-  [ limit rate 1024/second burst 5 type bytes flags 0x1 ]
+  [ limit rate 1024/second burst 0 type bytes flags 0x1 ]
 
 # limit rate over 2 kbytes/second
 ip test-ip4 output
-  [ limit rate 2048/second burst 5 type bytes flags 0x1 ]
+  [ limit rate 2048/second burst 0 type bytes flags 0x1 ]
 
 # limit rate over 1025 kbytes/second
 ip test-ip4 output
-  [ limit rate 1049600/second burst 5 type bytes flags 0x1 ]
+  [ limit rate 1049600/second burst 0 type bytes flags 0x1 ]
 
 # limit rate over 1023 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248/second burst 5 type bytes flags 0x1 ]
+  [ limit rate 1072693248/second burst 0 type bytes flags 0x1 ]
 
 # limit rate over 10230 mbytes/second
 ip test-ip4 output
-  [ limit rate 10726932480/second burst 5 type bytes flags 0x1 ]
+  [ limit rate 10726932480/second burst 0 type bytes flags 0x1 ]
 
 # limit rate over 1023000 mbytes/second
 ip test-ip4 output
-  [ limit rate 1072693248000/second burst 5 type bytes flags 0x1 ]
+  [ limit rate 1072693248000/second burst 0 type bytes flags 0x1 ]
 
 # limit rate over 1025 bytes/second burst 512 bytes
 ip test-ip4 output
-- 
2.30.2

