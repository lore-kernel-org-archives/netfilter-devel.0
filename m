Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E189C6FD19
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Mar 2023 14:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCLOhT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 10:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCLOhR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 10:37:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4D6A5CC
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2023 07:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KMAszCIvVknUP2a5Oes2D6yxaQPvipV8Qxd4On4prx0=; b=DGjqwENGbdbpfORxuM4neTtB/6
        TaWRKF8CCFdIjJQvbxjJVHJ2kFoQGuPF1QiIBMpMuuak37FEBeDqxKvaTM4ip5JrETQuXiAAj6mrW
        sbd6yZIEayphKMRv2bbGFxLvQaXm9XeiYIUTNBoin6nfWfFId/0dnftuLWpdr+zeCg5e0SrtS3uHj
        PeBMFRvzRheNIo9z+RMgNONY7milm57Y9C7wC0hJwUbPfqvIqKVVUpGTjRPvmTOH5QFBDj+NWNLfm
        tyYO4yADLvIF/lgVVLZWk0ZBa+TE36pQ6fNqFDur/tyh13+j8w/fAGBLxbRkc8dmCk/uHt7iMqJmx
        xtSubfEQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbMox-005aYF-DX
        for netfilter-devel@vger.kernel.org; Sun, 12 Mar 2023 14:37:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables] exthdr: add boolean DCCP option matching
Date:   Sun, 12 Mar 2023 14:37:07 +0000
Message-Id: <20230312143707.158928-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Iptables supports the matching of DCCP packets based on the presence
or absence of DCCP options.  Extend exthdr expressions to add this
functionality to nftables.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=930
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
I was considering how to structure this work as a series until I noticed
that Phil added support for matching SCPT chunks in one commit, and so
I've done likewise.

 doc/libnftables-json.adoc           |  11 ++
 doc/payload-expression.txt          |   6 +
 include/datatype.h                  |   2 +-
 include/dccpopt.h                   |  42 +++++
 include/exthdr.h                    |   1 +
 include/linux/netfilter/nf_tables.h |   2 +
 src/Makefile.am                     |   1 +
 src/dccpopt.c                       | 276 ++++++++++++++++++++++++++++
 src/evaluate.c                      |   1 +
 src/exthdr.c                        |   8 +
 src/json.c                          |   5 +
 src/parser_bison.y                  |  11 +-
 src/parser_json.c                   |  17 ++
 src/scanner.l                       |   3 +
 tests/py/inet/dccp.t                |   5 +
 tests/py/inet/dccp.t.json           |  44 +++++
 tests/py/inet/dccp.t.payload        |  14 ++
 17 files changed, 447 insertions(+), 2 deletions(-)
 create mode 100644 include/dccpopt.h
 create mode 100644 src/dccpopt.c

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index f4aea36eb571..f9288487e4b2 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1226,6 +1226,17 @@ If the *field* property is not given, the expression is to be used as an SCTP
 chunk existence check in a *match* statement with a boolean on the right hand
 side.
 
+=== DCCP OPTION
+[verse]
+*{ "dccp option": {
+	"type":* 'NUMBER'*
+*}}*
+
+Create a reference to a DCCP option (*type*).
+
+The expression is to be used as a DCCP option existence check in a *match*
+statement with a boolean on the right hand side.
+
 === META
 [verse]
 ____
diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index f1de34476145..06538832ec52 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -753,6 +753,7 @@ The following syntaxes are valid only in a relational expression with boolean ty
 *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
 *tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
 *ip option* { lsrr | ra | rr | ssrr }
+*dccp option* 'dccp_option_type'
 
 .IPv6 extension headers
 [options="header"]
@@ -855,6 +856,11 @@ ip6 filter input frag more-fragments 1 counter
 filter input ip option lsrr exists counter
 ---------------------------------------
 
+.finding DCCP option
+------------------
+filter input dccp option 40 exists counter
+---------------------------------------
+
 CONNTRACK EXPRESSIONS
 ~~~~~~~~~~~~~~~~~~~~~
 Conntrack expressions refer to meta data of the connection tracking entry associated with a packet. +
