From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: revisit tcp options support
Date: Wed, 22 Feb 2017 14:01:43 +0100
Message-ID: <1487768503-17023-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754269AbdBVNCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2017 08:02:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 072991395D9
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2017 14:02:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2466DA725
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2017 14:02:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEC3EDA39D
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2017 14:01:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rework syntax, add tokens so we can extend the grammar more easily.
This has triggered several syntax changes with regards to the original
patch, specifically:

	tcp option sack0 left 1

There is no space between sack and the block number anymore, no more
offset field, now they are a single field. Just like we do with rt, rt0
and rt2. This simplifies our grammar and that is good since it makes our
life easier when extending it later on to accomodate new features.

I have also renamed sack_permitted to sack-permitted. I couldn't find
any option using underscore so far, so let's keep it consistent with
what we have.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Florian, @Manuel: I would appreciate an explicit review ack on this patch.
 Sorry I couldn't come any sooner with feedback on this to you. I'm going
 to release 0.8 asap and I would like this comes out with the reviewed syntax.

 doc/nft.xml                         |  39 +++++++---
 include/tcpopt.h                    |  32 +++++++-
 src/exthdr.c                        |   2 +-
 src/parser_bison.y                  |  81 ++++++++++++--------
 src/scanner.l                       |  19 +++++
 src/tcpopt.c                        | 147 ++++++++++++++----------------------
 tests/py/inet/tcpopt.t              |  21 +++---
 tests/py/inet/tcpopt.t.payload.inet |  20 ++---
 tests/py/ip/tcpopt.t                |  20 ++---
 tests/py/ip/tcpopt.t.payload        |  20 ++---
 tests/py/ip6/tcpopt.t               |  20 ++---
 tests/py/ip6/tcpopt.t.payload       |  20 ++---
 12 files changed, 243 insertions(+), 198 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index ed978594ae13..3b838112b470 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2525,11 +2525,14 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 					<arg>noop</arg>
 					<arg>maxseg</arg>
 					<arg>window</arg>
-					<arg>sack_permitted</arg>
+					<arg>sack-permitted</arg>
 					<arg>sack</arg>
+					<arg>sack0</arg>
+					<arg>sack1</arg>
+					<arg>sack2</arg>
+					<arg>sack3</arg>
 					<arg>timestamp</arg>
 				</group>
-                <arg><replaceable>offset</replaceable></arg>
 				<arg choice="none"><replaceable>tcp_option_field</replaceable></arg>
 			</cmdsynopsis>
 			<para>
@@ -2604,13 +2607,33 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 								<entry>kind, length, count</entry>
 							</row>
 							<row>
-								<entry>sack_permitted</entry>
+								<entry>sack-permitted</entry>
 								<entry>TCP SACK permitted</entry>
 								<entry>kind, length</entry>
 							</row>
 							<row>
 								<entry>sack</entry>
-								<entry>TCP Selective Acknowledgement</entry>
+								<entry>TCP Selective Acknowledgement (alias of block 0)</entry>
+								<entry>kind, length, left, right</entry>
+							</row>
+							<row>
+								<entry>sack0</entry>
+								<entry>TCP Selective Acknowledgement (block 0)</entry>
+								<entry>kind, length, left, right</entry>
+							</row>
+							<row>
+								<entry>sack1</entry>
+								<entry>TCP Selective Acknowledgement (block 1)</entry>
+								<entry>kind, length, left, right</entry>
+							</row>
+							<row>
+								<entry>sack2</entry>
+								<entry>TCP Selective Acknowledgement (block 2)</entry>
+								<entry>kind, length, left, right</entry>
+							</row>
+							<row>
+								<entry>sack3</entry>
+								<entry>TCP Selective Acknowledgement (block 3)</entry>
 								<entry>kind, length, left, right</entry>
 							</row>
 							<row>
@@ -2624,16 +2647,10 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 			</para>
 
 			<para>
