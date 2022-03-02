Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F66CC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiCBPSz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiCBPSy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:18:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B1121803
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XvoXdwy+2KOhsxG1cnG+bH/wHts8DKsx6WYpc1xr4yg=; b=Qo3qXV7KFTHc3JpmoPWyuzmiLr
        uVGRCDbiK9+RM4N9HSff6cY7TyUlZmu5YG2Q0XE0Vqqkd57zQ7ClllDD71JFFqoUiiRLkNJubqp6z
        UsRmX2YnFCC92AJAgjG0XmsWOhVYRW6yoSeCAl6E8MMsSOYMLfUuOBp+7cbf6Vq9CzMWcrwpIKpRV
        48XiXWuQCgdDORPDVNBqZ0W3aVt2zfBXZtcX4IdNnztr4XxwIF/8QxRlUWVJaAXyh++0zTvi0zizW
        2t1QlCogd1GPfPpbAygKl4kVAb8NWkLxDRO4axkiHsFrKJWyH5w6RUfsyB9v6ZTElq3Pe/eupJUys
        YeqwAzzw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPQjw-00033e-Nh; Wed, 02 Mar 2022 16:18:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] nft: Simplify immediate parsing
Date:   Wed,  2 Mar 2022 16:18:04 +0100
Message-Id: <20220302151807.12185-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302151807.12185-1-phil@nwl.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Implementations of parse_immediate callback are mostly trivial, the only
relevant part is access to family-specific parts of struct
iptables_command_state when setting goto flag for iptables and
ip6tables. Refactor them into simple set_goto_flag callbacks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    |  9 ---------
 iptables/nft-bridge.c |  9 ---------
 iptables/nft-ipv4.c   | 12 +++---------
 iptables/nft-ipv6.c   | 12 +++---------
 iptables/nft-shared.c | 17 +++++++----------
 iptables/nft-shared.h |  2 +-
 6 files changed, 14 insertions(+), 47 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 1472b11543239..78509ce9d87e8 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -182,14 +182,6 @@ static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 	fw->arp.invflags |= flags;
 }
 
-static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
-				    void *data)
-{
-	struct iptables_command_state *cs = data;
-
-	cs->jumpto = jumpto;
-}
-
 static void parse_mask_ipv4(struct nft_xt_ctx *ctx, struct in_addr *mask)
 {
 	mask->s_addr = ctx->bitwise.mask[0];
@@ -797,7 +789,6 @@ struct nft_family_ops nft_family_ops_arp = {
 	.print_payload		= NULL,
 	.parse_meta		= nft_arp_parse_meta,
 	.parse_payload		= nft_arp_parse_payload,
-	.parse_immediate	= nft_arp_parse_immediate,
 	.print_header		= nft_arp_print_header,
 	.print_rule		= nft_arp_print_rule,
 	.save_rule		= nft_arp_save_rule,
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 90d55e441ab95..d6a0d6e518fcb 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -251,14 +251,6 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 	}
 }
 
-static void nft_bridge_parse_immediate(const char *jumpto, bool nft_goto,
-				       void *data)
-{
-	struct iptables_command_state *cs = data;
-
-	cs->jumpto = jumpto;
-}
-
 /* return 0 if saddr, 1 if daddr, -1 on error */
 static int
 lookup_check_ether_payload(uint32_t base, uint32_t offset, uint32_t len)
@@ -891,7 +883,6 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.print_payload		= NULL,
 	.parse_meta		= nft_bridge_parse_meta,
 	.parse_payload		= nft_bridge_parse_payload,
-	.parse_immediate	= nft_bridge_parse_immediate,
 	.parse_lookup		= nft_bridge_parse_lookup,
 	.parse_match		= nft_bridge_parse_match,
 	.parse_target		= nft_bridge_parse_target,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index f374d468d2ff4..bdb105f8eb683 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -215,15 +215,9 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 	}
 }
 
-static void nft_ipv4_parse_immediate(const char *jumpto, bool nft_goto,
-				     void *data)
+static void nft_ipv4_set_goto_flag(struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
-	cs->jumpto = jumpto;
-
-	if (nft_goto)
-		cs->fw.ip.flags |= IPT_F_GOTO;
+	cs->fw.ip.flags |= IPT_F_GOTO;
 }
 
 static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
@@ -450,7 +444,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.is_same		= nft_ipv4_is_same,
 	.parse_meta		= nft_ipv4_parse_meta,
 	.parse_payload		= nft_ipv4_parse_payload,
-	.parse_immediate	= nft_ipv4_parse_immediate,
+	.set_goto_flag		= nft_ipv4_set_goto_flag,
 	.print_header		= print_header,
 	.print_rule		= nft_ipv4_print_rule,
 	.save_rule		= nft_ipv4_save_rule,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 9ecc754f37805..a5323171bb4bb 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -180,15 +180,9 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 	}
 }
 
-static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
-				     void *data)
+static void nft_ipv6_set_goto_flag(struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
-	cs->jumpto = jumpto;
-
-	if (nft_goto)
-		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
+	cs->fw6.ipv6.flags |= IP6T_F_GOTO;
 }
 
 static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
@@ -418,7 +412,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.is_same		= nft_ipv6_is_same,
 	.parse_meta		= nft_ipv6_parse_meta,
 	.parse_payload		= nft_ipv6_parse_payload,
-	.parse_immediate	= nft_ipv6_parse_immediate,
+	.set_goto_flag		= nft_ipv6_set_goto_flag,
 	.print_header		= print_header,
 	.print_rule		= nft_ipv6_print_rule,
 	.save_rule		= nft_ipv6_save_rule,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 746a948ccf96d..daa251ae0982a 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -906,9 +906,7 @@ static void nft_parse_counter(struct nftnl_expr *e, struct xt_counters *counters
 static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	const char *chain = nftnl_expr_get_str(e, NFTNL_EXPR_IMM_CHAIN);
-	const char *jumpto = NULL;
-	bool nft_goto = false;
-	void *data = ctx->cs;
+	struct iptables_command_state *cs = ctx->cs;
 	int verdict;
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_IMM_DATA)) {
@@ -931,23 +929,22 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	/* Standard target? */
 	switch(verdict) {
 	case NF_ACCEPT:
-		jumpto = "ACCEPT";
+		cs->jumpto = "ACCEPT";
 		break;
 	case NF_DROP:
-		jumpto = "DROP";
+		cs->jumpto = "DROP";
 		break;
 	case NFT_RETURN:
-		jumpto = "RETURN";
+		cs->jumpto = "RETURN";
 		break;;
 	case NFT_GOTO:
-		nft_goto = true;
+		if (ctx->h->ops->set_goto_flag)
+			ctx->h->ops->set_goto_flag(cs);
 		/* fall through */
 	case NFT_JUMP:
-		jumpto = chain;
+		cs->jumpto = chain;
 		break;
 	}
-
-	ctx->h->ops->parse_immediate(jumpto, nft_goto, data);
 }
 
 static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 0788e98a9f93a..04b1d97f950d5 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -93,7 +93,7 @@ struct nft_family_ops {
 			  void *data);
 	void (*parse_lookup)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 			     void *data);
-	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
+	void (*set_goto_flag)(struct iptables_command_state *cs);
 
 	void (*print_table_header)(const char *tablename);
 	void (*print_header)(unsigned int format, const char *chain,
-- 
2.34.1

