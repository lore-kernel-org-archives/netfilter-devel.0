From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/6] ct: add packet/byte counter support
Date: Fri,  8 Jan 2016 10:42:48 +0100
Message-ID: <1452246171-13943-4-git-send-email-fw@strlen.de>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47937 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103AbcAHJuk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:40 -0500
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

packets and bytes need special treatment -- we want to be able to get
packet/byte counter in either direction, but also express
'fetch in *BOTH* directions', i.e.

ct packets original + ct packets reply > 1000

This either requires a '+' expression, a new 'both' direction, or
keys where direction is optional, i.e.

ct packets > 12345	; original + reply
ct original packets > 12345 ; original

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/ct.c                            | 4 ++++
 src/parser_bison.y                  | 8 +++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 70a9619..49de2b8 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -744,6 +744,8 @@ enum nft_ct_keys {
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
 	NFT_CT_LABELS,
+	NFT_CT_PKTS,
+	NFT_CT_BYTES,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index ff6cd61..b971ba1 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -203,6 +203,10 @@ static const struct ct_template ct_templates[] = {
 	[NFT_CT_LABELS]		= CT_TEMPLATE("label", &ct_label_type,
 					      BYTEORDER_HOST_ENDIAN,
 					      CT_LABEL_BIT_SIZE),
+	[NFT_CT_BYTES]		= CT_TEMPLATE("bytes", &integer_type,
+					      BYTEORDER_HOST_ENDIAN, 64),
+	[NFT_CT_PKTS]		= CT_TEMPLATE("packets", &integer_type,
+					      BYTEORDER_HOST_ENDIAN, 64),
 };
 
 static void ct_expr_print(const struct expr *expr)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0ba6f7c..7690ecc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -567,7 +567,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
-%type <val>			ct_key		ct_key_dir
+%type <val>			ct_key		ct_key_dir	ct_key_counters
 
 %type <val>			export_format
 %type <string>			monitor_event
@@ -2290,6 +2290,7 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
 			|	HELPER		{ $$ = NFT_CT_HELPER; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
+			|	ct_key_counters
 			;
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	DADDR		{ $$ = NFT_CT_DST; }
@@ -2297,6 +2298,11 @@ ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
+			|	ct_key_counters
+			;
+
+ct_key_counters		:	BYTES		{ $$ = NFT_CT_BYTES; }
+			|	PACKETS		{ $$ = NFT_CT_PKTS; }
 			;
 
 ct_stmt			:	CT	ct_key		SET	expr
-- 
2.4.10

