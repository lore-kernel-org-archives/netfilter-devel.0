From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] netfilter: remove include/net/netfilter/nft_dup.h
Date: Thu,  7 Jun 2018 19:38:09 +0000
Message-ID: <1528400289-28004-1-git-send-email-clabbe@baylibre.com>
Cc: coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

include/net/netfilter/nft_dup.h was introduced in d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
but was never user since this date.

Furthermore, the only struct in this file is unused elsewhere.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 include/net/netfilter/nft_dup.h | 10 ----------
 1 file changed, 10 deletions(-)
 delete mode 100644 include/net/netfilter/nft_dup.h

diff --git a/include/net/netfilter/nft_dup.h b/include/net/netfilter/nft_dup.h
deleted file mode 100644
index 4d9d512984b2..000000000000
--- a/include/net/netfilter/nft_dup.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NFT_DUP_H_
-#define _NFT_DUP_H_
-
-struct nft_dup_inet {
-	enum nft_registers	sreg_addr:8;
-	enum nft_registers	sreg_dev:8;
-};
-
-#endif /* _NFT_DUP_H_ */
-- 
2.16.4
