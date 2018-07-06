From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
Date: Fri,  6 Jul 2018 14:37:58 +0200
Message-ID: <20180706123805.2852900-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

With NETFILTER_XT_TARGET_TEE=y and IP6_NF_IPTABLES=m, we get a link
error when referencing the NF_DUP_IPV6 module:

net/netfilter/xt_TEE.o: In function `tee_tg6':
xt_TEE.c:(.text+0x14): undefined reference to `nf_dup_ipv6'

The problem here is the 'select NF_DUP_IPV6 if IP6_NF_IPTABLES'
that forces NF_DUP_IPV6 to be =m as well rather than setting it
to =y as was intended here. Adding a soft dependency on
IP6_NF_IPTABLES avoids that broken configuration.

Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8aa4883c176a..e42c38c99741 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -985,7 +985,8 @@ config NETFILTER_XT_TARGET_TEE
 	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
-	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on NF_CONNTRACK || !NF_CONNTRACK
+	depends on IP6_NF_IPTABLES || !IP6_NF_IPTABLES
 	select NF_DUP_IPV4
 	select NF_DUP_IPV6 if IP6_NF_IPTABLES
 	---help---
-- 
2.9.0
