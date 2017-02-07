From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 4/7] src: add TCP option matching
Date: Tue,  7 Feb 2017 03:14:12 +0100
Message-ID: <20170207021415.22460-5-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:43941 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751164AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id A7C45B0126
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:32 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables nft to match against TCP options.

Currently these TCP options are supported:
* End of Option List (eol)
* No-Operation (noop)
* Maximum Segment Size (maxseg)
* Window Scale (window)
* SACK Permitted (sack_permitted)
* SACK (sack)
* Timestamps (timestamp)

Syntax: tcp options $option_name [$offset] $field_name
Example:

 # count all incoming packets with a specific maximum segment size `x`
 # nft add rule filter input tcp option maxseg size x counter

 # count all incoming packets with a SACK TCP option where the third
 # (counted from zero) left field is greater `x`.
 # nft add rule filter input tcp option sack 2 left \> x counter

If the offset (the `2` in the example above) is zero, it can optionally
be omitted.
For all non-SACK TCP options it is always zero, thus can be left out.

Option names and field names are parsed from templates, similar to meta
and ct options rather than via keywords to prevent adding more keywords
than necessary.

Signed-off-by: Manuel Messner <mm@skelett.io>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml               | 178 +++++++++++++++++++++++++++++-
 include/expression.h      |   1 +
 include/exthdr.h          |   2 +
 include/tcpopt.h          |  26 +++++
 src/Makefile.am           |   1 +
 src/evaluate.c            |  35 +++++-
 src/exthdr.c              |  31 +++++-
 src/netlink_delinearize.c |   3 +-
 src/netlink_linearize.c   |   3 +-
 src/parser_bison.y        |  46 +++++++-
 src/scanner.l             |   1 +
 src/tcpopt.c              | 269 ++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 580 insertions(+), 16 deletions(-)
 create mode 100644 include/tcpopt.h
 create mode 100644 src/tcpopt.c

diff --git a/doc/nft.xml b/doc/nft.xml
index 1455086..08ecdfa 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2105,14 +2105,182 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 				</table>
 			</para>
 		</refsect2>
-	</refsect1>
 
-	<refsect1>
-		<title>bla</title>
 		<refsect2>
-			<title>IPv6 extension header expressions</title>
+			<title>Extension header expressions</title>
+			<para>
+				Extension header expressions refer to data from variable-sized protocol headers, such as IPv6 extension headers and
+				TCPs options.
+			</para>
+			<para>
+				nftables currently supports matching (finding) a given ipv6 extension header or TCP option.
+			</para>
+			<cmdsynopsis>
+				<command>hbh</command>
+				<group choice="req">
+					<arg>nexthdr</arg>
+					<arg>hdrlength</arg>
+				</group>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<command>frag</command>
+				<group choice="req">
+					<arg>nexthdr</arg>
+					<arg>frag-off</arg>
+					<arg>more-fragments</arg>
+					<arg>id</arg>
+				</group>
+			</cmdsynopsis>
+
+			<cmdsynopsis>
+				<command>rt</command>
+				<group choice="req">
+					<arg>nexthdr</arg>
+					<arg>hdrlength</arg>
+					<arg>type</arg>
+					<arg>seg-left</arg>
+				</group>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<command>dst</command>
+				<group choice="req">
+					<arg>nexthdr</arg>
+					<arg>hdrlength</arg>
+				</group>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<command>mh</command>
+				<group choice="req">
+					<arg>nexthdr</arg>
+					<arg>hdrlength</arg>
+					<arg>checksum</arg>
+					<arg>type</arg>
+				</group>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<command>tcp option</command>
+				<group choice="req">
+					<arg>eol</arg>
+					<arg>noop</arg>
+					<arg>maxseg</arg>
+					<arg>window</arg>
+					<arg>sack_permitted</arg>
+					<arg>sack</arg>
+					<arg>timestamp</arg>
+				</group>
+                <arg><replaceable>offset</replaceable></arg>
+				<arg choice="none"><replaceable>tcp_option_field</replaceable></arg>
+			</cmdsynopsis>
+			<para>
+				<table frame="all">
+					<title>IPv6 extension headers</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>hbh</entry>
+								<entry>Hop by Hop</entry>
+							</row>
+							<row>
+								<entry>rt</entry>
+								<entry>Routing Header</entry>
+							</row>
+							<row>
+								<entry>frag</entry>
+								<entry>Fragmentation header</entry>
+							</row>
+							<row>
+								<entry>dst</entry>
+								<entry>dst options</entry>
+							</row>
+							<row>
+								<entry>mh</entry>
+								<entry>Mobility Header</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+
+				<table frame="all">
+					<title>TCP Options</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>TCP option fields</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>eol</entry>
+								<entry>End of option list</entry>
+								<entry>kind</entry>
+							</row>
+							<row>
+								<entry>noop</entry>
+								<entry>1 Byte TCP No-op options</entry>
+								<entry>kind</entry>
+							</row>
+							<row>
+								<entry>maxseg</entry>
+								<entry>TCP Maximum Segment Size</entry>
+								<entry>kind, length, size</entry>
+							</row>
+							<row>
+								<entry>window</entry>
+								<entry>TCP Window Scaling</entry>
+								<entry>kind, length, count</entry>
+							</row>
+							<row>
+								<entry>sack_permitted</entry>
+								<entry>TCP SACK permitted</entry>
+								<entry>kind, length</entry>
+							</row>
+							<row>
+								<entry>sack</entry>
+								<entry>TCP Selective Acknowledgement</entry>
+								<entry>kind, length, left, right</entry>
+							</row>
+							<row>
+								<entry>timestamp</entry>
+								<entry>TCP Timestamps</entry>
+								<entry>kind, length, tsval, tsecr</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+
+			<para>
+				The <replaceable>offset</replaceable> is only used for the SACK TCP option fields <command>left</command> and <command>right</command>.
+				For all non-SACK TCP options it is always zero.
+				<replaceable>Offsets</replaceable> which equals to zero can be omitted.
+			</para>
+
 			<para>
