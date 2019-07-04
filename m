Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDBAC5B578
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 00:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05EF2187F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 00:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkZGYVdH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfGDAbM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 20:31:12 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:44321 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfGDAbM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 20:31:12 -0400
Received: by mail-oi1-f179.google.com with SMTP id e189so3544712oib.11
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 17:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=64fUeKKiHMzNusGItlRf0DOrC+YH1MhO/9lNMguEWY0=;
        b=WkZGYVdHEEOwrp4TIVUH6cGbZBj5ZIN1UcDn9TbuUXWQZhu/yl7PR0LgQnlS6uPZxc
         XdHHAK2pyIIWurqxxXCuRXUPgYiyPfYJOIQ6B/6vMeuiN0wpX0TlezO93kWQOvGyEhq9
         SA7HqyeCXqmW9AOpgiWE1Bg7XKtxtaRlpTKEpyRZ8Wfw3RToqM4IdO1cOzM6KGylaWAJ
         +ZRuG2h+vMMdmCoBGeSzeiqUcsNOCdtEnjuJBLe+AdaBZZq8GwXl0sOy2Fg0tt1T/8K7
         3AlxP7CQ73Dowei0b1DQ/Y+pc6ScDdbq2tuFyyHZW804A7p1Q/G+WNDdu89+l2f7Bt8f
         4LzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=64fUeKKiHMzNusGItlRf0DOrC+YH1MhO/9lNMguEWY0=;
        b=M/d/9zlB20LCY9FhlhDobv3tc03Hfj1cIDja5esMRUCr0INsSD8wbjPrrb65akKf2p
         +VzvMYeOe5tJ/7lma/pZZ/O/jIRC0+eoxujKbzFFZy7ouB+XbP+pr03JcMrJaG45AyrR
         PFkEBGA0qeVHGL7R0mzWgxUM9IsEbx0aiackfFpQM2hMLmeXQMu0HgnUozHPPrQe0d4x
         Jf4JsyHdm9goZ+T+AtFdatwcEuyQZ53FeHcHuhBu0qsTL21T5WLFPLE9TTNqnR0HwrUC
         2sbJ7mUdTRERLv0Uft+chUCC1StT491rNBQV/gnuLSZ/iADHnREPkwePJBb/W26+Cyu0
         x9dg==
X-Gm-Message-State: APjAAAVI+fu142MgcGF/+GXKmu2vGhuGtrEL0h7lphwcEmhh/3bnq3bw
        OA5DkFe9hqKTAciLd6Slozd451W3LQ==
X-Google-Smtp-Source: APXvYqx2+7xC4nNHYmPubNwJQvm6kop8VbBOvWPs8et1GzPPmd0Y64ReVgrBgN00IheM8Zu9doHdxg==
X-Received: by 2002:aca:dad7:: with SMTP id r206mr248528oig.34.1562200267300;
        Wed, 03 Jul 2019 17:31:07 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id 103sm1296386otu.33.2019.07.03.17.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 17:31:06 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nftables v4] exthdr: doc: add support for matching IPv4 options
Date:   Wed,  3 Jul 2019 20:30:52 -0400
Message-Id: <20190704003052.469-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the userspace change for the overall changes with this
description:
Add capability to have rules matching IPv4 options. This is developed
mainly to support dropping of IP packets with loose and/or strict source
route route options.

v2: Removed options that aren't supported in the kernel (per Pablo Neira
    Ayuso).
v3: Updated ipv6 exthdr payload to match libnftnl changes (feedback from
    Pablo Neira Ayuso).
v4: Add json support.
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 doc/payload-expression.txt          |  29 +-
 include/Makefile.am                 |   1 +
 include/exthdr.h                    |   1 +
 include/ipopt.h                     |  29 ++
 include/linux/netfilter/nf_tables.h |   2 +
 src/Makefile.am                     |   1 +
 src/evaluate.c                      |  17 +
 src/exthdr.c                        |  22 +-
 src/ipopt.c                         | 159 ++++++
 src/json.c                          |   8 +
 src/parser_bison.y                  |  31 ++
 src/parser_json.c                   |  61 +++
 src/payload.c                       |   4 +
 src/scanner.l                       |   8 +
 tests/py/ip/ipopt.t                 |  24 +
 tests/py/ip/ipopt.t.json            | 720 ++++++++++++++++++++++++++++
 tests/py/ip/ipopt.t.payload         | 150 ++++++
 tests/py/ip6/dst.t.payload.inet     |  40 +-
 tests/py/ip6/dst.t.payload.ip6      |  40 +-
 tests/py/ip6/exthdr.t.payload.ip6   |  24 +-
 tests/py/ip6/frag.t.payload.inet    |  70 +--
 tests/py/ip6/frag.t.payload.ip6     |  70 +--
 tests/py/ip6/hbh.t.payload.inet     |  40 +-
 tests/py/ip6/hbh.t.payload.ip6      |  40 +-
 tests/py/ip6/mh.t.payload.inet      |  82 ++--
 tests/py/ip6/mh.t.payload.ip6       |  82 ++--
 tests/py/ip6/rt.t.payload.inet      |  76 +--
 tests/py/ip6/rt.t.payload.ip6       |  76 +--
 tests/py/ip6/srh.t.payload          |  22 +-
 29 files changed, 1594 insertions(+), 335 deletions(-)
 create mode 100644 include/ipopt.h
 create mode 100644 src/ipopt.c
 create mode 100644 tests/py/ip/ipopt.t
 create mode 100644 tests/py/ip/ipopt.t.json
 create mode 100644 tests/py/ip/ipopt.t.payload

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index ebbffe5..b98a607 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -506,9 +506,9 @@ input meta iifname enp2s0 arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh
 
 EXTENSION HEADER EXPRESSIONS
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Extension header expressions refer to data from variable-sized protocol headers, such as IPv6 extension headers and TCP options.
+Extension header expressions refer to data from variable-sized protocol headers, such as IPv6 extension headers, TCP options and IPv4 options.
 
