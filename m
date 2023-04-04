Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51ECC761AF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 09:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjDDJqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 05:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbjDDJqP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 05:46:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD2D199E
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 02:45:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pjdEg-0004k5-2q; Tue, 04 Apr 2023 11:45:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables 2/2] ebtables-nft: add broute table emulation
Date:   Tue,  4 Apr 2023 11:45:44 +0200
Message-Id: <20230404094544.2892-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404094544.2892-1-fw@strlen.de>
References: <20230404094544.2892-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use new 'meta broute set 1' to emulate -t broute.  If '-t broute' is given,
automatically translate -j DROP to 'meta broute set 1 accept' internally.

Reverse translation zaps the broute and pretends verdict was DROP.

Note that BROUTING is internally handled via PREROUTING, i.e. 'redirect'
and 'nat' targets are not available, they will need to be emulated via
nft expressions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/ebtables-nft.8 | 42 +++++++++++++++++++++++++++--------------
 iptables/nft-bridge.c   | 36 +++++++++++++++++++++++++++++++++++
 iptables/nft-shared.c   | 39 +++++++++++++++++++++++++++-----------
 iptables/nft-shared.h   |  3 +++
 iptables/nft.c          | 13 +++++++++++++
 iptables/nft.h          |  3 ++-
 6 files changed, 110 insertions(+), 26 deletions(-)

diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index d75aae240bc0..d639bdf5e292 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -55,7 +55,7 @@ It is analogous to the
 application, but less complicated, due to the fact that the Ethernet protocol
 is much simpler than the IP protocol.
 .SS CHAINS
-There are two ebtables tables with built-in chains in the
+There are three ebtables tables with built-in chains in the
 Linux kernel. These tables are used to divide functionality into
 different sets of rules. Each set of rules is called a chain.
 Each chain is an ordered list of rules that can match Ethernet frames. If a
@@ -81,7 +81,10 @@ an 'extension' (see below) or a jump to a user-defined chain.
 .B ACCEPT
 means to let the frame through.
 .B DROP
-means the frame has to be dropped.
+means the frame has to be dropped. In the
+.BR BROUTING " chain however, the " ACCEPT " and " DROP " target have different"
+meanings (see the info provided for the
+.BR -t " option)."
 .B CONTINUE
 means the next rule has to be checked. This can be handy, f.e., to know how many
 frames pass a certain point in the chain, to log those frames or to apply multiple
@@ -93,17 +96,13 @@ For the extension targets please refer to the
 .B "TARGET EXTENSIONS"
 section of this man page.
 .SS TABLES
-As stated earlier, there are two ebtables tables in the Linux
-kernel.  The table names are
-.BR filter " and " nat .
-Of these two tables,
+As stated earlier, the table names are
+.BR filter ", " nat " and " broute .
+Of these tables,
 the filter table is the default table that the command operates on.
-If you are working with the filter table, then you can drop the '-t filter'
-argument to the ebtables command.  However, you will need to provide
-the -t argument for
-.B nat
-table.  Moreover, the -t argument must be the
-first argument on the ebtables command line, if used. 
+If you are working with the a table other than filter, you will need to provide
+the -t argument.  Moreover, the -t argument must be the
+first argument on the ebtables command line, if used.
 .TP
 .B "-t, --table"
 .br
@@ -131,6 +130,23 @@ iptables world to ebtables it is easier to have the same names. Note that you
 can change the name
 .BR "" ( -E )
 if you don't like the default.
+.br
+.br
+.B broute
+is used to make a brouter, it has one built-in chain:
+.BR BROUTING .
+The targets
+.BR DROP " and " ACCEPT
+have a special meaning in the broute table (these names are used for
+compatibility reasons with ebtables-legacy).
+.B DROP
+actually means the frame has to be routed, while
+.B ACCEPT
+means the frame has to be bridged. The
+.B BROUTING
+chain is traversed very early.
+Normally those frames
+would be bridged, but you can decide otherwise here.
 .SH EBTABLES COMMAND LINE ARGUMENTS
 After the initial ebtables '-t table' command line argument, the remaining
 arguments can be divided into several groups.  These groups
@@ -1059,8 +1075,6 @@ arp message and the hardware address length in the arp header is 6 bytes.
 .BR "" "See " http://netfilter.org/mailinglists.html
 .SH BUGS
 The version of ebtables this man page ships with does not support the
-.B broute
-table. Also there is no support for
 .B string
 match. Further, support for atomic-options
 .RB ( --atomic-file ", " --atomic-init ", " --atomic-save ", " --atomic-commit )
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index b9983b203f6d..22860d6b91a6 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -95,8 +95,44 @@ static void add_logical_outiface(struct nft_handle *h, struct nftnl_rule *r,
 		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
 }
 
+static int add_meta_broute(struct nftnl_rule *r)
+{
+	struct nftnl_expr *expr;
+
+	expr = nftnl_expr_alloc("immediate");
+	if (expr == NULL)
+		return -1;
+
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_IMM_DREG, NFT_REG32_01);
+	nftnl_expr_set_u8(expr, NFTNL_EXPR_IMM_DATA, 1);
+	nftnl_rule_add_expr(r, expr);
+
+	expr = nftnl_expr_alloc("meta");
+	if (expr == NULL)
+		return -1;
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, NFT_META_BRI_BROUTE);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_SREG, NFT_REG32_01);
+
+	nftnl_rule_add_expr(r, expr);
+	return 0;
+}
+
 static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 {
+	const char *table = nftnl_rule_get_str(r, NFTNL_RULE_TABLE);
+
+	if (cs->target &&
+	    table && strcmp(table, "broute") == 0) {
+		if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0) {
+			int ret = add_meta_broute(r);
+
+			if (ret)
+				return ret;
+
+			cs->jumpto = "ACCEPT";
+		}
+	}
+
 	return add_action(r, cs, false);
 }
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 1b22eb7afd30..c19d78e46972 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -511,8 +511,24 @@ void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv)
 	*inv = (op == NFT_CMP_NEQ);
 }
 
