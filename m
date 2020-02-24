Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74CEC35673
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B204E2071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgBXAEC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:04:02 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46022 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727210AbgBXAEC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:04:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j61E6-0004lu-6o; Mon, 24 Feb 2020 01:03:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     nevola@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/6] src: allow nat maps containing both ip(6) address and port
Date:   Mon, 24 Feb 2020 01:03:23 +0100
Message-Id: <20200224000324.9333-6-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224000324.9333-1-fw@strlen.de>
References: <20200224000324.9333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft will now be able to handle
map destinations {
	type ipv4_addr . inet_service : ipv4_addr . inet_service
}

chain f {
	dnat to ip daddr . tcp dport map @destinations
}

Something like this won't work though:
 meta l4proto tcp dnat ip6 to numgen inc mod 4 map { 0 : dead::f001 . 8080, ..

as we lack the type info to properly dissect "dead::f001" as an ipv6
address.

For the named map case, this info is available in the map
definition, but for the anon case we'd need to resort to guesswork.

Support is added by peeking into the map definition when evaluating
a nat statement with a map.
Right now, when a map is provided as address, we will only check that
the mapped-to data type matches the expected size (of an ipv4 or ipv6
address).

After this patch, if the mapped-to type is a concatenation, it will
take a peek at the individual concat expressions.  If its a combination
of address and service, nft will translate this so that the kernel nat
expression looks at the returned register that would store the
inet_service part of the octet soup returned from the lookup expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/statement.h       |  1 +
 src/evaluate.c            | 56 +++++++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c | 36 +++++++++++++++++++++++++
 src/netlink_linearize.c   | 31 +++++++++++++++++++++-
 4 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/include/statement.h b/include/statement.h
index 585908de7da2..8fb459ca1cd4 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -125,6 +125,7 @@ struct nat_stmt {
 	struct expr		*proto;
 	uint32_t		flags;
 	uint8_t			family;
+	bool			ipportmap;
 };
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc,
diff --git a/src/evaluate.c b/src/evaluate.c
index ce1e65f48995..0afd0403d3a4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2849,6 +2849,52 @@ static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 	return err;
 }
 
+static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct expr *one, *two, *data, *tmp;
+	const struct datatype *dtype;
+	int err;
+
+	dtype = get_addr_dtype(stmt->nat.family);
+
+	expr_set_context(&ctx->ectx, dtype, dtype->size);
+	if (expr_evaluate(ctx, &stmt->nat.addr))
+		return -1;
+
+	data = stmt->nat.addr->mappings->set->data;
+	if (expr_ops(data)->type != EXPR_CONCAT)
+		return __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+					   BYTEORDER_BIG_ENDIAN,
+					   &stmt->nat.addr);
+
+	one = list_first_entry(&data->expressions, struct expr, list);
+	two = list_entry(one->list.next, struct expr, list);
+
+	if (one == two || !list_is_last(&two->list, &data->expressions))
+		return __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+					   BYTEORDER_BIG_ENDIAN,
+					   &stmt->nat.addr);
+
+	tmp = one;
+	err = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+				  BYTEORDER_BIG_ENDIAN,
+				  &tmp);
+	if (err < 0)
+		return err;
+	if (tmp != one)
+		BUG("Internal error: Unexpected alteration of l3 expression");
+
+	tmp = two;
+	err = nat_evaluate_transport(ctx, stmt, &tmp);
+	if (err < 0)
+		return err;
+	if (tmp != two)
+		BUG("Internal error: Unexpected alteration of l4 expression");
+
+	stmt->nat.ipportmap = true;
+	return err;
+}
+
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -2862,6 +2908,16 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		if (err < 0)
 			return err;
 
+		if (stmt->nat.proto == NULL &&
+		    expr_ops(stmt->nat.addr)->type == EXPR_MAP) {
+			err = stmt_evaluate_nat_map(ctx, stmt);
+			if (err < 0)
+				return err;
+
+			stmt->flags |= STMT_F_TERMINAL;
+			return 0;
+		}
+
 		err = stmt_evaluate_addr(ctx, stmt, stmt->nat.family,
 					 &stmt->nat.addr);
 		if (err < 0)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4f774fb9f150..6203a53c6154 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -978,6 +978,35 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
+static bool is_nat_proto_map(const struct expr *addr, uint8_t family)
+{
+	const struct expr *mappings, *data;
+	const struct set *set;
+
+	if (!addr ||
+	    expr_ops(addr)->type != EXPR_MAP)
+		return false;
+
+	mappings = addr->right;
+	if (expr_ops(mappings)->type != EXPR_SET_REF)
+		return false;
+
+	set = mappings->set;
+	data = set->data;
+
+	/* if we're dealing with an address:inet_service map,
+	 * the length will be bit_sizeof(addr) + 32 (one register).
+	 */
+	switch (family) {
+	case NFPROTO_IPV4:
+		return data->len == 32 + 32;
+	case NFPROTO_IPV6:
+		return data->len == 128 + 32;
+	}
+
+	return false;
+}
+
 static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
@@ -998,6 +1027,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_NAT_FLAGS))
 		stmt->nat.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FLAGS);
 
+	addr = NULL;
 	reg1 = netlink_parse_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
 		addr = netlink_get_register(ctx, loc, reg1);
@@ -1034,6 +1064,12 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
+	if (is_nat_proto_map(addr, family)) {
+		stmt->nat.ipportmap = true;
+		ctx->stmt = stmt;
+		return;
+	}
+
 	reg1 = netlink_parse_register(nle, NFTNL_EXPR_NAT_REG_PROTO_MIN);
 	if (reg1) {
 		proto = netlink_get_register(ctx, loc, reg1);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b542aa3be23f..de461775a7e1 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1052,14 +1052,25 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static unsigned int nat_addrlen(uint8_t family)
+{
+	switch (family) {
+	case NFPROTO_IPV4: return 32;
+	case NFPROTO_IPV6: return 128;
+	}
+
+	BUG("invalid nat family %u\n", family);
+	return 0;
+}
+
 static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 	enum nft_registers amin_reg, amax_reg;
 	enum nft_registers pmin_reg, pmax_reg;
+	uint8_t family = 0;
 	int registers = 0;
-	int family;
 	int nftnl_flag_attr;
 	int nftnl_reg_pmin, nftnl_reg_pmax;
 
@@ -1118,6 +1129,24 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 					     amin_reg);
 		}
 
+		if (stmt->nat.ipportmap) {
+			/* nat_stmt evaluation step doesn't allow
+			 * stmt->nat.ipportmap && stmt->nat.proto.
+			 */
+			assert(stmt->nat.proto == NULL);
+
+			pmin_reg = amin_reg;
+
+			/* if ipportmap is set, the mapped type is a
+			 * concatenation of 'addr . inet_service'.
+			 * The map lookup will then return the
+			 * concatenated value, so we need to skip
+			 * the address and use the register that
+			 * will hold the inet_service part.
+			 */
+			pmin_reg += netlink_register_space(nat_addrlen(family));
+			netlink_put_register(nle, nftnl_reg_pmin, pmin_reg);
+		}
 	}
 
 	if (stmt->nat.proto) {
-- 
2.24.1