-nftables currently supports matching (finding) a given ipv6 extension header or TCP option.
+nftables currently supports matching (finding) a given ipv6 extension header, TCP option or IPv4 option.
 [verse]
 *hbh* {*nexthdr* | *hdrlength*}
 *frag* {*nexthdr* | *frag-off* | *more-fragments* | *id*}
@@ -517,11 +517,13 @@ nftables currently supports matching (finding) a given ipv6 extension header or
 *mh* {*nexthdr* | *hdrlength* | *checksum* | *type*}
 *srh* {*flags* | *tag* | *sid* | *seg-left*}
 *tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
+*ip option* { lsrr | ra | rr | ssrr } 'ip_option_field'
 
 The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
 [verse]
 *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
 *tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
+*ip option* { lsrr | ra | rr | ssrr }
 
 .IPv6 extension headers
 [options="header"]
@@ -580,6 +582,24 @@ TCP Timestamps |
 kind, length, tsval, tsecr
 |============================
 
+.IP Options
+[options="header"]
+|==================
+|Keyword| Description | IP option fields
+|lsrr|
+Loose Source Route |
+type, length, ptr, addr
+|ra|
+Router Alert |
+type, length, value
+|rr|
+Record Route |
+type, length, ptr, addr
+|ssrr|
+Strict Source Route |
+type, length, ptr, addr
+|============================
+
 .finding TCP options
 --------------------
 filter input tcp option sack-permitted kind 1 counter
@@ -590,6 +610,11 @@ filter input tcp option sack-permitted kind 1 counter
 ip6 filter input frag more-fragments 1 counter
 ---------------------------------------
 
+.finding IP option
+------------------
+filter input ip option lsrr exists counter
+---------------------------------------
+
 CONNTRACK EXPRESSIONS
 ~~~~~~~~~~~~~~~~~~~~~
 Conntrack expressions refer to meta data of the connection tracking entry associated with a packet. +
diff --git a/include/Makefile.am b/include/Makefile.am
index 2d77a76..04a4a61 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -7,6 +7,7 @@ noinst_HEADERS = 	cli.h		\
 			expression.h	\
 			fib.h		\
 			hash.h		\
+			ipopt.h		\
 			json.h		\
 			mini-gmp.h	\
 			gmputil.h	\
diff --git a/include/exthdr.h b/include/exthdr.h
index 32f99c9..3959a65 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -3,6 +3,7 @@
 
 #include <proto.h>
 #include <tcpopt.h>
+#include <ipopt.h>
 
 /**
  * struct exthdr_desc - extension header description
diff --git a/include/ipopt.h b/include/ipopt.h
new file mode 100644
index 0000000..d8d4806
--- /dev/null
+++ b/include/ipopt.h
@@ -0,0 +1,29 @@
+#ifndef NFTABLES_IPOPT_H
+#define NFTABLES_IPOPT_H
+
+#include <proto.h>
+#include <exthdr.h>
+#include <statement.h>
+
+extern struct expr *ipopt_expr_alloc(const struct location *loc,
+				      uint8_t type, uint8_t field, uint8_t ptr);
+
+extern void ipopt_init_raw(struct expr *expr, uint8_t type,
+			    unsigned int offset, unsigned int len,
+			    uint32_t flags, bool set_unknown);
+
+extern bool ipopt_find_template(struct expr *expr, unsigned int offset,
+			  unsigned int len);
+
+enum ipopt_fields {
+	IPOPT_FIELD_INVALID,
+	IPOPT_FIELD_TYPE,
+	IPOPT_FIELD_LENGTH,
+	IPOPT_FIELD_VALUE,
+	IPOPT_FIELD_PTR,
+	IPOPT_FIELD_ADDR_0,
+};
+
+extern const struct exthdr_desc *ipopt_protocols[UINT8_MAX];
+
+#endif /* NFTABLES_IPOPT_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 7bdb234..393bcb5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -730,10 +730,12 @@ enum nft_exthdr_flags {
  *
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
  * @NFT_EXTHDR_OP_TCP: match against tcp options
+ * @NFT_EXTHDR_OP_IPV4: match against ip options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
+	NFT_EXTHDR_OP_IPV4,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/src/Makefile.am b/src/Makefile.am
index fd64175..f4f8d83 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -62,6 +62,7 @@ libnftables_la_SOURCES =			\
 		nfnl_osf.c			\
 		tcpopt.c			\
 		socket.c			\
+		ipopt.c			\
 		libnftables.c
 
 # yacc and lex generate dirty code
diff --git a/src/evaluate.c b/src/evaluate.c
index 19c2d4c..8086f75 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -513,6 +513,20 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 					  totlen, max_tcpoptlen);
 		break;
 	}
+	case NFT_EXTHDR_OP_IPV4: {
+		static const unsigned int max_ipoptlen = 40 * BITS_PER_BYTE;
+		unsigned int totlen = 0;
+
+		totlen += expr->exthdr.tmpl->offset;
+		totlen += expr->exthdr.tmpl->len;
+		totlen += expr->exthdr.offset;
+
+		if (totlen > max_ipoptlen)
+			return expr_error(ctx->msgs, expr,
+					  "offset and size %u exceeds max ip option len (%u)",
+					  totlen, max_ipoptlen);
+		break;
+	}
 	default:
 		break;
 	}
@@ -537,6 +551,9 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 		dependency = &proto_tcp;
 		pb = PROTO_BASE_TRANSPORT_HDR;
 		break;
+	case NFT_EXTHDR_OP_IPV4:
+		dependency = &proto_ip;
+		break;
 	case NFT_EXTHDR_OP_IPV6:
 	default:
 		dependency = &proto_ip6;
diff --git a/src/exthdr.c b/src/exthdr.c
index c9c2bf5..e1ec6f3 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -38,6 +38,11 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		if (offset)
 			nft_print(octx, "%d", offset);
 		nft_print(octx, " %s", expr->exthdr.tmpl->token);
+	} else if (expr->exthdr.op == NFT_EXTHDR_OP_IPV4) {
+		nft_print(octx, "ip option %s", expr->exthdr.desc->name);
+		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
+			return;
+		nft_print(octx, " %s", expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			nft_print(octx, "exthdr %s", expr->exthdr.desc->name);
@@ -172,6 +177,8 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 	assert(expr->etype == EXPR_EXTHDR);
 	if (op == NFT_EXTHDR_OP_TCPOPT)
 		return tcpopt_init_raw(expr, type, offset, len, flags);
+	if (op == NFT_EXTHDR_OP_IPV4)
+		return ipopt_init_raw(expr, type, offset, len, flags, true);
 
 	expr->len = len;
 	expr->exthdr.flags = flags;
@@ -222,7 +229,8 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 {
 	unsigned int off, mask_offset, mask_len;
 
-	if (expr->exthdr.tmpl != &exthdr_unknown_template)
+	if (expr->exthdr.op != NFT_EXTHDR_OP_IPV4 &&
+	    expr->exthdr.tmpl != &exthdr_unknown_template)
 		return false;
 
 	/* In case we are handling tcp options instead of the default ipv6
@@ -237,8 +245,18 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 	off = expr->exthdr.offset;
 	off += round_up(mask->len, BITS_PER_BYTE) - mask_len;
 
+	/* Handle ip options after the offset and mask have been calculated. */
+	if (expr->exthdr.op == NFT_EXTHDR_OP_IPV4) {
+		if (ipopt_find_template(expr, off, mask_len - mask_offset)) {
+			*shift = mask_offset;
+			return true;
+		} else {
+			return false;
+		}
+	}
+
 	exthdr_init_raw(expr, expr->exthdr.desc->type,
-			off, mask_len - mask_offset, NFT_EXTHDR_OP_IPV6, 0);
+			off, mask_len - mask_offset, expr->exthdr.op, 0);
 
 	/* still failed to find a template... Bug. */
 	if (expr->exthdr.tmpl == &exthdr_unknown_template)
