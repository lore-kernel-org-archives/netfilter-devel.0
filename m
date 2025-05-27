Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBF41FCFFB
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375742; cv=none; b=UgL/yMwrHoWGyh2XjsyMvjjB+ld6decmT50cyqXSVMGOCtGHHd+Gbaijw3gPFAml7gblEm10SYN/PewyBw15zAKBe2nAT34xlJtf4L37TOU93wuAFGnD2Z6Jl2hFMT1Q4JxQcxcN38sKXrQkarrlEC/Wpu0+p8OKxVBM264Mg5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375742; c=relaxed/simple;
	bh=pd4CcXG0MY0uiYE2Heig4Moh2oOnjWfd7JTzmmh23XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luHtyhl1BWPkOMlULPnuEI+yGKBfiPwtBGiJb6vv1lWalX2h2cXnhfeFrmrzmphHPBKcQQlXFRieFhBFkA102+b8O0Hy0JuwUZdC8WKEG5uqMuMmYPXGIGfOCCWSk3xfet8R12fWl9ajkdThXQJxz1Rseu7UFbr3dVz4p46ja4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=neVcQw4m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aA+SMpSP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=neVcQw4m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aA+SMpSP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="neVcQw4m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aA+SMpSP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="neVcQw4m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aA+SMpSP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 41D4D21E0E;
	Tue, 27 May 2025 19:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhbeDwMd0bMb2Gtt2bD+05LVLI1vTUJ2dmywGXjMvjo=;
	b=neVcQw4mP38hAS4AEjj4wsTI0ZIpD5Q/Ft9wGV93Rk1+hYbjHgqSZORcqoWEGdsVKmIAI2
	JxAGR83r18+tn0zufPRNRaj5GyENGJLkKHJFk7xS9sRMAaYrGNZ/n2+ldZMVoiKCnt5vhz
	RZx9BFy46SvLs25WIMnvihgHKXf7mEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhbeDwMd0bMb2Gtt2bD+05LVLI1vTUJ2dmywGXjMvjo=;
	b=aA+SMpSPaijUVI5n8rXwvmonLlihFrDOvdVE5wCWGSvuM6X3ApGf/aj3zZY4RBDQK1FFFe
	lFCqARAMhnRzyrAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhbeDwMd0bMb2Gtt2bD+05LVLI1vTUJ2dmywGXjMvjo=;
	b=neVcQw4mP38hAS4AEjj4wsTI0ZIpD5Q/Ft9wGV93Rk1+hYbjHgqSZORcqoWEGdsVKmIAI2
	JxAGR83r18+tn0zufPRNRaj5GyENGJLkKHJFk7xS9sRMAaYrGNZ/n2+ldZMVoiKCnt5vhz
	RZx9BFy46SvLs25WIMnvihgHKXf7mEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhbeDwMd0bMb2Gtt2bD+05LVLI1vTUJ2dmywGXjMvjo=;
	b=aA+SMpSPaijUVI5n8rXwvmonLlihFrDOvdVE5wCWGSvuM6X3ApGf/aj3zZY4RBDQK1FFFe
	lFCqARAMhnRzyrAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC6AF136E0;
	Tue, 27 May 2025 19:55:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wBJ+NrQYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:32 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7 nft] src: add tunnel statement and expression support
Date: Tue, 27 May 2025 21:54:40 +0200
Message-ID: <c5b88cb62515cf544f3c633425eb1cfa2fb09e57.1748374810.git.fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748374810.git.fmancera@suse.de>
References: <cover.1748374810.git.fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.978];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,netfilter.org:email,suse.de:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch allows you to attach tunnel metadata through the tunnel
statement.

The following example shows how to redirect traffic to the erspan0
tunnel device which will take the tunnel configuration that is
specified by the ruleset.

     table netdev x {
            tunnel y {
                    id 10
                    ip saddr 192.168.2.10
                    ip daddr 192.168.2.11
                    sport 10
                    dport 20
                    ttl 10
                    erspan {
                            version 1
                            index 2
                    }
            }

	    chain x {
		    type filter hook ingress device veth0 priority 0;

		    ip daddr 10.141.10.123 tunnel name y fwd to erspan0
	    }
     }

This patch also allows to match on tunnel metadata via tunnel expression.

