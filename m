From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next 2/2] netfilter: nf_tables: make local functions static
Date: Fri, 19 May 2017 09:29:42 -0700
Message-ID: <20170519162942.30004-2-sthemmin@microsoft.com>
References: <20170519162942.30004-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36461 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdESQ3v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 12:29:51 -0400
Received: by mail-pf0-f176.google.com with SMTP id m17so42145012pfg.3
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 09:29:51 -0700 (PDT)
In-Reply-To: <20170519162942.30004-1-sthemmin@microsoft.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Resolves warnings:
net/netfilter/nft_rt.c:26:6: warning: no previous prototype for ‘nft_rt_get_eval’ [-Wmissing-prototypes]
net/netfilter/nft_rt.c:75:5: warning: no previous prototype for ‘nft_rt_get_init’ [-Wmissing-prototypes]
net/netfilter/nft_rt.c:106:5: warning: no previous prototype for ‘nft_rt_get_dump’ [-Wmissing-prototypes]

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 net/netfilter/nft_rt.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index d3eb640bc784..c7383d8f88d0 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -23,9 +23,9 @@ struct nft_rt {
 	enum nft_registers	dreg:8;
 };
 
-void nft_rt_get_eval(const struct nft_expr *expr,
-		     struct nft_regs *regs,
-		     const struct nft_pktinfo *pkt)
+static void nft_rt_get_eval(const struct nft_expr *expr,
+			    struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
@@ -72,9 +72,9 @@ const struct nla_policy nft_rt_policy[NFTA_RT_MAX + 1] = {
 	[NFTA_RT_KEY]		= { .type = NLA_U32 },
 };
 
-int nft_rt_get_init(const struct nft_ctx *ctx,
-		    const struct nft_expr *expr,
-		    const struct nlattr * const tb[])
+static int nft_rt_get_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
 {
 	struct nft_rt *priv = nft_expr_priv(expr);
 	unsigned int len;
@@ -103,8 +103,8 @@ int nft_rt_get_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, len);
 }
 
-int nft_rt_get_dump(struct sk_buff *skb,
-		    const struct nft_expr *expr)
+static int nft_rt_get_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 
-- 
2.11.0