diff --git a/src/ipopt.c b/src/ipopt.c
new file mode 100644
index 0000000..b3d0279
--- /dev/null
+++ b/src/ipopt.c
@@ -0,0 +1,159 @@
+#include <stdint.h>
+
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+
+#include <utils.h>
+#include <headers.h>
+#include <expression.h>
+#include <ipopt.h>
+
+static const struct proto_hdr_template ipopt_unknown_template =
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, BYTEORDER_INVALID, 0, 0);
+
+#define PHT(__token, __offset, __len) \
+	PROTO_HDR_TEMPLATE(__token, &integer_type, BYTEORDER_BIG_ENDIAN, \
+			   __offset, __len)
+static const struct exthdr_desc ipopt_lsrr = {
+	.name		= "lsrr",
+	.type		= IPOPT_LSRR,
+	.templates	= {
+		[IPOPT_FIELD_TYPE]		= PHT("type",    0,  8),
+		[IPOPT_FIELD_LENGTH]		= PHT("length",  8,  8),
+		[IPOPT_FIELD_PTR]		= PHT("ptr",    16,  8),
+		[IPOPT_FIELD_ADDR_0]		= PHT("addr",   24, 32),
+	},
+};
+
+static const struct exthdr_desc ipopt_rr = {
+	.name		= "rr",
+	.type		= IPOPT_RR,
+	.templates	= {
+		[IPOPT_FIELD_TYPE]		= PHT("type",   0,   8),
+		[IPOPT_FIELD_LENGTH]		= PHT("length",  8,  8),
+		[IPOPT_FIELD_PTR]		= PHT("ptr",    16,  8),
+		[IPOPT_FIELD_ADDR_0]		= PHT("addr",   24, 32),
+	},
+};
+
+static const struct exthdr_desc ipopt_ssrr = {
+	.name		= "ssrr",
+	.type		= IPOPT_SSRR,
+	.templates	= {
+		[IPOPT_FIELD_TYPE]		= PHT("type",   0,   8),
+		[IPOPT_FIELD_LENGTH]		= PHT("length",  8,  8),
+		[IPOPT_FIELD_PTR]		= PHT("ptr",    16,  8),
+		[IPOPT_FIELD_ADDR_0]		= PHT("addr",   24, 32),
+	},
+};
+
+static const struct exthdr_desc ipopt_ra = {
+	.name		= "ra",
+	.type		= IPOPT_RA,
+	.templates	= {
+		[IPOPT_FIELD_TYPE]		= PHT("type",   0,   8),
+		[IPOPT_FIELD_LENGTH]		= PHT("length", 8,   8),
+		[IPOPT_FIELD_VALUE]		= PHT("value",  16, 16),
+	},
+};
+
+const struct exthdr_desc *ipopt_protocols[UINT8_MAX] = {
+	[IPOPT_LSRR]		= &ipopt_lsrr,
+	[IPOPT_RR]		= &ipopt_rr,
+	[IPOPT_SSRR]		= &ipopt_ssrr,
+	[IPOPT_RA]		= &ipopt_ra,
+};
+
+static unsigned int calc_offset(const struct exthdr_desc *desc,
+				const struct proto_hdr_template *tmpl,
+				unsigned int arg)
+{
+	if (!desc || tmpl == &ipopt_unknown_template)
+		return 0;
+
+	switch (desc->type) {
+	case IPOPT_RR:
+	case IPOPT_LSRR:
+	case IPOPT_SSRR:
+		if (tmpl == &desc->templates[IPOPT_FIELD_ADDR_0])
+			return (tmpl->offset < 24) ? 0 : arg;
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+struct expr *ipopt_expr_alloc(const struct location *loc, uint8_t type,
+			       uint8_t field, uint8_t ptr)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct exthdr_desc *desc;
+	struct expr *expr;
+
+	desc = ipopt_protocols[type];
+	tmpl = &desc->templates[field];
+	if (!tmpl)
+		return NULL;
+
+	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
+			  BYTEORDER_BIG_ENDIAN, tmpl->len);
+	expr->exthdr.desc   = desc;
+	expr->exthdr.tmpl   = tmpl;
+	expr->exthdr.op     = NFT_EXTHDR_OP_IPV4;
+	expr->exthdr.offset = calc_offset(desc, tmpl, ptr);
+
+	return expr;
+}
+
+void ipopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
+		     unsigned int len, uint32_t flags, bool set_unknown)
+{
+	const struct proto_hdr_template *tmpl;
+	unsigned int i;
+
+	assert(expr->etype == EXPR_EXTHDR);
+
+	expr->len = len;
+	expr->exthdr.flags = flags;
+	expr->exthdr.offset = offset;
+
+	assert(type < array_size(ipopt_protocols));
+	expr->exthdr.desc = ipopt_protocols[type];
+	expr->exthdr.flags = flags;
+
+	for (i = 0; i < array_size(expr->exthdr.desc->templates); ++i) {
+		tmpl = &expr->exthdr.desc->templates[i];
+
+		/* Make sure that it's the right template based on offset and len */
+		if (tmpl->offset != offset || tmpl->len != len)
+			continue;
+
+		if (flags & NFT_EXTHDR_F_PRESENT)
+			expr->dtype = &boolean_type;
+		else
+			expr->dtype = tmpl->dtype;
+		expr->exthdr.tmpl = tmpl;
+		expr->exthdr.op   = NFT_EXTHDR_OP_IPV4;
+		break;
+	}
+	if (i == array_size(expr->exthdr.desc->templates) && set_unknown) {
+		expr->exthdr.tmpl = &ipopt_unknown_template;
+		expr->exthdr.op   = NFT_EXTHDR_OP_IPV4;
+	}
+}
+
+bool ipopt_find_template(struct expr *expr, unsigned int offset,
+			  unsigned int len)
+{
+	if (expr->exthdr.tmpl != &ipopt_unknown_template)
+		return false;
+
+	ipopt_init_raw(expr, expr->exthdr.desc->type, offset, len, 0, false);
+
+	if (expr->exthdr.tmpl == &ipopt_unknown_template)
+		return false;
+
+	return true;
+}
diff --git a/src/json.c b/src/json.c
index 4e64684..291f14c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -634,6 +634,14 @@ json_t *exthdr_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 		return json_pack("{s:o}", "tcp option", root);
 	}
