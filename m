From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH nf-next] netfilter: nf_tables: nft_flow_offload_type can
 be static
Date: Tue, 9 Jan 2018 00:33:49 +0800
Message-ID: <20180108163349.GA63173@xian>
References: <201801090023.pU1gl3W0%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:37285 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756661AbeAHQeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 11:34:50 -0500
Content-Disposition: inline
In-Reply-To: <201801090023.pU1gl3W0%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Fixes: db2ff0f2f440 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 nft_flow_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index b7c7082..e7f16fe 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -176,7 +176,7 @@ static int nft_flow_offload_dump(struct sk_buff *skb, const struct nft_expr *exp
 	return -1;
 }
 
-struct nft_expr_type nft_flow_offload_type;
+static struct nft_expr_type nft_flow_offload_type;
 static const struct nft_expr_ops nft_flow_offload_ops = {
 	.type		= &nft_flow_offload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
