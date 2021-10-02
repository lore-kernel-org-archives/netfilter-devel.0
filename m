Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6FDC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 15:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0C861AAA
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 15:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhJBP2J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 11:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhJBP2J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 11:28:09 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0CCC0613EC
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Oct 2021 08:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3NTsY8eAuXXTpo+jllqtqaoQdYVJcUmxohs2mxB1Eg8=; b=LGTqzKZQT8srlBGRVByrV2ZdM1
        afTMcnPgqUjbkq0EB1YfG2HP/ZMV/9hxeSd5z6FR8rZwwSsttR2fGljZV4NOAF0BzSkhrnecqkS+D
        ncFXkhbeTh3R/SIZ/+s12y7qk5ktrW/aes480bZrFmh7ZmtUtcl0GViWfPJOa0pP57Fh78fQO3qfv
        su21B8LaS96vRZFvSYWzRD8p/m62qTsycip9REVlOIWyow+8UbS71bHsGlR+iuRKrUsD3GlzmCa2C
        sk0NEyNYRPlBemH1kXDnJIgC6OjsPc2b1yLkuJhjqjQDjmI4XdZMOStQnjwraurCuY19A+wo6MwzG
        ZOUNcouQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWgu5-003XZX-14
        for netfilter-devel@vger.kernel.org; Sat, 02 Oct 2021 16:26:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH] parser: extend limit statement syntax.
Date:   Sat,  2 Oct 2021 16:22:30 +0100
Message-Id: <20211002152230.1568537-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The documentation describes the syntax of limit statements thus:

  limit rate [over] packet_number / TIME_UNIT [burst packet_number packets]
  limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]

  TIME_UNIT := second | minute | hour | day
  BYTE_UNIT := bytes | kbytes | mbytes

This implies that one may specify a limit as either of the following:

  limit rate 1048576 / second
  limit rate 1048576 mbytes / second

However, the latter currently does not parse:

  $ sudo /usr/sbin/nft add filter input limit rate 1048576 mbytes / second
  Error: wrong rate format
  add filter input limit rate 1048576 mbytes / second
                   ^^^^^^^^^^^^^^^^^^^^^^^^^

Extend the parser to support it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---

I can't help thinking that it ought to be possible to fold the two

  limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]

rules into one.  However, my attempts to get the scanner to tokenize
"bytes/second" as "bytes" "/" "second" (for example) failed.

 src/parser_bison.y           | 58 +++++++++++++++++++++++++++++++-----
 tests/py/any/limit.t         |  5 ++++
 tests/py/any/limit.t.json    | 39 ++++++++++++++++++++++++
 tests/py/any/limit.t.payload | 13 ++++++++
 4 files changed, 108 insertions(+), 7 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c25af6ba114a..4a41e9e3a293 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -689,7 +689,7 @@ int nft_lex(void *, void *, void *);
 %type <val>			level_type log_flags log_flags_tcp log_flag_tcp
 %type <stmt>			limit_stmt quota_stmt connlimit_stmt
 %destructor { stmt_free($$); }	limit_stmt quota_stmt connlimit_stmt
-%type <val>			limit_burst_pkts limit_burst_bytes limit_mode time_unit quota_mode
+%type <val>			limit_burst_pkts limit_burst_bytes limit_mode limit_bytes time_unit quota_mode
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -3184,6 +3184,21 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts	close_s
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
 			}
