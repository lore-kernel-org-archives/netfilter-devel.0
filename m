Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD0BC43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 21:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F21205C9
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 21:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="g36duY9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLIVmx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 16:42:53 -0500
Received: from kadath.azazel.net ([81.187.231.250]:37706 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfLIVmx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 16:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HBMEf8BIgKPOLxPfnLWjLFvPxQ7N7CWAqqQNbXp98Q4=; b=g36duY9cHWV2cuqB1buysQBTL6
        GlfK8ccPA/nuyTmA9EP0cfBAhAwTX3ABqUkVr8okTp0CnBJusEc87FIrWGGa4B0ATqTkivg9HvBYR
        LcNk0wVLqSe+ydw6yZZW2JiEnvhQ9gJ32z9qODTKhETtTd73YHv8VeIf180LQ0RRMbwe28zhsnUMV
        tiayE1UAmMmxgFs4WORCWqQN99wxuA/74QMbo/dGJwnwmFV81zUbrnq+9n2fBbNOWe551zLzQdL/e
        DFU4V6cRGW04yJTDLMcJk4Jfr+psApT0G8y9F9Pthfj12ddqJLZBuPauKceZmNOpSVPx74OiwdMHe
        xvBW2KXQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ieQnr-0002KH-TS; Mon, 09 Dec 2019 21:42:51 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [RFC PATCH nftables] Add "ct dscpmark" conntrack statement.
Date:   Mon,  9 Dec 2019 21:42:51 +0000
Message-Id: <20191209214251.852279-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209214208.852229-1-jeremy@azazel.net>
References: <20191209214208.852229-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"ct dscpmark" is a method of storing the DSCP of an ip packet into the
conntrack mark.  In combination with a suitable tc filter action
(act_ctinfo) DSCP values are able to be stored in the mark on egress and
restored on ingress across links that otherwise alter or bleach DSCP.

This is useful for qdiscs such as CAKE which are able to shape according
to policies based on DSCP.

Ingress classification is traditionally a challenging task since
iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
lookups, hence are unable to see internal IPv4 addresses as used on the
typical home masquerading gateway.

The "ct dscpmark" conntrack statement solves the problem of storing the
DSCP to the conntrack mark in a way suitable for the new act_ctinfo tc
action to restore.

The "ct dscpmark" statement accepts 2 parameters, a 32bit 'dscpmask' and a
32bit 'statemask'.  The dscp mask must be 6 contiguous bits and
represents the area where the DSCP will be stored in the connmark.  The
state mask is a minimum 1 bit length mask that must not overlap with the
dscpmask.  It represents a flag which is set when the DSCP has been
stored in the conntrack mark. This is useful to implement a 'one shot'
iptables based classification where the 'complicated' iptables rules are
only run once to classify the connection on initial (egress) packet and
subsequent packets are all marked/restored with the same DSCP.  A state
mask of zero disables the setting of a status bit/s.

For example,

  table ip t {
    chain c {
      type filter hook postrouting priority mangle; policy accept;
      oif eth0 ct dscpmark set 0xfc000000/0x01000000
    }
  }

would store the DSCP in the top 6 bits of the 32bit mark field, and use
the LSB of the top byte as the 'DSCP has been stored' marker.

|----0xFC----conntrack mark----000000---|
| Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
| DSCP       | unused | flag  |unused   |
|-----------------------0x01---000000---|
      ^                   ^
      |                   |
      ---|             Conditional flag
         |             set this when dscp
|-ip diffserv-|        stored in mark
| 6 bits      |
|-------------|

an identically configured tc action to restore looks like:

  tc filter show dev eth0 ingress
  filter parent ffff: protocol all pref 10 u32 chain 0
  filter parent ffff: protocol all pref 10 u32 chain 0 fh 800: ht divisor 1
  filter parent ffff: protocol all pref 10 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1: not_in_hw
    match 00000000/00000000 at 0
          action order 1: ctinfo zone 0 pipe
           index 2 ref 1 bind 1 dscp 0xfc000000/0x1000000

          action order 2: mirred (Egress Redirect to device ifb4eth0) stolen
          index 1 ref 1 bind 1

|----0xFC----conntrack mark----000000---|
| Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
| DSCP       | unused | flag  |unused   |
|-----------------------0x01---000000---|
      |                   |
      |                   |
      ---|             Conditional flag
         v             only restore if set
|-ip diffserv-|
| 6 bits      |
|-------------|

Suggested-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/statements.txt                            | 12 ++++-
 include/ct.h                                  |  1 +
 include/datatype.h                            |  2 +
 include/json.h                                |  2 +
 include/linux/netfilter/nf_tables.h           |  2 +
 src/ct.c                                      | 25 +++++++++
 src/datatype.c                                |  1 +
 src/json.c                                    |  9 ++++
 src/parser_bison.y                            | 53 ++++++++++++++++++-
 src/scanner.l                                 |  1 +
 .../shell/testcases/chains/0040ct_dscpmark_0  | 21 ++++++++
 .../shell/testcases/chains/0040ct_dscpmark_1  | 14 +++++
 .../shell/testcases/chains/0040ct_dscpmark_2  | 14 +++++
 .../shell/testcases/chains/0040ct_dscpmark_3  | 14 +++++
 14 files changed, 167 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/chains/0040ct_dscpmark_0
 create mode 100755 tests/shell/testcases/chains/0040ct_dscpmark_1
 create mode 100755 tests/shell/testcases/chains/0040ct_dscpmark_2
 create mode 100755 tests/shell/testcases/chains/0040ct_dscpmark_3

diff --git a/doc/statements.txt b/doc/statements.txt
index ced311cb8d17..c3e8a208ec65 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -211,9 +211,9 @@ CONNTRACK STATEMENT
 The conntrack statement can be used to set the conntrack mark and conntrack labels.
 
 [verse]
-*ct* {*mark* | *event* | *label* | *zone*} *set* 'value'
+*ct* {*mark* | *dscpmark* | *event* | *label* | *zone*} *set* 'value'
 
-The ct statement sets meta data associated with a connection. The zone id
+The ct statement sets metadata associated with a connection. The zone id
 has to be assigned before a conntrack lookup takes place, i.e. this has to be
 done in prerouting and possibly output (if locally generated packets need to be
 placed in a distinct zone), with a hook priority of -300.
@@ -231,6 +231,9 @@ quoted string
 |mark|
 Connection tracking mark |
 mark
+|dscpmark|
+A pair of bitmasks indicating that the DiffServ code-point should be used as the ct mark |
+dscp-mask/state-mask
 |label|
 Connection tracking label|
 label
@@ -263,6 +266,11 @@ table inet raw {
 ct event set new,related,destroy
 --------------------------------------
 
+.use the DSCP shifted to the top six bits ORed with 0x101 as the ct mark:
+-------------------------------------------------------------------------
+ct dscpmark 0xfc000000/0x00000101
+-------------------------------------------------------------------------
+
 META STATEMENT
 ~~~~~~~~~~~~~~
 A meta statement sets the value of a meta expression. The existing meta fields
diff --git a/include/ct.h b/include/ct.h
index efb2d4185543..0f1562819cd7 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -39,5 +39,6 @@ extern const char *ct_label2str(const struct symbol_table *tbl,
 extern const struct datatype ct_dir_type;
 extern const struct datatype ct_state_type;
 extern const struct datatype ct_status_type;
+extern const struct datatype ct_dscpmark_type;
 
 #endif /* NFTABLES_CT_H */
diff --git a/include/datatype.h b/include/datatype.h
index 49b8f608aa1d..38cab83f6560 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -48,6 +48,7 @@
  * @TYPE_TIME_DATA	Date type (integer subtype)
  * @TYPE_TIME_HOUR	Hour type (integer subtype)
  * @TYPE_TIME_DAY	Day type (integer subtype)
+ * @TYPE_CT_DSCPMARK	conntrack DSCP mark type (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -96,6 +97,7 @@ enum datatypes {
 	TYPE_TIME_DATE,
 	TYPE_TIME_HOUR,
 	TYPE_TIME_DAY,
+	TYPE_CT_DSCPMARK,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/json.h b/include/json.h
index 20d6c2a4a8e7..4d20940c01cf 100644
--- a/include/json.h
+++ b/include/json.h
@@ -65,6 +65,7 @@ json_t *ct_label_type_json(const struct expr *expr, struct output_ctx *octx);
 json_t *time_type_json(const struct expr *expr, struct output_ctx *octx);
 json_t *uid_type_json(const struct expr *expr, struct output_ctx *octx);
 json_t *gid_type_json(const struct expr *expr, struct output_ctx *octx);
+json_t *ct_dscpmark_type_json(const struct expr *expr, struct output_ctx *octx);
 
 json_t *expr_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *payload_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
@@ -162,6 +163,7 @@ EXPR_PRINT_STUB(ct_label_type)
 EXPR_PRINT_STUB(time_type)
 EXPR_PRINT_STUB(uid_type)
 EXPR_PRINT_STUB(gid_type)
+EXPR_PRINT_STUB(ct_dscpmark_type)
 
 STMT_PRINT_STUB(expr)
 STMT_PRINT_STUB(payload)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ed8881ad18ed..8afd22516a67 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -982,6 +982,7 @@ enum nft_socket_keys {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_ID: conntrack id
+ * @NFT_CT_DSCPMARK: conntrack DSCP mark
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -1008,6 +1009,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_ID,
+	NFT_CT_DSCPMARK,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/src/ct.c b/src/ct.c
index 9e6a8351ffb2..efee7bd66589 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -141,6 +141,28 @@ static const struct datatype ct_event_type = {
 	.sym_tbl	= &ct_events_tbl,
 };
 
+static void ct_dscpmark_type_print(const struct expr *expr,
+				   struct output_ctx *octx)
+{
+	uint64_t ct_dscpmark = mpz_get_uint64(expr->value);
+	uint32_t dscpshift   = ct_dscpmark >> 32;
+	uint32_t statemask   = ct_dscpmark & 0xffffffff;
+
+	nft_print(octx, "0x%08" PRIx32 "/0x%08" PRIx32,
+		  0x3f << dscpshift, statemask);
+}
+
+const struct datatype ct_dscpmark_type = {
+	.type		= TYPE_CT_DSCPMARK,
+	.name		= "ct_dscpmark",
+	.desc		= "conntrack dscp mark",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= 8 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= ct_dscpmark_type_print,
+	.json		= ct_dscpmark_type_json,
+};
+
 #define CT_LABEL_BIT_SIZE 128
 
 const char *ct_label2str(const struct symbol_table *ct_label_tbl,
@@ -301,6 +323,9 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_BIG_ENDIAN, 128),
 	[NFT_CT_SECMARK]	= CT_TEMPLATE("secmark", &integer_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
+	[NFT_CT_DSCPMARK]	= CT_TEMPLATE("dscpmark", &ct_dscpmark_type,
+					      BYTEORDER_HOST_ENDIAN,
+					      8 * BITS_PER_BYTE),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
diff --git a/src/datatype.c b/src/datatype.c
index b9e167e03765..bd4be5f3a556 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -74,6 +74,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_TIME_DATE]	= &date_type,
 	[TYPE_TIME_HOUR]	= &hour_type,
 	[TYPE_TIME_DAY]		= &day_type,
+	[TYPE_CT_DSCPMARK]      = &ct_dscpmark_type,
 };
 
 const struct datatype *datatype_lookup(enum datatypes type)
diff --git a/src/json.c b/src/json.c
index 3498e24db363..b8714891f501 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1093,6 +1093,15 @@ json_t *gid_type_json(const struct expr *expr, struct output_ctx *octx)
 	return json_integer(gid);
 }
 
+json_t *ct_dscpmark_type_json(const struct expr *expr, struct output_ctx *octx)
+{
+	uint64_t ct_dscpmark = mpz_get_uint64(expr->value);
+	uint32_t dscpshift   = ct_dscpmark >> 32;
+	uint32_t statemask   = ct_dscpmark & 0xffffffff;
+
+	return json_pack("[ii]", 0x3f << dscpshift, statemask);
+}
+
 json_t *expr_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	return expr_print_json(stmt->expr, octx);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 707f46716ed3..e7a2e222f88d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -448,6 +448,7 @@ int nft_lex(void *, void *, void *);
 %token STATUS			"status"
 %token ORIGINAL			"original"
 %token REPLY			"reply"
+%token DSCPMARK			"dscpmark"
 
 %token COUNTER			"counter"
 %token NAME			"name"
@@ -658,8 +659,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			multiton_stmt_expr
 %destructor { expr_free($$); }	multiton_stmt_expr
-%type <expr>			prefix_stmt_expr range_stmt_expr wildcard_expr
-%destructor { expr_free($$); }	prefix_stmt_expr range_stmt_expr wildcard_expr
+%type <expr>			ct_dscpmark_stmt_expr prefix_stmt_expr range_stmt_expr wildcard_expr
+%destructor { expr_free($$); }	ct_dscpmark_stmt_expr prefix_stmt_expr range_stmt_expr wildcard_expr
 
 %type <expr>			primary_stmt_expr basic_stmt_expr
 %destructor { expr_free($$); }	primary_stmt_expr basic_stmt_expr
@@ -3020,6 +3021,50 @@ map_stmt_expr		:	concat_stmt_expr	MAP	map_stmt_expr_set
 			|	concat_stmt_expr	{ $$ = $1; }
 			;
 
+ct_dscpmark_stmt_expr	:	NUM	SLASH	NUM
+			{
+				uint32_t dscpmask  = $1;
+				uint32_t statemask = $3;
+				uint32_t dscpshift = 0;
+				uint64_t ct_dscpmark;
+
+				if (dscpmask & statemask) {
+					erec_queue(error(&@$,
+							 "State mask overlaps with DSCP mask"),
+						   state->msgs);
+					YYERROR;
+				}
+
+				for (uint32_t m = 0x3f;
+				     m != (m & dscpmask) && dscpshift <= 26;
+				     m <<= 1, dscpshift++)
+					;
+
+				if (dscpshift > 26) {
+					erec_queue(error(&@1,
+							 "DSCP mask not found"),
+						   state->msgs);
+					YYERROR;
+				}
+
+				if (~(0x3f << dscpshift) & dscpmask) {
+					erec_queue(error(&@1,
+							 "Invalid DSCP mask"),
+						   state->msgs);
+					YYERROR;
+				}
+
+				ct_dscpmark = ((uint64_t) dscpshift << 32) | statemask;
+
+				$$ = constant_expr_alloc(&@$,
+							 &ct_dscpmark_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(ct_dscpmark) *
+							 BITS_PER_BYTE,
+							 &ct_dscpmark);
+			}
+			;
+
 prefix_stmt_expr	:	basic_stmt_expr	SLASH	NUM
 			{
 				$$ = prefix_expr_alloc(&@$, $1, $3);
@@ -4468,6 +4513,10 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr
 			{
 				$$ = ct_stmt_alloc(&@$, $3, $2, $5);
 			}
+			|	CT	DSCPMARK	SET	ct_dscpmark_stmt_expr
+			{
+				$$ = ct_stmt_alloc(&@$, NFT_CT_DSCPMARK, -1, $4);
+			}
 			;
 
 payload_stmt		:	payload_expr		SET	stmt_expr
diff --git a/src/scanner.l b/src/scanner.l
index d32adf4897ae..23a5c06bf267 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -544,6 +544,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "label"			{ return LABEL; }
 "state"			{ return STATE; }
 "status"		{ return STATUS; }
+"dscpmark"		{ return DSCPMARK; }
 
 "numgen"		{ return NUMGEN; }
 "inc"			{ return INC; }
diff --git a/tests/shell/testcases/chains/0040ct_dscpmark_0 b/tests/shell/testcases/chains/0040ct_dscpmark_0
new file mode 100755
index 000000000000..44d7afcf5de3
--- /dev/null
+++ b/tests/shell/testcases/chains/0040ct_dscpmark_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule t c oif lo tcp dport ssh ct dscpmark set 0xfc000000/0x00010000
+"
+
+OUTPUT='table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		oif "lo" tcp dport 22 ct dscpmark set 0xfc000000/0x00010000
+	}
+}'
+
+$NFT -f - <<< "$RULESET"
+
+test "$OUTPUT" = "$($NFT list ruleset)"
+
diff --git a/tests/shell/testcases/chains/0040ct_dscpmark_1 b/tests/shell/testcases/chains/0040ct_dscpmark_1
new file mode 100755
index 000000000000..b5d7a2b3f494
--- /dev/null
+++ b/tests/shell/testcases/chains/0040ct_dscpmark_1
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule t c oif lo tcp dport ssh ct dscpmark set 0xfc000000/0x10000000
+"
+
+if $NFT -f - <<< "$RULESET" 2>/dev/null; then
+	echo "E: accepted overlapping ct dscpmark fields" 1>&2
+	exit 1
+fi
+exit 0
+
diff --git a/tests/shell/testcases/chains/0040ct_dscpmark_2 b/tests/shell/testcases/chains/0040ct_dscpmark_2
new file mode 100755
index 000000000000..054c5f78cba4
--- /dev/null
+++ b/tests/shell/testcases/chains/0040ct_dscpmark_2
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule t c oif lo tcp dport ssh ct dscpmark set 0xf0000000/0x00000000
+"
+
+if $NFT -f - <<< "$RULESET" 2>/dev/null; then
+	echo "E: accepted missing ct dscpmark dscpmask field" 1>&2
+	exit 1
+fi
+exit 0
+
diff --git a/tests/shell/testcases/chains/0040ct_dscpmark_3 b/tests/shell/testcases/chains/0040ct_dscpmark_3
new file mode 100755
index 000000000000..f6fb40863acd
--- /dev/null
+++ b/tests/shell/testcases/chains/0040ct_dscpmark_3
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule t c oif lo tcp dport ssh ct dscpmark set 0xfc000001/0x01000000
+"
+
+if $NFT -f - <<< "$RULESET" 2>/dev/null; then
+	echo "E: accepted invalid ct dscpmark dscpmask field" 1>&2
+	exit 1
+fi
+exit 0
+
-- 
2.24.0

