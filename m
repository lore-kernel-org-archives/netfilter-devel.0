Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404C2C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 16:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbiAIQLf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 11:11:35 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41386 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiAIQLe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 11:11:34 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E33456468F
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 17:08:44 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 08/14] netfilter: nf_tables: add NFT_REG32_NUM
Date:   Sun,  9 Jan 2022 17:11:20 +0100
Message-Id: <20220109161126.83917-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109161126.83917-1-pablo@netfilter.org>
References: <20220109161126.83917-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a definition including the maximum number of 32-bits registers that
are used a scratchpad memory area to store data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a046b01bdab..515e5db97e01 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -105,6 +105,8 @@ struct nft_data {
 	};
 } __attribute__((aligned(__alignof__(u64))));
 
+#define NFT_REG32_NUM		20
+
 /**
  *	struct nft_regs - nf_tables register set
  *
@@ -115,7 +117,7 @@ struct nft_data {
  */
 struct nft_regs {
 	union {
-		u32			data[20];
+		u32			data[NFT_REG32_NUM];
 		struct nft_verdict	verdict;
 	};
 };
-- 
2.30.2

