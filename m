Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F09C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 867A1613C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhEDRDH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 May 2021 13:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhEDRDF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 May 2021 13:03:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB670C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  4 May 2021 10:02:09 -0700 (PDT)
Received: from localhost ([::1]:42772 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1ldyQy-0008D1-3B; Tue, 04 May 2021 19:02:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/3] exthdr: Implement SCTP Chunk matching
Date:   Tue,  4 May 2021 19:01:48 +0200
Message-Id: <20210504170148.25226-3-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210504170148.25226-1-phil@nwl.cc>
References: <20210504170148.25226-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend exthdr expression to support scanning through SCTP packet chunks
and matching on fixed fields' values.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc           |  13 +
 doc/payload-expression.txt          |  53 +++
 include/linux/netfilter/nf_tables.h |   2 +
 include/parser.h                    |   1 +
 include/sctp_chunk.h                |  87 +++++
 src/Makefile.am                     |   1 +
 src/evaluate.c                      |   1 +
 src/exthdr.c                        |   8 +
 src/json.c                          |   2 +
 src/parser_bison.y                  | 148 ++++++++-
 src/parser_json.c                   |  49 +++
 src/scanner.l                       |  38 +++
 src/sctp_chunk.c                    | 261 +++++++++++++++
 tests/py/inet/sctp.t                |  37 +++
 tests/py/inet/sctp.t.json           | 478 ++++++++++++++++++++++++++++
 tests/py/inet/sctp.t.payload        | 155 +++++++++
 16 files changed, 1332 insertions(+), 2 deletions(-)
 create mode 100644 include/sctp_chunk.h
 create mode 100644 src/sctp_chunk.c

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 858abbf73fbfc..fba4cb08ccb68 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1200,6 +1200,19 @@ Create a reference to a field (*field*) of a TCP option header (*name*).
 If the *field* property is not given, the expression is to be used as a TCP option
 existence check in a *match* statement with a boolean on the right hand side.
 
+=== SCTP CHUNK
+[verse]
+*{ "sctp chunk": {
+	"name":* 'STRING'*,
+	"field":* 'STRING'
+*}}*
+
+Create a reference to a field (*field*) of an SCTP chunk (*name*).
+
+If the *field* property is not given, the expression is to be used as an SCTP
+chunk existence check in a *match* statement with a boolean on the right hand
+side.
+
 === META
 [verse]
 ____
diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index a593e2e7b947d..a338dcf044505 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -369,7 +369,33 @@ integer (16 bit)
 SCTP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
+____
 *sctp* {*sport* | *dport* | *vtag* | *checksum*}
+*sctp chunk* 'CHUNK' [ 'FIELD' ]
+
+'CHUNK' := *data* | *init* | *init-ack* | *sack* | *heartbeat* |
+	   *heartbeat-ack* | *abort* | *shutdown* | *shutdown-ack* | *error* |
+	   *cookie-echo* | *cookie-ack* | *ecne* | *cwr* | *shutdown-complete*
+	   | *asconf-ack* | *forward-tsn* | *asconf*
+
+'FIELD' := 'COMMON_FIELD' | 'DATA_FIELD' | 'INIT_FIELD' | 'INIT_ACK_FIELD' |
+	   'SACK_FIELD' | 'SHUTDOWN_FIELD' | 'ECNE_FIELD' | 'CWR_FIELD' |
+	   'ASCONF_ACK_FIELD' | 'FORWARD_TSN_FIELD' | 'ASCONF_FIELD'
+
+'COMMON_FIELD' := *type* | *flags* | *length*
+'DATA_FIELD' := *tsn* | *stream* | *ssn* | *ppid*
+'INIT_FIELD' := *init-tag* | *a-rwnd* | *num-outbound-streams* |
+		*num-inbound-streams* | *initial-tsn*
+'INIT_ACK_FIELD' := 'INIT_FIELD'
+'SACK_FIELD' := *cum-tsn-ack* | *a-rwnd* | *num-gap-ack-blocks* |
+		*num-dup-tsns*
+'SHUTDOWN_FIELD' := *cum-tsn-ack*
+'ECNE_FIELD' := *lowest-tsn*
+'CWR_FIELD' := *lowest-tsn*
+'ASCONF_ACK_FIELD' := *seqno*
+'FORWARD_TSN_FIELD' := *new-cum-tsn*
+'ASCONF_FIELD' := *seqno*
+____
 
 .SCTP header expression
 [options="header"]
@@ -387,8 +413,35 @@ integer (32 bit)
 |checksum|
 Checksum|
 integer (32 bit)
+|chunk|
+Search chunk in packet|
+without 'FIELD', boolean indicating existence
 |================
 
+.SCTP chunk fields
+[options="header"]
+|==================
+|Name| Width in bits | Chunk | Notes
+|type| 8 | all | not useful, defined by chunk type
+|flags| 8 | all | semantics defined on per-chunk basis
+|length| 16 | all | length of this chunk in bytes excluding padding
+|tsn| 32 | data | transmission sequence number
+|stream| 16 | data | stream identifier
+|ssn| 16 | data | stream sequence number
+|ppid| 32 | data | payload protocol identifier
+|init-tag| 32 | init, init-ack | initiate tag
+|a-rwnd| 32 | init, init-ack, sack | advertised receiver window credit
+|num-outbound-streams| 16 | init, init-ack | number of outbound streams
+|num-inbound-streams| 16 | init, init-ack | number of inbound streams
+|initial-tsn| 32 | init, init-ack | initial transmit sequence number
+|cum-tsn-ack| 32 | sack, shutdown | cumulative transmission sequence number acknowledged
+|num-gap-ack-blocks| 16 | sack | number of Gap Ack Blocks included
+|num-dup-tsns| 16 | sack | number of duplicate transmission sequence numbers received
+|lowest-tsn| 32 | ecne, cwr | lowest transmission sequence number
+|seqno| 32 | asconf-ack, asconf | sequence number
+|new-cum-tsn| 32 | forward-tsn | new cumulative transmission sequence number
+|==================
+
 DCCP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b1633e7ba5296..7f9fc203f6f82 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -806,11 +806,13 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
  * @NFT_EXTHDR_OP_TCP: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
+ * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
 	NFT_EXTHDR_OP_IPV4,
+	NFT_EXTHDR_OP_SCTP,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/include/parser.h b/include/parser.h
index e3f48078385bb..1a272ee25b4cc 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -47,6 +47,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_NUMGEN,
 	PARSER_SC_EXPR_QUEUE,
 	PARSER_SC_EXPR_RT,
+	PARSER_SC_EXPR_SCTP_CHUNK,
 	PARSER_SC_EXPR_SOCKET,
 
 	PARSER_SC_STMT_LOG,
diff --git a/include/sctp_chunk.h b/include/sctp_chunk.h
new file mode 100644
index 0000000000000..3819200f9f0a4
--- /dev/null
+++ b/include/sctp_chunk.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright Red Hat
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#ifndef NFTABLES_SCTP_CHUNK_H
+#define NFTABLES_SCTP_CHUNK_H
+
+/* SCTP chunk types used on wire */
+enum sctp_hdr_chunk_types {
+	SCTP_CHUNK_TYPE_DATA			= 0,
+	SCTP_CHUNK_TYPE_INIT			= 1,
+	SCTP_CHUNK_TYPE_INIT_ACK		= 2,
+	SCTP_CHUNK_TYPE_SACK			= 3,
+	SCTP_CHUNK_TYPE_HEARTBEAT		= 4,
+	SCTP_CHUNK_TYPE_HEARTBEAT_ACK		= 5,
+	SCTP_CHUNK_TYPE_ABORT			= 6,
+	SCTP_CHUNK_TYPE_SHUTDOWN		= 7,
+	SCTP_CHUNK_TYPE_SHUTDOWN_ACK		= 8,
+	SCTP_CHUNK_TYPE_ERROR			= 9,
+	SCTP_CHUNK_TYPE_COOKIE_ECHO		= 10,
+	SCTP_CHUNK_TYPE_COOKIE_ACK		= 11,
+	SCTP_CHUNK_TYPE_ECNE			= 12,
+	SCTP_CHUNK_TYPE_CWR			= 13,
+	SCTP_CHUNK_TYPE_SHUTDOWN_COMPLETE	= 14,
+	SCTP_CHUNK_TYPE_ASCONF_ACK		= 128,
+	SCTP_CHUNK_TYPE_FORWARD_TSN		= 192,
+	SCTP_CHUNK_TYPE_ASCONF			= 193,
+};
+
+enum sctp_hdr_chunk_common_fields {
+	SCTP_CHUNK_COMMON_TYPE,
+	SCTP_CHUNK_COMMON_FLAGS,
+	SCTP_CHUNK_COMMON_LENGTH,
+	__SCTP_CHUNK_COMMON_MAX,
+};
+
+#define SCTP_CHUNK_START_INDEX	__SCTP_CHUNK_COMMON_MAX
+
+enum sctp_hdr_chunk_data_fields {
+	SCTP_CHUNK_DATA_TSN = SCTP_CHUNK_START_INDEX,
+	SCTP_CHUNK_DATA_STREAM,
+	SCTP_CHUNK_DATA_SSN,
+	SCTP_CHUNK_DATA_PPID,
+};
+
+enum sctp_hdr_chunk_init_fields {
+	SCTP_CHUNK_INIT_TAG = SCTP_CHUNK_START_INDEX,
+	SCTP_CHUNK_INIT_RWND,
+	SCTP_CHUNK_INIT_OSTREAMS,
+	SCTP_CHUNK_INIT_ISTREAMS,
+	SCTP_CHUNK_INIT_TSN,
+};
+
+enum sctp_hdr_chunk_sack_fields {
+	SCTP_CHUNK_SACK_CTSN_ACK = SCTP_CHUNK_START_INDEX,
+	SCTP_CHUNK_SACK_RWND,
+	SCTP_CHUNK_SACK_GACK_BLOCKS,
+	SCTP_CHUNK_SACK_DUP_TSNS,
+};
+
+enum sctp_hdr_chunk_shutdown_fields {
+	SCTP_CHUNK_SHUTDOWN_CTSN_ACK = SCTP_CHUNK_START_INDEX,
+};
+
+enum sctp_hdr_chunk_ecne_cwr_fields {
+	SCTP_CHUNK_ECNE_CWR_MIN_TSN = SCTP_CHUNK_START_INDEX,
+};
+
+enum sctp_hdr_chunk_asconf_fields {
+	SCTP_CHUNK_ASCONF_SEQNO = SCTP_CHUNK_START_INDEX,
+};
+
+enum sctp_hdr_chunk_fwd_tsn_fields {
+	SCTP_CHUNK_FORWARD_TSN_NCTSN = SCTP_CHUNK_START_INDEX,
+};
+
+struct expr *sctp_chunk_expr_alloc(const struct location *loc,
+				   unsigned int type, unsigned int field);
+void sctp_chunk_init_raw(struct expr *expr, uint8_t type, unsigned int off,
+			 unsigned int len, uint32_t flags);
+const struct exthdr_desc *sctp_chunk_protocol_find(const char *name);
+
+#endif /* NFTABLES_SCTP_CHUNK_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 2f6d434b3ad2c..01c12c81bce75 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -75,6 +75,7 @@ libnftables_la_SOURCES =			\
 		tcpopt.c			\
 		socket.c			\
 		print.c				\
+		sctp_chunk.c			\
 		libnftables.c			\
 		libnftables.map
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 85cf9e05b641f..3cdf332aebec0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -580,6 +580,7 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT:
+	case NFT_EXTHDR_OP_SCTP:
 		return __expr_evaluate_exthdr(ctx, exprp);
 	case NFT_EXTHDR_OP_IPV4:
 		dependency = &proto_ip;
