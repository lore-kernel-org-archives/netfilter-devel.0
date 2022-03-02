Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE08C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbiCBPTK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiCBPTJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:19:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC3B21803
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JC9FbDmrPddR6hFZ6haXm2AcbVbPx0rs21iftVrrCKc=; b=Xjf25bfvRCdpPWirQ4SbDyPeSE
        hPtt9mQ1pu12A+SF917/I0S1pR64G5OejUgpWW01pmRAM7/49J1mjdZ5cePT3fGluCtDLW6alpE3F
        K8KL5pepXuvnIfBDC31a+rIvUYfWroN8KihGGb7I8n3iCmVgRoUI0Y4IMFJixKI5YADYVlZY94ZN6
        dKmPcoPfwV7OXNUj0+9YiARlzN/PI154WOF2sx0wtbbsUkkpGgo+eO2P5YP3dSP1GFmhvich0aGgv
        sZXfIIUv+Qvlprlcdhus2GZWb9tetwncyF/MtH3FZ9iXWwEdefoCBEVgct1aJNAI6oVYeY8oFyJFg
        8XWo7wnQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPQkC-00034L-LS; Wed, 02 Mar 2022 16:18:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] nft: Speed up immediate parsing
Date:   Wed,  2 Mar 2022 16:18:05 +0100
Message-Id: <20220302151807.12185-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302151807.12185-1-phil@nwl.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parsing of rules which jump to a chain pointlessly causes a call to
xtables_find_target() despite the code already knowing the outcome.

Avoid the significant delay for rulesets with many chain jumps by
performing the (standard) target lookup only for accept/drop/return
verdicts.

From a biased test-case on my VM:

| # iptables-nft-save | grep -c -- '-j'
| 133943
| # time ./old/iptables-nft-save >/dev/null
| real	0m45.566s
| user	0m1.308s
| sys	0m8.430s
| # time ./new/iptables-nft-save >/dev/null
| real	0m3.547s
| user	0m0.762s
| sys	0m2.476s

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
The same benchmark completes in 1.7s with legacy, in case anyone
wonders.
---
 iptables/nft-bridge.c |  1 +
 iptables/nft-shared.c | 37 ++++++++++++++++++-------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index d6a0d6e518fcb..d342858e1d9d8 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -502,6 +502,7 @@ static void nft_bridge_parse_target(struct xtables_target *t, void *data)
 	}
 
 	cs->target = t;
+	cs->jumpto = t->name;
 }
 
 static void nft_rule_to_ebtables_command_state(struct nft_handle *h,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index daa251ae0982a..861aa0642061e 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -907,6 +907,8 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	const char *chain = nftnl_expr_get_str(e, NFTNL_EXPR_IMM_CHAIN);
 	struct iptables_command_state *cs = ctx->cs;
+	struct xt_entry_target *t;
+	uint32_t size;
 	int verdict;
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_IMM_DATA)) {
@@ -943,8 +945,21 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		/* fall through */
 	case NFT_JUMP:
 		cs->jumpto = chain;
-		break;
+		/* fall through */
+	default:
+		return;
 	}
+
+	cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+	if (!cs->target)
+		return;
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + cs->target->size;
+	t = xtables_calloc(1, size);
+	t->u.target_size = size;
+	t->u.user.revision = cs->target->revision;
+	strcpy(t->u.user.name, cs->jumpto);
+	cs->target->t = t;
 }
 
 static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -1143,25 +1158,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 		}
 	}
 
-	if (cs->target != NULL) {
-		cs->jumpto = cs->target->name;
-	} else if (cs->jumpto != NULL) {
-		struct xt_entry_target *t;
-		uint32_t size;
-
-		cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
-		if (!cs->target)
-			return;
-
-		size = XT_ALIGN(sizeof(struct xt_entry_target)) + cs->target->size;
-		t = xtables_calloc(1, size);
-		t->u.target_size = size;
-		t->u.user.revision = cs->target->revision;
-		strcpy(t->u.user.name, cs->jumpto);
-		cs->target->t = t;
-	} else {
+	if (!cs->jumpto)
 		cs->jumpto = "";
-	}
 }
 
 void nft_clear_iptables_command_state(struct iptables_command_state *cs)
@@ -1326,6 +1324,7 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data)
 	struct iptables_command_state *cs = data;
 
 	cs->target = t;
+	cs->jumpto = t->name;
 }
 
 void nft_check_xt_legacy(int family, bool is_ipt_save)
-- 
2.34.1