diff --git a/include/datatype.h b/include/datatype.h
index 73f38f66c4ce..391d6ac8b4bd 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -23,7 +23,7 @@
  * @TYPE_INET_SERVICE:	internet service (integer subtype)
  * @TYPE_ICMP_TYPE:	ICMP type codes (integer subtype)
  * @TYPE_TCP_FLAG:	TCP flag (bitmask subtype)
- * @TCPE_DCCP_PKTTYPE:	DCCP packet type (integer subtype)
+ * @TYPE_DCCP_PKTTYPE:	DCCP packet type (integer subtype)
  * @TYPE_MH_TYPE:	Mobility Header type (integer subtype)
  * @TYPE_TIME:		relative time
  * @TYPE_MARK:		packet mark (integer subtype)
diff --git a/include/dccpopt.h b/include/dccpopt.h
new file mode 100644
index 000000000000..9686932d74b7
--- /dev/null
+++ b/include/dccpopt.h
@@ -0,0 +1,42 @@
+#ifndef NFTABLES_DCCPOPT_H
+#define NFTABLES_DCCPOPT_H
+
+#include <nftables.h>
+#include <stdint.h>
+
+#define DCCPOPT_TYPE_MIN 0
+#define DCCPOPT_TYPE_MAX UINT8_MAX
+
+enum dccpopt_fields {
+	DCCPOPT_FIELD_INVALID,
+	DCCPOPT_FIELD_TYPE,
+};
+
+enum dccpopt_types {
+	DCCPOPT_PADDING			=   0,
+	DCCPOPT_MANDATORY		=   1,
+	DCCPOPT_SLOW_RECEIVER		=   2,
+	DCCPOPT_RESERVED_SHORT		=   3,
+	DCCPOPT_CHANGE_L		=  32,
+	DCCPOPT_CONFIRM_L		=  33,
+	DCCPOPT_CHANGE_R		=  34,
+	DCCPOPT_CONFIRM_R		=  35,
+	DCCPOPT_INIT_COOKIE		=  36,
+	DCCPOPT_NDP_COUNT		=  37,
+	DCCPOPT_ACK_VECTOR_NONCE_0	=  38,
+	DCCPOPT_ACK_VECTOR_NONCE_1	=  39,
+	DCCPOPT_DATA_DROPPED		=  40,
+	DCCPOPT_TIMESTAMP		=  41,
+	DCCPOPT_TIMESTAMP_ECHO		=  42,
+	DCCPOPT_ELAPSED_TIME		=  43,
+	DCCPOPT_DATA_CHECKSUM		=  44,
+	DCCPOPT_RESERVED_LONG		=  45,
+	DCCPOPT_CCID_SPECIFIC           = 128,
+};
+
+const struct exthdr_desc *dccpopt_find_desc(uint8_t type);
+struct expr *dccpopt_expr_alloc(const struct location *loc, uint8_t type);
+void dccpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
+		      unsigned int len);
+
+#endif /* NFTABLES_DCCPOPT_H */
diff --git a/include/exthdr.h b/include/exthdr.h
index 1bc756f93649..084daba5358f 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -4,6 +4,7 @@
 #include <proto.h>
 #include <tcpopt.h>
 #include <ipopt.h>
