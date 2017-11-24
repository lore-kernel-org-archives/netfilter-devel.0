From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] parser_bison: no need for 'name' token for meters
Date: Fri, 24 Nov 2017 14:29:00 +0100
Message-ID: <20171124132900.28301-2-pablo@netfilter.org>
References: <20171124132900.28301-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752058AbdKXN3J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 08:29:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF940392E01
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA6C0DA86D
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81953DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:05 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 65D3F403DF98
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 14:29:05 +0100 (CET)
In-Reply-To: <20171124132900.28301-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rework grammar to skip the 'name' token after 'meter' for named meters.
For consistency with sets and maps in terms of syntax.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                                 | 36 +++++++++++++++-------
 tests/py/ip/flowtable.t                            |  2 +-
 tests/py/ip/flowtable.t.payload                    |  2 +-
 tests/py/ip6/flowtable.t                           |  4 +--
 tests/py/ip6/flowtable.t.payload                   |  4 +--
 .../testcases/sets/0022type_selective_flush_0      |  4 +--
 6 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d2673173bd27..c7b9f71e3be4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -557,8 +557,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
-%type <stmt>			meter_stmt meter_stmt_alloc
-%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc
+%type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
+%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr
@@ -2482,33 +2482,30 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
 			;
 
-meter_stmt		:	meter_stmt_alloc		meter_stmt_opts	'{' meter_key_expr stmt '}'
+meter_stmt		:	flow_stmt_legacy_alloc		flow_stmt_opts	'{' meter_key_expr stmt '}'
 			{
 				$1->meter.key  = $4;
 				$1->meter.stmt = $5;
 				$$->location  = @$;
 				$$ = $1;
 			}
+			|	meter_stmt_alloc		{ $$ = $1; }
 			;
 
-meter_stmt_alloc	:	FLOW
-			{
-				$$ = meter_stmt_alloc(&@$);
-			}
-			|	METER
+flow_stmt_legacy_alloc	:	FLOW
 			{
 				$$ = meter_stmt_alloc(&@$);
 			}
 			;
 
-meter_stmt_opts		:	meter_stmt_opt
+flow_stmt_opts		:	flow_stmt_opt
 			{
 				$<stmt>$	= $<stmt>0;
 			}
-			|	meter_stmt_opts		meter_stmt_opt
+			|	flow_stmt_opts		flow_stmt_opt
 			;
 
-meter_stmt_opt		:	TABLE			identifier
+flow_stmt_opt		:	TABLE			identifier
 			{
 				$<stmt>0->meter.name = $2;
 			}
@@ -2518,6 +2515,23 @@ meter_stmt_opt		:	TABLE			identifier
 			}
 			;
 
+meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
+			{
+				$$ = meter_stmt_alloc(&@$);
+				$$->meter.name = $2;
+				$$->meter.key  = $4;
+				$$->meter.stmt = $5;
+				$$->location  = @$;
+			}
+			|	METER	'{' meter_key_expr stmt '}'
+			{
+				$$ = meter_stmt_alloc(&@$);
+				$$->meter.key  = $3;
+				$$->meter.stmt = $4;
+				$$->location  = @$;
+			}
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
index 7eaf5731ea22..4427fab88eb8 100644
--- a/tests/py/ip/flowtable.t
+++ b/tests/py/ip/flowtable.t
@@ -2,4 +2,4 @@
 
 *ip;test-ip;input
 
-meter name xyz { ip saddr timeout 30s counter};ok
+meter xyz { ip saddr timeout 30s counter};ok
diff --git a/tests/py/ip/flowtable.t.payload b/tests/py/ip/flowtable.t.payload
index 4dbd03d01926..34a584994b64 100644
--- a/tests/py/ip/flowtable.t.payload
+++ b/tests/py/ip/flowtable.t.payload
@@ -1,4 +1,4 @@
-# meter name xyz { ip saddr timeout 30s counter}
+# meter xyz { ip saddr timeout 30s counter}
 xyz test-ip 31
 xyz test-ip 0
 ip test-ip input 
diff --git a/tests/py/ip6/flowtable.t b/tests/py/ip6/flowtable.t
index 7a53f31aa67e..5c048935d726 100644
--- a/tests/py/ip6/flowtable.t
+++ b/tests/py/ip6/flowtable.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;input
 
-meter name acct_out { meta iif . ip6 saddr timeout 600s counter };ok;meter name acct_out { iif . ip6 saddr timeout 10m counter}
-meter name acct_out { ip6 saddr . meta iif timeout 600s counter };ok;meter name acct_out { ip6 saddr . iif timeout 10m counter}
+meter acct_out { meta iif . ip6 saddr timeout 600s counter };ok;meter acct_out { iif . ip6 saddr timeout 10m counter}
+meter acct_out { ip6 saddr . meta iif timeout 600s counter };ok;meter acct_out { ip6 saddr . iif timeout 10m counter}
diff --git a/tests/py/ip6/flowtable.t.payload b/tests/py/ip6/flowtable.t.payload
index cf2de733ca42..a3f71b1304dc 100644
--- a/tests/py/ip6/flowtable.t.payload
+++ b/tests/py/ip6/flowtable.t.payload
@@ -1,4 +1,4 @@
-# meter name acct_out { meta iif . ip6 saddr timeout 600s counter }
+# meter acct_out { meta iif . ip6 saddr timeout 600s counter }
 acct_out test-ip6 31
 acct_out test-ip6 0
 ip6 test-ip6 input
@@ -6,7 +6,7 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 9 ]
   [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
 
-# meter name acct_out { ip6 saddr . meta iif timeout 600s counter }
+# meter acct_out { ip6 saddr . meta iif timeout 600s counter }
 acct_out test-ip6 31
 acct_out test-ip6 0
 ip6 test-ip6 input
diff --git a/tests/shell/testcases/sets/0022type_selective_flush_0 b/tests/shell/testcases/sets/0022type_selective_flush_0
index 87a4c7bc4393..659bf70c05bf 100755
--- a/tests/shell/testcases/sets/0022type_selective_flush_0
+++ b/tests/shell/testcases/sets/0022type_selective_flush_0
@@ -16,7 +16,7 @@ add table t
 add chain t c
 add set t s {type ipv4_addr;}
 add map t m {type ipv4_addr : inet_service;}
-add rule t c tcp dport 80 meter name f {ip saddr limit rate 10/second}
+add rule t c tcp dport 80 meter f {ip saddr limit rate 10/second}
 " >$tmpfile
 
 $NFT -f $tmpfile
@@ -26,7 +26,7 @@ $NFT -f $tmpfile
 declare -a cmds=(
 		"flush set t m" "flush set t f"
 		"flush map t s" "flush map t f"
-		"flush meter name t s" "flush meter name t m"
+		"flush meter t s" "flush meter t m"
 		)
 
 for i in "${cmds[@]}"
-- 
2.11.0

