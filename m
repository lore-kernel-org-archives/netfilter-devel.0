From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix port natting in little endian archs
Date: Mon, 22 Dec 2014 13:59:42 +0100
Message-ID: <1419253182-3590-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, christophe.leroy@c-s.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35864 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbaLVM5Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:57:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: leroy christophe <christophe.leroy@c-s.fr>

Make sure this fetches 16-bits port data from the register.
Remove casting to make sparse happy, not needed anymore.

Signed-off-by: leroy christophe <christophe.leroy@c-s.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Christophe: I have also mangled other spots where this problems will show up
and remove casting (not required anymore to make sparse happy). Please, test
and will submit this to mainstream. I have included you as author, I wanted
to speed up the submission process. Thanks.

 net/ipv4/netfilter/nft_redir_ipv4.c |    8 ++++----
 net/ipv6/netfilter/nft_redir_ipv6.c |    8 ++++----
 net/netfilter/nft_nat.c             |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
index ff2d23d..6ecfce6 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -27,10 +27,10 @@ static void nft_redir_ipv4_eval(const struct nft_expr *expr,
 
 	memset(&mr, 0, sizeof(mr));
 	if (priv->sreg_proto_min) {
-		mr.range[0].min.all = (__force __be16)
-					data[priv->sreg_proto_min].data[0];
-		mr.range[0].max.all = (__force __be16)
-					data[priv->sreg_proto_max].data[0];
+		mr.range[0].min.all =
+			*(__be16 *)&data[priv->sreg_proto_min].data[0];
+		mr.range[0].max.all =
+			*(__be16 *)&data[priv->sreg_proto_max].data[0];
 		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index 2433a6b..11820b6 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -27,10 +27,10 @@ static void nft_redir_ipv6_eval(const struct nft_expr *expr,
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)
-					data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = (__force __be16)
-					data[priv->sreg_proto_max].data[0];
+		range.min_proto.all =
+			*(__be16 *)&data[priv->sreg_proto_min].data[0];
+		range.max_proto.all =
+			*(__be16 *)&data[priv->sreg_proto_max].data[0];
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index afe2b0b..aff54fb1 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -65,10 +65,10 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	}
 
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)
-					data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = (__force __be16)
-					data[priv->sreg_proto_max].data[0];
+		range.min_proto.all =
+			*(__be16 *)&data[priv->sreg_proto_min].data[0];
+		range.max_proto.all =
+			*(__be16 *)&data[priv->sreg_proto_max].data[0];
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
-- 
1.7.10.4

