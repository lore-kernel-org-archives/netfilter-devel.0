From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/27] netfilter: select LIBCRC32C together with SCTP conntrack
Date: Fri,  3 Feb 2017 13:25:16 +0100
Message-ID: <1486124738-3013-6-git-send-email-pablo@netfilter.org>
References: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

nf_conntrack needs to compute crc32c when dealing with SCTP packets.
Moreover, NF_NAT_PROTO_SCTP (currently selecting LIBCRC32C) can be enabled
only if conntrack support for SCTP is enabled. Therefore, move enabling of
kernel support for crc32c so that it is selected when NF_CT_PROTO_SCTP=y.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 63729b489c2c..6d425e355bf5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -162,6 +162,7 @@ config NF_CT_PROTO_SCTP
 	bool 'SCTP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
 	default y
+	select LIBCRC32C
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on SCTP connections.
@@ -397,7 +398,6 @@ config NF_NAT_PROTO_SCTP
 	bool
 	default NF_NAT && NF_CT_PROTO_SCTP
 	depends on NF_NAT && NF_CT_PROTO_SCTP
-	select LIBCRC32C
 
 config NF_NAT_AMANDA
 	tristate
-- 
2.1.4