diff --git a/src/exthdr.c b/src/exthdr.c
index b0243adad1da4..22a08b0c9c2bf 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -22,6 +22,7 @@
 #include <headers.h>
 #include <expression.h>
 #include <statement.h>
+#include <sctp_chunk.h>
 
 static const struct exthdr_desc *exthdr_definitions[PROTO_DESC_MAX + 1] = {
 	[EXTHDR_DESC_HBH]	= &exthdr_hbh,
@@ -75,6 +76,11 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			return;
 		nft_print(octx, " %s", expr->exthdr.tmpl->token);
+	} else if (expr->exthdr.op == NFT_EXTHDR_OP_SCTP) {
+		nft_print(octx, "sctp chunk %s", expr->exthdr.desc->name);
+		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
+			return;
+		nft_print(octx, " %s", expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			nft_print(octx, "exthdr %s", expr->exthdr.desc->name);
@@ -291,6 +297,8 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 		return tcpopt_init_raw(expr, type, offset, len, flags);
 	if (op == NFT_EXTHDR_OP_IPV4)
 		return ipopt_init_raw(expr, type, offset, len, flags, true);
+	if (op == NFT_EXTHDR_OP_SCTP)
+		return sctp_chunk_init_raw(expr, type, offset, len, flags);
 
 	expr->len = len;
 	expr->exthdr.flags = flags;
diff --git a/src/json.c b/src/json.c
index 93decfe6a279e..ad646775e14d4 100644
--- a/src/json.c
+++ b/src/json.c
@@ -705,6 +705,8 @@ json_t *exthdr_expr_json(const struct expr *expr, struct output_ctx *octx)
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_IPV4:
 		return json_pack("{s:o}", "ip option", root);
+	case NFT_EXTHDR_OP_SCTP:
+		return json_pack("{s:o}", "sctp chunk", root);
 	default:
 		return json_pack("{s:o}", "exthdr", root);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 411c788c0fc25..d49cb5d9af01a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -38,6 +38,7 @@
 #include <utils.h>
 #include <parser.h>
 #include <erec.h>
+#include <sctp_chunk.h>
 
 #include "parser_bison.h"
 
@@ -416,6 +417,40 @@ int nft_lex(void *, void *, void *);
 %token DCCP			"dccp"
 
 %token SCTP			"sctp"
+%token CHUNK			"chunk"
+%token DATA			"data"
+%token INIT			"init"
+%token INIT_ACK			"init-ack"
+%token HEARTBEAT		"heartbeat"
+%token HEARTBEAT_ACK		"heartbeat-ack"
+%token ABORT			"abort"
+%token SHUTDOWN			"shutdown"
+%token SHUTDOWN_ACK		"shutdown-ack"
+%token ERROR			"error"
+%token COOKIE_ECHO		"cookie-echo"
+%token COOKIE_ACK		"cookie-ack"
+%token ECNE			"ecne"
+%token CWR			"cwr"
+%token SHUTDOWN_COMPLETE	"shutdown-complete"
+%token ASCONF_ACK		"asconf-ack"
+%token FORWARD_TSN		"forward-tsn"
+%token ASCONF			"asconf"
+%token TSN			"tsn"
+%token STREAM			"stream"
+%token SSN			"ssn"
+%token PPID			"ppid"
+%token INIT_TAG			"init-tag"
+%token A_RWND			"a-rwnd"
+%token NUM_OSTREAMS		"num-outbound-streams"
+%token NUM_ISTREAMS		"num-inbound-streams"
+%token INIT_TSN			"initial-tsn"
+%token CUM_TSN_ACK		"cum-tsn-ack"
+%token NUM_GACK_BLOCKS		"num-gap-ack-blocks"
+%token NUM_DUP_TSNS		"num-dup-tsns"
+%token LOWEST_TSN		"lowest-tsn"
+%token SEQNO			"seqno"
+%token NEW_CUM_TSN		"new-cum-tsn"
+
 %token VTAG			"vtag"
 
 %token RT			"rt"
@@ -767,9 +802,12 @@ int nft_lex(void *, void *, void *);
 %type <expr>			udp_hdr_expr	udplite_hdr_expr
 %destructor { expr_free($$); }	udp_hdr_expr	udplite_hdr_expr
 %type <val>			udp_hdr_field	udplite_hdr_field
-%type <expr>			dccp_hdr_expr	sctp_hdr_expr
-%destructor { expr_free($$); }	dccp_hdr_expr	sctp_hdr_expr
+%type <expr>			dccp_hdr_expr	sctp_hdr_expr sctp_chunk_alloc
+%destructor { expr_free($$); }	dccp_hdr_expr	sctp_hdr_expr sctp_chunk_alloc
 %type <val>			dccp_hdr_field	sctp_hdr_field
+%type <val>			sctp_chunk_type sctp_chunk_common_field
+%type <val>			sctp_chunk_data_field sctp_chunk_init_field
+%type <val>			sctp_chunk_sack_field
 %type <expr>			th_hdr_expr
 %destructor { expr_free($$); }	th_hdr_expr
 %type <val>			th_hdr_field
@@ -877,6 +915,7 @@ close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_sctp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SCTP); };
+close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SCTP_CHUNK); };
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 
@@ -5367,10 +5406,115 @@ dccp_hdr_field		:	SPORT		{ $$ = DCCPHDR_SPORT; }
 			|	TYPE		{ $$ = DCCPHDR_TYPE; }
 			;
 
