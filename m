Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A43AC43461
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 383C06112F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbhD0Uok (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 16:44:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54336 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238992AbhD0Uoj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 16:44:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3C35D64143;
        Tue, 27 Apr 2021 22:43:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 6/7] netfilter: nft_socket: fix an unused variable warning
Date:   Tue, 27 Apr 2021 22:43:44 +0200
Message-Id: <20210427204345.22043-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

