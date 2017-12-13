From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] netfilter: meta: nft_meta_get_validate() can be static
Date: Wed, 13 Dec 2017 15:16:22 +0800
Message-ID: <20171213071622.GA138460@ivb43.lkp.intel.com>
References: <20171201124021.20973-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18849 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753266AbdLMPV3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 10:21:29 -0500
Content-Disposition: inline
In-Reply-To: <20171201124021.20973-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Fixes: dce1fc524886 ("netfilter: meta: secpath support")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 nft_meta.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 63a013a..993157e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -328,9 +328,9 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
-int nft_meta_get_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data)
+static int nft_meta_get_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
