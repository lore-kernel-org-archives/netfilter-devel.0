Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEC7C4321E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78E8619F8
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353627AbhJARr0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FAFC0613E4
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/r06e2Bl3qL5kC52SgyZbcnrBLYOwAKmudZToPuh07Y=; b=lJlgBOHCm/9neH4J4izlU1jwyh
        2puNRhhMXecnE6O9wCw3X1veOAB+kzH3r5EUpRRU2dTvtTVjjpiqV+lNuoM4LBcaIxX9Ef4x2G9jU
        DJhfmdN9cErjqJenywdCYkgW3rK876G8qzJ3yHG5pP7CUGDD+XJjNi2OKE6PqFVPgm5eYRGnZzr5z
        l8JgrNGZe/rKgAexK/E7d5KJySWE9espE7fFQf2kOe6b4nf1/UnwuuYpnO2Hn9xcJAM66tEinTCTK
        alPzh3k0GHy7QZVASFTWIZOGW+gb48spAFzXrKtLwqtxGlKxN6Fj1Cz/ei/mAPRCA4Hv8E0F4ifKY
        I3YPlsaA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbG-002RLP-NO; Fri, 01 Oct 2021 18:45:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 3/8] extensions: libxt_NFLOG: don't truncate log prefix on print/save
Date:   Fri,  1 Oct 2021 18:41:37 +0100
Message-Id: <20211001174142.1267726-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kyle Bowman <kbowman@cloudflare.com>

When parsing the rule, use a struct with a layout compatible to that of
struct xt_nflog_info, but with a buffer large enough to contain the
whole 128-character nft prefix.

We always send the nflog-group to the kernel since, for nft, log and
nflog targets are handled by the same kernel module, and are
distinguished by whether they define an nflog-group. Therefore, we must
send the group even if it is zero, or the kernel will configure the
target as a log, not an nflog.

Changes to nft_is_expr_compatible were made since only targets which
have an `nflog-group` are compatible. Since nflog targets are
distinguished by having an nflog-group, we ignore targets without one.

We also set the copy-len flag if the snap-len is set since without this,
iptables will mistake `nflog-size` for `nflog-range`.

Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
Signed-off-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 52 +++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.c        |  4 ++++
 2 files changed, 56 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 4253b08196d2..2430bac44bb0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -20,8 +20,10 @@
 
 #include <xtables.h>
 
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
+#include <linux/netfilter/xt_NFLOG.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
@@ -595,6 +597,54 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
+static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
+{
+	struct xtables_target *target;
+	struct xt_entry_target *t;
+	size_t target_size;
+	/*
+	 * In order to handle the longer log-prefix supported by nft, instead of
+	 * using struct xt_nflog_info, we use a struct with a compatible layout, but
+	 * a larger buffer for the prefix.
+	 */
+	struct xt_nflog_info_nft {
+		__u32 len;
+		__u16 group;
+		__u16 threshold;
+		__u16 flags;
+		__u16 pad;
+		char  prefix[NF_LOG_PREFIXLEN];
+	} info = {
+		.group     = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP),
+		.threshold = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD),
+	};
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_SNAPLEN)) {
+		info.len = nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
+		info.flags = XT_NFLOG_F_COPY_LEN;
+	}
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_PREFIX))
+		snprintf(info.prefix, sizeof(info.prefix), "%s",
+			 nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
+
+	target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
+	if (target == NULL)
+		return;
+
+	target_size = XT_ALIGN(sizeof(struct xt_entry_target)) +
+		      XT_ALIGN(sizeof(struct xt_nflog_info_nft));
+
+	t = xtables_calloc(1, target_size);
+	t->u.target_size = target_size;
+	strcpy(t->u.user.name, target->name);
+	t->u.user.revision = target->revision;
+
+	target->t = t;
+
+	memcpy(&target->t->data, &info, sizeof(info));
+
+	ctx->h->ops->parse_target(target, ctx->cs);
+}
+
 static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 			     struct nftnl_expr *e)
 {
@@ -644,6 +694,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_limit(&ctx, expr);
 		else if (strcmp(name, "lookup") == 0)
 			nft_parse_lookup(&ctx, h, expr);
+		else if (strcmp(name, "log") == 0)
+			nft_parse_log(&ctx, expr);
 
 		expr = nftnl_expr_iter_next(iter);
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index 53506c9475c0..58943088f832 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3527,6 +3527,10 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
 	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_FLAGS) == 0)
 		return 0;
 
+	if (!strcmp(name, "log") &&
+	    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
+		return 0;
+
 	return -1;
 }
 
-- 
2.33.0