+	if (expr->exthdr.op == NFT_EXTHDR_OP_IPV4) {
+		root = json_pack("{s:s}", "name", desc);
+
+		if (!is_exists)
+			json_object_set_new(root, "field", json_string(field));
+
+		return json_pack("{s:o}", "ip option", root);
+	}
 
 	root = json_pack("{s:s}",
 			 "name", desc);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 670e91f..f518a24 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -308,6 +308,14 @@ int nft_lex(void *, void *, void *);
 %token PROTOCOL			"protocol"
 %token CHECKSUM			"checksum"
 
+%token PTR			"ptr"
+%token VALUE			"value"
+
+%token LSRR			"lsrr"
+%token RR			"rr"
+%token SSRR			"ssrr"
+%token RA			"ra"
+
 %token ICMP			"icmp"
 %token CODE			"code"
 %token SEQUENCE			"seq"
@@ -697,6 +705,7 @@ int nft_lex(void *, void *, void *);
 %type <expr>			ip_hdr_expr	icmp_hdr_expr		igmp_hdr_expr numgen_expr	hash_expr
 %destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		igmp_hdr_expr numgen_expr	hash_expr
 %type <val>			ip_hdr_field	icmp_hdr_field		igmp_hdr_field
+%type <val>			ip_option_type	ip_option_field
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
 %destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
 %type <val>			ip6_hdr_field   icmp6_hdr_field
@@ -4244,6 +4253,15 @@ ip_hdr_expr		:	IP	ip_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ip, $2);
 			}
+			|	IP	OPTION	ip_option_type ip_option_field
+			{
+				$$ = ipopt_expr_alloc(&@$, $3, $4, 0);
+			}
+			|	IP	OPTION	ip_option_type
+			{
+				$$ = ipopt_expr_alloc(&@$, $3, IPOPT_FIELD_TYPE, 0);
+				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+			}
 			;
 
 ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
@@ -4260,6 +4278,19 @@ ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	DADDR		{ $$ = IPHDR_DADDR; }
 			;
 
+ip_option_type		:	LSRR		{ $$ = IPOPT_LSRR; }
+			|	RR		{ $$ = IPOPT_RR; }
+			|	SSRR		{ $$ = IPOPT_SSRR; }
+			|	RA		{ $$ = IPOPT_RA; }
+			;
+
+ip_option_field		:	TYPE		{ $$ = IPOPT_FIELD_TYPE; }
+			|	LENGTH		{ $$ = IPOPT_FIELD_LENGTH; }
+			|	VALUE		{ $$ = IPOPT_FIELD_VALUE; }
+			|	PTR		{ $$ = IPOPT_FIELD_PTR; }
+			|	ADDR		{ $$ = IPOPT_FIELD_ADDR_0; }
+			;
+
 icmp_hdr_expr		:	ICMP	icmp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_icmp, $2);
diff --git a/src/parser_json.c b/src/parser_json.c
index 30b1717..f701ebd 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -587,6 +587,66 @@ static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
 	return tcpopt_expr_alloc(int_loc, descval, fieldval);
 }
 
