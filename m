From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH v2] netfilter: nftables: Fix sparse endianness issue on nft_nat.c
Date: Mon, 28 Oct 2013 12:19:45 +0200
Message-ID: <1382955585-21113-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53341 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab3J1KTt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:19:49 -0400
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
 net/netfilter/nft_nat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index b0b87b2..d3b1ffe 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -47,8 +47,10 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
 		if (priv->family == AF_INET) {
-			range.min_addr.ip = data[priv->sreg_addr_min].data[0];
-			range.max_addr.ip = data[priv->sreg_addr_max].data[0];
+			range.min_addr.ip = (__force __be32)
+					data[priv->sreg_addr_min].data[0];
+			range.max_addr.ip = (__force __be32)
+					data[priv->sreg_addr_max].data[0];
 
 		} else {
 			memcpy(range.min_addr.ip6,
@@ -62,8 +64,10 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	}
 
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = data[priv->sreg_proto_max].data[0];
+		range.min_proto.all = (__force __be16)
+					data[priv->sreg_proto_min].data[0];
+		range.max_proto.all = (__force __be16)
+					data[priv->sreg_proto_max].data[0];
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
-- 
1.8.3.2