-				The <replaceable>offset</replaceable> is only used for the SACK TCP option fields <command>left</command> and <command>right</command>.
-				For all non-SACK TCP options it is always zero.
-				<replaceable>Offsets</replaceable> which equals to zero can be omitted.
-			</para>
-
-			<para>
 				<example>
 					<title>finding TCP options</title>
 					<programlisting>
-filter input tcp option sack_permitted kind 1 counter
+filter input tcp option sack-permitted kind 1 counter
 					</programlisting>
 				</example>
 				<example>
diff --git a/include/tcpopt.h b/include/tcpopt.h
index 5b990083c437..f43a7eb703fe 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -5,9 +5,7 @@
 #include <exthdr.h>
 
 extern struct expr *tcpopt_expr_alloc(const struct location *loc,
-				      const char *option_str,
-				      const unsigned int option_num,
-				      const char *optioni_field);
+				      uint8_t type, uint8_t field);
 
 extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len);
@@ -15,6 +13,34 @@ extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
 extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
 
+enum tcpopt_hdr_types {
+	TCPOPTHDR_INVALID,
+	TCPOPTHDR_EOL,
+	TCPOPTHDR_NOOP,
+	TCPOPTHDR_MAXSEG,
+	TCPOPTHDR_WINDOW,
+	TCPOPTHDR_SACK_PERMITTED,
+	TCPOPTHDR_SACK0,
+	TCPOPTHDR_SACK1,
+	TCPOPTHDR_SACK2,
+	TCPOPTHDR_SACK3,
+	TCPOPTHDR_TIMESTAMP,
+	TCPOPTHDR_ECHO,
+	TCPOPTHDR_ECHO_REPLY,
+};
+
+enum tcpopt_hdr_fields {
+	TCPOPTHDR_FIELD_INVALID,
+	TCPOPTHDR_FIELD_KIND,
+	TCPOPTHDR_FIELD_LENGTH,
+	TCPOPTHDR_FIELD_SIZE,
+	TCPOPTHDR_FIELD_COUNT,
+	TCPOPTHDR_FIELD_LEFT,
+	TCPOPTHDR_FIELD_RIGHT,
+	TCPOPTHDR_FIELD_TSVAL,
+	TCPOPTHDR_FIELD_TSECR,
+};
+
 extern const struct exthdr_desc tcpopt_eol;
 extern const struct exthdr_desc tcpopt_nop;
 extern const struct exthdr_desc tcpopt_maxseg;
diff --git a/src/exthdr.c b/src/exthdr.c
index cfc6bb604d2c..ddda1b870310 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -33,7 +33,7 @@ static void exthdr_expr_print(const struct expr *expr)
 		char buf[3] = {0};
 
 		if (offset)
-			snprintf(buf, sizeof buf, " %d", offset);
+			snprintf(buf, sizeof buf, "%d", offset);
 		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
 					     expr->exthdr.tmpl->token);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b295bfde2ed3..08acbd40e6d3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -309,6 +309,23 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token WINDOW			"window"
 %token URGPTR			"urgptr"
 %token OPTION			"option"
+%token ECHO			"echo"
+%token EOL			"eol"
+%token MAXSEG			"maxseg"
+%token NOOP			"noop"
+%token SACK			"sack"
+%token SACK0			"sack0"
+%token SACK1			"sack1"
+%token SACK2			"sack2"
+%token SACK3			"sack3"
+%token SACK_PERMITTED		"sack-permitted"
+%token TIMESTAMP		"timestamp"
+%token KIND			"kind"
+%token COUNT			"count"
+%token LEFT			"left"
+%token RIGHT			"right"
+%token TSVAL			"tsval"
+%token TSECR			"tsecr"
 
 %token DCCP			"dccp"
 
@@ -429,8 +446,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token NOTRACK			"notrack"
 
-%type <string>			identifier type_identifier string comment_spec tcp_option_name tcp_option_field
-%destructor { xfree($$); }	identifier type_identifier string comment_spec tcp_option_name tcp_option_field
+%type <string>			identifier type_identifier string comment_spec
+%destructor { xfree($$); }	identifier type_identifier string comment_spec
 
 %type <val>			time_spec quota_used
 
