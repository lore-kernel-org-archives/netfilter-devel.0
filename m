Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05E7C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 19:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D2C613F9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 19:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238690AbhD0Tqc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 15:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235661AbhD0Tqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 15:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD8C611F2;
        Tue, 27 Apr 2021 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619552748;
        bh=LDoohEnCArlGbum8fJyPABYpTo/IiOc7gWRCmRENEKk=;
        h=From:To:Cc:Subject:Date:From;
        b=P6EaCGT/1tkDXdwDRUEY2vhTWX1m+SMp/BC74NckIuFC3v52raY7xWHQJXhbwF6FC
         1oIkAOqxAY2PspZWRW1Nf/SB0VXMIR17dorDxV1tN9tL1Z+fkpyj1PVC9mICvAqw2R
         2SADRJxZmjuFQGI9SX+gi16LHTbQdq936nnHSjjw2oWO9E78aU6Ib6kn9UY8YmRP0g
         6YXVqpzpBlX91HsXDQGVRnfG3omFaTieOBP8z0Znu7ztm/LKedkUZJw/IdV/BfYDuM
         VyCIS2E6hkCMfDmm1i/tBS8xuJlyX2mmiq6qR6N1hoEnURQIrPTsnGOJxg1mef+/EL
         Y6FLqYORW4mfQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Balazs Scheidler <bazsi77@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] netfilter: nft_socket: fix an unused variable warning
Date:   Tue, 27 Apr 2021 21:45:18 +0200
Message-Id: <20210427194528.2325108-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The variable is only used in an #ifdef, causing a harmless warning:

net/netfilter/nft_socket.c: In function 'nft_socket_init':
net/netfilter/nft_socket.c:137:27: error: unused variable 'level' [-Werror=unused-variable]
  137 |         unsigned int len, level;
      |                           ^~~~~

Move it into the same #ifdef block.

Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nft_socket.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 9c169d100651..f9c5ff6024e0 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -134,7 +134,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_socket *priv = nft_expr_priv(expr);
-	unsigned int len, level;
+	unsigned int len;
 
 	if (!tb[NFTA_SOCKET_DREG] || !tb[NFTA_SOCKET_KEY])
 		return -EINVAL;
@@ -160,7 +160,9 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_CGROUPS
-	case NFT_SOCKET_CGROUPV2:
+	case NFT_SOCKET_CGROUPV2: {
+		unsigned int level;
+
 		if (!tb[NFTA_SOCKET_LEVEL])
 			return -EINVAL;
 
@@ -171,6 +173,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		priv->level = level;
 		len = sizeof(u64);
 		break;
+	}
 #endif
 	default:
 		return -EOPNOTSUPP;
-- 
2.29.2

