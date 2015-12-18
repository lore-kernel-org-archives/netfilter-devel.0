From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/23] netfilter: nf_tables: remove unused struct members
Date: Fri, 18 Dec 2015 21:26:38 +0100
Message-ID: <1450470409-31427-13-git-send-email-pablo@netfilter.org>
References: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4bd7508..101d7d7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -19,8 +19,6 @@ struct nft_pktinfo {
 	const struct net_device		*out;
 	u8				pf;
 	u8				hook;
-	u8				nhoff;
-	u8				thoff;
 	u8				tprot;
 	/* for x_tables compatibility */
 	struct xt_action_param		xt;
-- 
2.1.4
