From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 46/47] netfilter: conntrack: remove unused code in nf_conntrack_proto_generic.c
Date: Mon,  4 Sep 2017 00:43:44 +0200
Message-ID: <1504478625-13330-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

L4 protocol helpers for DCCP, SCTP and UDPlite can't be built as kernel
modules anymore, so we can remove code enclosed in
 #ifdef CONFIG_NF_CT_PROTO_{DCCP,SCTP,UDPLITE}_MODULE

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_generic.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 2bc3d0c1a5bf..2993995b690d 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -17,22 +17,10 @@ static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
 static bool nf_generic_should_process(u8 proto)
 {
 	switch (proto) {
-#ifdef CONFIG_NF_CT_PROTO_SCTP_MODULE
-	case IPPROTO_SCTP:
-		return false;
-#endif
-#ifdef CONFIG_NF_CT_PROTO_DCCP_MODULE
-	case IPPROTO_DCCP:
-		return false;
-#endif
 #ifdef CONFIG_NF_CT_PROTO_GRE_MODULE
 	case IPPROTO_GRE:
 		return false;
 #endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE_MODULE
-	case IPPROTO_UDPLITE:
-		return false;
-#endif
 	default:
 		return true;
 	}
-- 
2.1.4