-static void nft_meta_set_to_target(struct nft_xt_ctx *ctx,
-				   struct nftnl_expr *e)
+static bool nft_parse_meta_set_common(struct nft_xt_ctx* ctx,
+				      struct nft_xt_ctx_reg *sreg)
+{
+	if ((sreg->type != NFT_XT_REG_IMMEDIATE)) {
+		ctx->errmsg = "meta sreg is not an immediate";
+		return false;
+	}
+
+	if (sreg->immediate.data[0] == 0) {
+		ctx->errmsg = "meta sreg immediate is 0";
+		return false;
+	}
+
+	return true;
+}
+
+static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
+			       struct nftnl_expr *e)
 {
 	struct xtables_target *target;
 	struct nft_xt_ctx_reg *sreg;
@@ -528,18 +544,17 @@ static void nft_meta_set_to_target(struct nft_xt_ctx *ctx,
 
 	switch (nftnl_expr_get_u32(e, NFTNL_EXPR_META_KEY)) {
 	case NFT_META_NFTRACE:
-		if ((sreg->type != NFT_XT_REG_IMMEDIATE)) {
-			ctx->errmsg = "meta nftrace but reg not immediate";
+		if (!nft_parse_meta_set_common(ctx, sreg))
 			return;
-		}
-
-		if (sreg->immediate.data[0] == 0) {
-			ctx->errmsg = "trace is cleared";
-			return;
-		}
 
 		targname = "TRACE";
 		break;
+	case NFT_META_BRI_BROUTE:
+		if (!nft_parse_meta_set_common(ctx, sreg))
+			return;
+
+		ctx->cs->jumpto = "DROP";
+		return;
 	default:
 		ctx->errmsg = "meta sreg key not supported";
 		return;
@@ -568,7 +583,7 @@ static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
         struct nft_xt_ctx_reg *reg;
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_META_SREG)) {
-		nft_meta_set_to_target(ctx, e);
+		nft_parse_meta_set(ctx, e);
 		return;
 	}
 
@@ -1145,6 +1160,8 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	/* Standard target? */
 	switch(verdict) {
 	case NF_ACCEPT:
+		if (cs->jumpto && strcmp(ctx->table, "broute") == 0)
+			break;
 		cs->jumpto = "ACCEPT";
 		break;
 	case NF_DROP:
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index b8bc1a6ce2e9..2c4c0d90cd07 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -61,6 +61,9 @@ struct nft_xt_ctx_reg {
 		struct {
 			uint32_t key;
 		} meta_dreg;
+		struct {
+			uint32_t key;
+		} meta_sreg;
 	};
 
 	struct {
diff --git a/iptables/nft.c b/iptables/nft.c
index 5ef5335a24c1..1cb104e75ccc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -643,6 +643,19 @@ static const struct builtin_table xtables_bridge[NFT_TABLE_MAX] = {
 			},
 		},
 	},
+	[NFT_TABLE_BROUTE] = {
+		.name = "broute",
+		.type	= NFT_TABLE_BROUTE,
+		.chains = {
+			{
+				.name   = "BROUTING",
+				.type   = "filter",
+				.prio   = NF_BR_PRI_FIRST,
+				.hook   = NF_BR_PRE_ROUTING,
+			},
+		},
+	},
+
 };
 
 static int nft_table_builtin_add(struct nft_handle *h,
diff --git a/iptables/nft.h b/iptables/nft.h
index 56005863ed4c..1d18982dc8cf 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -14,8 +14,9 @@ enum nft_table_type {
 	NFT_TABLE_RAW,
 	NFT_TABLE_FILTER,
 	NFT_TABLE_NAT,
+	NFT_TABLE_BROUTE,
 };
-#define NFT_TABLE_MAX	(NFT_TABLE_NAT + 1)
+#define NFT_TABLE_MAX	(NFT_TABLE_BROUTE + 1)
 
 struct builtin_chain {
 	const char *name;
-- 
2.39.2