-				IPv6 extension header expressions refer to data from an IPv6 packet's extension headers.
+				<example>
+					<title>finding TCP options</title>
+					<programlisting>
+filter input tcp option sack_permitted kind 1 counter
+					</programlisting>
+				</example>
+				<example>
+				<title>matching IPv6 exthdr</title>
+					<programlisting>
+ip6 filter input frag more-fragments 1 counter
+					</programlisting>
+				</example>
 			</para>
 		</refsect2>
 
diff --git a/include/expression.h b/include/expression.h
index ec90265..83ecf11 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -281,6 +281,7 @@ struct expr {
 			const struct exthdr_desc	*desc;
 			const struct proto_hdr_template	*tmpl;
 			unsigned int			offset;
+			enum nft_exthdr_op		op;
 		} exthdr;
 		struct {
 			/* EXPR_META */
diff --git a/include/exthdr.h b/include/exthdr.h
index 93a53f3..cdcc2b9 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -2,6 +2,7 @@
 #define NFTABLES_EXTHDR_H
 
 #include <proto.h>
+#include <tcpopt.h>
 
 /**
  * struct exthdr_desc - extension header description
@@ -78,6 +79,7 @@ enum mh_hdr_fields {
 	MHHDR_CHECKSUM,
 };
 
+extern const struct expr_ops exthdr_expr_ops;
 extern const struct exthdr_desc exthdr_hbh;
 extern const struct exthdr_desc exthdr_rt;
 extern const struct exthdr_desc exthdr_rt0;
diff --git a/include/tcpopt.h b/include/tcpopt.h
new file mode 100644
index 0000000..5b99008
--- /dev/null
+++ b/include/tcpopt.h
@@ -0,0 +1,26 @@
+#ifndef NFTABLES_TCPOPT_H
+#define NFTABLES_TCPOPT_H
+
+#include <proto.h>
+#include <exthdr.h>
+
+extern struct expr *tcpopt_expr_alloc(const struct location *loc,
+				      const char *option_str,
+				      const unsigned int option_num,
+				      const char *optioni_field);
+
+extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
+			    unsigned int offset, unsigned int len);
+
+extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
+				 unsigned int *shift);
+
+extern const struct exthdr_desc tcpopt_eol;
+extern const struct exthdr_desc tcpopt_nop;
+extern const struct exthdr_desc tcpopt_maxseg;
+extern const struct exthdr_desc tcpopt_window;
+extern const struct exthdr_desc tcpopt_sack_permitted;
+extern const struct exthdr_desc tcpopt_sack;
+extern const struct exthdr_desc tcpopt_timestamp;
+
+#endif /* NFTABLES_TCPOPT_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index c6586f5..99eef7b 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -55,6 +55,7 @@ nft_SOURCES =	main.c				\
 		services.c			\
 		mergesort.c			\
 		scanner.l			\
+		tcpopt.c			\
 		parser_bison.y
 
 if BUILD_CLI
diff --git a/src/evaluate.c b/src/evaluate.c
index 0e02548..4817a55 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -438,6 +438,26 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	    expr->len % BITS_PER_BYTE != 0)
 		expr_evaluate_bits(ctx, exprp);
 
+	switch (expr->exthdr.op) {
+	case NFT_EXTHDR_OP_TCPOPT: {
+		static const uint8_t tcphdrlen = 20 * BITS_PER_BYTE;
+		static const unsigned int max_tcpoptlen = 15 * 4 * BITS_PER_BYTE - tcphdrlen;
+		unsigned int totlen = 0;
+
+		totlen += expr->exthdr.tmpl->offset;
+		totlen += expr->exthdr.tmpl->len;
+		totlen += expr->exthdr.offset;
+
+		if (totlen > max_tcpoptlen)
+			return expr_error(ctx->msgs, expr,
+					  "offset and size %u exceeds max tcp headerlen (%u)",
+					  totlen, max_tcpoptlen);
+		break;
+	}
+	default:
+		break;
+	}
+
 	return 0;
 }
 
@@ -448,11 +468,24 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
  */
 static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 {
-	const struct proto_desc *base, *dependency = &proto_ip6;
+	const struct proto_desc *base, *dependency = NULL;
 	enum proto_bases pb = PROTO_BASE_NETWORK_HDR;
 	struct expr *expr = *exprp;
 	struct stmt *nstmt;
 
+	switch (expr->exthdr.op) {
+	case NFT_EXTHDR_OP_TCPOPT:
+		dependency = &proto_tcp;
+		pb = PROTO_BASE_TRANSPORT_HDR;
+		break;
+	case NFT_EXTHDR_OP_IPV6:
+	default:
+		dependency = &proto_ip6;
+		break;
+	}
+
+	assert(dependency);
+
 	base = ctx->pctx.protocol[pb].desc;
 	if (base == dependency)
 		return __expr_evaluate_exthdr(ctx, exprp);
diff --git a/src/exthdr.c b/src/exthdr.c
index 45b1b69..cfc6bb6 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -24,13 +24,29 @@
 
 static void exthdr_expr_print(const struct expr *expr)
 {
-	printf("%s %s", expr->exthdr.desc->name, expr->exthdr.tmpl->token);
+	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
+		/* Offset calcualtion is a bit hacky at this point.
+		 * There might be an tcp option one day with another
+		 * multiplicator
+		 */
+		unsigned int offset = expr->exthdr.offset / 64;
+		char buf[3] = {0};
+
+		if (offset)
+			snprintf(buf, sizeof buf, " %d", offset);
+		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
+					     expr->exthdr.tmpl->token);
+	}
+	else
+		printf("%s %s", expr->exthdr.desc->name,
+				expr->exthdr.tmpl->token);
 }
 
 static bool exthdr_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return e1->exthdr.desc == e2->exthdr.desc &&
