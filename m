From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/52] netfilter: nf_tables_arp: don't set forward chain
Date: Mon,  8 Jan 2018 21:19:30 +0100
Message-ID: <20180108202000.12989-23-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

46928a0b49f3 ("netfilter: nf_tables: remove multihook chains and
families") already removed this, this is a leftover.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_tables_arp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 4bbc273b45e8..ec47c12cd137 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -34,7 +34,6 @@ static struct nft_af_info nft_af_arp __read_mostly = {
 	.hooks		= {
 		[NF_ARP_IN]		= nft_do_chain_arp,
 		[NF_ARP_OUT]		= nft_do_chain_arp,
-		[NF_ARP_FORWARD]	= nft_do_chain_arp,
 	},
 };
 
-- 
2.11.0
