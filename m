Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3807C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A98EF60FD7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242438AbhI1TgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 15:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhI1TgX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 15:36:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16119C06161C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Sep 2021 12:34:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mVIsD-0000OU-E7; Tue, 28 Sep 2021 21:34:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     netfilter@breakpoint.cc, Florian Westphal <fw@strlen.de>,
        Paulo Ricardo Bruck <paulobruck1@gmail.com>
Subject: [PATCH nft] netlink: dynset: set compound expr dtype based on set key definition
Date:   Tue, 28 Sep 2021 21:34:30 +0200
Message-Id: <20210928193430.20328-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <CANSGRxSmW1HZwtZReU10S0Yf1bN2B1f1cV=P1OMbig2mx8=j4Q@mail.gmail.com>
References: <CANSGRxSmW1HZwtZReU10S0Yf1bN2B1f1cV=P1OMbig2mx8=j4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"nft add rule ... add @t { ip saddr . 22 ..." will be listed as
'ip saddr . 0x16  [ invalid type]".

This is a display bug, the compound expression created during netlink
deserialization lacks correct datatypes for the value expression.

Avoid this by setting the individual expressions' datatype.
The set key defintion has those, so walk over the types and set
them as needed.

Also add a test case.

Reported-by: Paulo Ricardo Bruck <paulobruck1@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c                     | 46 ++++++++++++++++++-
 .../testcases/sets/0045concat_ipv4_service    | 16 +++++++
 .../sets/dumps/0045concat_ipv4_service.nft    | 12 +++++
 3 files changed, 73 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/sets/0045concat_ipv4_service
 create mode 100644 tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index bd75ad5cbe1e..0c2b439eac6f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -134,6 +134,50 @@ err:
 	return NULL;
 }
 
+static struct expr *netlink_parse_concat_key(struct netlink_parse_ctx *ctx,
+					       const struct location *loc,
+					       unsigned int reg,
+					       const struct expr *key)
+{
+	uint32_t type = key->dtype->type;
+	unsigned int n, len = key->len;
+	struct expr *concat, *expr;
+	unsigned int consumed;
+
+	concat = concat_expr_alloc(loc);
+	n = div_round_up(fls(type), TYPE_BITS);
+
+	while (len > 0) {
+		const struct datatype *i;
+
+		expr = netlink_get_register(ctx, loc, reg);
+		if (expr == NULL) {
+			netlink_error(ctx, loc,
+				      "Concat expression size mismatch");
+			goto err;
+		}
+
+		if (n > 0 && concat_subtype_id(type, --n)) {
+			i = concat_subtype_lookup(type, n);
+
+			expr_set_type(expr, i, i->byteorder);
+		}
+
+		compound_expr_add(concat, expr);
+
+		consumed = netlink_padded_len(expr->len);
+		assert(consumed > 0);
+		len -= consumed;
+		reg += netlink_register_space(expr->len);
+	}
+
+	return concat;
+
+err:
+	expr_free(concat);
+	return NULL;
+}
+
 static struct expr *netlink_parse_concat_data(struct netlink_parse_ctx *ctx,
 					      const struct location *loc,
 					      unsigned int reg,
@@ -1572,7 +1616,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 
 	if (expr->len < set->key->len) {
 		expr_free(expr);
-		expr = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
+		expr = netlink_parse_concat_key(ctx, loc, sreg, set->key);
 		if (expr == NULL)
 			return;
 	}
diff --git a/tests/shell/testcases/sets/0045concat_ipv4_service b/tests/shell/testcases/sets/0045concat_ipv4_service
new file mode 100755
index 000000000000..5b40f97302ad
--- /dev/null
+++ b/tests/shell/testcases/sets/0045concat_ipv4_service
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+$NFT -f - <<EOF
+table inet t {
+	set s {
+		type ipv4_addr . inet_service
+		size 65536
+		flags dynamic,timeout
+		elements = { 192.168.7.1 . 22 }
+	}
+
+	chain c {
+		tcp dport 21 add @s { ip saddr . 22 timeout 60s }
+	}
+}
+EOF
diff --git a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft
new file mode 100644
index 000000000000..e548a17a142d
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft
@@ -0,0 +1,12 @@
+table inet t {
+	set s {
+		type ipv4_addr . inet_service
+		size 65536
+		flags dynamic,timeout
+		elements = { 192.168.7.1 . 22 }
+	}
+
+	chain c {
+		tcp dport 21 add @s { ip saddr . 22 timeout 1m }
+	}
+}
-- 
2.32.0

