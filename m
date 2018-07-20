From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/38] netfilter: Kconfig: Make NETFILTER_XT_MATCH_SOCKET select NF_SOCKET_IPV4/6
Date: Fri, 20 Jul 2018 15:08:35 +0200
Message-ID: <20180720130906.27687-8-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

Instead of depending on it.

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index dbd7d1fad277..3ce657fbca67 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1492,8 +1492,8 @@ config NETFILTER_XT_MATCH_SOCKET
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
 	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
-	depends on NF_SOCKET_IPV4
-	depends on NF_SOCKET_IPV6
+	select NF_SOCKET_IPV4
+	select NF_SOCKET_IPV6 if IP6_NF_IPTABLES
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES != n
 	help
-- 
2.11.0
