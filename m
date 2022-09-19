Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EF9ECAAD3
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Sep 2022 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiISUNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Sep 2022 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiISUND (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Sep 2022 16:13:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572B2481D5
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Sep 2022 13:13:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oaN8W-0002Aa-AC; Mon, 19 Sep 2022 22:13:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft] iptables-nft: must withdraw PAYLOAD flag after parsing
Date:   Mon, 19 Sep 2022 22:12:54 +0200
Message-Id: <20220919201254.32253-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

else, next payload is stacked via 'CTX_PREV_PAYLOAD'.

Example breakage:

ip saddr 1.2.3.4 meta l4proto tcp
... is dumped as
-s 6.0.0.0 -p tcp

iptables-nft -s 1.2.3.4 -p tcp is dumped correctly, because
the expressions are ordered like:
meta l4proto tcp ip saddr 1.2.3.4

... and 'meta l4proto' will clear the PAYLOAD flag.

Fixes: 250dce876d92 ("nft-shared: support native tcp port delinearize")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c                         |  2 ++
 .../ipt-restore/0018-multi-payload_0          | 27 +++++++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 71e2f18dab92..66e09e8fd533 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -986,6 +986,8 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 			nft_parse_transport(ctx, e, ctx->cs);
 			break;
 		}
+
+		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
 	}
 }
 
diff --git a/iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0 b/iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0
new file mode 100755
index 000000000000..f27577540d6e
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# Make sure iptables-restore simply ignores
+# rules starting with -6
+
+set -e
+
+# show rules, drop uninteresting policy settings
+ipt_show() {
+	$XT_MULTI iptables-save | grep -- '-A INPUT'
+}
+
+# issue reproducer for iptables-restore
+
+$XT_MULTI iptables-restore <<EOF
+*filter
+-A INPUT -s 1.2.3.0/25 -p udp
+-A INPUT -s 1.2.3.0/26 -d 5.6.7.8/32
+-A INPUT -s 1.2.3.0/27 -d 10.2.0.0/16 -p tcp -j ACCEPT
+COMMIT
+EOF
+
+EXPECT='-A INPUT -s 1.2.3.0/25 -p udp
+-A INPUT -s 1.2.3.0/26 -d 5.6.7.8/32
+-A INPUT -s 1.2.3.0/27 -d 10.2.0.0/16 -p tcp -j ACCEPT'
+
+diff -u -Z <(echo -e "$EXPECT") <(ipt_show)
-- 
2.35.1

