From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH] netfilter: nftables: Fix sparse endianness issue on nft_nat.c
Date: Fri, 18 Oct 2013 12:00:53 +0300
Message-ID: <1382086853-14251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19393 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3JRJBB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:01:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes this:

CHECK   net/netfilter/nft_nat.c
net/netfilter/nft_nat.c:50:43: warning: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:50:43:    expected restricted __be32 [addressable] [usertype] ip
net/netfilter/nft_nat.c:50:43:    got unsigned int [unsigned] [usertype] <noident>
net/netfilter/nft_nat.c:51:43: warning: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:51:43:    expected restricted __be32 [addressable] [usertype] ip
net/netfilter/nft_nat.c:51:43:    got unsigned int [unsigned] [usertype] <noident>
net/netfilter/nft_nat.c:65:37: warning: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:65:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
net/netfilter/nft_nat.c:65:37:    got unsigned int [unsigned] <noident>
net/netfilter/nft_nat.c:66:37: warning: incorrect type in assignment (different base types)
net/netfilter/nft_nat.c:66:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
net/netfilter/nft_nat.c:66:37:    got unsigned int [unsigned] <noident>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---

Hi,

looks a bit ugly, would there be another way to fix this?

Tomasz

 net/netfilter/nft_nat.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index b0b87b2..f9d488f 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -47,8 +47,12 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
 		if (priv->family == AF_INET) {
-			range.min_addr.ip = data[priv->sreg_addr_min].data[0];
-			range.max_addr.ip = data[priv->sreg_addr_max].data[0];
+			range.min_addr.ip =
+				be32_to_cpup((__be32 *)
+					data[priv->sreg_addr_min].data);
+			range.max_addr.ip =
+				be32_to_cpup((__be32 *)
+					data[priv->sreg_addr_max].data);
 
 		} else {
 			memcpy(range.min_addr.ip6,
@@ -62,8 +66,12 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	}
 
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = data[priv->sreg_proto_max].data[0];
+		range.min_proto.all =
+			be16_to_cpup((__be16 *)
+					data[priv->sreg_proto_min].data);
+		range.max_proto.all =
+			be16_to_cpup((__be16 *)
+					data[priv->sreg_proto_max].data);
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
-- 
1.8.3.2

