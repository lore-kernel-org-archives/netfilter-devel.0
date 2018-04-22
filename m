From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] netfilter: fix nf_tables filter chain type build
Date: Sat, 21 Apr 2018 21:10:09 -0700
Message-ID: <c8e42e35-ccff-471c-8c45-61f44855e21a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kbuild test robot <lkp@intel.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors due to a missing Kconfig dependency term.
Fixes these build errors:

net/ipv6/netfilter/nft_chain_nat_ipv6.o: In function `nft_nat_do_chain':
net/ipv6/netfilter/nft_chain_nat_ipv6.c:37: undefined reference to `nft_do_chain'
net/ipv6/netfilter/nft_chain_nat_ipv6.o: In function `nft_chain_nat_ipv6_exit':
net/ipv6/netfilter/nft_chain_nat_ipv6.c:94: undefined reference to `nft_unregister_chain_type'
net/ipv6/netfilter/nft_chain_nat_ipv6.o: In function `nft_chain_nat_ipv6_init':
net/ipv6/netfilter/nft_chain_nat_ipv6.c:87: undefined reference to `nft_register_chain_type'

Fixes: 02c7b25e5f54 ("netfilter: nf_tables: build-in filter chain type")

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
---
 net/ipv6/netfilter/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20180419.orig/net/ipv6/netfilter/Kconfig
+++ linux-next-20180419/net/ipv6/netfilter/Kconfig
@@ -108,7 +108,7 @@ config NF_NAT_IPV6
 if NF_NAT_IPV6
 
 config NFT_CHAIN_NAT_IPV6
-	depends on NF_TABLES_IPV6
+	depends on NF_TABLES_IPV6 && NF_TABLES
 	tristate "IPv6 nf_tables nat chain support"
 	help
 	  This option enables the "nat" chain for IPv6 in nf_tables. This