+sctp_chunk_type		:	DATA		{ $$ = SCTP_CHUNK_TYPE_DATA; }
+			|	INIT		{ $$ = SCTP_CHUNK_TYPE_INIT; }
+			|	INIT_ACK	{ $$ = SCTP_CHUNK_TYPE_INIT_ACK; }
+			|	SACK		{ $$ = SCTP_CHUNK_TYPE_SACK; }
+			|	HEARTBEAT	{ $$ = SCTP_CHUNK_TYPE_HEARTBEAT; }
+			|	HEARTBEAT_ACK	{ $$ = SCTP_CHUNK_TYPE_HEARTBEAT_ACK; }
+			|	ABORT		{ $$ = SCTP_CHUNK_TYPE_ABORT; }
+			|	SHUTDOWN	{ $$ = SCTP_CHUNK_TYPE_SHUTDOWN; }
+			|	SHUTDOWN_ACK	{ $$ = SCTP_CHUNK_TYPE_SHUTDOWN_ACK; }
+			|	ERROR		{ $$ = SCTP_CHUNK_TYPE_ERROR; }
+			|	COOKIE_ECHO	{ $$ = SCTP_CHUNK_TYPE_COOKIE_ECHO; }
+			|	COOKIE_ACK	{ $$ = SCTP_CHUNK_TYPE_COOKIE_ACK; }
+			|	ECNE		{ $$ = SCTP_CHUNK_TYPE_ECNE; }
+			|	CWR		{ $$ = SCTP_CHUNK_TYPE_CWR; }
+			|	SHUTDOWN_COMPLETE { $$ = SCTP_CHUNK_TYPE_SHUTDOWN_COMPLETE; }
+			|	ASCONF_ACK	{ $$ = SCTP_CHUNK_TYPE_ASCONF_ACK; }
+			|	FORWARD_TSN	{ $$ = SCTP_CHUNK_TYPE_FORWARD_TSN; }
+			|	ASCONF		{ $$ = SCTP_CHUNK_TYPE_ASCONF; }
+			;
+
+sctp_chunk_common_field	:	TYPE	{ $$ = SCTP_CHUNK_COMMON_TYPE; }
+			|	FLAGS	{ $$ = SCTP_CHUNK_COMMON_FLAGS; }
+			|	LENGTH	{ $$ = SCTP_CHUNK_COMMON_LENGTH; }
+			;
+
+sctp_chunk_data_field	:	TSN	{ $$ = SCTP_CHUNK_DATA_TSN; }
+			|	STREAM	{ $$ = SCTP_CHUNK_DATA_STREAM; }
+			|	SSN	{ $$ = SCTP_CHUNK_DATA_SSN; }
+			|	PPID	{ $$ = SCTP_CHUNK_DATA_PPID; }
+			;
+
+sctp_chunk_init_field	:	INIT_TAG	{ $$ = SCTP_CHUNK_INIT_TAG; }
+			|	A_RWND		{ $$ = SCTP_CHUNK_INIT_RWND; }
+			|	NUM_OSTREAMS	{ $$ = SCTP_CHUNK_INIT_OSTREAMS; }
+			|	NUM_ISTREAMS	{ $$ = SCTP_CHUNK_INIT_ISTREAMS; }
+			|	INIT_TSN	{ $$ = SCTP_CHUNK_INIT_TSN; }
+			;
+
+sctp_chunk_sack_field	:	CUM_TSN_ACK	{ $$ = SCTP_CHUNK_SACK_CTSN_ACK; }
+			|	A_RWND		{ $$ = SCTP_CHUNK_SACK_RWND; }
+			|	NUM_GACK_BLOCKS	{ $$ = SCTP_CHUNK_SACK_GACK_BLOCKS; }
+			|	NUM_DUP_TSNS	{ $$ = SCTP_CHUNK_SACK_DUP_TSNS; }
+			;
+
+sctp_chunk_alloc	:	sctp_chunk_type
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, $1, SCTP_CHUNK_COMMON_TYPE);
+				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+			}
+			|	sctp_chunk_type	sctp_chunk_common_field
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, $1, $2);
+			}
+			|	DATA	sctp_chunk_data_field
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_DATA, $2);
+			}
+			|	INIT	sctp_chunk_init_field
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_INIT, $2);
+			}
+			|	INIT_ACK	sctp_chunk_init_field
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_INIT_ACK, $2);
+			}
+			|	SACK	sctp_chunk_sack_field
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_SACK, $2);
+			}
+			|	SHUTDOWN	CUM_TSN_ACK
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_SHUTDOWN,
+							   SCTP_CHUNK_SHUTDOWN_CTSN_ACK);
+			}
+			|	ECNE	LOWEST_TSN
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_ECNE,
+							   SCTP_CHUNK_ECNE_CWR_MIN_TSN);
+			}
+			|	CWR	LOWEST_TSN
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_CWR,
+							   SCTP_CHUNK_ECNE_CWR_MIN_TSN);
+			}
+			|	ASCONF_ACK	SEQNO
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_ASCONF_ACK,
+							   SCTP_CHUNK_ASCONF_SEQNO);
+			}
+			|	FORWARD_TSN	NEW_CUM_TSN
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_FORWARD_TSN,
+							   SCTP_CHUNK_FORWARD_TSN_NCTSN);
+			}
+			|	ASCONF	SEQNO
+			{
+				$$ = sctp_chunk_expr_alloc(&@$, SCTP_CHUNK_TYPE_ASCONF,
+							   SCTP_CHUNK_ASCONF_SEQNO);
+			}
+			;
+
 sctp_hdr_expr		:	SCTP	sctp_hdr_field	close_scope_sctp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_sctp, $2);
 			}
+			|	SCTP	CHUNK	sctp_chunk_alloc close_scope_sctp_chunk close_scope_sctp
+			{
+				$$ = $3;
+			}
 			;
 
 sctp_hdr_field		:	SPORT		{ $$ = SCTPHDR_SPORT; }
diff --git a/src/parser_json.c b/src/parser_json.c
index ddbf9d9c027b1..32b8a71346c50 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -11,6 +11,7 @@
 #include <netlink.h>
 #include <parser.h>
 #include <rule.h>
+#include <sctp_chunk.h>
 #include <socket.h>
 
 #include <netdb.h>
@@ -707,6 +708,53 @@ static struct expr *json_parse_ip_option_expr(struct json_ctx *ctx,
 	return ipopt_expr_alloc(int_loc, descval, fieldval, 0);
 }
 
