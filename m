From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/18] netfilter: make NF_OSF non-visible symbol
Date: Wed, 23 May 2018 20:42:48 +0200
Message-ID: <20180523184254.22599-13-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e57c9d479503..a5b60e6a983e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -445,7 +445,7 @@ config NETFILTER_SYNPROXY
 endif # NF_CONNTRACK
 
 config NF_OSF
-	tristate 'Passive OS fingerprint infrastructure'
+	tristate
 
 config NF_TABLES
 	select NETFILTER_NETLINK
-- 
2.11.0
