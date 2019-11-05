Return-Path: <SRS0=AHIo=Y5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BDCC5DF60
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Nov 2019 21:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C008E21882
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Nov 2019 21:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZjQWpm0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfKEVk3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Nov 2019 16:40:29 -0500
Received: from kadath.azazel.net ([81.187.231.250]:53434 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKEVk3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Nov 2019 16:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cWMV1PlpO32zM6Ia7iWlTq54tVzYHgPxhaRuu94cdZ4=; b=ZjQWpm0aEBbKwvGSDeoOJICwuj
        rmRV3X5Yz0BSpQJt0UZwViEn6kPNGIADVGMmYFyosVZXHx8N86HgWAn2n1wHaWc+O1vg8+i8XMRnF
        mhcW48oWE4JHsXFwfHVatErLjxLnN15SgKJ76aRqMnUkX1dvRKPnxtLeHLzidUIYRSyL14ePhSf8I
        5lQCGJi/x1fiBd2lcLtgHjYa6yuOkxrjm/qrMjzo8yubjXfCQQed47lEuV3iEQGNhci1iB5Y/8fhf
        hnizW2vjZKxnKnspqSVTfYNNB2p2hN9dRNjgdrsyebokfjALIICNKcPrqlCvrDgxpSi/bPi98yk91
        CJpRxBIA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iS6Yu-0002ZM-1Z; Tue, 05 Nov 2019 21:40:28 +0000
Date:   Tue, 5 Nov 2019 21:40:26 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] src: add `set_is_meter` helper.
Message-ID: <20191105214026.GA24004@azazel.net>
References: <20191105213154.23929-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20191105213154.23929-1-jeremy@azazel.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Resending with the right subject prefix.

J.

--wac7ysb48OaltWcw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="0001-src-add-set_is_meter-helper.patch"

From 4c3519ba46b4b9cfd24dd94246a40f4857be0e32 Mon Sep 17 00:00:00 2001
From: Jeremy Sowden <jeremy@azazel.net>
Date: Mon, 4 Nov 2019 09:18:07 +0000
Subject: [PATCH nft] src: add `set_is_meter` helper.

The sets constructed for meters are flagged as anonymous and dynamic.
However, in some places there are only checks that they are dynamic,
which can lead to normal sets being classified as meters.

For example:

  # nft add table t
  # nft add set t s { type ipv4_addr; size 256; flags dynamic,timeout; }
  # nft add chain t c
  # nft add rule t c tcp dport 80 meter m size 128 { ip saddr limit rate 10/second }
  # nft list meters
  table ip t {
          set s {
                  type ipv4_addr
                  size 256
                  flags dynamic,timeout
          }
          meter m {
                  type ipv4_addr
                  size 128
                  flags dynamic
          }
  }
  # nft list meter t m
  table ip t {
          meter m {
                  type ipv4_addr
                  size 128
                  flags dynamic
          }
  }
  # nft list meter t s
  Error: No such file or directory
  list meter t s
               ^

Add a new helper `set_is_meter` and use it wherever there are checks for
meters.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/rule.h                              |  5 ++++
 src/evaluate.c                              |  6 ++---
 src/expression.c                            | 12 ++++-----
 src/json.c                                  |  4 +--
 src/rule.c                                  |  9 +++----
 tests/shell/testcases/sets/0038meter_list_0 | 29 +++++++++++++++++++++
 6 files changed, 47 insertions(+), 18 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0038meter_list_0

diff --git a/include/rule.h b/include/rule.h
index 2708cbebc9f8..627741f8e82b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -349,6 +349,11 @@ static inline bool map_is_literal(uint32_t set_flags)
 	return !(set_is_anonymous(set_flags) || !set_is_map(set_flags));
 }
 