+static int json_parse_sctp_chunk_field(const struct exthdr_desc *desc,
+				       const char *name, int *val)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(desc->templates); i++) {
+		if (desc->templates[i].token &&
+		    !strcmp(desc->templates[i].token, name)) {
+			if (val)
+				*val = i;
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static struct expr *json_parse_sctp_chunk_expr(struct json_ctx *ctx,
+					       const char *type, json_t *root)
+{
+	const struct exthdr_desc *desc;
+	const char *name, *field;
+	struct expr *expr;
+	int fieldval;
+
+	if (json_unpack_err(ctx, root, "{s:s}", "name", &name))
+		return NULL;
+
+	desc = sctp_chunk_protocol_find(name);
+	if (!desc) {
+		json_error(ctx, "Unknown sctp chunk name '%s'.", name);
+		return NULL;
+	}
+
+	if (json_unpack(root, "{s:s}", "field", &field)) {
+		expr = sctp_chunk_expr_alloc(int_loc, desc->type,
+					     SCTP_CHUNK_COMMON_TYPE);
+		expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+
+		return expr;
+	}
+	if (json_parse_sctp_chunk_field(desc, field, &fieldval)) {
+		json_error(ctx, "Unknown sctp chunk field '%s'.", field);
+		return NULL;
+	}
+	return sctp_chunk_expr_alloc(int_loc, desc->type, fieldval);
+}
+
 static const struct exthdr_desc *exthdr_lookup_byname(const char *name)
 {
 	const struct exthdr_desc *exthdr_tbl[] = {
@@ -1412,6 +1460,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "exthdr", json_parse_exthdr_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "ip option", json_parse_ip_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
+		{ "sctp chunk", json_parse_sctp_chunk_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "osf", json_parse_osf_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
 		{ "ipsec", json_parse_xfrm_expr, CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
diff --git a/src/scanner.l b/src/scanner.l
index 35603e5e9c884..c058f5f7cdf89 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -213,6 +213,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_NUMGEN
 %s SCANSTATE_EXPR_QUEUE
 %s SCANSTATE_EXPR_RT
+%s SCANSTATE_EXPR_SCTP_CHUNK
 %s SCANSTATE_EXPR_SOCKET
 
 %s SCANSTATE_STMT_LOG
@@ -528,9 +529,46 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "sctp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_SCTP); return SCTP; }
 
 <SCANSTATE_SCTP>{
+	"chunk"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SCTP_CHUNK); return CHUNK; }
 	"vtag"			{ return VTAG; }
 }
 
+<SCANSTATE_EXPR_SCTP_CHUNK>{
+	"data"			{ return DATA; }
+	"init"			{ return INIT; }
+	"init-ack"		{ return INIT_ACK; }
+	"heartbeat"		{ return HEARTBEAT; }
+	"heartbeat-ack"		{ return HEARTBEAT_ACK; }
+	"abort"			{ return ABORT; }
+	"shutdown"		{ return SHUTDOWN; }
+	"shutdown-ack"		{ return SHUTDOWN_ACK; }
+	"error"			{ return ERROR; }
+	"cookie-echo"		{ return COOKIE_ECHO; }
+	"cookie-ack"		{ return COOKIE_ACK; }
+	"ecne"			{ return ECNE; }
+	"cwr"			{ return CWR; }
+	"shutdown-complete"	{ return SHUTDOWN_COMPLETE; }
+	"asconf-ack"		{ return ASCONF_ACK; }
+	"forward-tsn"		{ return FORWARD_TSN; }
+	"asconf"		{ return ASCONF; }
+
+	"tsn"			{ return TSN; }
+	"stream"		{ return STREAM; }
+	"ssn"			{ return SSN; }
+	"ppid"			{ return PPID; }
+	"init-tag"		{ return INIT_TAG; }
+	"a-rwnd"		{ return A_RWND; }
+	"num-outbound-streams"	{ return NUM_OSTREAMS; }
+	"num-inbound-streams"	{ return NUM_ISTREAMS; }
+	"initial-tsn"		{ return INIT_TSN; }
+	"cum-tsn-ack"		{ return CUM_TSN_ACK; }
+	"num-gap-ack-blocks"	{ return NUM_GACK_BLOCKS; }
+	"num-dup-tsns"		{ return NUM_DUP_TSNS; }
+	"lowest-tsn"		{ return LOWEST_TSN; }
+	"seqno"			{ return SEQNO; }
+	"new-cum-tsn"		{ return NEW_CUM_TSN; }
+}
+
 "rt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT; }
 "rt0"			{ return RT0; }
 "rt2"			{ return RT2; }
diff --git a/src/sctp_chunk.c b/src/sctp_chunk.c
new file mode 100644
index 0000000000000..6e73e72f8308b
--- /dev/null
+++ b/src/sctp_chunk.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright Red Hat
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#include <exthdr.h>
+#include <sctp_chunk.h>
+
+#include <string.h>
+
+#define PHT(__token, __offset, __len) \
+	PROTO_HDR_TEMPLATE(__token, &integer_type, BYTEORDER_BIG_ENDIAN, \
+			   __offset, __len)
+
+static const struct exthdr_desc sctp_chunk_data = {
+	.name	= "data",
+	.type	= SCTP_CHUNK_TYPE_DATA,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_DATA_TSN]		= PHT("tsn", 32, 32),
+		[SCTP_CHUNK_DATA_STREAM]	= PHT("stream", 64, 16),
+		[SCTP_CHUNK_DATA_SSN]		= PHT("ssn", 80, 16),
+		[SCTP_CHUNK_DATA_PPID]		= PHT("ppid", 96, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_init = {
+	.name	= "init",
+	.type	= SCTP_CHUNK_TYPE_INIT,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_INIT_TAG]		= PHT("init-tag", 32, 32),
+		[SCTP_CHUNK_INIT_RWND]		= PHT("a-rwnd", 64, 32),
+		[SCTP_CHUNK_INIT_OSTREAMS]	= PHT("num-outbound-streams", 96, 16),
+		[SCTP_CHUNK_INIT_ISTREAMS]	= PHT("num-inbound-streams", 112, 16),
+		[SCTP_CHUNK_INIT_TSN]		= PHT("initial-tsn", 128, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_init_ack = {
+	.name	= "init-ack",
+	.type	= SCTP_CHUNK_TYPE_INIT_ACK,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_INIT_TAG]		= PHT("init-tag", 32, 32),
+		[SCTP_CHUNK_INIT_RWND]		= PHT("a-rwnd", 64, 32),
+		[SCTP_CHUNK_INIT_OSTREAMS]	= PHT("num-outbound-streams", 96, 16),
+		[SCTP_CHUNK_INIT_ISTREAMS]	= PHT("num-inbound-streams", 112, 16),
+		[SCTP_CHUNK_INIT_TSN]		= PHT("initial-tsn", 128, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_sack = {
+	.name	= "sack",
+	.type	= SCTP_CHUNK_TYPE_SACK,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_SACK_CTSN_ACK]	= PHT("cum-tsn-ack", 32, 32),
+		[SCTP_CHUNK_SACK_RWND]		= PHT("a-rwnd", 64, 32),
+		[SCTP_CHUNK_SACK_GACK_BLOCKS]	= PHT("num-gap-ack-blocks", 96, 16),
+		[SCTP_CHUNK_SACK_DUP_TSNS]	= PHT("num-dup-tsns", 112, 16),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_shutdown = {
+	.name	= "shutdown",
+	.type	= SCTP_CHUNK_TYPE_SHUTDOWN,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_SHUTDOWN_CTSN_ACK]	= PHT("cum-tsn-ack", 32, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_ecne = {
+	.name	= "ecne",
+	.type	= SCTP_CHUNK_TYPE_ECNE,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_ECNE_CWR_MIN_TSN]	= PHT("lowest-tsn", 32, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_cwr = {
+	.name	= "cwr",
+	.type	= SCTP_CHUNK_TYPE_CWR,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_ECNE_CWR_MIN_TSN]	= PHT("lowest-tsn", 32, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_asconf_ack = {
+	.name	= "asconf-ack",
+	.type	= SCTP_CHUNK_TYPE_ASCONF_ACK,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_ASCONF_SEQNO]	= PHT("seqno", 32, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_forward_tsn = {
+	.name	= "forward-tsn",
+	.type	= SCTP_CHUNK_TYPE_FORWARD_TSN,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_FORWARD_TSN_NCTSN]	= PHT("new-cum-tsn", 32, 32),
+	},
+};
+
+static const struct exthdr_desc sctp_chunk_asconf = {
+	.name	= "asconf",
+	.type	= SCTP_CHUNK_TYPE_ASCONF,
+	.templates = {
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),
+		[SCTP_CHUNK_ASCONF_SEQNO]	= PHT("seqno", 32, 32),
+	},
+};
+
+#define SCTP_CHUNK_DESC_GENERATOR(descname, hname, desctype)		\
+static const struct exthdr_desc sctp_chunk_##descname = {		\
+	.name	= #hname,						\
+	.type	= SCTP_CHUNK_TYPE_##desctype,				\
+	.templates = {							\
+		[SCTP_CHUNK_COMMON_TYPE]	= PHT("type", 0, 8),	\
+		[SCTP_CHUNK_COMMON_FLAGS]	= PHT("flags", 8, 8),	\
+		[SCTP_CHUNK_COMMON_LENGTH]	= PHT("length", 16, 16),\
+	},								\
+};
+
+SCTP_CHUNK_DESC_GENERATOR(heartbeat, heartbeat, HEARTBEAT)
+SCTP_CHUNK_DESC_GENERATOR(heartbeat_ack, heartbeat-ack, HEARTBEAT_ACK)
+SCTP_CHUNK_DESC_GENERATOR(abort, abort, ABORT)
+SCTP_CHUNK_DESC_GENERATOR(shutdown_ack, shutdown-ack, SHUTDOWN_ACK)
+SCTP_CHUNK_DESC_GENERATOR(error, error, ERROR)
+SCTP_CHUNK_DESC_GENERATOR(cookie_echo, cookie-echo, COOKIE_ECHO)
+SCTP_CHUNK_DESC_GENERATOR(cookie_ack, cookie-ack, COOKIE_ACK)
+SCTP_CHUNK_DESC_GENERATOR(shutdown_complete, shutdown-complete, SHUTDOWN_COMPLETE)
+
+#undef SCTP_CHUNK_DESC_GENERATOR
+
+static const struct exthdr_desc *sctp_chunk_protocols[] = {
+	[SCTP_CHUNK_TYPE_DATA]			= &sctp_chunk_data,
+	[SCTP_CHUNK_TYPE_INIT]			= &sctp_chunk_init,
+	[SCTP_CHUNK_TYPE_INIT_ACK]		= &sctp_chunk_init_ack,
+	[SCTP_CHUNK_TYPE_SACK]			= &sctp_chunk_sack,
+	[SCTP_CHUNK_TYPE_HEARTBEAT]		= &sctp_chunk_heartbeat,
+	[SCTP_CHUNK_TYPE_HEARTBEAT_ACK]		= &sctp_chunk_heartbeat_ack,
+	[SCTP_CHUNK_TYPE_ABORT]			= &sctp_chunk_abort,
+	[SCTP_CHUNK_TYPE_SHUTDOWN]		= &sctp_chunk_shutdown,
+	[SCTP_CHUNK_TYPE_SHUTDOWN_ACK]		= &sctp_chunk_shutdown_ack,
+	[SCTP_CHUNK_TYPE_ERROR]			= &sctp_chunk_error,
+	[SCTP_CHUNK_TYPE_COOKIE_ECHO]		= &sctp_chunk_cookie_echo,
+	[SCTP_CHUNK_TYPE_COOKIE_ACK]		= &sctp_chunk_cookie_ack,
+	[SCTP_CHUNK_TYPE_ECNE]			= &sctp_chunk_ecne,
+	[SCTP_CHUNK_TYPE_CWR]			= &sctp_chunk_cwr,
+	[SCTP_CHUNK_TYPE_SHUTDOWN_COMPLETE]	= &sctp_chunk_shutdown_complete,
+	[SCTP_CHUNK_TYPE_ASCONF_ACK]		= &sctp_chunk_asconf_ack,
+	[SCTP_CHUNK_TYPE_FORWARD_TSN]		= &sctp_chunk_forward_tsn,
+	[SCTP_CHUNK_TYPE_ASCONF]		= &sctp_chunk_asconf,
+};
+
+const struct exthdr_desc *sctp_chunk_protocol_find(const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(sctp_chunk_protocols); i++) {
+		if (sctp_chunk_protocols[i] &&
+		    !strcmp(sctp_chunk_protocols[i]->name, name))
+			return sctp_chunk_protocols[i];
+	}
+	return NULL;
+}
+
+struct expr *sctp_chunk_expr_alloc(const struct location *loc,
+				   unsigned int type, unsigned int field)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct exthdr_desc *desc = NULL;
+	struct expr *expr;
+
+	if (type < array_size(sctp_chunk_protocols))
+		desc = sctp_chunk_protocols[type];
+
+	if (!desc)
+		return NULL;
+
+	tmpl = &desc->templates[field];
+	if (!tmpl)
+		return NULL;
+
+	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
+			  BYTEORDER_BIG_ENDIAN, tmpl->len);
+	expr->exthdr.desc	= desc;
+	expr->exthdr.tmpl	= tmpl;
+	expr->exthdr.op		= NFT_EXTHDR_OP_SCTP;
+	expr->exthdr.raw_type	= desc->type;
+	expr->exthdr.offset	= tmpl->offset;
+
+	return expr;
+}
+
+void sctp_chunk_init_raw(struct expr *expr, uint8_t type, unsigned int off,
+			 unsigned int len, uint32_t flags)
+{
+	const struct proto_hdr_template *tmpl;
+	unsigned int i;
+
+	assert(expr->etype == EXPR_EXTHDR);
+
+	expr->len = len;
+	expr->exthdr.flags = flags;
+	expr->exthdr.offset = off;
+	expr->exthdr.op = NFT_EXTHDR_OP_SCTP;
+
+	if (flags & NFT_EXTHDR_F_PRESENT)
+		datatype_set(expr, &boolean_type);
+	else
+		datatype_set(expr, &integer_type);
+
+	if (type >= array_size(sctp_chunk_protocols))
+		return;
+
+	expr->exthdr.desc = sctp_chunk_protocols[type];
+	expr->exthdr.flags = flags;
+	assert(expr->exthdr.desc != NULL);
+
+	for (i = 0; i < array_size(expr->exthdr.desc->templates); ++i) {
+		tmpl = &expr->exthdr.desc->templates[i];
+		if (tmpl->offset != off || tmpl->len != len)
+			continue;
+
+		if ((flags & NFT_EXTHDR_F_PRESENT) == 0)
+			datatype_set(expr, tmpl->dtype);
+
+		expr->exthdr.tmpl = tmpl;
+		break;
+	}
+}
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 5188b57e65085..3d1c2fd6cd2f7 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -41,3 +41,40 @@ sctp vtag {33, 55, 67, 88};ok
 sctp vtag != {33, 55, 67, 88};ok
 sctp vtag { 33-55};ok
 sctp vtag != { 33-55};ok
+
+# assert all chunk types are recognized
+sctp chunk data exists;ok
+sctp chunk init exists;ok
+sctp chunk init-ack exists;ok
+sctp chunk sack exists;ok
+sctp chunk heartbeat exists;ok
+sctp chunk heartbeat-ack exists;ok
+sctp chunk abort exists;ok
+sctp chunk shutdown exists;ok
+sctp chunk shutdown-ack exists;ok
+sctp chunk error exists;ok
+sctp chunk cookie-echo exists;ok
+sctp chunk cookie-ack exists;ok
+sctp chunk ecne exists;ok
+sctp chunk cwr exists;ok
+sctp chunk shutdown-complete exists;ok
+sctp chunk asconf-ack exists;ok
+sctp chunk forward-tsn exists;ok
+sctp chunk asconf exists;ok
+
+# test common header fields in random chunk types
+sctp chunk data type 0;ok
+sctp chunk init flags 23;ok
+sctp chunk init-ack length 42;ok
+
+# test one custom field in every applicable chunk type
+sctp chunk data stream 1337;ok
+sctp chunk init initial-tsn 5;ok
+sctp chunk init-ack num-outbound-streams 3;ok
+sctp chunk sack a-rwnd 1;ok
+sctp chunk shutdown cum-tsn-ack 65535;ok
+sctp chunk ecne lowest-tsn 5;ok
+sctp chunk cwr lowest-tsn 8;ok
+sctp chunk asconf-ack seqno 12345;ok
+sctp chunk forward-tsn new-cum-tsn 31337;ok
+sctp chunk asconf seqno 12345;ok
diff --git a/tests/py/inet/sctp.t.json b/tests/py/inet/sctp.t.json
index 2684b0349a71b..8135686230129 100644
--- a/tests/py/inet/sctp.t.json
+++ b/tests/py/inet/sctp.t.json
@@ -608,3 +608,481 @@
     }
 ]
 
+# sctp chunk data exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "data"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk init exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "init"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk init-ack exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "init-ack"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk sack exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "sack"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk heartbeat exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "heartbeat"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk heartbeat-ack exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "heartbeat-ack"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk abort exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "abort"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk shutdown exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "shutdown"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk shutdown-ack exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "shutdown-ack"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk error exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "error"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk cookie-echo exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "cookie-echo"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk cookie-ack exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "cookie-ack"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk ecne exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "ecne"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk cwr exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "cwr"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk shutdown-complete exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "shutdown-complete"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk asconf-ack exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "asconf-ack"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk forward-tsn exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "forward-tsn"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk asconf exists
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "name": "asconf"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# sctp chunk data type 0
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "type",
+                    "name": "data"
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    }
+]
+
+# sctp chunk init flags 23
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "flags",
+                    "name": "init"
+                }
+            },
+            "op": "==",
+            "right": 23
+        }
+    }
+]
+
+# sctp chunk init-ack length 42
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "length",
+                    "name": "init-ack"
+                }
+            },
+            "op": "==",
+            "right": 42
+        }
+    }
+]
+
+# sctp chunk data stream 1337
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "stream",
+                    "name": "data"
+                }
+            },
+            "op": "==",
+            "right": 1337
+        }
+    }
+]
+
+# sctp chunk init initial-tsn 5
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "initial-tsn",
+                    "name": "init"
+                }
+            },
+            "op": "==",
+            "right": 5
+        }
+    }
+]
+
+# sctp chunk init-ack num-outbound-streams 3
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "num-outbound-streams",
+                    "name": "init-ack"
+                }
+            },
+            "op": "==",
+            "right": 3
+        }
+    }
+]
+
+# sctp chunk sack a-rwnd 1
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "a-rwnd",
+                    "name": "sack"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# sctp chunk shutdown cum-tsn-ack 65535
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "cum-tsn-ack",
+                    "name": "shutdown"
+                }
+            },
+            "op": "==",
+            "right": 65535
+        }
+    }
+]
+
+# sctp chunk ecne lowest-tsn 5
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "lowest-tsn",
+                    "name": "ecne"
+                }
+            },
+            "op": "==",
+            "right": 5
+        }
+    }
+]
+
+# sctp chunk cwr lowest-tsn 8
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "lowest-tsn",
+                    "name": "cwr"
+                }
+            },
+            "op": "==",
+            "right": 8
+        }
+    }
+]
+
+# sctp chunk asconf-ack seqno 12345
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "seqno",
+                    "name": "asconf-ack"
+                }
+            },
+            "op": "==",
+            "right": 12345
+        }
+    }
+]
+
+# sctp chunk forward-tsn new-cum-tsn 31337
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "new-cum-tsn",
+                    "name": "forward-tsn"
+                }
+            },
+            "op": "==",
+            "right": 31337
+        }
+    }
+]
+
+# sctp chunk asconf seqno 12345
+[
+    {
+        "match": {
+            "left": {
+                "sctp chunk": {
+                    "field": "seqno",
+                    "name": "asconf"
+                }
+            },
+            "op": "==",
+            "right": 12345
+        }
+    }
+]
+
diff --git a/tests/py/inet/sctp.t.payload b/tests/py/inet/sctp.t.payload
index ecfcc7252a066..9c4854cfe71c3 100644
--- a/tests/py/inet/sctp.t.payload
+++ b/tests/py/inet/sctp.t.payload
@@ -274,3 +274,158 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# sctp chunk data exists
+ip
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk init exists
+ip
+  [ exthdr load 1b @ 1 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk init-ack exists
+ip
+  [ exthdr load 1b @ 2 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk sack exists
+ip
+  [ exthdr load 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk heartbeat exists
+ip
+  [ exthdr load 1b @ 4 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk heartbeat-ack exists
+ip
+  [ exthdr load 1b @ 5 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk abort exists
+ip
+  [ exthdr load 1b @ 6 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk shutdown exists
+ip
+  [ exthdr load 1b @ 7 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk shutdown-ack exists
+ip
+  [ exthdr load 1b @ 8 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk error exists
+ip
+  [ exthdr load 1b @ 9 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk cookie-echo exists
+ip
+  [ exthdr load 1b @ 10 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk cookie-ack exists
+ip
+  [ exthdr load 1b @ 11 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk ecne exists
+ip
+  [ exthdr load 1b @ 12 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk cwr exists
+ip
+  [ exthdr load 1b @ 13 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk shutdown-complete exists
+ip
+  [ exthdr load 1b @ 14 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk asconf-ack exists
+ip
+  [ exthdr load 1b @ 128 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk forward-tsn exists
+ip
+  [ exthdr load 1b @ 192 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk asconf exists
+ip
+  [ exthdr load 1b @ 193 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# sctp chunk data type 0
+ip
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# sctp chunk init flags 23
+ip
+  [ exthdr load 1b @ 1 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000017 ]
+
+# sctp chunk init-ack length 42
+ip
+  [ exthdr load 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00002a00 ]
+
+# sctp chunk data stream 1337
+ip
+  [ exthdr load 2b @ 0 + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00003905 ]
+
+# sctp chunk init initial-tsn 5
+ip
+  [ exthdr load 4b @ 1 + 16 => reg 1 ]
+  [ cmp eq reg 1 0x05000000 ]
+
+# sctp chunk init-ack num-outbound-streams 3
+ip
+  [ exthdr load 2b @ 2 + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000300 ]
+
+# sctp chunk sack a-rwnd 1
+ip
+  [ exthdr load 4b @ 3 + 8 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# sctp chunk shutdown cum-tsn-ack 65535
+ip
+  [ exthdr load 4b @ 7 + 4 => reg 1 ]
+  [ cmp eq reg 1 0xffff0000 ]
+
+# sctp chunk ecne lowest-tsn 5
+ip
+  [ exthdr load 4b @ 12 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x05000000 ]
+
+# sctp chunk cwr lowest-tsn 8
+ip
+  [ exthdr load 4b @ 13 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x08000000 ]
+
+# sctp chunk asconf-ack seqno 12345
+ip
+  [ exthdr load 4b @ 128 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x39300000 ]
+
+# sctp chunk forward-tsn new-cum-tsn 31337
+ip
+  [ exthdr load 4b @ 192 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x697a0000 ]
+
+# sctp chunk asconf seqno 12345
+ip
+  [ exthdr load 4b @ 193 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x39300000 ]
+
-- 
2.31.0

