Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB8CC3F2D7
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C91220717
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583212127;
	bh=NQSOVIl9XzNclxfGgTHbtUOwQQHboh4d4ds040VPqMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zeveUq+2xpqvZj3/PcKiDlzQ39huM3/O2VeXJ0Hgn1C2KXzeMSoApX6TLQYx6xmlV
	 V7RBQ8NNoPbx8+Es1v25warPrSls8lobz0lo56p3zfCwaoXW0TvxFaK/CBxWWGrrAH
	 58Ygqr2q1VPYrIg8RzrNNeGWuRh1MV+zkpzG8hJw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCCFIq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 00:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgCCFIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 00:08:45 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F20E24671;
        Tue,  3 Mar 2020 05:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212125;
        bh=NQSOVIl9XzNclxfGgTHbtUOwQQHboh4d4ds040VPqMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exhZDZEIwvjdwY9FAr1UvbaW27Mb1ZSiG/WEO7IX+WbeFj/hVUSyb1kebXdrQBdd8
         zi+vztQ0OjIzQtVo2SKp5z7iLr/CXdNCMHuper5rrfYxE4/YokcDhdDxJ9y+b9fXQ4
         fyuGkzcYbAAoJnyo9H6MSNrbjb2Ay5eUfGrlJYDE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH netfilter 3/3] netfilter: nf_tables: add missing attribute validation for tunnels
Date:   Mon,  2 Mar 2020 21:08:33 -0800
Message-Id: <20200303050833.4089193-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050833.4089193-1-kuba@kernel.org>
References: <20200303050833.4089193-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing attribute validation for tunnel source and
destination ports to the netlink policy.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netfilter/nft_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 4c3f2e24c7cb..764e88682a81 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -339,6 +339,8 @@ static const struct nla_policy nft_tunnel_key_policy[NFTA_TUNNEL_KEY_MAX + 1] =
 	[NFTA_TUNNEL_KEY_FLAGS]	= { .type = NLA_U32, },
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
+	[NFTA_TUNNEL_KEY_SPORT]	= { .type = NLA_U16, },
+	[NFTA_TUNNEL_KEY_DPORT]	= { .type = NLA_U16, },
 	[NFTA_TUNNEL_KEY_OPTS]	= { .type = NLA_NESTED, },
 };
 
-- 
2.24.1