+#include <dccpopt.h>
 
 enum exthdr_desc_id {
 	EXTHDR_DESC_UNKNOWN	= 0,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ff677f3a6cad..abbe2677c1d9 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -859,12 +859,14 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_TCP: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
+ * @NFT_EXTHDR_OP_DCCP: match against dccp options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
 	NFT_EXTHDR_OP_IPV4,
 	NFT_EXTHDR_OP_SCTP,
+	NFT_EXTHDR_OP_DCCP,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/src/Makefile.am b/src/Makefile.am
index 264d981e20c7..ace38bd75a97 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -75,6 +75,7 @@ libnftables_la_SOURCES =			\
 		socket.c			\
 		print.c				\
 		sctp_chunk.c			\
+		dccpopt.c			\
 		libnftables.c			\
 		libnftables.map
 
diff --git a/src/dccpopt.c b/src/dccpopt.c
new file mode 100644
index 000000000000..f430fa4b8e19
--- /dev/null
+++ b/src/dccpopt.c
@@ -0,0 +1,276 @@
+#include <stddef.h>
+#include <stdint.h>
+
+#include <datatype.h>
+#include <dccpopt.h>
+#include <expression.h>
+#include <nftables.h>
+#include <utils.h>
+
+#define PHT(__token, __offset, __len)					 \
+	PROTO_HDR_TEMPLATE(__token, &integer_type, BYTEORDER_BIG_ENDIAN, \
+			   __offset, __len)
+
+static const struct proto_hdr_template dccpopt_unknown_template =
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, BYTEORDER_INVALID, 0, 0);
+
+/*
+ *             Option                           DCCP-  Section
+ *     Type    Length     Meaning               Data?  Reference
+ *     ----    ------     -------               -----  ---------
+ *       0        1       Padding                 Y      5.8.1
+ *       1        1       Mandatory               N      5.8.2
+ *       2        1       Slow Receiver           Y      11.6
+ *     3-31       1       Reserved
+ *      32     variable   Change L                N      6.1
+ *      33     variable   Confirm L               N      6.2
+ *      34     variable   Change R                N      6.1
+ *      35     variable   Confirm R               N      6.2
+ *      36     variable   Init Cookie             N      8.1.4
+ *      37       3-8      NDP Count               Y      7.7
+ *      38     variable   Ack Vector [Nonce 0]    N      11.4
+ *      39     variable   Ack Vector [Nonce 1]    N      11.4
+ *      40     variable   Data Dropped            N      11.7
+ *      41        6       Timestamp               Y      13.1
+ *      42      6/8/10    Timestamp Echo          Y      13.3
+ *      43       4/6      Elapsed Time            N      13.2
+ *      44        6       Data Checksum           Y      9.3
+ *     45-127  variable   Reserved
+ *    128-255  variable   CCID-specific options   -      10.3
+ */
+
+static const struct exthdr_desc dccpopt_padding = {
+	.name		= "padding",
+	.type           = DCCPOPT_PADDING,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type", 0, 8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_mandatory = {
+	.name		= "mandatory",
+	.type           = DCCPOPT_MANDATORY,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type", 0, 8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_slow_receiver = {
+	.name		= "slow_receiver",
+	.type           = DCCPOPT_SLOW_RECEIVER,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type", 0, 8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_reserved_short = {
+	.name		= "reserved_short",
+	.type           = DCCPOPT_RESERVED_SHORT,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type", 0, 8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_change_l = {
+	.name		= "change_l",
+	.type           = DCCPOPT_CHANGE_L,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8)
+	},
+};
+
+static const struct exthdr_desc dccpopt_confirm_l = {
+	.name		= "confirm_l",
+	.type           = DCCPOPT_CONFIRM_L,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_change_r = {
+	.name		= "change_r",
+	.type           = DCCPOPT_CHANGE_R,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_confirm_r = {
+	.name		= "confirm_r",
+	.type           = DCCPOPT_CONFIRM_R,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_init_cookie = {
+	.name		= "init_cookie",
+	.type           = DCCPOPT_INIT_COOKIE,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_ndp_count = {
+	.name		= "ndp_count",
+	.type           = DCCPOPT_NDP_COUNT,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_ack_vector_nonce_0 = {
+	.name		= "ack_vector_nonce_0",
+	.type           = DCCPOPT_ACK_VECTOR_NONCE_0,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_ack_vector_nonce_1 = {
+	.name		= "ack_vector_nonce_1",
+	.type           = DCCPOPT_ACK_VECTOR_NONCE_1,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_data_dropped = {
+	.name		= "data_dropped",
+	.type           = DCCPOPT_DATA_DROPPED,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_timestamp = {
+	.name		= "timestamp",
+	.type           = DCCPOPT_TIMESTAMP,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_timestamp_echo = {
+	.name		= "timestamp_echo",
+	.type           = DCCPOPT_TIMESTAMP_ECHO,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_elapsed_time = {
+	.name		= "elapsed_time",
+	.type           = DCCPOPT_ELAPSED_TIME,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_data_checksum = {
+	.name		= "data_checksum",
+	.type           = DCCPOPT_DATA_CHECKSUM,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_reserved_long = {
+	.name		= "reserved_long",
+	.type           = DCCPOPT_RESERVED_LONG,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+static const struct exthdr_desc dccpopt_ccid_specific = {
+	.name		= "ccid_specific",
+	.type           = DCCPOPT_CCID_SPECIFIC,
+	.templates	= {
+		[DCCPOPT_FIELD_TYPE]	= PHT("type",    0,    8),
+	},
+};
+
+const struct exthdr_desc *dccpopt_protocols[1 + UINT8_MAX] = {
+	[DCCPOPT_PADDING]		= &dccpopt_padding,
+	[DCCPOPT_MANDATORY]		= &dccpopt_mandatory,
+	[DCCPOPT_SLOW_RECEIVER]		= &dccpopt_slow_receiver,
+	[DCCPOPT_RESERVED_SHORT]	= &dccpopt_reserved_short,
+	[DCCPOPT_CHANGE_L]		= &dccpopt_change_l,
+	[DCCPOPT_CONFIRM_L]		= &dccpopt_confirm_l,
+	[DCCPOPT_CHANGE_R]		= &dccpopt_change_r,
+	[DCCPOPT_CONFIRM_R]		= &dccpopt_confirm_r,
+	[DCCPOPT_INIT_COOKIE]		= &dccpopt_init_cookie,
+	[DCCPOPT_NDP_COUNT]		= &dccpopt_ndp_count,
+	[DCCPOPT_ACK_VECTOR_NONCE_0]	= &dccpopt_ack_vector_nonce_0,
+	[DCCPOPT_ACK_VECTOR_NONCE_1]	= &dccpopt_ack_vector_nonce_1,
+	[DCCPOPT_DATA_DROPPED]		= &dccpopt_data_dropped,
+	[DCCPOPT_TIMESTAMP]		= &dccpopt_timestamp,
+	[DCCPOPT_TIMESTAMP_ECHO]	= &dccpopt_timestamp_echo,
+	[DCCPOPT_ELAPSED_TIME]		= &dccpopt_elapsed_time,
+	[DCCPOPT_DATA_CHECKSUM]		= &dccpopt_data_checksum,
+	[DCCPOPT_RESERVED_LONG]		= &dccpopt_reserved_long,
+	[DCCPOPT_CCID_SPECIFIC]		= &dccpopt_ccid_specific,
+};
+
+const struct exthdr_desc *
+dccpopt_find_desc(uint8_t type)
+{
+	enum dccpopt_types proto_idx =
+		  3 <= type && type <=  31 ? DCCPOPT_RESERVED_SHORT :
+		 45 <= type && type <= 127 ? DCCPOPT_RESERVED_LONG  :
+		128 <= type                ? DCCPOPT_CCID_SPECIFIC  : type;
+
+	return dccpopt_protocols[proto_idx];
+}
+
+struct expr *
+dccpopt_expr_alloc(const struct location *loc, uint8_t type)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct exthdr_desc *desc;
+	struct expr *expr;
+
+	desc = dccpopt_find_desc(type);
+	tmpl = &desc->templates[DCCPOPT_FIELD_TYPE];
+
+	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
+			  BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE);
+	expr->exthdr.desc     = desc;
+	expr->exthdr.tmpl     = tmpl;
+	expr->exthdr.offset   = tmpl->offset;
+	expr->exthdr.raw_type = type;
+	expr->exthdr.flags    = NFT_EXTHDR_F_PRESENT;
+	expr->exthdr.op       = NFT_EXTHDR_OP_DCCP;
+
+	return expr;
+}
+
+void
+dccpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
+		 unsigned int len)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct exthdr_desc *desc;
+
+	assert(expr->etype == EXPR_EXTHDR);
+
+	desc = dccpopt_find_desc(type);
+	tmpl = &desc->templates[DCCPOPT_FIELD_TYPE];
+
+	expr->len   = len;
+	expr->dtype = &boolean_type;
+
+	expr->exthdr.offset = offset;
+	expr->exthdr.desc   = desc;
+	expr->exthdr.flags  = NFT_EXTHDR_F_PRESENT;
+	expr->exthdr.op     = NFT_EXTHDR_OP_DCCP;
+
+	/* Make sure that it's the right template based on offset and
+	 * len
+	 */
+	if (tmpl->offset != offset || tmpl->len != len)
+		expr->exthdr.tmpl = &dccpopt_unknown_template;
+	else
+		expr->exthdr.tmpl = tmpl;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 47caf3b0d716..1095eaef7356 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -616,6 +616,7 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT:
 	case NFT_EXTHDR_OP_SCTP:
+	case NFT_EXTHDR_OP_DCCP:
 		return __expr_evaluate_exthdr(ctx, exprp);
 	case NFT_EXTHDR_OP_IPV4:
 		dependency = &proto_ip;
diff --git a/src/exthdr.c b/src/exthdr.c
index 3e5f5cd8b73e..d0274bea6ca0 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -84,6 +84,9 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			return;
 		nft_print(octx, " %s", expr->exthdr.tmpl->token);
+	} else if (expr->exthdr.op == NFT_EXTHDR_OP_DCCP) {
+		nft_print(octx, "dccp option %d", expr->exthdr.raw_type);
+		return;
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			nft_print(octx, "exthdr %s", name);
@@ -177,6 +180,8 @@ static struct expr *exthdr_expr_parse_udata(const struct nftnl_udata *attr)
 	case NFT_EXTHDR_OP_SCTP:
 		return sctp_chunk_expr_alloc(&internal_location,
 					     desc_id, type);
+	case NFT_EXTHDR_OP_DCCP:
+		return dccpopt_expr_alloc(&internal_location, type);
 	case __NFT_EXTHDR_OP_MAX:
 		return NULL;
 	}
@@ -206,6 +211,7 @@ static int exthdr_expr_build_udata(struct nftnl_udata_buf *udbuf,
 	case NFT_EXTHDR_OP_TCPOPT:
 	case NFT_EXTHDR_OP_IPV4:
 	case NFT_EXTHDR_OP_SCTP:
+	case NFT_EXTHDR_OP_DCCP:
 		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_OP, op);
 		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_DESC, expr->exthdr.raw_type);
 		break;
@@ -332,6 +338,8 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 		return ipopt_init_raw(expr, type, offset, len, flags, true);
 	if (op == NFT_EXTHDR_OP_SCTP)
 		return sctp_chunk_init_raw(expr, type, offset, len, flags);
+	if (op == NFT_EXTHDR_OP_DCCP)
+		return dccpopt_init_raw(expr, type, offset, len);
 
 	expr->len = len;
 	expr->exthdr.flags = flags;
diff --git a/src/json.c b/src/json.c
index f15461d33894..28b7917d5972 100644
--- a/src/json.c
+++ b/src/json.c
@@ -745,6 +745,11 @@ json_t *exthdr_expr_json(const struct expr *expr, struct output_ctx *octx)
 		return json_pack("{s:o}", "tcp option", root);
 	}
 
+	if (expr->exthdr.op == NFT_EXTHDR_OP_DCCP) {
+		root = json_pack("{s:i}", "type", expr->exthdr.raw_type);
+		return json_pack("{s:o}", "dccp option", root);
+	}
+
 	root = json_pack("{s:s}", "name", desc);
 	if (!is_exists)
 		json_object_set_new(root, "field", json_string(field));
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3c06ff48c95c..c70882b40bbb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5932,6 +5932,15 @@ dccp_hdr_expr		:	DCCP	dccp_hdr_field	close_scope_dccp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
 			}
+			|	DCCP	OPTION		NUM	close_scope_dccp
+			{
+				if ($3 > DCCPOPT_TYPE_MAX) {
+					erec_queue(error(&@1, "value too large"),
+						   state->msgs);
+					YYERROR;
+				}
+				$$ = dccpopt_expr_alloc(&@$, $3);
+			}
 			;
 
 dccp_hdr_field		:	SPORT		{ $$ = DCCPHDR_SPORT; }
@@ -6180,7 +6189,7 @@ exthdr_exists_expr	:	EXTHDR	exthdr_key
 				desc = exthdr_find_proto($2);
 
 				/* Assume that NEXTHDR template is always
-				 * the fist one in list of templates.
+				 * the first one in list of templates.
 				 */
 				$$ = exthdr_expr_alloc(&@$, desc, 1);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
diff --git a/src/parser_json.c b/src/parser_json.c
index ec0c02a044e2..5e45e9a7a3ff 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -756,6 +756,22 @@ static struct expr *json_parse_sctp_chunk_expr(struct json_ctx *ctx,
 	return sctp_chunk_expr_alloc(int_loc, desc->type, fieldval);
 }
 
+static struct expr *json_parse_dccp_option_expr(struct json_ctx *ctx,
+						const char *type, json_t *root)
+{
+	const int opt_type;
+
+	if (json_unpack_err(ctx, root, "{s:i}", "type", &opt_type))
+		return NULL;
+
+	if (opt_type < DCCPOPT_TYPE_MIN || opt_type > DCCPOPT_TYPE_MAX) {
+		json_error(ctx, "Unknown dccp option type '%d'.", opt_type);
+		return NULL;
+	}
+
+	return dccpopt_expr_alloc(int_loc, opt_type);
+}
+
 static const struct exthdr_desc *exthdr_lookup_byname(const char *name)
 {
 	const struct exthdr_desc *exthdr_tbl[] = {
@@ -1462,6 +1478,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "ip option", json_parse_ip_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "sctp chunk", json_parse_sctp_chunk_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
+		{ "dccp option", json_parse_dccp_option_expr, CTX_F_PRIMARY },
 		{ "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "osf", json_parse_osf_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
 		{ "ipsec", json_parse_xfrm_expr, CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
diff --git a/src/scanner.l b/src/scanner.l
index 15ca3d461d70..c903b8c3e02d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -632,6 +632,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_CT,SCANSTATE_EXPR_DCCP,SCANSTATE_SCTP,SCANSTATE_TCP,SCANSTATE_EXPR_TH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE>{
 	"dport"			{ return DPORT; }
 }
+<SCANSTATE_EXPR_DCCP>{
+	"option"		{ return OPTION; }
+}
 
 "vxlan"			{ return VXLAN; }
 "vni"			{ return VNI; }
diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index 90142f53254e..99cddbe77c5b 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -23,3 +23,8 @@ dccp type {request, response, data, ack, dataack, closereq, close, reset, sync,
 dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
 dccp type request;ok
 dccp type != request;ok
+
+dccp option 0 exists;ok
+dccp option 43 missing;ok
+dccp option 255 exists;ok
+dccp option 256 exists;fail
diff --git a/tests/py/inet/dccp.t.json b/tests/py/inet/dccp.t.json
index 806ef5eefca3..9f47e97b8711 100644
--- a/tests/py/inet/dccp.t.json
+++ b/tests/py/inet/dccp.t.json
@@ -230,3 +230,47 @@
     }
 ]
 
+# dccp option 0 exists
+[
+    {
+        "match": {
+            "left": {
+                "dccp option": {
+                    "type": 0
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# dccp option 43 missing
+[
+    {
+        "match": {
+            "left": {
+                "dccp option": {
+                    "type": 43
+                }
+            },
+            "op": "==",
+            "right": false
+        }
+    }
+]
+
+# dccp option 255 exists
+[
+    {
+        "match": {
+            "left": {
+                "dccp option": {
+                    "type": 255
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index fbe9dc5b0016..c0b87be18da7 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -99,3 +99,17 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
+# dccp option 0 exists
+ip test-inet input
+  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# dccp option 43 missing
+ip test-inet input
+  [ exthdr load 1b @ 43 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# dccp option 255 exists
+ip test-inet input
+  [ exthdr load 1b @ 255 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
-- 
2.39.2