+static inline bool set_is_meter(uint32_t set_flags)
+{
+	return set_is_anonymous(set_flags) && (set_flags & NFT_SET_EVAL);
+}
+
 #include <statement.h>
 
 struct counter {
diff --git a/src/evaluate.c b/src/evaluate.c
index a56cd2a56e99..85a218107392 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3870,8 +3870,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (!(set->flags & NFT_SET_EVAL) ||
-			 !(set->flags & NFT_SET_ANONYMOUS))
+		else if (!set_is_meter(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
@@ -4008,8 +4007,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (!(set->flags & NFT_SET_EVAL) ||
-			 !(set->flags & NFT_SET_ANONYMOUS))
+		else if (!set_is_meter(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
diff --git a/src/expression.c b/src/expression.c
index e456010ff8b0..5070b1014392 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1051,14 +1051,12 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 
 static void set_ref_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	if (set_is_anonymous(expr->set->flags)) {
-		if (expr->set->flags & NFT_SET_EVAL)
-			nft_print(octx, "%s", expr->set->handle.set.name);
-		else
-			expr_print(expr->set->init, octx);
-	} else {
+	if (set_is_meter(expr->set->flags))
+		nft_print(octx, "%s", expr->set->handle.set.name);
+	else if (set_is_anonymous(expr->set->flags))
+		expr_print(expr->set->init, octx);
+	else
 		nft_print(octx, "@%s", expr->set->handle.set.name);
-	}
 }
 
 static void set_ref_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/json.c b/src/json.c
index 13a064249d90..50435adce55a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -86,7 +86,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 	} else if (set_is_objmap(set->flags)) {
 		type = "map";
 		datatype_ext = obj_type_name(set->objtype);
-	} else if (set->flags & NFT_SET_EVAL) {
+	} else if (set_is_meter(set->flags)) {
 		type = "meter";
 	} else {
 		type = "set";
@@ -1674,7 +1674,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 			    !set_is_literal(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_METERS &&
-			    !(set->flags & NFT_SET_EVAL))
+			    !set_is_meter(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !map_is_literal(set->flags))
diff --git a/src/rule.c b/src/rule.c
index 64756bcee6b8..f7e19735c3b3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -446,8 +446,7 @@ static void set_print_declaration(const struct set *set,
 	const char *type;
 	uint32_t flags;
 
-	if ((set->flags & (NFT_SET_EVAL | NFT_SET_ANONYMOUS)) ==
-				(NFT_SET_EVAL | NFT_SET_ANONYMOUS))
+	if (set_is_meter(set->flags))
 		type = "meter";
 	else if (set_is_map(set->flags))
 		type = "map";
@@ -534,11 +533,11 @@ static void set_print_declaration(const struct set *set,
 }
 
 static void do_set_print(const struct set *set, struct print_fmt_options *opts,
-			  struct output_ctx *octx)
+			 struct output_ctx *octx)
 {
 	set_print_declaration(set, opts, octx);
 
-	if ((set->flags & NFT_SET_EVAL && nft_output_stateless(octx)) ||
+	if ((set_is_meter(set->flags) && nft_output_stateless(octx)) ||
 	    nft_output_terse(octx)) {
 		nft_print(octx, "%s}%s", opts->tab, opts->nl);
 		return;
@@ -1679,7 +1678,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			    !set_is_literal(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_METERS &&
-			    !(set->flags & NFT_SET_EVAL))
+			    !set_is_meter(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !map_is_literal(set->flags))
diff --git a/tests/shell/testcases/sets/0038meter_list_0 b/tests/shell/testcases/sets/0038meter_list_0
new file mode 100755
index 000000000000..e9e0f6fb02b1
--- /dev/null
+++ b/tests/shell/testcases/sets/0038meter_list_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+#
+# Listing meters should not include dynamic sets in the output
+#
+
+set -e
+
+RULESET="
+  add table t
+  add set t s { type ipv4_addr; size 256; flags dynamic,timeout; }
+  add chain t c
+  add rule t c tcp dport 80 meter m size 128 { ip saddr limit rate 10/second }
+"
+
+expected_output="table ip t {
+	meter m {
+		type ipv4_addr
+		size 128
+		flags dynamic
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
+
+test_output=$($NFT list meters)
+
+test "$test_output" = "$expected_output"
+
-- 
2.24.0.rc1


--wac7ysb48OaltWcw--