+static int json_parse_ip_option_type(const char *name, int *val)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(ipopt_protocols); i++) {
+		if (ipopt_protocols[i] &&
+		    !strcmp(ipopt_protocols[i]->name, name)) {
+			if (val)
+				*val = i;
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static int json_parse_ip_option_field(int type, const char *name, int *val)
+{
+	unsigned int i;
+	const struct exthdr_desc *desc = ipopt_protocols[type];
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
+static struct expr *json_parse_ip_option_expr(struct json_ctx *ctx,
+					       const char *type, json_t *root)
+{
+	const char *desc, *field;
+	int descval, fieldval;
+	struct expr *expr;
+
+	if (json_unpack_err(ctx, root, "{s:s}", "name", &desc))
+		return NULL;
+
+	if (json_parse_ip_option_type(desc, &descval)) {
+		json_error(ctx, "Unknown ip option name '%s'.", desc);
+		return NULL;
+	}
+
+	if (json_unpack(root, "{s:s}", "field", &field)) {
+		expr = ipopt_expr_alloc(int_loc, descval,
+					 IPOPT_FIELD_TYPE, 0);
+		expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+
+		return expr;
+	}
+	if (json_parse_ip_option_field(descval, field, &fieldval)) {
+		json_error(ctx, "Unknown ip option field '%s'.", field);
+		return NULL;
+	}
+	return ipopt_expr_alloc(int_loc, descval, fieldval, 0);
+}
+
 static const struct exthdr_desc *exthdr_lookup_byname(const char *name)
 {
 	const struct exthdr_desc *exthdr_tbl[] = {
@@ -1291,6 +1351,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "payload", json_parse_payload_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP },
 		{ "exthdr", json_parse_exthdr_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
 		{ "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES },
+		{ "ip option", json_parse_ip_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES },
 		{ "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP },
 		{ "osf", json_parse_osf_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_MAP },
 		{ "ipsec", json_parse_xfrm_expr, CTX_F_PRIMARY | CTX_F_MAP },
diff --git a/src/payload.c b/src/payload.c
index 7e4f935..3bf1ecc 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -542,6 +542,10 @@ void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 		if (payload_dependency_exists(ctx, PROTO_BASE_NETWORK_HDR))
 			payload_dependency_release(ctx);
 		break;
+	case NFT_EXTHDR_OP_IPV4:
+		if (payload_dependency_exists(ctx, PROTO_BASE_NETWORK_HDR))
+			payload_dependency_release(ctx);
+		break;
 	default:
 		break;
 	}
diff --git a/src/scanner.l b/src/scanner.l
index d1f6e87..2cd3253 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -401,6 +401,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "protocol"		{ return PROTOCOL; }
 "checksum"		{ return CHECKSUM; }
 
+"lsrr"			{ return LSRR; }
+"rr"			{ return RR; }
+"ssrr"			{ return SSRR; }
+"ra"			{ return RA; }
+
+"value"			{ return VALUE; }
+"ptr"			{ return PTR; }
+
 "echo"			{ return ECHO; }
 "eol"			{ return EOL; }
 "maxseg"		{ return MAXSEG; }
diff --git a/tests/py/ip/ipopt.t b/tests/py/ip/ipopt.t
new file mode 100644
index 0000000..161fcc4
--- /dev/null
+++ b/tests/py/ip/ipopt.t
@@ -0,0 +1,24 @@
+:input;type filter hook input priority 0
+
+*ip;test-ipopt;input
+
+ip option lsrr type 1;ok
+ip option lsrr length 1;ok
+ip option lsrr ptr 1;ok
+ip option lsrr addr 1;ok
+ip option rr type 1;ok
+ip option rr length 1;ok
+ip option rr ptr 1;ok
+ip option rr addr 1;ok
+ip option ssrr type 1;ok
+ip option ssrr length 1;ok
+ip option ssrr ptr 1;ok
+ip option ssrr addr 1;ok
+ip option ra type 1;ok
+ip option ra length 1;ok
+ip option ra value 1;ok
+
+ip option foobar;fail
+ip option foo bar;fail
+ip option lsrr type;fail
+ip option lsrr flag 1;fail
diff --git a/tests/py/ip/ipopt.t.json b/tests/py/ip/ipopt.t.json
new file mode 100644
index 0000000..d00ac0f
--- /dev/null
+++ b/tests/py/ip/ipopt.t.json
@@ -0,0 +1,720 @@
+# ip option lsrr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra value 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "value",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra value 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "value",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option lsrr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "lsrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option rr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "rr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr ptr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "ptr",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ssrr addr 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "addr",
+                    "name": "ssrr"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra type 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "type",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra length 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "length",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ip option ra value 1
+[
+    {
+        "match": {
+            "left": {
+                "ip option": {
+                    "field": "value",
+                    "name": "ra"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
diff --git a/tests/py/ip/ipopt.t.payload b/tests/py/ip/ipopt.t.payload
new file mode 100644
index 0000000..7be197f
--- /dev/null
+++ b/tests/py/ip/ipopt.t.payload
@@ -0,0 +1,150 @@
+# ip option lsrr type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 131 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option lsrr length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 131 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option lsrr ptr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 131 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option lsrr addr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 4b @ 131 + 3 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip option rr type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 7 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option rr length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 7 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option rr ptr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 7 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option rr addr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 4b @ 7 + 3 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip option ssrr type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 137 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ssrr length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 137 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ssrr ptr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 137 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ssrr addr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 4b @ 137 + 3 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip option ra type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 148 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ra length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 148 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ra value 1
+ip test-ipopt input 
+  [ exthdr load ipv4 2b @ 148 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# ip option lsrr type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 131 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option lsrr length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 131 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option lsrr ptr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 131 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option lsrr addr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 4b @ 131 + 3 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip option rr type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 7 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option rr length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 7 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option rr ptr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 7 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option rr addr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 4b @ 7 + 3 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip option ssrr type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 137 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ssrr length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 137 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ssrr ptr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 137 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ssrr addr 1
+ip test-ipopt input 
+  [ exthdr load ipv4 4b @ 137 + 3 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# ip option ra type 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 148 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ra length 1
+ip test-ipopt input 
+  [ exthdr load ipv4 1b @ 148 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# ip option ra value 1
+ip test-ipopt input 
+  [ exthdr load ipv4 2b @ 148 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 768b4f1..ff22237 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -2,21 +2,21 @@
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # dst nexthdr != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # dst nexthdr 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -24,7 +24,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst nexthdr { 33, 55, 67, 88}
@@ -34,7 +34,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { 33, 55, 67, 88}
@@ -44,7 +44,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr { 33-55}
@@ -54,7 +54,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { 33-55}
@@ -64,7 +64,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -74,7 +74,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -84,42 +84,42 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # dst nexthdr != icmp
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # dst hdrlength 22
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # dst hdrlength != 233
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # dst hdrlength 33-45
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -127,7 +127,7 @@ ip6 test-ip6 input
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst hdrlength { 33, 55, 67, 88}
@@ -137,7 +137,7 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst hdrlength != { 33, 55, 67, 88}
@@ -147,7 +147,7 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst hdrlength { 33-55}
@@ -157,7 +157,7 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst hdrlength != { 33-55}
@@ -167,6 +167,6 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index 56afc12..9bf564c 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -1,22 +1,22 @@
 # dst nexthdr 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # dst nexthdr != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # dst nexthdr 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # dst nexthdr != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst nexthdr { 33, 55, 67, 88}
@@ -24,7 +24,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { 33, 55, 67, 88}
@@ -32,7 +32,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr { 33-55}
@@ -40,7 +40,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { 33-55}
@@ -48,7 +48,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -56,7 +56,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -64,38 +64,38 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst nexthdr icmp
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # dst nexthdr != icmp
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # dst hdrlength 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # dst hdrlength != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # dst hdrlength 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # dst hdrlength != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst hdrlength { 33, 55, 67, 88}
@@ -103,7 +103,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst hdrlength != { 33, 55, 67, 88}
@@ -111,7 +111,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dst hdrlength { 33-55}
@@ -119,7 +119,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # dst hdrlength != { 33-55}
@@ -127,7 +127,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 
diff --git a/tests/py/ip6/exthdr.t.payload.ip6 b/tests/py/ip6/exthdr.t.payload.ip6
index 3b6bb62..be10d61 100644
--- a/tests/py/ip6/exthdr.t.payload.ip6
+++ b/tests/py/ip6/exthdr.t.payload.ip6
@@ -1,60 +1,60 @@
 # exthdr hbh exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr rt exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr frag exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 44 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr dst exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 60 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 60 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr mh exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr hbh missing
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # exthdr hbh == exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr hbh == missing
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # exthdr hbh != exists
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # exthdr hbh != missing
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # exthdr hbh 1
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # exthdr hbh 0
 ip6 test-ip6 input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 0630533..ef44f1a 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -2,14 +2,14 @@
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
 
 # frag nexthdr != icmp
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
@@ -19,7 +19,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
@@ -29,42 +29,42 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag nexthdr esp
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
 
 # frag nexthdr ah
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
 
 # frag reserved 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # frag reserved != 233
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # frag reserved 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -72,7 +72,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved { 33, 55, 67, 88}
@@ -82,7 +82,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag reserved != { 33, 55, 67, 88}
@@ -92,7 +92,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag reserved { 33-55}
@@ -102,7 +102,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag reserved != { 33-55}
@@ -112,14 +112,14 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag frag-off 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000b000 ]
 
@@ -127,7 +127,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00004807 ]
 
@@ -135,7 +135,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000801 ]
   [ cmp lte reg 1 0x00006801 ]
@@ -144,7 +144,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ range neq reg 1 0x00000801 0x00006801 ]
 
@@ -155,7 +155,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
@@ -166,7 +166,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -177,7 +177,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
@@ -188,7 +188,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -196,7 +196,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
@@ -204,28 +204,28 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # frag id 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # frag id != 33
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp neq reg 1 0x21000000 ]
 
 # frag id 33-45
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
   [ cmp lte reg 1 0x2d000000 ]
 
@@ -233,7 +233,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # frag id { 33, 55, 67, 88}
@@ -243,7 +243,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag id != { 33, 55, 67, 88}
@@ -253,7 +253,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag id { 33-55}
@@ -263,7 +263,7 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag id != { 33-55}
@@ -273,14 +273,14 @@ __set%d test-inet 0
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag reserved2 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
@@ -288,7 +288,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
@@ -296,7 +296,7 @@ inet test-inet output
 inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index 6e86b8a..940fb9f 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -1,11 +1,11 @@
 # frag nexthdr tcp
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
 
 # frag nexthdr != icmp
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
@@ -13,7 +13,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
@@ -21,38 +21,38 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag nexthdr esp
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
 
 # frag nexthdr ah
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
 
 # frag reserved 22
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # frag reserved != 233
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # frag reserved 33-45
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # frag reserved != 33-45
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved { 33, 55, 67, 88}
@@ -60,7 +60,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag reserved != { 33, 55, 67, 88}
@@ -68,7 +68,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag reserved { 33-55}
@@ -76,7 +76,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag reserved != { 33-55}
@@ -84,31 +84,31 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag frag-off 22
 ip6 test-ip6 output
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000b000 ]
 
 # frag frag-off != 233
 ip6 test-ip6 output
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00004807 ]
 
 # frag frag-off 33-45
 ip6 test-ip6 output
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000801 ]
   [ cmp lte reg 1 0x00006801 ]
 
 # frag frag-off != 33-45
 ip6 test-ip6 output
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ range neq reg 1 0x00000801 0x00006801 ]
 
@@ -117,7 +117,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
@@ -126,7 +126,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
@@ -135,7 +135,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
 ip6 test-ip6 output 
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
@@ -144,40 +144,40 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
 ip6 test-ip6 output 
-  [ exthdr load 2b @ 44 + 2 => reg 1 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag more-fragments 1
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # frag id 1
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # frag id 22
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp eq reg 1 0x16000000 ]
 
 # frag id != 33
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp neq reg 1 0x21000000 ]
 
 # frag id 33-45
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ cmp gte reg 1 0x21000000 ]
   [ cmp lte reg 1 0x2d000000 ]
 
 # frag id != 33-45
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # frag id { 33, 55, 67, 88}
@@ -185,7 +185,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag id != { 33, 55, 67, 88}
@@ -193,7 +193,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag id { 33-55}
@@ -201,7 +201,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # frag id != { 33-55}
@@ -209,24 +209,24 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
 ip6 test-ip6 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag reserved2 1
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
 # frag more-fragments 0
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # frag more-fragments 1
 ip6 test-ip6 output
-  [ exthdr load 1b @ 44 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index cf7e353..e358351 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -2,21 +2,21 @@
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # hbh hdrlength != 233
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # hbh hdrlength 33-45
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -24,7 +24,7 @@ inet test-inet filter-input
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh hdrlength {33, 55, 67, 88}
@@ -34,7 +34,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength != {33, 55, 67, 88}
@@ -44,7 +44,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh hdrlength { 33-55}
@@ -54,7 +54,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength != { 33-55}
@@ -64,7 +64,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
@@ -74,7 +74,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
@@ -84,28 +84,28 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr 22
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # hbh nexthdr != 233
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # hbh nexthdr 33-45
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -113,7 +113,7 @@ inet test-inet filter-input
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh nexthdr {33, 55, 67, 88}
@@ -123,7 +123,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != {33, 55, 67, 88}
@@ -133,7 +133,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr { 33-55}
@@ -143,7 +143,7 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != { 33-55}
@@ -153,20 +153,20 @@ __set%d test-inet 0
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr ip
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # hbh nexthdr != ip
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index 93522c4..a4b131a 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -1,22 +1,22 @@
 # hbh hdrlength 22
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # hbh hdrlength != 233
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # hbh hdrlength 33-45
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # hbh hdrlength != 33-45
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh hdrlength {33, 55, 67, 88}
@@ -24,7 +24,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength != {33, 55, 67, 88}
@@ -32,7 +32,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh hdrlength { 33-55}
@@ -40,7 +40,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh hdrlength != { 33-55}
@@ -48,7 +48,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
@@ -56,7 +56,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
@@ -64,28 +64,28 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr 22
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # hbh nexthdr != 233
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # hbh nexthdr 33-45
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # hbh nexthdr != 33-45
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh nexthdr {33, 55, 67, 88}
@@ -93,7 +93,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != {33, 55, 67, 88}
@@ -101,7 +101,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr { 33-55}
@@ -109,7 +109,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # hbh nexthdr != { 33-55}
@@ -117,16 +117,16 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # hbh nexthdr ip
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # hbh nexthdr != ip
 ip6 test-ip6 filter-input
-  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 24335b1..2c473fb 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -2,14 +2,14 @@
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # mh nexthdr != 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
@@ -19,7 +19,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
@@ -29,42 +29,42 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # mh nexthdr != icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh nexthdr != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh nexthdr 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -72,7 +72,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
@@ -82,7 +82,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { 33, 55, 67, 88 }
@@ -92,7 +92,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh nexthdr { 33-55 }
@@ -102,7 +102,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { 33-55 }
@@ -112,28 +112,28 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh hdrlength != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh hdrlength 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -141,7 +141,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
@@ -151,7 +151,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh hdrlength != { 33, 55, 67, 88 }
@@ -161,7 +161,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh hdrlength { 33-55 }
@@ -171,7 +171,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh hdrlength != { 33-55 }
@@ -181,7 +181,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
@@ -191,42 +191,42 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh type home-agent-switch-message
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000000c ]
 
 # mh type != home-agent-switch-message
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000000c ]
 
 # mh reserved 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh reserved != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh reserved 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -234,7 +234,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh reserved { 33, 55, 67, 88}
@@ -244,7 +244,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh reserved != { 33, 55, 67, 88}
@@ -254,7 +254,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh reserved { 33-55}
@@ -264,7 +264,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh reserved != { 33-55}
@@ -274,28 +274,28 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh checksum 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # mh checksum != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # mh checksum 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
@@ -303,7 +303,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # mh checksum { 33, 55, 67, 88}
@@ -313,7 +313,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh checksum != { 33, 55, 67, 88}
@@ -323,7 +323,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh checksum { 33-55}
@@ -333,7 +333,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh checksum != { 33-55}
@@ -343,6 +343,6 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index d19b6e6..93744da 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -1,11 +1,11 @@
 # mh nexthdr 1
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # mh nexthdr != 1
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
@@ -13,7 +13,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp }
@@ -21,38 +21,38 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh nexthdr icmp
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # mh nexthdr != icmp
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # mh nexthdr 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh nexthdr != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh nexthdr 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # mh nexthdr != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
@@ -60,7 +60,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { 33, 55, 67, 88 }
@@ -68,7 +68,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh nexthdr { 33-55 }
@@ -76,7 +76,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh nexthdr != { 33-55 }
@@ -84,28 +84,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh hdrlength 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh hdrlength != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh hdrlength 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # mh hdrlength != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
@@ -113,7 +113,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh hdrlength != { 33, 55, 67, 88 }
@@ -121,7 +121,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh hdrlength { 33-55 }
@@ -129,7 +129,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh hdrlength != { 33-55 }
@@ -137,7 +137,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
@@ -145,38 +145,38 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000001  : 0 [end]	element 00000002  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 0 [end]	element 00000008  : 0 [end]	element 00000009  : 0 [end]	element 0000000a  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh type home-agent-switch-message
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000000c ]
 
 # mh type != home-agent-switch-message
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 2 => reg 1 ]
   [ cmp neq reg 1 0x0000000c ]
 
 # mh reserved 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # mh reserved != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # mh reserved 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # mh reserved != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh reserved { 33, 55, 67, 88}
