Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32819A7
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 03:56:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rAU2B-0007uR-Dx; Tue, 05 Dec 2023 12:56:15 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM + length field
Date: Tue,  5 Dec 2023 12:56:08 +0100
Message-ID: <20231205115610.19791-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

  tcp option 254 length ge 4

... will segfault.
The crash bug is that tcpopt_expr_alloc() can return NULL if we cannot
find a suitable template for the requested kind + field combination,
so add the needed error handling in the bison parser.

However, we can handle this.  NOP and EOL have templates, all other
options (known or unknown) must also have a length field.

So also add a fallback template to handle both kind and length, even
if only a numeric option is given that nft doesn't recognize.

Don't bother with output, above will be printed via raw syntax, i.e.
tcp option @254,8,8 >= 4.

Fixes: 24d8da308342 ("tcpopt: allow to check for presence of any tcp option")
Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: MUST bump exthdr.offset, else this continues to check for 'kind',
 even if 'length' was asked for.
 Also fix the dump file, it was not correct (254,0,8 instead of 254,8,8).

 src/parser_bison.y                            |  4 ++
 src/tcpopt.c                                  | 28 +++++++++----
 .../packetpath/dumps/tcp_options.nft          | 14 +++++++
 tests/shell/testcases/packetpath/tcp_options  | 39 +++++++++++++++++++
 4 files changed, 78 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/tcp_options.nft
 create mode 100755 tests/shell/testcases/packetpath/tcp_options

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ee7e9e14c1f2..1a3d64f794cb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5828,6 +5828,10 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			|	TCP	OPTION	tcp_hdr_option_kind_and_field
 			{
 				$$ = tcpopt_expr_alloc(&@$, $3.kind, $3.field);
+				if ($$ == NULL) {
+					erec_queue(error(&@1, "Could not find a tcp option template"), state->msgs);
+					YYERROR;
+				}
 			}
 			|	TCP	OPTION	AT	close_scope_at	tcp_hdr_option_type	COMMA	NUM	COMMA	NUM
 			{
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 3fcb2731ae73..93b08c8cc0f2 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -118,6 +118,13 @@ static const struct exthdr_desc tcpopt_mptcp = {
 		[TCPOPT_MPTCP_SUBTYPE]  = PHT("subtype", 16, 4),
 	},
 };
+
+static const struct exthdr_desc tcpopt_fallback = {
+	.templates	= {
+		[TCPOPT_COMMON_KIND]	= PHT("kind",   0, 8),
+		[TCPOPT_COMMON_LENGTH]	= PHT("length", 8, 8),
+	},
+};
 #undef PHT
 
 const struct exthdr_desc *tcpopt_protocols[] = {
@@ -182,19 +189,24 @@ struct expr *tcpopt_expr_alloc(const struct location *loc,
 		desc = tcpopt_protocols[kind];
 
 	if (!desc) {
-		if (field != TCPOPT_COMMON_KIND || kind > 255)
+		if (kind > 255)
 			return NULL;
 
+		switch (field) {
+		case TCPOPT_COMMON_KIND:
+		case TCPOPT_COMMON_LENGTH:
+			break;
+		default:
+			return NULL;
+		}
+
 		expr = expr_alloc(loc, EXPR_EXTHDR, &integer_type,
 				  BYTEORDER_BIG_ENDIAN, 8);
 
-		desc = tcpopt_protocols[TCPOPT_NOP];
+		desc = &tcpopt_fallback;
 		tmpl = &desc->templates[field];
-		expr->exthdr.desc   = desc;
-		expr->exthdr.tmpl   = tmpl;
-		expr->exthdr.op = NFT_EXTHDR_OP_TCPOPT;
 		expr->exthdr.raw_type = kind;
-		return expr;
+		goto out_finalize;
 	}
 
 	tmpl = &desc->templates[field];
@@ -203,10 +215,12 @@ struct expr *tcpopt_expr_alloc(const struct location *loc,
 
 	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
 			  BYTEORDER_BIG_ENDIAN, tmpl->len);
+
+	expr->exthdr.raw_type = desc->type;
+out_finalize:
 	expr->exthdr.desc   = desc;
 	expr->exthdr.tmpl   = tmpl;
 	expr->exthdr.op     = NFT_EXTHDR_OP_TCPOPT;
-	expr->exthdr.raw_type = desc->type;
 	expr->exthdr.offset = tmpl->offset;
 
 	return expr;
diff --git a/tests/shell/testcases/packetpath/dumps/tcp_options.nft b/tests/shell/testcases/packetpath/dumps/tcp_options.nft
new file mode 100644
index 000000000000..03e50a56e8c9
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/tcp_options.nft
@@ -0,0 +1,14 @@
+table inet t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		tcp dport != 22345 accept
+		tcp flags syn / fin,syn,rst,ack tcp option @254,8,8 >= 4 counter packets 0 bytes 0 drop
+		tcp flags syn / fin,syn,rst,ack tcp option fastopen length >= 2 reset tcp option fastopen counter packets 0 bytes 0
+		tcp flags syn / fin,syn,rst,ack tcp option sack-perm missing counter packets 0 bytes 0 drop
+		tcp flags syn / fin,syn,rst,ack tcp option sack-perm exists counter packets 1 bytes 60
+		tcp flags syn / fin,syn,rst,ack tcp option maxseg size > 1400 counter packets 1 bytes 60
+		tcp flags syn / fin,syn,rst,ack tcp option nop missing counter packets 0 bytes 0
+		tcp flags syn / fin,syn,rst,ack tcp option nop exists counter packets 1 bytes 60
+		tcp flags syn / fin,syn,rst,ack drop
+	}
+}
diff --git a/tests/shell/testcases/packetpath/tcp_options b/tests/shell/testcases/packetpath/tcp_options
new file mode 100755
index 000000000000..0f1ca2644655
--- /dev/null
+++ b/tests/shell/testcases/packetpath/tcp_options
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+have_socat="no"
+socat -h > /dev/null && have_socat="yes"
+
+ip link set lo up
+
+$NFT -f /dev/stdin <<EOF
+table inet t {
+	chain c {
+		type filter hook output priority 0;
+		tcp dport != 22345 accept
+		tcp flags syn / fin,syn,rst,ack tcp option 254  length ge 4 counter drop
+		tcp flags syn / fin,syn,rst,ack tcp option fastopen length ge 2 reset tcp option fastopen counter
+		tcp flags syn / fin,syn,rst,ack tcp option sack-perm missing counter drop
+		tcp flags syn / fin,syn,rst,ack tcp option sack-perm exists counter
+		tcp flags syn / fin,syn,rst,ack tcp option maxseg size gt 1400 counter
+		tcp flags syn / fin,syn,rst,ack tcp option nop missing counter
+		tcp flags syn / fin,syn,rst,ack tcp option nop exists counter
+		tcp flags syn / fin,syn,rst,ack drop
+	}
+}
+EOF
+
+if [ $? -ne 0 ]; then
+	exit 1
+fi
+
+if [ $have_socat != "yes" ]; then
+	echo "Ran partial test, socat not available (skipped)"
+	exit 77
+fi
+
+# This will fail (drop in output -> connect fails with eperm)
+socat -t 3 -u STDIN TCP:127.0.0.1:22345,connect-timeout=1 < /dev/null > /dev/null
+
+# Indicate success, dump file has incremented packet counter where its
+# expected to match.
+exit 0
-- 
2.41.0