-	       e1->exthdr.tmpl == e2->exthdr.tmpl;
+	       e1->exthdr.tmpl == e2->exthdr.tmpl &&
+	       e1->exthdr.op == e2->exthdr.op;
 }
 
 static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
@@ -38,9 +54,10 @@ static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 	new->exthdr.desc = expr->exthdr.desc;
 	new->exthdr.tmpl = expr->exthdr.tmpl;
 	new->exthdr.offset = expr->exthdr.offset;
+	new->exthdr.op = expr->exthdr.op;
 }
 
-static const struct expr_ops exthdr_expr_ops = {
+const struct expr_ops exthdr_expr_ops = {
 	.type		= EXPR_EXTHDR,
 	.name		= "exthdr",
 	.print		= exthdr_expr_print,
@@ -86,6 +103,8 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_EXTHDR);
+	if (op == NFT_EXTHDR_OP_TCPOPT)
+		return tcpopt_init_raw(expr, type, offset, len);
 
 	expr->len = len;
 	expr->exthdr.offset = offset;
@@ -117,6 +136,12 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 	if (expr->exthdr.tmpl != &exthdr_unknown_template)
 		return false;
 
+	/* In case we are handling tcp options instead of the default ipv6
+	 * extension headers.
+	 */
+	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT)
+		return tcpopt_find_template(expr, mask, shift);
+
 	mask_offset = mpz_scan1(mask->value, 0);
 	mask_len = mask_length(mask);
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d6a9fe1..87010f1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -507,7 +507,7 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 	type   = nftnl_expr_get_u8(nle, NFTNL_EXPR_EXTHDR_TYPE);
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_LEN) * BITS_PER_BYTE;
-	op     = NFT_EXTHDR_OP_IPV6;
+	op     = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_OP);
 
 	expr = exthdr_expr_alloc(loc, NULL, 0);
 	exthdr_init_raw(expr, type, offset, len, op);
