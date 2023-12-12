Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E425CF
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 01:23:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rCyyo-0006dG-Lg; Tue, 12 Dec 2023 10:23:06 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: fix ct scope underflow if ct helper section is duplicated
Date: Tue, 12 Dec 2023 10:22:58 +0100
Message-ID: <20231212092301.24582-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

table inet filter {
	ct helper sip-5060u {
		type "sip" protocol udp
		l3proto ip
	}5060t {
		type "sip" protocol tcp
		l3pownerip
	}

Will close the 'ct' scope twice, it has to be closed AFTER the separator
has been parsed.

While not strictly needed, also error out if the protocol is already
given, this provides a better error description.

Also make sure we release the string in all error branches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                | 15 +++++++++++----
 .../bogons/nft-f/ct_helper_yystate_underflow      | 14 ++++++++++++++
 2 files changed, 25 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/ct_helper_yystate_underflow

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 70acfc5754fa..91c4d263dc73 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1971,7 +1971,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_helper_block     '}' close_scope_ct stmt_separator
+			|	table_block	CT	HELPER	obj_identifier  obj_block_alloc '{'     ct_helper_block     '}' stmt_separator close_scope_ct
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_HELPER;
@@ -1980,7 +1980,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$5->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	TIMEOUT obj_identifier obj_block_alloc '{'	ct_timeout_block	'}' close_scope_ct stmt_separator
+			|	table_block	CT	TIMEOUT obj_identifier obj_block_alloc '{'	ct_timeout_block	'}' stmt_separator close_scope_ct
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_TIMEOUT;
@@ -1989,7 +1989,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$5->list, &$1->objs);
 				$$ = $1;
 			}
-			|	table_block	CT	EXPECTATION obj_identifier obj_block_alloc '{'	ct_expect_block	'}' close_scope_ct stmt_separator
+			|	table_block	CT	EXPECTATION obj_identifier obj_block_alloc '{'	ct_expect_block	'}' stmt_separator close_scope_ct
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_EXPECT;
@@ -4826,16 +4826,23 @@ ct_l4protoname		:	TCP	close_scope_tcp	{ $$ = IPPROTO_TCP; }
 			|	UDP	close_scope_udp	{ $$ = IPPROTO_UDP; }
 			;
 
-ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator	close_scope_type
+ct_helper_config	:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator	close_scope_type
 			{
 				struct ct_helper *ct;
 				int ret;
 
 				ct = &$<obj>0->ct_helper;
 
+				if (ct->l4proto) {
+					erec_queue(error(&@2, "You can only specify this once. This statement is already set for %s.", ct->name), state->msgs);
+					free_const($2);
+					YYERROR;
+				}
+
 				ret = snprintf(ct->name, sizeof(ct->name), "%s", $2);
 				if (ret <= 0 || ret >= (int)sizeof(ct->name)) {
 					erec_queue(error(&@2, "invalid name '%s', max length is %u\n", $2, (int)sizeof(ct->name)), state->msgs);
+					free_const($2);
 					YYERROR;
 				}
 				free_const($2);
diff --git a/tests/shell/testcases/bogons/nft-f/ct_helper_yystate_underflow b/tests/shell/testcases/bogons/nft-f/ct_helper_yystate_underflow
new file mode 100644
index 000000000000..18eb25ebcd48
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/ct_helper_yystate_underflow
@@ -0,0 +1,14 @@
+table inet filter {
+	ct helper sip-5060u {
+		type "sip" protocol udp
+		l3proto ip
+	}5060t {
+		type "sip" protocol tcp
+		l3pownerip
+	}
+
+	chain input {
+		type filtol/dev/stdinok input priority f)lser; policy accept;
+		ct helper set ip protocol . th dport map { udp . 1-20000 : "si60u", tcp . 10000-20000 : "sip-5060t" }
+	}
+}
-- 
2.41.0

