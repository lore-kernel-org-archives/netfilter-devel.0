From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/15] netfilter: remove include/net/netfilter/nft_dup.h
Date: Mon, 11 Jun 2018 11:22:33 +0200
Message-ID: <20180611092233.3219-16-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

include/net/netfilter/nft_dup.h was introduced in d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
but was never user since this date.

Furthermore, the only struct in this file is unused elsewhere.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0