@@ -601,9 +618,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	mh_hdr_expr
 %type <val>			mh_hdr_field
 
-%type <expr>			tcp_hdr_optexpr
-%destructor { expr_free($$); }	tcp_hdr_optexpr
-
 %type <expr>			meta_expr
 %destructor { expr_free($$); }	meta_expr
 %type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type
@@ -633,6 +647,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			tcp_hdr_expr
 %destructor { expr_free($$); }	tcp_hdr_expr
 %type <val>			tcp_hdr_field
+%type <val>			tcp_hdr_option_type tcp_hdr_option_field
 
 %%
 
@@ -3196,6 +3211,10 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_tcp, $2);
 			}
+			|	TCP	OPTION	tcp_hdr_option_type tcp_hdr_option_field
+			{
+				$$ = tcpopt_expr_alloc(&@$, $3, $4);
+			}
 			;
 
 tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
@@ -3210,6 +3229,30 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 			|	URGPTR		{ $$ = TCPHDR_URGPTR; }
 			;
 
+tcp_hdr_option_type	:	EOL		{ $$ = TCPOPTHDR_EOL; }
+			|	NOOP		{ $$ = TCPOPTHDR_NOOP; }
+			|	MAXSEG		{ $$ = TCPOPTHDR_MAXSEG; }
+			|	WINDOW		{ $$ = TCPOPTHDR_WINDOW; }
+			|	SACK_PERMITTED	{ $$ = TCPOPTHDR_SACK_PERMITTED; }
+			|	SACK		{ $$ = TCPOPTHDR_SACK0; }
+			|	SACK0		{ $$ = TCPOPTHDR_SACK0; }
+			|	SACK1		{ $$ = TCPOPTHDR_SACK1; }
+			|	SACK2		{ $$ = TCPOPTHDR_SACK2; }
+			|	SACK3		{ $$ = TCPOPTHDR_SACK3; }
+			|	ECHO		{ $$ = TCPOPTHDR_ECHO; }
+			|	TIMESTAMP	{ $$ = TCPOPTHDR_TIMESTAMP; }
+			;
+
+tcp_hdr_option_field	:	KIND		{ $$ = TCPOPTHDR_FIELD_KIND; }
+			|	LENGTH		{ $$ = TCPOPTHDR_FIELD_LENGTH; }
+			|	SIZE		{ $$ = TCPOPTHDR_FIELD_SIZE; }
+			|	COUNT		{ $$ = TCPOPTHDR_FIELD_COUNT; }
+			|	LEFT		{ $$ = TCPOPTHDR_FIELD_LEFT; }
+			|	RIGHT		{ $$ = TCPOPTHDR_FIELD_RIGHT; }
+			|	TSVAL		{ $$ = TCPOPTHDR_FIELD_TSVAL; }
+			|	TSECR		{ $$ = TCPOPTHDR_FIELD_TSECR; }
+			;
+
 dccp_hdr_expr		:	DCCP	dccp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
@@ -3240,7 +3283,6 @@ exthdr_expr		:	hbh_hdr_expr
 			|	frag_hdr_expr
 			|	dst_hdr_expr
 			|	mh_hdr_expr
-			|	tcp_hdr_optexpr
 			;
 
 hbh_hdr_expr		:	HBH	hbh_hdr_field
