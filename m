Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDD0C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B2F610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhKFVBK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVBJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E02C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:28 -0700 (PDT)
Received: from localhost ([::1]:58770 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSle-00046v-MH; Sat, 06 Nov 2021 21:58:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/10] nft-shared: Drop unused function print_proto()
Date:   Sat,  6 Nov 2021 21:57:55 +0100
Message-Id: <20211106205756.14529-10-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The last users vanished back in 2013. There is identical code in
save_rule_details(), but with only a single user there's not much point
in keeping the function.

Fixes: cdc78b1d6bd7b ("nft: convert rule into a command state structure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 15 ---------------
 iptables/nft-shared.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index a6a79c8cda084..b281ba2987cc3 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -373,21 +373,6 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
-void print_proto(uint16_t proto, int invert)
-{
-	const struct protoent *pent = getprotobynumber(proto);
-
-	if (invert)
-		printf("! ");
-
-	if (pent) {
-		printf("-p %s ", pent->p_name);
-		return;
-	}
-
-	printf("-p %u ", proto);
-}
-
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv)
 {
 	uint32_t len;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index de684374ef9e0..bcf8486eb44c4 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -158,7 +158,6 @@ bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
 int parse_meta(struct nftnl_expr *e, uint8_t key, char *iniface,
 		unsigned char *iniface_mask, char *outiface,
 		unsigned char *outiface_mask, uint8_t *invflags);
-void print_proto(uint16_t proto, int invert);
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
 void nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
-- 
2.33.0

