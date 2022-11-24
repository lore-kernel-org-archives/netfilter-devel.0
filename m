Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D36CC4708A
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiKXNuJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 08:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiKXNuF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 08:50:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C374E3AC0D
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 05:49:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oyCc1-0000UQ-9H; Thu, 24 Nov 2022 14:49:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 3/3] extensions: remove trailing spaces
Date:   Thu, 24 Nov 2022 14:49:39 +0100
Message-Id: <20221124134939.8245-4-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221124134939.8245-1-fw@strlen.de>
References: <20221124134939.8245-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous patches cause minor test breakage, e.g:
exp: nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460'
res: nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460 '

So fix up the ->xlate callbacks of the affected modules to not print a
tailing space character.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_CONNMARK.c |  2 +-
 extensions/libxt_MARK.c     | 16 ++++++++--------
 extensions/libxt_NFLOG.c    |  2 +-
 extensions/libxt_NFQUEUE.c  | 22 +++++++++++-----------
 extensions/libxt_SYNPROXY.c | 12 ++++++------
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index a6568c99b6c4..054dcc5b5019 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -601,7 +601,7 @@ static int connmark_tg_xlate_v2(struct xt_xlate *xl,
 	case XT_CONNMARK_SET:
 		xt_xlate_add(xl, "ct mark set %s", braces);
 		if (info->ctmask == 0xFFFFFFFFU)
-			xt_xlate_add(xl, "0x%x ", info->ctmark);
+			xt_xlate_add(xl, "0x%x", info->ctmark);
 		else if (info->ctmark == 0)
 			xt_xlate_add(xl, "ct mark and 0x%x", ~info->ctmask);
 		else if (info->ctmark == info->ctmask)
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 100f6a38996a..73c5ec8720b5 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -334,15 +334,15 @@ static int mark_tg_xlate(struct xt_xlate *xl,
 	xt_xlate_add(xl, "meta mark set ");
 
 	if (info->mask == 0xffffffffU)
-		xt_xlate_add(xl, "0x%x ", info->mark);
+		xt_xlate_add(xl, "0x%x", info->mark);
 	else if (info->mark == 0)
-		xt_xlate_add(xl, "mark and 0x%x ", ~info->mask);
+		xt_xlate_add(xl, "mark and 0x%x", ~info->mask);
 	else if (info->mark == info->mask)
-		xt_xlate_add(xl, "mark or 0x%x ", info->mark);
+		xt_xlate_add(xl, "mark or 0x%x", info->mark);
 	else if (info->mask == 0)
-		xt_xlate_add(xl, "mark xor 0x%x ", info->mark);
+		xt_xlate_add(xl, "mark xor 0x%x", info->mark);
 	else
-		xt_xlate_add(xl, "mark and 0x%x xor 0x%x ", ~info->mask,
+		xt_xlate_add(xl, "mark and 0x%x xor 0x%x", ~info->mask,
 			     info->mark);
 
 	return 1;
@@ -358,13 +358,13 @@ static int MARK_xlate(struct xt_xlate *xl,
 
 	switch(markinfo->mode) {
 	case XT_MARK_SET:
-		xt_xlate_add(xl, "0x%x ", (uint32_t)markinfo->mark);
+		xt_xlate_add(xl, "0x%x", (uint32_t)markinfo->mark);
 		break;
 	case XT_MARK_AND:
-		xt_xlate_add(xl, "mark and 0x%x ", (uint32_t)markinfo->mark);
+		xt_xlate_add(xl, "mark and 0x%x", (uint32_t)markinfo->mark);
 		break;
 	case XT_MARK_OR:
-		xt_xlate_add(xl, "mark or 0x%x ", (uint32_t)markinfo->mark);
+		xt_xlate_add(xl, "mark or 0x%x", (uint32_t)markinfo->mark);
 		break;
 	default:
 		return 0;
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index d12ef044f0ed..2e3f7fa8a4f7 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -122,7 +122,7 @@ static void nflog_print_xlate(const struct xt_nflog_info *info,
 		xt_xlate_add(xl, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
 		xt_xlate_add(xl, "queue-threshold %u ", info->threshold);
-	xt_xlate_add(xl, "group %u ", info->group);
+	xt_xlate_add(xl, "group %u", info->group);
 }
 
 static int NFLOG_xlate(struct xt_xlate *xl,
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index ca6cdaf49703..b9e1c2134d25 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -276,7 +276,7 @@ static int NFQUEUE_xlate(struct xt_xlate *xl,
 	const struct xt_NFQ_info *tinfo =
 		(const struct xt_NFQ_info *)params->target->data;
 
-	xt_xlate_add(xl, "queue num %u ", tinfo->queuenum);
+	xt_xlate_add(xl, "queue num %u", tinfo->queuenum);
 
 	return 1;
 }
@@ -289,9 +289,9 @@ static int NFQUEUE_xlate_v1(struct xt_xlate *xl,
 
 	if (last > 1) {
 		last += tinfo->queuenum - 1;
-		xt_xlate_add(xl, "queue num %u-%u ", tinfo->queuenum, last);
+		xt_xlate_add(xl, "queue num %u-%u", tinfo->queuenum, last);
 	} else {
-		xt_xlate_add(xl, "queue num %u ", tinfo->queuenum);
+		xt_xlate_add(xl, "queue num %u", tinfo->queuenum);
 	}
 
 	return 1;
@@ -305,12 +305,12 @@ static int NFQUEUE_xlate_v2(struct xt_xlate *xl,
 
 	if (last > 1) {
 		last += info->queuenum - 1;
-		xt_xlate_add(xl, "queue num %u-%u ", info->queuenum, last);
+		xt_xlate_add(xl, "queue num %u-%u", info->queuenum, last);
 	} else
-		xt_xlate_add(xl, "queue num %u ", info->queuenum);
+		xt_xlate_add(xl, "queue num %u", info->queuenum);
 
 	if (info->bypass & NFQ_FLAG_BYPASS)
-		xt_xlate_add(xl, "bypass");
+		xt_xlate_add(xl, " bypass");
 
 	return 1;
 }
@@ -323,16 +323,16 @@ static int NFQUEUE_xlate_v3(struct xt_xlate *xl,
 
 	if (last > 1) {
 		last += info->queuenum - 1;
-		xt_xlate_add(xl, "queue num %u-%u ", info->queuenum, last);
+		xt_xlate_add(xl, "queue num %u-%u", info->queuenum, last);
 	} else
-		xt_xlate_add(xl, "queue num %u ", info->queuenum);
+		xt_xlate_add(xl, "queue num %u", info->queuenum);
 
 	if (info->flags & NFQ_FLAG_BYPASS)
-		xt_xlate_add(xl, "bypass");
+		xt_xlate_add(xl, " bypass");
 
 	if (info->flags & NFQ_FLAG_CPU_FANOUT)
-		xt_xlate_add(xl, "%sfanout ",
-			     info->flags & NFQ_FLAG_BYPASS ? "," : "");
+		xt_xlate_add(xl, "%sfanout",
+			     info->flags & NFQ_FLAG_BYPASS ? "," : " ");
 
 	return 1;
 }
diff --git a/extensions/libxt_SYNPROXY.c b/extensions/libxt_SYNPROXY.c
index 6a0b913e03b5..3662ff9ac01a 100644
--- a/extensions/libxt_SYNPROXY.c
+++ b/extensions/libxt_SYNPROXY.c
@@ -112,18 +112,18 @@ static int SYNPROXY_xlate(struct xt_xlate *xl,
 	const struct xt_synproxy_info *info =
 		(const struct xt_synproxy_info *)params->target->data;
 
-	xt_xlate_add(xl, "synproxy ");
+	xt_xlate_add(xl, "synproxy");
 
 	if (info->options & XT_SYNPROXY_OPT_SACK_PERM)
-		xt_xlate_add(xl, "sack-perm ");
+		xt_xlate_add(xl, " sack-perm");
 	if (info->options & XT_SYNPROXY_OPT_TIMESTAMP)
-		xt_xlate_add(xl, "timestamp ");
+		xt_xlate_add(xl, " timestamp");
 	if (info->options & XT_SYNPROXY_OPT_WSCALE)
-		xt_xlate_add(xl, "wscale %u ", info->wscale);
+		xt_xlate_add(xl, " wscale %u", info->wscale);
 	if (info->options & XT_SYNPROXY_OPT_MSS)
-		xt_xlate_add(xl, "mss %u ", info->mss);
+		xt_xlate_add(xl, " mss %u", info->mss);
 	if (info->options & XT_SYNPROXY_OPT_ECN)
-		xt_xlate_add(xl, "ecn ");
+		xt_xlate_add(xl, " ecn");
 
 	return 1;
 }
-- 
2.37.4