@@ -3323,31 +3365,4 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
-tcp_option_name		:	STRING		{ $$ = $1; }
-			|	WINDOW		{ $$ = xstrdup("window"); }
-			;
-
-tcp_option_field	:	STRING		{ $$ = $1; }
-			|	LENGTH		{ $$ = xstrdup("length"); }
-			|	SIZE		{ $$ = xstrdup("size"); }
-			;
-
-tcp_hdr_optexpr		:	TCP	OPTION	tcp_option_name		tcp_option_field
-			{
-				$$ = tcpopt_expr_alloc(&@$, $3, 0, $4);
-			}
-			|	TCP	OPTION	STRING	NUM	tcp_option_field
-			{
-				if (strcmp($3, "sack")) {
-					erec_queue(error(&@2, "tcp: number (%d) can only be used with sack option", $4), state->msgs);
-					YYERROR;
-				}
-
-				if ($4 > 3) {
-					erec_queue(error(&@2, "tcp: option block (%d) too large (0-3)", $4), state->msgs);
-					YYERROR;
-				}
-				$$ = tcpopt_expr_alloc(&@$, $3, $4, $5);
-			}
-			;
 %%
diff --git a/src/scanner.l b/src/scanner.l
index 922d8ec82fc1..4a3ce41937ea 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -375,6 +375,25 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "protocol"		{ return PROTOCOL; }
 "checksum"		{ return CHECKSUM; }
 
+"echo"			{ return ECHO; }
+"eol"			{ return EOL; }
+"maxseg"		{ return MAXSEG; }
+"noop"			{ return NOOP; }
+"sack"			{ return SACK; }
+"sack0"			{ return SACK0; }
+"sack1"			{ return SACK1; }
+"sack2"			{ return SACK2; }
+"sack3"			{ return SACK3; }
+"sack-permitted"	{ return SACK_PERMITTED; }
+"timestamp"		{ return TIMESTAMP; }
+
+"kind"			{ return KIND; }
+"count"			{ return COUNT; }
+"left"			{ return LEFT; }
+"right"			{ return RIGHT; }
+"tsval"			{ return TSVAL; }
+"tsecr"			{ return TSECR; }
+
 "icmp"			{ return ICMP; }
 "code"			{ return CODE; }
 "sequence"		{ return SEQUENCE; }
diff --git a/src/tcpopt.c b/src/tcpopt.c
index e6f92bc67cd3..f861214117a1 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -12,48 +12,6 @@
 #include <expression.h>
 #include <tcpopt.h>
 
-/* We do not need to export these enums, because the tcpopts are parsed at
- * runtime and not by bison.
- */
-enum tcpopt_eol_hdr_fields {
-	TCPOPT_EOLHDR_KIND,
-};
-
-enum tcpopt_nop_hdr_fields {
-	TCPOPT_NOPHDR_KIND,
-};
-
-enum tcpopt_maxseg_hdr_fields {
-	TCPOPT_MAXSEGHDR_KIND,
-	TCPOPT_MAXSEGHDR_LENGTH,
-	TCPOPT_MAXSEGHDR_SIZE,
-};
-
-enum tcpopt_window_hdr_fields {
-	TCPOPT_WINDOWHDR_KIND,
-	TCPOPT_WINDOWHDR_LENGTH,
-	TCPOPT_WINDOWHDR_COUNT,
-};
-
-enum tcpopt_sack_permitted_hdr_fields {
-	TCPOPT_SACKPERMHDR_KIND,
-	TCPOPT_SACKPERMHDR_LENGTH,
-};
-
-enum tcpopt_sack_hdr_fields {
-	TCPOPT_SACKHDR_KIND,
-	TCPOPT_SACKHDR_LENGTH,
-	TCPOPT_SACKHDR_LEFT,
-	TCPOPT_SACKHDR_RIGHT,
-};
-
-enum tcpopt_timestamp_hdr_fields {
-	TCPOPT_TIMESTAMPSHDR_KIND,
-	TCPOPT_TIMESTAMPSHDR_LENGTH,
-	TCPOPT_TIMESTAMPSHDR_TSVAL,
-	TCPOPT_TIMESTAMPSHDR_TSECR,
-};
-
 static const struct proto_hdr_template tcpopt_unknown_template =
 	PROTO_HDR_TEMPLATE("unknown", &invalid_type, BYTEORDER_INVALID, 0, 0);
 
