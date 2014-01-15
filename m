From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftables]: expr/cmp: fix type size
Date: Wed, 15 Jan 2014 07:31:25 +0000
Message-ID: <20140115073124.GA17045@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41655 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaAOHb3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:31:29 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pushed to next-3.14.

commit 3177a0d6f4be42775c128c02afe7de78dc3ea99d
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Jan 15 07:28:20 2014 +0000

    expr/cmp: fix type size
    
    Since nftables now uses nft_rule_expr_get_u32(), the internal size must
    also be a uint32_t.
    
    Fixes complete breakage of any cmp or meta expression.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 246f22f..1c5787e 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -26,8 +26,8 @@
 
 struct nft_expr_cmp {
 	union nft_data_reg	data;
-	uint8_t			sreg;	/* enum nft_registers */
-	uint8_t			op;	/* enum nft_cmp_ops */
+	uint32_t		sreg;	/* enum nft_registers */
+	uint32_t		op;	/* enum nft_cmp_ops */
 };
 
 static int
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 490d64a..74ecdb3 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -27,10 +27,10 @@
 #endif
 
 struct nft_expr_meta {
-	uint8_t			key;	/* enum nft_meta_keys */
+	uint32_t		key;	/* enum nft_meta_keys */
 	union {
-		uint8_t		dreg;	/* enum nft_registers */
-		uint8_t		sreg;   /* enum nft_registers */
+		uint32_t	dreg;	/* enum nft_registers */
+		uint32_t	sreg;   /* enum nft_registers */
 	};
 };
 