@@ -184,7 +184,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh reserved != { 33, 55, 67, 88}
@@ -192,7 +192,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh reserved { 33-55}
@@ -200,7 +200,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh reserved != { 33-55}
@@ -208,28 +208,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 135 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh checksum 22
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
 
 # mh checksum != 233
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
 # mh checksum 33-45
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
 # mh checksum != 33-45
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # mh checksum { 33, 55, 67, 88}
@@ -237,7 +237,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh checksum != { 33, 55, 67, 88}
@@ -245,7 +245,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # mh checksum { 33-55}
@@ -253,7 +253,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # mh checksum != { 33-55}
@@ -261,6 +261,6 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 2b @ 135 + 4 => reg 1 ]
+  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index 8fb717f..eafb4a0 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -2,14 +2,14 @@
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # rt nexthdr != 1
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -19,7 +19,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -29,42 +29,42 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt nexthdr icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # rt nexthdr != icmp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt nexthdr != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt nexthdr 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -72,7 +72,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt nexthdr { 33, 55, 67, 88}
@@ -82,7 +82,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != { 33, 55, 67, 88}
@@ -92,7 +92,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt nexthdr { 33-55}
@@ -102,7 +102,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != { 33-55}
@@ -112,28 +112,28 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt hdrlength != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt hdrlength 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -141,7 +141,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt hdrlength { 33, 55, 67, 88}
@@ -151,7 +151,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt hdrlength != { 33, 55, 67, 88}
@@ -161,7 +161,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt hdrlength { 33-55}
@@ -171,7 +171,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt hdrlength != { 33-55}
@@ -181,28 +181,28 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt type 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt type != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt type 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -210,7 +210,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt type { 33, 55, 67, 88}
@@ -220,7 +220,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt type != { 33, 55, 67, 88}
@@ -230,7 +230,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt type { 33-55}
@@ -240,7 +240,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt type != { 33-55}
@@ -250,28 +250,28 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt seg-left 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt seg-left != 233
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt seg-left 33-45
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
@@ -279,7 +279,7 @@ inet test-inet input
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt seg-left { 33, 55, 67, 88}
@@ -289,7 +289,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt seg-left != { 33, 55, 67, 88}
@@ -299,7 +299,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt seg-left { 33-55}
@@ -309,7 +309,7 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt seg-left != { 33-55}
@@ -319,6 +319,6 @@ __set%d test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index 5a57463..929cf9e 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -1,11 +1,11 @@
 # rt nexthdr 1
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # rt nexthdr != 1
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -13,7 +13,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != {udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
@@ -21,38 +21,38 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000088  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000033  : 0 [end]	element 00000084  : 0 [end]	element 00000032  : 0 [end]	element 00000021  : 0 [end]	element 00000006  : 0 [end]	element 0000003a  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt nexthdr icmp
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # rt nexthdr != icmp
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # rt nexthdr 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt nexthdr != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt nexthdr 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt nexthdr != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt nexthdr { 33, 55, 67, 88}
@@ -60,7 +60,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != { 33, 55, 67, 88}
@@ -68,7 +68,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt nexthdr { 33-55}
@@ -76,7 +76,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt nexthdr != { 33-55}
@@ -84,28 +84,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt hdrlength 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt hdrlength != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt hdrlength 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt hdrlength != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt hdrlength { 33, 55, 67, 88}
@@ -113,7 +113,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt hdrlength != { 33, 55, 67, 88}
@@ -121,7 +121,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt hdrlength { 33-55}
@@ -129,7 +129,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt hdrlength != { 33-55}
@@ -137,28 +137,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 1 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt type 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt type != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt type 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt type != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt type { 33, 55, 67, 88}
@@ -166,7 +166,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt type != { 33, 55, 67, 88}
@@ -174,7 +174,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt type { 33-55}
@@ -182,7 +182,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt type != { 33-55}
@@ -190,28 +190,28 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 2 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt seg-left 22
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ cmp eq reg 1 0x00000016 ]
 
 # rt seg-left != 233
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ cmp neq reg 1 0x000000e9 ]
 
 # rt seg-left 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # rt seg-left != 33-45
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt seg-left { 33, 55, 67, 88}
@@ -219,7 +219,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt seg-left != { 33, 55, 67, 88}
@@ -227,7 +227,7 @@ __set%d test-ip6 3
 __set%d test-ip6 0
 	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # rt seg-left { 33-55}