@@ -64,7 +22,7 @@ const struct exthdr_desc tcpopt_eol = {
 	.name		= "eol",
 	.type		= TCPOPT_EOL,
 	.templates	= {
-		[TCPOPT_EOLHDR_KIND]		= PHT("kind",  0,    8),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",  0,    8),
 	},
 };
 
@@ -72,7 +30,7 @@ const struct exthdr_desc tcpopt_nop = {
 	.name		= "noop",
 	.type		= TCPOPT_NOP,
 	.templates	= {
-		[TCPOPT_NOPHDR_KIND]		= PHT("kind",   0,   8),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
 	},
 };
 
@@ -80,9 +38,9 @@ const struct exthdr_desc tcptopt_maxseg = {
 	.name		= "maxseg",
 	.type		= TCPOPT_MAXSEG,
 	.templates	= {
-		[TCPOPT_MAXSEGHDR_KIND]		= PHT("kind",   0,  8),
-		[TCPOPT_MAXSEGHDR_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPT_MAXSEGHDR_SIZE]		= PHT("size",  16, 16),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
+		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPTHDR_FIELD_SIZE]		= PHT("size",  16, 16),
 	},
 };
 
@@ -90,18 +48,18 @@ const struct exthdr_desc tcpopt_window = {
 	.name		= "window",
 	.type		= TCPOPT_WINDOW,
 	.templates	= {
-		[TCPOPT_WINDOWHDR_KIND]		= PHT("kind",   0,  8),
-		[TCPOPT_WINDOWHDR_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPT_WINDOWHDR_COUNT]	= PHT("count", 16,  8),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
+		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPTHDR_FIELD_COUNT]		= PHT("count", 16,  8),
 	},
 };
 
 const struct exthdr_desc tcpopt_sack_permitted = {
-	.name		= "sack_permitted",
+	.name		= "sack-permitted",
 	.type		= TCPOPT_SACK_PERMITTED,
 	.templates	= {
-		[TCPOPT_SACKPERMHDR_KIND]	= PHT("kind",   0, 8),
-		[TCPOPT_SACKPERMHDR_LENGTH]	= PHT("length", 8, 8),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0, 8),
+		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8, 8),
 	},
 };
 
@@ -109,10 +67,10 @@ const struct exthdr_desc tcpopt_sack = {
 	.name		= "sack",
 	.type		= TCPOPT_SACK,
 	.templates	= {
-		[TCPOPT_SACKHDR_KIND]		= PHT("kind",   0,   8),
-		[TCPOPT_SACKHDR_LENGTH]		= PHT("length", 8,   8),
-		[TCPOPT_SACKHDR_LEFT]		= PHT("left",  16,  32),
-		[TCPOPT_SACKHDR_RIGHT]		= PHT("right", 48,  32),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
+		[TCPOPTHDR_FIELD_LENGTH]		= PHT("length", 8,   8),
+		[TCPOPTHDR_FIELD_LEFT]		= PHT("left",  16,  32),
+		[TCPOPTHDR_FIELD_RIGHT]		= PHT("right", 48,  32),
 	},
 };
 
@@ -120,10 +78,10 @@ const struct exthdr_desc tcpopt_timestamp = {
 	.name		= "timestamp",
 	.type		= TCPOPT_TIMESTAMP,
 	.templates	= {
-		[TCPOPT_TIMESTAMPSHDR_KIND]	= PHT("kind",   0,  8),
-		[TCPOPT_TIMESTAMPSHDR_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPT_TIMESTAMPSHDR_TSVAL]	= PHT("tsval",  16, 32),
-		[TCPOPT_TIMESTAMPSHDR_TSECR]	= PHT("tsecr",  48, 32),
+		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,  8),
+		[TCPOPTHDR_FIELD_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPTHDR_FIELD_TSVAL]		= PHT("tsval",  16, 32),
+		[TCPOPTHDR_FIELD_TSECR]		= PHT("tsecr",  48, 32),
 	},
 };
 #undef PHT
