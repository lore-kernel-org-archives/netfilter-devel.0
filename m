From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/2] netfilter: nft_ct: unnecessary to require dir when use ct l3proto/protocol
Date: Thu, 22 Sep 2016 22:28:51 +0800
Message-ID: <1474554532-50664-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:41220 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934041AbcIVO3m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:29:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Currently, if the user want to match ct l3proto, we must specify the
direction, for example:
  # nft add rule filter input ct original l3proto ipv4
                                 ^^^^^^^^
Otherwise, error message will be reported:
  # nft add rule filter input ct l3proto ipv4
  nft add rule filter input ct l3proto ipv4
  <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
  add rule filter input ct l3proto ipv4
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Actually, there's no need to require NFTA_CT_DIRECTION attr, because
ct l3proto and protocol are unrelated to direction.

And for compatibility, even if the user specify the NFTA_CT_DIRECTION
attr, do not report error, just skip it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 Note: syntax "ct l3proto ipv4" is not supported yet, nft patch will be sent
       later.

 net/netfilter/nft_ct.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 51e180f..825fbbc 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -128,15 +128,18 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		memcpy(dest, &count, sizeof(count));
 		return;
 	}
+	case NFT_CT_L3PROTOCOL:
+		*dest = nf_ct_l3num(ct);
+		return;
+	case NFT_CT_PROTOCOL:
+		*dest = nf_ct_protonum(ct);
+		return;
 	default:
 		break;
 	}
 
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
-	case NFT_CT_L3PROTOCOL:
-		*dest = nf_ct_l3num(ct);
-		return;
 	case NFT_CT_SRC:
 		memcpy(dest, tuple->src.u3.all,
 		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
@@ -145,9 +148,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		memcpy(dest, tuple->dst.u3.all,
 		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
 		return;
-	case NFT_CT_PROTOCOL:
-		*dest = nf_ct_protonum(ct);
-		return;
 	case NFT_CT_PROTO_SRC:
 		*dest = (__force __u16)tuple->src.u.all;
 		return;
@@ -283,8 +283,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 
 	case NFT_CT_L3PROTOCOL:
 	case NFT_CT_PROTOCOL:
-		if (tb[NFTA_CT_DIRECTION] == NULL)
-			return -EINVAL;
+		/* For compatibility, do not report error if NFTA_CT_DIRECTION
+		 * attribute is specified.
+		 */
 		len = sizeof(u8);
 		break;
 	case NFT_CT_SRC:
@@ -432,8 +433,6 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 
 	switch (priv->key) {
-	case NFT_CT_L3PROTOCOL:
-	case NFT_CT_PROTOCOL:
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
 	case NFT_CT_PROTO_SRC:
-- 
2.5.5