@@ -235,7 +235,7 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # rt seg-left != { 33-55}
@@ -243,6 +243,6 @@ __set%d test-ip6 7
 __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 3 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
diff --git a/tests/py/ip6/srh.t.payload b/tests/py/ip6/srh.t.payload
index a2a46f1..b624745 100644
--- a/tests/py/ip6/srh.t.payload
+++ b/tests/py/ip6/srh.t.payload
@@ -1,11 +1,11 @@
 # srh last-entry 0
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 4 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # srh last-entry 127
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 4 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
   [ cmp eq reg 1 0x0000007f ]
 
 # srh last-entry { 0, 4-127, 255 }
@@ -13,17 +13,17 @@ __set%d test-ip6 7 size 5
 __set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = {
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 4 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # srh flags 0
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 5 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # srh flags 127
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 5 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
   [ cmp eq reg 1 0x0000007f ]
 
 # srh flags { 0, 4-127, 255 }
@@ -31,17 +31,17 @@ __set%d test-ip6 7 size 5
 __set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = {
 ip6 test-ip6 input
-  [ exthdr load 1b @ 43 + 5 => reg 1 ]
+  [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # srh tag 0
 ip6 test-ip6 input
-  [ exthdr load 2b @ 43 + 6 => reg 1 ]
+  [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # srh tag 127
 ip6 test-ip6 input
-  [ exthdr load 2b @ 43 + 6 => reg 1 ]
+  [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
   [ cmp eq reg 1 0x00007f00 ]
 
 # srh tag { 0, 4-127, 0xffff }
@@ -49,16 +49,16 @@ __set%d test-ip6 7 size 5
 __set%d test-ip6 0
 	element 00000000  : 0 [end]	element 00000100  : 1 [end]	element 00000400  : 0 [end]	element 00008000  : 1 [end]	element 0000ffff  : 0 [end]  userdata = {
 ip6 test-ip6 input
-  [ exthdr load 2b @ 43 + 6 => reg 1 ]
+  [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
 # srh sid[1] dead::beef
 ip6 test-ip6 input
-  [ exthdr load 16b @ 43 + 8 => reg 1 ]
+  [ exthdr load ipv6 16b @ 43 + 8 => reg 1 ]
   [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
 
 # srh sid[2] dead::beef
 ip6 test-ip6 input
-  [ exthdr load 16b @ 43 + 24 => reg 1 ]
+  [ exthdr load ipv6 16b @ 43 + 24 => reg 1 ]
   [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
 
-- 
2.17.1

