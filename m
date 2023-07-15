Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24642EB64DC
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jul 2023 12:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjGOM7q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jul 2023 08:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGOM7p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jul 2023 08:59:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF9C35B5
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jul 2023 05:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pZgP58MwircQ12wUwAmel/yrcPYuFHW1QWLLohP5Q/0=; b=UPUA/dc+9sGAMR84Gj9VdX06WT
        YWgXVnz6iQlKd3+NSqIAP5hr+PyZz8AmCnDfKIRCivGf7o2dlGZUPiEDPkbbSi9Du8fEy+XpHJLoe
        XEtjAZWOHqqKPKAnCLtcOVRGJbpvx68MOLcgCUc4LE6kLa7Mp3D54lTmp2PIxKNS9rFhTt/9d8kwC
        ea+D07wrKqQ15YWVHQGI2p5P6kDNMQXuiN/bhOJx2an57rkZkxyH+3fA8cvhz1WcszAWopDvjPp5I
        6y8LzdBpWsENIaLk0MZ8jQDPWCDrLfBh6ygFAWuCF5AtEIeOTV24/aplZMWOCRrQS3/oNdij4Vppy
        kocxt90Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qKes5-0002NA-FA; Sat, 15 Jul 2023 14:59:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, igor@gooddata.com
Subject: [iptables PATCH 2/3] nft: Do not pass nft_rule_ctx to add_nft_among()
Date:   Sat, 15 Jul 2023 14:59:27 +0200
Message-Id: <20230715125928.18395-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230715125928.18395-1-phil@nwl.cc>
References: <20230715125928.18395-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is not used, must be a left-over from an earlier version of the fixed
commit.

Fixes: 4e95200ded923 ("nft-bridge: pass context structure to ops->add() to improve anonymous set support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 230946d30108d..f453f07acb7e9 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1154,8 +1154,7 @@ gen_lookup(uint32_t sreg, const char *set_name, uint32_t set_id, uint32_t flags)
 #define NFT_DATATYPE_ETHERADDR	9
 
 static int __add_nft_among(struct nft_handle *h, const char *table,
-			   struct nft_rule_ctx *ctx, struct nftnl_rule *r,
-			   struct nft_among_pair *pairs,
+			   struct nftnl_rule *r, struct nft_among_pair *pairs,
 			   int cnt, bool dst, bool inv, bool ip)
 {
 	uint32_t set_id, type = NFT_DATATYPE_ETHERADDR, len = ETH_ALEN;
@@ -1236,7 +1235,7 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	return 0;
 }
 
-static int add_nft_among(struct nft_handle *h, struct nft_rule_ctx *ctx,
+static int add_nft_among(struct nft_handle *h,
 			 struct nftnl_rule *r, struct xt_entry_match *m)
 {
 	struct nft_among_data *data = (struct nft_among_data *)m->data;
@@ -1252,10 +1251,10 @@ static int add_nft_among(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	}
 
 	if (data->src.cnt)
-		__add_nft_among(h, table, ctx, r, data->pairs, data->src.cnt,
+		__add_nft_among(h, table, r, data->pairs, data->src.cnt,
 				false, data->src.inv, data->src.ip);
 	if (data->dst.cnt)
-		__add_nft_among(h, table, ctx, r, data->pairs + data->src.cnt,
+		__add_nft_among(h, table, r, data->pairs + data->src.cnt,
 				data->dst.cnt, true, data->dst.inv,
 				data->dst.ip);
 	return 0;
@@ -1476,7 +1475,7 @@ int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 		if (!strcmp(m->u.user.name, "limit"))
 			return add_nft_limit(r, m);
 		else if (!strcmp(m->u.user.name, "among"))
-			return add_nft_among(h, ctx, r, m);
+			return add_nft_among(h, r, m);
 		else if (!strcmp(m->u.user.name, "udp"))
 			return add_nft_udp(h, r, m);
 		else if (!strcmp(m->u.user.name, "tcp"))
-- 
2.40.0