@@ -1221,6 +1221,7 @@ static const struct {
 	{ .name = "numgen",	.parse = netlink_parse_numgen },
 	{ .name = "hash",	.parse = netlink_parse_hash },
 	{ .name = "fib",	.parse = netlink_parse_fib },
+	{ .name = "tcpopt",	.parse = netlink_parse_exthdr },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 056f113..8849b0e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -162,7 +162,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers dreg)
 {
-	unsigned int offset = expr->exthdr.tmpl->offset;
+	unsigned int offset = expr->exthdr.tmpl->offset + expr->exthdr.offset;
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("exthdr");
@@ -172,6 +172,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
+	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d543e3e..b295bfd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -308,6 +308,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DOFF			"doff"
 %token WINDOW			"window"
 %token URGPTR			"urgptr"
+%token OPTION			"option"
 
 %token DCCP			"dccp"
 
@@ -428,8 +429,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token NOTRACK			"notrack"
 
-%type <string>			identifier type_identifier string comment_spec
-%destructor { xfree($$); }	identifier type_identifier string comment_spec
+%type <string>			identifier type_identifier string comment_spec tcp_option_name tcp_option_field
+%destructor { xfree($$); }	identifier type_identifier string comment_spec tcp_option_name tcp_option_field
 
 %type <val>			time_spec quota_used
 
@@ -581,9 +582,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
 %destructor { expr_free($$); }	auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
 %type <val>			auth_hdr_field	esp_hdr_field		comp_hdr_field
-%type <expr>			udp_hdr_expr	udplite_hdr_expr	tcp_hdr_expr
-%destructor { expr_free($$); }	udp_hdr_expr	udplite_hdr_expr	tcp_hdr_expr
-%type <val>			udp_hdr_field	udplite_hdr_field	tcp_hdr_field
+%type <expr>			udp_hdr_expr	udplite_hdr_expr
+%destructor { expr_free($$); }	udp_hdr_expr	udplite_hdr_expr
+%type <val>			udp_hdr_field	udplite_hdr_field
 %type <expr>			dccp_hdr_expr	sctp_hdr_expr
 %destructor { expr_free($$); }	dccp_hdr_expr	sctp_hdr_expr
 %type <val>			dccp_hdr_field	sctp_hdr_field
@@ -600,6 +601,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	mh_hdr_expr
 %type <val>			mh_hdr_field
 
+%type <expr>			tcp_hdr_optexpr
+%destructor { expr_free($$); }	tcp_hdr_optexpr
+
 %type <expr>			meta_expr
 %destructor { expr_free($$); }	meta_expr
 %type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type
@@ -626,6 +630,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <quota>			quota_config
 %destructor { xfree($$); }	quota_config
 
+%type <expr>			tcp_hdr_expr
+%destructor { expr_free($$); }	tcp_hdr_expr
+%type <val>			tcp_hdr_field
+
 %%
 
 input			:	/* empty */
@@ -3232,6 +3240,7 @@ exthdr_expr		:	hbh_hdr_expr
 			|	frag_hdr_expr
 			|	dst_hdr_expr
 			|	mh_hdr_expr
+			|	tcp_hdr_optexpr
 			;
 
 hbh_hdr_expr		:	HBH	hbh_hdr_field
@@ -3314,4 +3323,31 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
+tcp_option_name		:	STRING		{ $$ = $1; }
+			|	WINDOW		{ $$ = xstrdup("window"); }
+			;
+
+tcp_option_field	:	STRING		{ $$ = $1; }
+			|	LENGTH		{ $$ = xstrdup("length"); }
+			|	SIZE		{ $$ = xstrdup("size"); }
+			;
+
+tcp_hdr_optexpr		:	TCP	OPTION	tcp_option_name		tcp_option_field
+			{
+				$$ = tcpopt_expr_alloc(&@$, $3, 0, $4);
+			}
+			|	TCP	OPTION	STRING	NUM	tcp_option_field
+			{
+				if (strcmp($3, "sack")) {
+					erec_queue(error(&@2, "tcp: number (%d) can only be used with sack option", $4), state->msgs);
+					YYERROR;
+				}
+
+				if ($4 > 3) {
+					erec_queue(error(&@2, "tcp: option block (%d) too large (0-3)", $4), state->msgs);
+					YYERROR;
+				}
+				$$ = tcpopt_expr_alloc(&@$, $3, $4, $5);
+			}
+			;
 %%
diff --git a/src/scanner.l b/src/scanner.l
index d0d25ea..922d8ec 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -411,6 +411,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "doff"			{ return DOFF; }
 "window"		{ return WINDOW; }
 "urgptr"		{ return URGPTR; }
+"option"		{ return OPTION; }
 
 "dccp"			{ return DCCP; }
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
new file mode 100644
index 0000000..e6f92bc
--- /dev/null
+++ b/src/tcpopt.c
@@ -0,0 +1,269 @@
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+
+#include <utils.h>
+#include <headers.h>
+#include <expression.h>
+#include <tcpopt.h>
+
+/* We do not need to export these enums, because the tcpopts are parsed at
+ * runtime and not by bison.
+ */
+enum tcpopt_eol_hdr_fields {
+	TCPOPT_EOLHDR_KIND,
+};
+
+enum tcpopt_nop_hdr_fields {
+	TCPOPT_NOPHDR_KIND,
+};
+
+enum tcpopt_maxseg_hdr_fields {
+	TCPOPT_MAXSEGHDR_KIND,
+	TCPOPT_MAXSEGHDR_LENGTH,
+	TCPOPT_MAXSEGHDR_SIZE,
+};
+
+enum tcpopt_window_hdr_fields {
+	TCPOPT_WINDOWHDR_KIND,
+	TCPOPT_WINDOWHDR_LENGTH,
+	TCPOPT_WINDOWHDR_COUNT,
+};
+
+enum tcpopt_sack_permitted_hdr_fields {
+	TCPOPT_SACKPERMHDR_KIND,
+	TCPOPT_SACKPERMHDR_LENGTH,
+};
+
+enum tcpopt_sack_hdr_fields {
+	TCPOPT_SACKHDR_KIND,
+	TCPOPT_SACKHDR_LENGTH,
+	TCPOPT_SACKHDR_LEFT,
+	TCPOPT_SACKHDR_RIGHT,
+};
+
+enum tcpopt_timestamp_hdr_fields {
+	TCPOPT_TIMESTAMPSHDR_KIND,
+	TCPOPT_TIMESTAMPSHDR_LENGTH,
+	TCPOPT_TIMESTAMPSHDR_TSVAL,
+	TCPOPT_TIMESTAMPSHDR_TSECR,
+};
+
+static const struct proto_hdr_template tcpopt_unknown_template =
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, BYTEORDER_INVALID, 0, 0);
+
+#define PHT(__token, __offset, __len) \
+	PROTO_HDR_TEMPLATE(__token, &integer_type, BYTEORDER_BIG_ENDIAN, \
+			   __offset, __len)
+const struct exthdr_desc tcpopt_eol = {
+	.name		= "eol",
+	.type		= TCPOPT_EOL,
+	.templates	= {
+		[TCPOPT_EOLHDR_KIND]		= PHT("kind",  0,    8),
+	},
+};
+
+const struct exthdr_desc tcpopt_nop = {
+	.name		= "noop",
+	.type		= TCPOPT_NOP,
+	.templates	= {
+		[TCPOPT_NOPHDR_KIND]		= PHT("kind",   0,   8),
+	},
+};
+
+const struct exthdr_desc tcptopt_maxseg = {
+	.name		= "maxseg",
+	.type		= TCPOPT_MAXSEG,
+	.templates	= {
+		[TCPOPT_MAXSEGHDR_KIND]		= PHT("kind",   0,  8),
+		[TCPOPT_MAXSEGHDR_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_MAXSEGHDR_SIZE]		= PHT("size",  16, 16),
+	},
+};
+
+const struct exthdr_desc tcpopt_window = {
+	.name		= "window",
+	.type		= TCPOPT_WINDOW,
+	.templates	= {
+		[TCPOPT_WINDOWHDR_KIND]		= PHT("kind",   0,  8),
+		[TCPOPT_WINDOWHDR_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_WINDOWHDR_COUNT]	= PHT("count", 16,  8),
+	},
+};
+
+const struct exthdr_desc tcpopt_sack_permitted = {
+	.name		= "sack_permitted",
+	.type		= TCPOPT_SACK_PERMITTED,
+	.templates	= {
+		[TCPOPT_SACKPERMHDR_KIND]	= PHT("kind",   0, 8),
+		[TCPOPT_SACKPERMHDR_LENGTH]	= PHT("length", 8, 8),
+	},
+};
+
+const struct exthdr_desc tcpopt_sack = {
+	.name		= "sack",
+	.type		= TCPOPT_SACK,
+	.templates	= {
+		[TCPOPT_SACKHDR_KIND]		= PHT("kind",   0,   8),
+		[TCPOPT_SACKHDR_LENGTH]		= PHT("length", 8,   8),
+		[TCPOPT_SACKHDR_LEFT]		= PHT("left",  16,  32),
+		[TCPOPT_SACKHDR_RIGHT]		= PHT("right", 48,  32),
+	},
+};
+
+const struct exthdr_desc tcpopt_timestamp = {
+	.name		= "timestamp",
+	.type		= TCPOPT_TIMESTAMP,
+	.templates	= {
+		[TCPOPT_TIMESTAMPSHDR_KIND]	= PHT("kind",   0,  8),
+		[TCPOPT_TIMESTAMPSHDR_LENGTH]	= PHT("length", 8,  8),
+		[TCPOPT_TIMESTAMPSHDR_TSVAL]	= PHT("tsval",  16, 32),
+		[TCPOPT_TIMESTAMPSHDR_TSECR]	= PHT("tsecr",  48, 32),
+	},
+};
+#undef PHT
+
+#define TCPOPT_OBSOLETE ((struct exthdr_desc *)NULL)
+#define TCPOPT_ECHO 6
+#define TCPOPT_ECHO_REPLY 7
+const struct exthdr_desc *tcpopt_protocols[] = {
+	[TCPOPT_EOL]		= &tcpopt_eol,
+	[TCPOPT_NOP]		= &tcpopt_nop,
+	[TCPOPT_MAXSEG]		= &tcptopt_maxseg,
+	[TCPOPT_WINDOW]		= &tcpopt_window,
+	[TCPOPT_SACK_PERMITTED]	= &tcpopt_sack_permitted,
+	[TCPOPT_SACK]		= &tcpopt_sack,
+	[TCPOPT_ECHO]		= TCPOPT_OBSOLETE,
+	[TCPOPT_ECHO_REPLY]	= TCPOPT_OBSOLETE,
+	[TCPOPT_TIMESTAMP]	= &tcpopt_timestamp,
+};
+
+static unsigned int calc_offset(const struct exthdr_desc *desc,
+				const struct proto_hdr_template *tmpl,
+				unsigned int num)
+{
+	if (!desc || tmpl == &tcpopt_unknown_template)
+		return 0;
+
+	switch (desc->type) {
+	case TCPOPT_SACK:
+		/* Make sure, offset calculations only apply to left and right
+		 * fields
+		 */
+		return (tmpl->offset < 16) ? 0 : num * 64;
+	default:
+		return 0;
+	}
+}
+
+
+static unsigned int calc_offset_reverse(const struct exthdr_desc *desc,
+					const struct proto_hdr_template *tmpl,
+					unsigned int offset)
+{
+	if (!desc || tmpl == &tcpopt_unknown_template)
+		return offset;
+
+	switch (desc->type) {
+	case TCPOPT_SACK:
+		/* We can safely ignore the first left/right field */
+		return offset < 80 ? offset : (offset % 64);
+	default:
+		return offset;
+	}
+}
+
+
+struct expr *tcpopt_expr_alloc(const struct location *loc,
+			       const char *option_str,
+			       const unsigned int option_num,
+			       const char *option_field)
+{
+	const struct proto_hdr_template *tmp, *tmpl = &tcpopt_unknown_template;
+	const struct exthdr_desc *desc = NULL;
+	struct expr *expr;
+	unsigned int i, j;
+
+	for (i = 0; i < array_size(tcpopt_protocols); ++i) {
+		if (tcpopt_protocols[i] == TCPOPT_OBSOLETE)
+			continue;
+
+		if (!tcpopt_protocols[i]->name ||
+		    strcmp(option_str, tcpopt_protocols[i]->name))
+			continue;
+
+		for (j = 0; j < array_size(tcpopt_protocols[i]->templates); ++j) {
+			tmp = &tcpopt_protocols[i]->templates[j];
+			if (!tmp->token || strcmp(option_field, tmp->token))
+				continue;
+
+			desc = tcpopt_protocols[i];
+			tmpl = tmp;
+			goto found;
+		}
+	}
+
+found:
+	/* tmpl still points to tcpopt_unknown_template if nothing was found and
+	 * desc is null
+	 */
+	expr = expr_alloc(loc, &exthdr_expr_ops, tmpl->dtype,
+			  BYTEORDER_BIG_ENDIAN, tmpl->len);
+	expr->exthdr.desc   = desc;
+	expr->exthdr.tmpl   = tmpl;
+	expr->exthdr.op     = NFT_EXTHDR_OP_TCPOPT;
+	expr->exthdr.offset = calc_offset(desc, tmpl, option_num);
+
+	return expr;
+}
+
+void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
+		     unsigned int len)
+{
+	const struct proto_hdr_template *tmpl;
+	unsigned int i, off;
+
+	assert(expr->ops->type == EXPR_EXTHDR);
+
+	expr->len = len;
+	expr->exthdr.offset = offset;
+
+	assert(type < array_size(tcpopt_protocols));
+	expr->exthdr.desc = tcpopt_protocols[type];
+	assert(expr->exthdr.desc != TCPOPT_OBSOLETE);
+
+	for (i = 0; i < array_size(expr->exthdr.desc->templates); ++i) {
+		tmpl = &expr->exthdr.desc->templates[i];
+		/* We have to reverse calculate the offset for the sack options
+		 * at this point
+		 */
+		off = calc_offset_reverse(expr->exthdr.desc, tmpl, offset);
+		if (tmpl->offset != off || tmpl->len != len)
+			continue;
+
+		expr->dtype       = tmpl->dtype;
+		expr->exthdr.tmpl = tmpl;
+		expr->exthdr.op   = NFT_EXTHDR_OP_TCPOPT;
+		break;
+	}
+}
+
+bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
+			  unsigned int *shift)
+{
+	if (expr->exthdr.tmpl != &tcpopt_unknown_template)
+		return false;
+
+	tcpopt_init_raw(expr, expr->exthdr.desc->type, expr->exthdr.offset,
+			expr->len);
+
+	if (expr->exthdr.tmpl == &tcpopt_unknown_template)
+		return false;
+
+	return true;
+}
-- 
2.11.1

