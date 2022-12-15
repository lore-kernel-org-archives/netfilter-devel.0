Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245FFC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 16:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLOQSY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLOQSX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 11:18:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE66725EBB
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 08:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Bo4dYtlPho5YgmcrIPs0euyZjVPcJW2SGmUvY91x/MI=; b=ee8RQdQpgBz+4Sr6KelqAmvaF7
        Vkte4GpUBZsNkcCtMeMQNCtEi1JKbu7MAkZVtYXi/6Wb6Uy3EKrRikIcrAK0sFDTUEWPVt+CmKOp4
        1VNkfEXNRB/hQUuf+8dBkr4cItafBw27SMQ71oVMHbFlSQ932WZ0KQv5fBbyXP9HyT/Gjv9SRPSk+
        B4KIIhEmBJMjmxmc1YLsTlAITRl0g9BSxyUIwkNvO8TQr2ymjZFLDSWpiy1h4iO7HWtxAbbCtCXNy
        sCi/+6J9XvUjqy5ap4G7gM4MCLnXehc9XKWZH9jQrQDE/60xTBB1ERlZ6YiesPDg59qY6/vvHGxee
        PeCb4PSA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p5qw8-0001uj-On; Thu, 15 Dec 2022 17:18:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 2/4] arptables: Check the mandatory ar_pln match
Date:   Thu, 15 Dec 2022 17:17:54 +0100
Message-Id: <20221215161756.3463-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221215161756.3463-1-phil@nwl.cc>
References: <20221215161756.3463-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This match is added by nft_arp_add() to every rule with same value, so
when parsing just check it is as expected and otherwise ignore it. This
allows to treat matches on all other offsets/lengths as error.

Fixes: 84909d171585d ("xtables: bootstrap ARP compatibility layer for nftables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index d670cbe629fe4..edf179521e355 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -214,7 +214,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 	struct arpt_entry *fw = &cs->arp;
 	struct in_addr addr;
 	uint16_t ar_hrd, ar_pro, ar_op;
-	uint8_t ar_hln;
+	uint8_t ar_hln, ar_pln;
 	bool inv;
 
 	switch (reg->payload.offset) {
@@ -246,6 +246,11 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPOP;
 		break;
+	case offsetof(struct arphdr, ar_pln):
+		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
+		if (ar_pln != 4 || inv)
+			ctx->errmsg = "unexpected ARP protocol length match";
+		break;
 	default:
 		if (reg->payload.offset == sizeof(struct arphdr)) {
 			if (nft_arp_parse_devaddr(reg, e, &fw->arp.src_devaddr))
-- 
2.38.0

