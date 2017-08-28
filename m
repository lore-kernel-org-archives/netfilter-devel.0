From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next] netfilter: nf_conntrack: remove unused code in nf_conntrack_proto_generic.c
Date: Mon, 28 Aug 2017 11:52:07 +0200
Message-ID: <2506ca6f6d8fdc51d85fc77e558b1662ff18eba9.1503913723.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751143AbdH1JwK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 05:52:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

L4 protocol helpers for DCCP, SCTP and UDPlite can't be built as kernel
modules anymore, so we can remove code enclosed in
 #ifdef CONFIG_NF_CT_PROTO_{DCCP,SCTP,UDPLITE}_MODULE

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
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
2.13.5

