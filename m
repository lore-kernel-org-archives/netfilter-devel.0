From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/12] netfilter: kconfig: nat related expression depend on nftables core
Date: Tue, 11 Sep 2018 02:20:38 +0200
Message-ID: <20180911002044.9100-7-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

NF_TABLES_IPV4 is now boolean so it is possible to set

NF_TABLES=m
NF_TABLES_IPV4=y
NFT_CHAIN_NAT_IPV4=y

which causes:
nft_chain_nat_ipv4.c:(.text+0x6d): undefined reference to `nft_do_chain'

Wrap NFT_CHAIN_NAT_IPV4 and related nat expressions with NF_TABLES to
restore the dependency.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 02c7b25e5f54 ("netfilter: nf_tables: build-in filter chain type")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d9504adc47b3..184bf2e0a1ed 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -106,6 +106,10 @@ config NF_NAT_IPV4
 
 if NF_NAT_IPV4
 
+config NF_NAT_MASQUERADE_IPV4
+	bool
+
+if NF_TABLES
 config NFT_CHAIN_NAT_IPV4
 	depends on NF_TABLES_IPV4
 	tristate "IPv4 nf_tables nat chain support"
@@ -115,9 +119,6 @@ config NFT_CHAIN_NAT_IPV4
 	  packet transformations such as the source, destination address and
 	  source and destination ports.
 
-config NF_NAT_MASQUERADE_IPV4
-	bool
-
 config NFT_MASQ_IPV4
 	tristate "IPv4 masquerading support for nf_tables"
 	depends on NF_TABLES_IPV4
@@ -135,6 +136,7 @@ config NFT_REDIR_IPV4
 	help
 	  This is the expression that provides IPv4 redirect support for
 	  nf_tables.
+endif # NF_TABLES
 
 config NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support"
-- 
2.11.0
