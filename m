From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: fix CONFIG_NF_REJECT_IPV6=m link error
Date: Mon,  9 Apr 2018 12:53:12 +0200
Message-ID: <20180409105322.2247296-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We get a new link error with CONFIG_NFT_REJECT_INET=y and CONFIG_NF_REJECT_IPV6=m
after larger parts of the nftables modules are linked together:

net/netfilter/nft_reject_inet.o: In function `nft_reject_inet_eval':
nft_reject_inet.c:(.text+0x17c): undefined reference to `nf_send_unreach6'
nft_reject_inet.c:(.text+0x190): undefined reference to `nf_send_reset6'

The problem is that with NF_TABLES_INET set, we implicitly try to use
the ipv6 version as well for NFT_REJECT, but when CONFIG_IPV6 is set to
a loadable module, it's impossible to reach that.

The best workaround I found is to express the above as a Kconfig
dependency, forcing NFT_REJECT itself to be 'm' in that particular
configuration.

Fixes: 02c7b25e5f54 ("netfilter: nf_tables: build-in filter chain type")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 704b3832dbad..44d8a55e9721 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -594,6 +594,7 @@ config NFT_QUOTA
 config NFT_REJECT
 	default m if NETFILTER_ADVANCED=n
 	tristate "Netfilter nf_tables reject support"
+	depends on !NF_TABLES_INET || (IPV6!=m || m)
 	help
 	  This option adds the "reject" expression that you can use to
 	  explicitly deny and notify via TCP reset/ICMP informational errors
-- 
2.9.0