@@ -178,46 +136,57 @@ static unsigned int calc_offset_reverse(const struct exthdr_desc *desc,
 	}
 }
 
+static const struct exthdr_desc *tcpopthdr_protocols[] = {
+	[TCPOPTHDR_EOL]			= &tcpopt_eol,
+	[TCPOPTHDR_NOOP]		= &tcpopt_nop,
+	[TCPOPTHDR_MAXSEG]		= &tcptopt_maxseg,
+	[TCPOPTHDR_WINDOW]		= &tcpopt_window,
+	[TCPOPTHDR_SACK_PERMITTED]	= &tcpopt_sack_permitted,
+	[TCPOPTHDR_SACK0]		= &tcpopt_sack,
+	[TCPOPTHDR_SACK1]		= &tcpopt_sack,
+	[TCPOPTHDR_SACK2]		= &tcpopt_sack,
+	[TCPOPTHDR_SACK3]		= &tcpopt_sack,
+	[TCPOPTHDR_ECHO]		= TCPOPT_OBSOLETE,
+	[TCPOPTHDR_ECHO_REPLY]		= TCPOPT_OBSOLETE,
+	[TCPOPTHDR_TIMESTAMP]		= &tcpopt_timestamp,
+};
+
+static uint8_t tcpopt_optnum[] = {
+	[TCPOPTHDR_SACK0]	= 0,
+	[TCPOPTHDR_SACK1]	= 1,
+	[TCPOPTHDR_SACK2]	= 2,
+	[TCPOPTHDR_SACK3]	= 3,
+};
 
-struct expr *tcpopt_expr_alloc(const struct location *loc,
-			       const char *option_str,
-			       const unsigned int option_num,
-			       const char *option_field)
+static uint8_t tcpopt_find_optnum(uint8_t optnum)
 {
-	const struct proto_hdr_template *tmp, *tmpl = &tcpopt_unknown_template;
-	const struct exthdr_desc *desc = NULL;
-	struct expr *expr;
-	unsigned int i, j;
+	if (optnum > TCPOPTHDR_SACK3)
+		return 0;
 
-	for (i = 0; i < array_size(tcpopt_protocols); ++i) {
-		if (tcpopt_protocols[i] == TCPOPT_OBSOLETE)
-			continue;
+	return tcpopt_optnum[optnum];
+}
 
-		if (!tcpopt_protocols[i]->name ||
-		    strcmp(option_str, tcpopt_protocols[i]->name))
-			continue;
+struct expr *tcpopt_expr_alloc(const struct location *loc, uint8_t type,
+			       uint8_t field)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct exthdr_desc *desc;
+	struct expr *expr;
+	uint8_t optnum;
 
-		for (j = 0; j < array_size(tcpopt_protocols[i]->templates); ++j) {
-			tmp = &tcpopt_protocols[i]->templates[j];
-			if (!tmp->token || strcmp(option_field, tmp->token))
-				continue;
+	desc = tcpopthdr_protocols[type];
+	tmpl = &desc->templates[field];
+	if (!tmpl)
+		return NULL;
 
-			desc = tcpopt_protocols[i];
-			tmpl = tmp;
-			goto found;
-		}
-	}
+	optnum = tcpopt_find_optnum(type);
 
-found:
-	/* tmpl still points to tcpopt_unknown_template if nothing was found and
-	 * desc is null
-	 */
 	expr = expr_alloc(loc, &exthdr_expr_ops, tmpl->dtype,
 			  BYTEORDER_BIG_ENDIAN, tmpl->len);
 	expr->exthdr.desc   = desc;
 	expr->exthdr.tmpl   = tmpl;
 	expr->exthdr.op     = NFT_EXTHDR_OP_TCPOPT;
-	expr->exthdr.offset = calc_offset(desc, tmpl, option_num);
+	expr->exthdr.offset = calc_offset(desc, tmpl, optnum);
 
 	return expr;
 }
diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
index 39204fdfc99d..59452b48fce5 100644
--- a/tests/py/inet/tcpopt.t
+++ b/tests/py/inet/tcpopt.t
@@ -10,20 +10,19 @@ tcp option maxseg size 1;ok
 tcp option window kind 1;ok
 tcp option window length 1;ok
 tcp option window count 1;ok
-tcp option sack_permitted kind 1;ok
-tcp option sack_permitted length 1;ok
+tcp option sack-permitted kind 1;ok
+tcp option sack-permitted length 1;ok
 tcp option sack kind 1;ok
 tcp option sack length 1;ok
 tcp option sack left 1;ok
-tcp option sack 0 left 1;ok;tcp option sack left 1
-tcp option sack 1 left 1;ok
-tcp option sack 2 left 1;ok
-tcp option sack 3 left 1;ok
-tcp option sack right 1;ok
-tcp option sack 0 right 1;ok;tcp option sack right 1
-tcp option sack 1 right 1;ok
-tcp option sack 2 right 1;ok
-tcp option sack 3 right 1;ok
+tcp option sack0 left 1;ok;tcp option sack left 1
+tcp option sack1 left 1;ok
+tcp option sack2 left 1;ok
+tcp option sack3 left 1;ok
+tcp option sack0 right 1;ok;tcp option sack right 1
+tcp option sack1 right 1;ok
+tcp option sack2 right 1;ok
+tcp option sack3 right 1;ok
 tcp option timestamp kind 1;ok
 tcp option timestamp length 1;ok
 tcp option timestamp tsval 1;ok
diff --git a/tests/py/inet/tcpopt.t.payload.inet b/tests/py/inet/tcpopt.t.payload.inet
index 1343ae52285d..12deab8c920f 100644
--- a/tests/py/inet/tcpopt.t.payload.inet
+++ b/tests/py/inet/tcpopt.t.payload.inet
@@ -54,14 +54,14 @@ inet test-inet input
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack_permitted kind 1
+# tcp option sack-permitted kind 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack_permitted length 1
+# tcp option sack-permitted length 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -89,28 +89,28 @@ inet test-inet input
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 0 left 1
+# tcp option sack0 left 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 1 left 1
+# tcp option sack1 left 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 2 left 1
+# tcp option sack2 left 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 3 left 1
+# tcp option sack3 left 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -124,28 +124,28 @@ inet test-inet input
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 0 right 1
+# tcp option sack0 right 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 1 right 1
+# tcp option sack1 right 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 2 right 1
+# tcp option sack2 right 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 3 right 1
+# tcp option sack3 right 1
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip/tcpopt.t b/tests/py/ip/tcpopt.t
index fccc6dda176d..7ee50a89d9c5 100644
--- a/tests/py/ip/tcpopt.t
+++ b/tests/py/ip/tcpopt.t
@@ -10,20 +10,20 @@ tcp option maxseg size 1;ok
 tcp option window kind 1;ok
 tcp option window length 1;ok
 tcp option window count 1;ok
-tcp option sack_permitted kind 1;ok
-tcp option sack_permitted length 1;ok
+tcp option sack-permitted kind 1;ok
+tcp option sack-permitted length 1;ok
 tcp option sack kind 1;ok
 tcp option sack length 1;ok
 tcp option sack left 1;ok
-tcp option sack 0 left 1;ok;tcp option sack left 1
-tcp option sack 1 left 1;ok
-tcp option sack 2 left 1;ok
-tcp option sack 3 left 1;ok
+tcp option sack0 left 1;ok;tcp option sack left 1
+tcp option sack1 left 1;ok
+tcp option sack2 left 1;ok
+tcp option sack3 left 1;ok
 tcp option sack right 1;ok
-tcp option sack 0 right 1;ok;tcp option sack right 1
-tcp option sack 1 right 1;ok
-tcp option sack 2 right 1;ok
-tcp option sack 3 right 1;ok
+tcp option sack0 right 1;ok;tcp option sack right 1
+tcp option sack1 right 1;ok
+tcp option sack2 right 1;ok
+tcp option sack3 right 1;ok
 tcp option timestamp kind 1;ok
 tcp option timestamp length 1;ok
 tcp option timestamp tsval 1;ok
