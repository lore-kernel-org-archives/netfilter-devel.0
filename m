Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22177C32753
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AE320665
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564753017;
	bh=k1r3lRP7k7RIVzGCqFyjF7GFtx6cGjm0mO0x8noUTfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Qcd42rjbi0eS10wxJzUQeqQCWsuPikrANA+bRQeRFiADUmQ5SKSudIBPyqMjjDwsQ
	 lj95NgzSul+iC5F2Xm+QBP751gkQPDoZ1BVxEQt/TWs2/Gkof7IfhJwgZL5L3LMAkx
	 nKi1CP8KJTg6FbXExgqTUXxtfQnb9qK4z0HL6YmM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406402AbfHBNgr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393266AbfHBNUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F61216C8;
        Fri,  2 Aug 2019 13:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752002;
        bh=k1r3lRP7k7RIVzGCqFyjF7GFtx6cGjm0mO0x8noUTfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZraUpIzYp4v/q4p9rC2DVRxtH6XJZOVQJ3Xa+7JPQsO0rMvjMUv0isYzdsOHCh4n
         zD33R+fpW/6iVbUwTpxvrs03ktUUOsguw4sW/fs7p3yWcRFrtP/mL0rIDmMzFRvCz7
         4LSN8mEQY2pH9Piin4fSjGX1fazXcHHC2tHooVTk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laura Garcia Liebana <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 08/76] netfilter: nft_hash: fix symhash with modulus one
Date:   Fri,  2 Aug 2019 09:18:42 -0400
Message-Id: <20190802131951.11600-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

[ Upstream commit 28b1d6ef53e3303b90ca8924bb78f31fa527cafb ]

The rule below doesn't work as the kernel raises -ERANGE.

nft add rule netdev nftlb lb01 ip daddr set \
	symhash mod 1 map { 0 : 192.168.0.10 } fwd to "eth0"

This patch allows to use the symhash modulus with one
element, in the same way that the other types of hashes and
algorithms that uses the modulus parameter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index fe93e731dc7fb..b836d550b9199 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -129,7 +129,7 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
 
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
-	if (priv->modulus <= 1)
+	if (priv->modulus < 1)
 		return -ERANGE;
 
 	if (priv->offset + priv->modulus - 1 < priv->offset)
-- 
2.20.1

