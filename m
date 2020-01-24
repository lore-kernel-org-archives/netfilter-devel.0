Return-Path: <SRS0=/v6G=3N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CD6C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 14:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6CC92077C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 14:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579876358;
	bh=IaeHs+S2Ps94ZSyJpZcAEjWPSWI6EbzsML1TxXP6uFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ATYhruYhFBCTDbyZmFCsX3PVUONTlIcVwFWXQdXIYpYoalwGzIXP7XOlphk9yAbhG
	 dkl71xKqCKArdd3bipcYl3tb4mwISNMoiUgg83T383cEFwfQcoi73k4E0+TfJuNXT4
	 g7e3PwFF9U4u04zH8HslFiubJIwwrvNSZ31j+thU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392697AbgAXOcd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:32:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404373AbgAXOUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9C42087E;
        Fri, 24 Jan 2020 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875604;
        bh=IaeHs+S2Ps94ZSyJpZcAEjWPSWI6EbzsML1TxXP6uFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02dUdkkku1rL1RI2WqqfRszOoPCoSnJs93KGpt2tn+F9rNKxBd8s1xtLG5AKo5GGw
         MnVivE31F9SJ1NpV4GFWH1aQ4Xrqujfx8CDuq224/V9QYAQ0EUZQVAulCLX1eOPG6x
         NZlAZrNTCXKHVvzzNPeWQPWZv8HQlIcOANhPMEQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 092/107] netfilter: nft_tunnel: ERSPAN_VERSION must not be null
Date:   Fri, 24 Jan 2020 09:18:02 -0500
Message-Id: <20200124141817.28793-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9ec22d7c6c69146180577f3ad5fdf504beeaee62 ]

Fixes: af308b94a2a4a5 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d89c7c5530309..5284fcf16be73 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -266,6 +266,9 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	if (err < 0)
 		return err;
 
+	if (!tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION])
+		 return -EINVAL;
+
 	version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
 	switch (version) {
 	case ERSPAN_VERSION:
-- 
2.20.1