Joint work with Fernando.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Makefile.am               |  2 ++
 include/expression.h      |  6 ++++
 include/tunnel.h          | 33 +++++++++++++++++
 src/evaluate.c            |  7 ++++
 src/expression.c          |  1 +
 src/netlink_delinearize.c | 17 +++++++++
 src/netlink_linearize.c   | 14 ++++++++
 src/parser_bison.y        | 33 ++++++++++++++---
 src/scanner.l             |  3 +-
 src/statement.c           |  1 +
 src/tunnel.c              | 76 +++++++++++++++++++++++++++++++++++++++
 11 files changed, 187 insertions(+), 6 deletions(-)
 create mode 100644 include/tunnel.h
 create mode 100644 src/tunnel.c

diff --git a/Makefile.am b/Makefile.am
index fb64105d..092b130c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -99,6 +99,7 @@ noinst_HEADERS = \
 	include/socket.h \
 	include/statement.h \
 	include/tcpopt.h \
+	include/tunnel.h \
 	include/utils.h \
 	include/xfrm.h \
 	include/xt.h \
@@ -241,6 +242,7 @@ src_libnftables_la_SOURCES = \
 	src/socket.c \
 	src/statement.c \
 	src/tcpopt.c \
+	src/tunnel.c \
 	src/utils.c \
 	src/xfrm.c \
 	$(NULL)
