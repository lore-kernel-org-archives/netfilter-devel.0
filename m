Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F7BC43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 11:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AD18206E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 11:59:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZRL51oV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfFTL7U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 07:59:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41308 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfFTL7U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 07:59:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so1547605pff.8
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 04:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qw0bJIPFia5B6aLR8E+78r5YfAn/AOWJX/Vg727USqg=;
        b=iZRL51oVsK/lwBKGwSRMgD1MdaDdjO87xadbsy9Kpd3YPrZNIilMR+ttV6ANJE51YW
         /bCzLRliM9DfrHntNhFD2yYME6WfsWgiFulzbuks+a31Fh2NDLc6HDk+9Xacjy7R6AQB
         Xfzr1AblMLaPqAWcWVYVFdgnyxRTX+BMk9LHEZhwgQf75/P5huFtepgyrdkeuUprdOFg
         OCzfZtSwwCRfqr0G0qlGgkL62iwIvHIwha5AncbotmZtRfc1ktH+u2vQtnAuhEyuCALv
         O+op4OYUwbKvZ7qZyoGDDe+SiuR1YQQliPv/96BfQflVJXXXQ9AASoLwlc2DwwDeFRi7
         JwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qw0bJIPFia5B6aLR8E+78r5YfAn/AOWJX/Vg727USqg=;
        b=nOmU5odadlZQkOODi+kHGxn7hdwd5Gge/6wreXjO6F7NWggbLblk2pN1pflV0A6E/X
         e+c0TUcXUlIzepYB/YwEyPrYUpuIrbqwkurLm/cU6eii2a9pPOSXW93VAObGkOoUDTy8
         YOsJCwFSSgMuZFZZ5H2+V3oH5pa/t6AK0YIqa6iYrCLmxzdTDDcEYjOXYXXoS9ZkaQip
         0FbyocZ/An/3xTagaftzdF9E2mwtqF2zzqRQjASiUqJg5h03kmoREqw+qFH2ioo0v0n6
         nXGnZu0SOuoFckL57ROG3tSL9KiP8SoNLL4/BoiOAtgsjJD+1OaWLj63mMYn3kqEO2TM
         KnrA==
X-Gm-Message-State: APjAAAX6oHJXshslrfWQV6kuiUonrk3NpHOhKx1hZkeR56MlvXUKFBgv
        2/GbnLtVtVoxSAoo6Jz6dMWQydbhcA==
X-Google-Smtp-Source: APXvYqyi/N0iw5xWad3oq2LXZuCC1wgr8wLVPAQssDv7aMi+00AEMwtqWNPKK7tf/o/CCuYm3B6Pdg==
X-Received: by 2002:a63:4f5b:: with SMTP id p27mr12359974pgl.273.1561031958419;
        Thu, 20 Jun 2019 04:59:18 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.8])
        by smtp.gmail.com with ESMTPSA id q198sm29347818pfq.155.2019.06.20.04.59.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:59:17 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nftables v2] exthdr: doc: add support for matching IPv4 options
Date:   Thu, 20 Jun 2019 07:59:00 -0400
Message-Id: <20190620115900.3845-1-ssuryaextr@gmail.com>
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
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 doc/payload-expression.txt          |  29 ++++-
 include/Makefile.am                 |   1 +
 include/exthdr.h                    |   1 +
 include/ipopt.h                     |  27 +++++
 include/linux/netfilter/nf_tables.h |   2 +
 src/Makefile.am                     |   1 +
 src/evaluate.c                      |  17 +++
 src/exthdr.c                        |  22 +++-
 src/ipopt.c                         | 159 ++++++++++++++++++++++++++++
 src/parser_bison.y                  |  31 ++++++
 src/payload.c                       |   4 +
 src/scanner.l                       |   8 ++
 tests/py/ip/ipopt.t                 |  24 +++++
 tests/py/ip/ipopt.t.payload         | 150 ++++++++++++++++++++++++++
 14 files changed, 472 insertions(+), 4 deletions(-)
 create mode 100644 include/ipopt.h
 create mode 100644 src/ipopt.c
 create mode 100644 tests/py/ip/ipopt.t
 create mode 100644 tests/py/ip/ipopt.t.payload

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 7f3ca42..218dd36 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -494,9 +494,9 @@ input meta iifname enp2s0 arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh
 
 EXTENSION HEADER EXPRESSIONS
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Extension header expressions refer to data from variable-sized protocol headers, such as IPv6 extension headers and TCP options.
+Extension header expressions refer to data from variable-sized protocol headers, such as IPv6 extension headers, TCP options and IPv4 options.
 
-nftables currently supports matching (finding) a given ipv6 extension header or TCP option.
+nftables currently supports matching (finding) a given ipv6 extension header, TCP option or IPv4 option.
 [verse]
 *hbh* {*nexthdr* | *hdrlength*}
 *frag* {*nexthdr* | *frag-off* | *more-fragments* | *id*}
@@ -505,11 +505,13 @@ nftables currently supports matching (finding) a given ipv6 extension header or
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
@@ -568,6 +570,24 @@ TCP Timestamps |
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
@@ -578,6 +598,11 @@ filter input tcp option sack-permitted kind 1 counter
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
index b1f4fcf..9606ae1 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -6,6 +6,7 @@ noinst_HEADERS = 	cli.h		\
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
index 0000000..20710c3
--- /dev/null
+++ b/include/ipopt.h
@@ -0,0 +1,27 @@
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
index 8e1a4d8..a45d8e3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -61,6 +61,7 @@ libnftables_la_SOURCES =			\
 		nfnl_osf.c			\
 		tcpopt.c			\
 		socket.c			\
+		ipopt.c			\
 		libnftables.c
 
 # yacc and lex generate dirty code
diff --git a/src/evaluate.c b/src/evaluate.c
index 21d9e14..fb66b46 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -518,6 +518,20 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
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
@@ -542,6 +556,9 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
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
index 0cd0319..d73cbcc 100644
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
index 0000000..f67a56f
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
+static const struct exthdr_desc *ipopt_protocols[] = {
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
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9e632c0..5bbc6d5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -309,6 +309,14 @@ int nft_lex(void *, void *, void *);
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
@@ -698,6 +706,7 @@ int nft_lex(void *, void *, void *);
 %type <expr>			ip_hdr_expr	icmp_hdr_expr		igmp_hdr_expr numgen_expr	hash_expr
 %destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		igmp_hdr_expr numgen_expr	hash_expr
 %type <val>			ip_hdr_field	icmp_hdr_field		igmp_hdr_field
+%type <val>			ip_option_type	ip_option_field
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
 %destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
 %type <val>			ip6_hdr_field   icmp6_hdr_field
@@ -4249,6 +4258,15 @@ ip_hdr_expr		:	IP	ip_hdr_field
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
@@ -4265,6 +4283,19 @@ ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
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
diff --git a/src/payload.c b/src/payload.c
index 338a4b7..931370f 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -524,6 +524,10 @@ void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
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
index 558bf92..8432250 100644
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
-- 
2.17.1