+			|	LIMIT	RATE	limit_mode	limit_bytes SLASH time_unit	limit_burst_bytes	close_scope_limit
+			{
+				if ($7 == 0) {
+					erec_queue(error(&@7, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
+
+				$$ = limit_stmt_alloc(&@$);
+				$$->limit.rate	= $4;
+				$$->limit.unit	= $6;
+				$$->limit.burst	= $7;
+				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
+				$$->limit.flags = $3;
+			}
 			|	LIMIT	NAME	stmt_expr	close_scope_limit
 			{
 				$$ = objref_stmt_alloc(&@$);
@@ -3251,19 +3266,22 @@ limit_burst_pkts	:	/* empty */			{ $$ = 5; }
 			;
 
 limit_burst_bytes	:	/* empty */			{ $$ = 5; }
-			|	BURST	NUM	BYTES		{ $$ = $2; }
-			|	BURST	NUM	STRING
+			|	BURST	limit_bytes		{ $$ = $2; }
+			;
+
+limit_bytes		:	NUM	BYTES		{ $$ = $1; }
+			|	NUM	STRING
 			{
 				struct error_record *erec;
 				uint64_t rate;
 
-				erec = data_unit_parse(&@$, $3, &rate);
-				xfree($3);
+				erec = data_unit_parse(&@$, $2, &rate);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
 				}
-				$$ = $2 * rate;
+				$$ = $1 * rate;
 			}
 			;
 
@@ -4317,7 +4335,22 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 				$$->limit.burst = $6;
 				$$->limit.type  = NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
-                        }
+			}
+			|	LIMIT	RATE	limit_mode	limit_bytes SLASH time_unit	limit_burst_bytes	close_scope_limit
+			{
+				if ($7 == 0) {
+					erec_queue(error(&@7, "limit burst must be > 0"),
+						   state->msgs);
+					YYERROR;
+				}
+
+				$$ = limit_stmt_alloc(&@$);
+				$$->limit.rate	= $4;
+				$$->limit.unit	= $6;
+				$$->limit.burst	= $7;
+				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
+				$$->limit.flags	= $3;
+			}
 			|	CT	COUNT	NUM	close_scope_ct
 			{
 				$$ = connlimit_stmt_alloc(&@$);
@@ -4581,6 +4614,17 @@ limit_config		:	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 				limit->type	= NFT_LIMIT_PKT_BYTES;
 				limit->flags	= $2;
 			}
+			|	RATE	limit_mode	limit_bytes SLASH time_unit	limit_burst_bytes
+			{
+				struct limit *limit;
+
+				limit = &$<obj>0->limit;
+				limit->rate	= $3;
+				limit->unit	= $5;
+				limit->burst	= $6;
+				limit->type	= NFT_LIMIT_PKT_BYTES;
+				limit->flags	= $2;
+			}
 			;
 
 limit_obj		:	/* empty */
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index ef7f93133297..b4b4e5296088 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -24,6 +24,11 @@ limit rate 10230 mbytes/second;ok
 limit rate 1023000 mbytes/second;ok
 limit rate 512 kbytes/second burst 5 packets;fail
 
+limit rate 1 bytes / second;ok;limit rate 1 bytes/second
+limit rate 1 kbytes / second;ok;limit rate 1 kbytes/second
+limit rate 1 mbytes / second;ok;limit rate 1 mbytes/second
+limit rate 1 gbytes / second;fail
+
 limit rate 1025 bytes/second burst 512 bytes;ok
 limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
diff --git a/tests/py/any/limit.t.json b/tests/py/any/limit.t.json
index 8bab7e3d79b4..b41ae60a3bd6 100644
--- a/tests/py/any/limit.t.json
+++ b/tests/py/any/limit.t.json
@@ -125,6 +125,45 @@
     }
 ]
 
+# limit rate 1 bytes / second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "bytes"
+        }
+    }
+]
+
+# limit rate 1 kbytes / second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate 1 mbytes / second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
 # limit rate 1025 bytes/second burst 512 bytes
 [
     {
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index dc6cea9b2846..3bd85f4ebf45 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -46,6 +46,19 @@ ip test-ip4 output
 ip test-ip4 output
   [ limit rate 1072693248000/second burst 5 type bytes flags 0x0 ]
 
+# limit rate 1 bytes / second
+ip
+  [ limit rate 1/second burst 5 type bytes flags 0x0 ]
+
+# limit rate 1 kbytes / second
+ip
+  [ limit rate 1024/second burst 5 type bytes flags 0x0 ]
+
+# limit rate 1 mbytes / second
+ip
+  [ limit rate 1048576/second burst 5 type bytes flags 0x0 ]
+
+
 # limit rate 1025 bytes/second burst 512 bytes
 ip test-ip4 output
   [ limit rate 1025/second burst 512 type bytes flags 0x0 ]
-- 
2.33.0