diff --git a/tests/py/ip/tcpopt.t.payload b/tests/py/ip/tcpopt.t.payload
index 47e4dee053a7..3e1d4ad1fcef 100644
--- a/tests/py/ip/tcpopt.t.payload
+++ b/tests/py/ip/tcpopt.t.payload
@@ -54,14 +54,14 @@ ip test-ip input
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack_permitted kind 1
+# tcp option sack-permitted kind 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack_permitted length 1
+# tcp option sack-permitted length 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -89,28 +89,28 @@ ip test-ip input
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 0 left 1
+# tcp option sack0 left 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 1 left 1
+# tcp option sack1 left 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 2 left 1
+# tcp option sack2 left 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 3 left 1
+# tcp option sack3 left 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -124,28 +124,28 @@ ip test-ip input
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 0 right 1
+# tcp option sack0 right 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 1 right 1
+# tcp option sack1 right 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 2 right 1
+# tcp option sack2 right 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 3 right 1
+# tcp option sack3 right 1
 ip test-ip input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip6/tcpopt.t b/tests/py/ip6/tcpopt.t
index d6f2dba25ff2..497f69fc8678 100644
--- a/tests/py/ip6/tcpopt.t
+++ b/tests/py/ip6/tcpopt.t
@@ -9,20 +9,20 @@ tcp option maxseg size 1;ok
 tcp option window kind 1;ok
 tcp option window length 1;ok
 tcp option window count 1;ok
-tcp option sack_permitted kind 1;ok
-tcp option sack_permitted length 1;ok
+tcp option sack-permitted kind 1;ok
+tcp option sack-permitted length 1;ok
 tcp option sack kind 1;ok
 tcp option sack length 1;ok
 tcp option sack left 1;ok
-tcp option sack 0 left 1;ok;tcp option sack left 1
-tcp option sack 1 left 1;ok
-tcp option sack 2 left 1;ok
-tcp option sack 3 left 1;ok
+tcp option sack0 left 1;ok;tcp option sack left 1
+tcp option sack1 left 1;ok
+tcp option sack2 left 1;ok
+tcp option sack3 left 1;ok
 tcp option sack right 1;ok
-tcp option sack 0 right 1;ok;tcp option sack right 1
-tcp option sack 1 right 1;ok
-tcp option sack 2 right 1;ok
-tcp option sack 3 right 1;ok
+tcp option sack0 right 1;ok;tcp option sack right 1
+tcp option sack1 right 1;ok
+tcp option sack2 right 1;ok
+tcp option sack3 right 1;ok
 tcp option timestamp kind 1;ok
 tcp option timestamp length 1;ok
 tcp option timestamp tsval 1;ok
diff --git a/tests/py/ip6/tcpopt.t.payload b/tests/py/ip6/tcpopt.t.payload
index 98389b0ac22b..88e277d1c94b 100644
--- a/tests/py/ip6/tcpopt.t.payload
+++ b/tests/py/ip6/tcpopt.t.payload
@@ -54,14 +54,14 @@ ip6 test-ip input
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack_permitted kind 1
+# tcp option sack-permitted kind 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack_permitted length 1
+# tcp option sack-permitted length 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -89,28 +89,28 @@ ip6 test-ip input
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 0 left 1
+# tcp option sack0 left 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 1 left 1
+# tcp option sack1 left 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 2 left 1
+# tcp option sack2 left 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 3 left 1
+# tcp option sack3 left 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -124,28 +124,28 @@ ip6 test-ip input
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 0 right 1
+# tcp option sack0 right 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 1 right 1
+# tcp option sack1 right 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 2 right 1
+# tcp option sack2 right 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack 3 right 1
+# tcp option sack3 right 1
 ip6 test-ip input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-- 
2.1.4