diff --git a/include/expression.h b/include/expression.h
index f42a0c2b..96c9a512 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -77,6 +77,7 @@ enum expr_types {
 	EXPR_NUMGEN,
 	EXPR_HASH,
 	EXPR_RT,
+	EXPR_TUNNEL,
 	EXPR_FIB,
 	EXPR_XFRM,
 	EXPR_SET_ELEM_CATCHALL,
@@ -229,6 +230,7 @@ enum expr_flags {
 #include <hash.h>
 #include <ct.h>
 #include <socket.h>
+#include <tunnel.h>
 #include <osf.h>
 #include <xfrm.h>
 
@@ -358,6 +360,10 @@ struct expr {
 			enum nft_socket_keys	key;
 			uint32_t		level;
 		} socket;
+		struct {
+			/* EXPR_TUNNEL */
+			enum nft_tunnel_keys	key;
+		} tunnel;
 		struct {
 			/* EXPR_RT */
 			enum nft_rt_keys	key;
diff --git a/include/tunnel.h b/include/tunnel.h
new file mode 100644
index 00000000..9e6bd97a
--- /dev/null
+++ b/include/tunnel.h
@@ -0,0 +1,33 @@
+#ifndef NFTABLES_TUNNEL_H
+#define NFTABLES_TUNNEL_H
+
+/**
+ * struct tunnel_template - template for tunnel expressions
+ *
+ * @token:	parser token for the expression
+ * @dtype:	data type of the expression
+ * @len:	length of the expression
+ * @byteorder:	byteorder
+ */
+struct tunnel_template {
+	const char		*token;
+	const struct datatype	*dtype;
+	enum byteorder		byteorder;
+	unsigned int		len;
+};
+
+extern const struct tunnel_template tunnel_templates[];
+
+#define TUNNEL_TEMPLATE(__token, __dtype, __len, __byteorder) {	\
+	.token		= (__token),				\
+	.dtype		= (__dtype),				\
+	.len		= (__len),				\
+	.byteorder	= (__byteorder),			\
+}
+
+extern struct expr *tunnel_expr_alloc(const struct location *loc,
+				      enum nft_tunnel_keys key);
+
+extern const struct expr_ops tunnel_expr_ops;
+
+#endif /* NFTABLES_TUNNEL_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 84c150d8..323b11c1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2936,6 +2936,11 @@ static int expr_evaluate_osf(struct eval_ctx *ctx, struct expr **expr)
 	return expr_evaluate_primary(ctx, expr);
 }
 
+static int expr_evaluate_tunnel(struct eval_ctx *ctx, struct expr **exprp)
+{
+	return expr_evaluate_primary(ctx, exprp);
+}
+
 static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct symbol *sym = (*exprp)->sym;
@@ -3037,6 +3042,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_meta(ctx, expr);
 	case EXPR_SOCKET:
 		return expr_evaluate_socket(ctx, expr);
+	case EXPR_TUNNEL:
+		return expr_evaluate_tunnel(ctx, expr);
 	case EXPR_OSF:
 		return expr_evaluate_osf(ctx, expr);
 	case EXPR_FIB:
diff --git a/src/expression.c b/src/expression.c
index dc9a4467..25388dd6 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1761,6 +1761,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_NUMGEN: return &numgen_expr_ops;
 	case EXPR_HASH: return &hash_expr_ops;
 	case EXPR_RT: return &rt_expr_ops;
+	case EXPR_TUNNEL: return &tunnel_expr_ops;
 	case EXPR_FIB: return &fib_expr_ops;
 	case EXPR_XFRM: return &xfrm_expr_ops;
 	case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 48a3e33a..486a58ae 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -940,6 +940,21 @@ static void netlink_parse_osf(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_tunnel(struct netlink_parse_ctx *ctx,
+				 const struct location *loc,
+				 const struct nftnl_expr *nle)
+{
+	enum nft_registers dreg;
+	struct expr * expr;
+	uint32_t key;
+
+	key = nftnl_expr_get_u32(nle, NFTNL_EXPR_TUNNEL_KEY);
+	expr = tunnel_expr_alloc(loc, key);
+
+	dreg = netlink_parse_register(nle, NFTNL_EXPR_TUNNEL_DREG);
+	netlink_set_register(ctx, dreg, expr);
+}
+
 static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nftnl_expr *nle)
@@ -1922,6 +1937,7 @@ static const struct expr_handler netlink_parsers[] = {
 	{ .name = "exthdr",	.parse = netlink_parse_exthdr },
 	{ .name = "meta",	.parse = netlink_parse_meta },
 	{ .name = "socket",	.parse = netlink_parse_socket },
+	{ .name = "tunnel",	.parse = netlink_parse_tunnel },
 	{ .name = "osf",	.parse = netlink_parse_osf },
 	{ .name = "rt",		.parse = netlink_parse_rt },
 	{ .name = "ct",		.parse = netlink_parse_ct },
@@ -3023,6 +3039,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_NUMGEN:
 	case EXPR_FIB:
 	case EXPR_SOCKET:
+	case EXPR_TUNNEL:
 	case EXPR_OSF:
 	case EXPR_XFRM:
 		break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5f73183b..adb28402 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -334,6 +334,18 @@ static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
+static void netlink_gen_tunnel(struct netlink_linearize_ctx *ctx,
+			       const struct expr *expr,
+			       enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("tunnel");
+	netlink_put_register(nle, NFTNL_EXPR_TUNNEL_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_TUNNEL_KEY, expr->tunnel.key);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
@@ -932,6 +944,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_fib(ctx, expr, dreg);
 	case EXPR_SOCKET:
 		return netlink_gen_socket(ctx, expr, dreg);
+	case EXPR_TUNNEL:
+		return netlink_gen_tunnel(ctx, expr, dreg);
 	case EXPR_OSF:
 		return netlink_gen_osf(ctx, expr, dreg);
 	case EXPR_XFRM:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9ba6e8f2..e533370a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -320,6 +320,8 @@ int nft_lex(void *, void *, void *);
 %token RULESET			"ruleset"
 %token TRACE			"trace"
 
+%token PATH			"path"
+
 %token INET			"inet"
 %token NETDEV			"netdev"
 
@@ -778,8 +780,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %type <stmt>			limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
 %destructor { stmt_free($$); }	limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
-%type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
-%destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
+%type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_stmt_tunnel
+%destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_stmt_tunnel
 
 %type <stmt>			payload_stmt
 %destructor { stmt_free($$); }	payload_stmt
@@ -939,9 +941,9 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	mh_hdr_expr
 %type <val>			mh_hdr_field
 
-%type <expr>			meta_expr
-%destructor { expr_free($$); }	meta_expr
-%type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type
+%type <expr>			meta_expr	tunnel_expr
+%destructor { expr_free($$); }	meta_expr	tunnel_expr
+%type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type	tunnel_key
 
 %type <expr>			socket_expr
 %destructor { expr_free($$); } socket_expr
@@ -3203,6 +3205,14 @@ objref_stmt_synproxy	: 	SYNPROXY	NAME	stmt_expr close_scope_synproxy
 			}
 			;
 
+objref_stmt_tunnel	:	TUNNEL	NAME	stmt_expr	close_scope_tunnel
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_TUNNEL;
+				$$->objref.expr = $3;
+			}
+			;
+
 objref_stmt_ct		:	CT	TIMEOUT		SET	stmt_expr	close_scope_ct
 			{
 				$$ = objref_stmt_alloc(&@$);
@@ -3223,6 +3233,7 @@ objref_stmt		:	objref_stmt_counter
 			|	objref_stmt_quota
 			|	objref_stmt_synproxy
 			|	objref_stmt_ct
+			|	objref_stmt_tunnel
 			;
 
 stateful_stmt		:	counter_stmt	close_scope_counter
@@ -3901,6 +3912,7 @@ primary_stmt_expr	:	symbol_expr			{ $$ = $1; }
 			|	boolean_expr			{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
 			|	rt_expr				{ $$ = $1; }
+			|	tunnel_expr			{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
 			|	numgen_expr             	{ $$ = $1; }
 			|	hash_expr               	{ $$ = $1; }
@@ -4377,6 +4389,7 @@ selector_expr		:	payload_expr			{ $$ = $1; }
 			|	exthdr_expr			{ $$ = $1; }
 			|	exthdr_exists_expr		{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
+			|	tunnel_expr			{ $$ = $1; }
 			|	socket_expr			{ $$ = $1; }
 			|	rt_expr				{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
@@ -5471,6 +5484,16 @@ socket_key 		: 	TRANSPARENT	{ $$ = NFT_SOCKET_TRANSPARENT; }
 			|	WILDCARD	{ $$ = NFT_SOCKET_WILDCARD; }
 			;
 
+tunnel_key		:	PATH		{ $$ = NFT_TUNNEL_PATH; }
+			|	ID		{ $$ = NFT_TUNNEL_ID; }
+			;
+
+tunnel_expr		:	TUNNEL	tunnel_key
+			{
+				$$ = tunnel_expr_alloc(&@$, $2);
+			}
+			;
+
 offset_opt		:	/* empty */	{ $$ = 0; }
 			|	OFFSET	NUM	{ $$ = $2; }
 			;
diff --git a/src/scanner.l b/src/scanner.l
index c5c394b7..7d1fae0c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -410,7 +410,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
-<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF>"name"			{ return NAME; }
+<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"			{ return NAME; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
 
@@ -822,6 +822,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"erspan"		{ return ERSPAN; }
 	"egress"		{ return EGRESS; }
 	"ingress"		{ return INGRESS; }
+	"path"			{ return PATH; }
 }
 
 "notrack"		{ return NOTRACK; }
diff --git a/src/statement.c b/src/statement.c
index 695b57a6..19bc7db4 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -289,6 +289,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_QUOTA]	= "quota",
 	[NFT_OBJECT_CT_HELPER]	= "ct helper",
 	[NFT_OBJECT_LIMIT]	= "limit",
+	[NFT_OBJECT_TUNNEL]	= "tunnel",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
 	[NFT_OBJECT_SYNPROXY]	= "synproxy",
diff --git a/src/tunnel.c b/src/tunnel.c
new file mode 100644
index 00000000..d03f853a
--- /dev/null
+++ b/src/tunnel.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2018 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <errno.h>
+#include <limits.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <net/if.h>
+#include <net/if_arp.h>
+#include <pwd.h>
+#include <grp.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <linux/pkt_sched.h>
+#include <linux/if_packet.h>
+
+#include <nftables.h>
+#include <expression.h>
+#include <datatype.h>
+#include <tunnel.h>
+#include <gmputil.h>
+#include <utils.h>
+#include <erec.h>
+
+const struct tunnel_template tunnel_templates[] = {
+	[NFT_TUNNEL_PATH]	= META_TEMPLATE("path", &boolean_type,
+						BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
+	[NFT_TUNNEL_ID]		= META_TEMPLATE("id",  &integer_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
+};
+
+static void tunnel_expr_print(const struct expr *expr, struct output_ctx *octx)
+{
+	nft_print(octx, "tunnel %s",
+		  tunnel_templates[expr->tunnel.key].token);
+}
+
+static bool tunnel_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->tunnel.key == e2->tunnel.key;
+}
+
+static void tunnel_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->tunnel.key = expr->tunnel.key;
+}
+
+const struct expr_ops tunnel_expr_ops = {
+	.type		= EXPR_TUNNEL,
+	.name		= "tunnel",
+	.print		= tunnel_expr_print,
+	.cmp		= tunnel_expr_cmp,
+	.clone		= tunnel_expr_clone,
+};
+
+struct expr *tunnel_expr_alloc(const struct location *loc,
+			       enum nft_tunnel_keys key)
+{
+	const struct tunnel_template *tmpl = &tunnel_templates[key];
+	struct expr *expr;
+
+	expr = expr_alloc(loc, EXPR_TUNNEL, tmpl->dtype, tmpl->byteorder,
+			  tmpl->len);
+	expr->tunnel.key = key;
+
+	return expr;
+}
-- 
2.49.0

