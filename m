Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497E3C4321E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiLAQka (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiLAQkE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:40:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6E9ABA26
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MLK87kKE6XEepbhFzYpBB8gYoFa9pxROwtVnmL2DnZg=; b=jxCgf7aMO7OLMGRmThUeF3+ovI
        XJgEUf6P9NfGh4D9v5Y4wH5VZzipdtYBa75KhekuUu6y+X+CQBDdOa+WJ4H0ULUVHu0Ch4V8ds1zP
        jV3rYzLCJYfyrH3jE1v1qTZ9Nkgk6WpuRPWeAH0Gi6zI/tyPRzbvzElm/mqjZyOBc26OD8fDauJsU
        pr9O4/vkDJbaNk1m/8C6Naa89uQ/CW2Qi+4knQd9eSjCPN7XnQu1m64bP/oMvpDgyAAO3exZ9M6rS
        dyGNwMKbx6h8beVb2lgZVtBnyOHKDu5kbrminXuXWR+cNHaQ3pBBvWIe7qC8tOSJ3GehY52eOzUCs
        8snvlCwg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0mbH-0002YG-DU; Thu, 01 Dec 2022 17:39:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 5/7] nft: Recognize INVAL/D interface name
Date:   Thu,  1 Dec 2022 17:39:14 +0100
Message-Id: <20221201163916.30808-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is just a hack to translate '! -i +' into a never matching nft rule,
but recognize it anyway for completeness' sake and to make xlate replay
test pass.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index bcb6ada34e0fb..b7e073df5a270 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -359,6 +359,21 @@ static int parse_meta_pkttype(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	return 0;
 }
 
+static void parse_invalid_iface(char *iface, unsigned char *mask,
+				uint8_t *invflags, uint8_t invbit)
+{
+	if (*invflags & invbit || strcmp(iface, "INVAL/D"))
+		return;
+
+	/* nft's poor "! -o +" excuse */
+	*invflags |= invbit;
+	iface[0] = '+';
+	iface[1] = '\0';
+	mask[0] = 0xff;
+	mask[1] = 0xff;
+	memset(mask + 2, 0, IFNAMSIZ - 2);
+}
+
 int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	       char *iniface, unsigned char *iniface_mask,
 	       char *outiface, unsigned char *outiface_mask, uint8_t *invflags)
@@ -393,6 +408,8 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 			*invflags |= IPT_INV_VIA_IN;
 
 		parse_ifname(ifname, len, iniface, iniface_mask);
+		parse_invalid_iface(iniface, iniface_mask,
+				    invflags, IPT_INV_VIA_IN);
 		break;
 	case NFT_META_BRI_OIFNAME:
 	case NFT_META_OIFNAME:
@@ -401,6 +418,8 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 			*invflags |= IPT_INV_VIA_OUT;
 
 		parse_ifname(ifname, len, outiface, outiface_mask);
+		parse_invalid_iface(outiface, outiface_mask,
+				    invflags, IPT_INV_VIA_OUT);
 		break;
 	case NFT_META_MARK:
 		parse_meta_mark(ctx, e);
-- 
2.38.0

