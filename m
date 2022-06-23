Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBCFC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 13:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbiFWNFs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 09:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiFWNFr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 09:05:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A885640E61
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 06:05:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4MWn-0005Ze-6L; Thu, 23 Jun 2022 15:05:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/6] netfilter: nf_tables: use correct integer types
Date:   Thu, 23 Jun 2022 15:05:13 +0200
Message-Id: <20220623130514.13775-6-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220623130514.13775-1-fw@strlen.de>
References: <20220623130514.13775-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sparse tool complains about mixing of different endianess
types, so use the correct ones.

Add type casts where needed.

objdiff shows no changes except in nft_tunnel (type is changed).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_cmp.c    |  6 +++---
 net/netfilter/nft_ct.c     |  4 ++--
 net/netfilter/nft_exthdr.c | 10 +++++-----
 net/netfilter/nft_tunnel.c |  3 ++-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 6528f76ca29e..bec22584395f 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -125,13 +125,13 @@ static void nft_payload_n2h(union nft_cmp_offload_data *data,
 {
 	switch (len) {
 	case 2:
-		data->val16 = ntohs(*((u16 *)val));
+		data->val16 = ntohs(*((__be16 *)val));
 		break;
 	case 4:
-		data->val32 = ntohl(*((u32 *)val));
+		data->val32 = ntohl(*((__be32 *)val));
 		break;
 	case 8:
-		data->val64 = be64_to_cpu(*((u64 *)val));
+		data->val64 = be64_to_cpu(*((__be64 *)val));
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d8e1614918a1..b04995c3e17f 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -204,12 +204,12 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	case NFT_CT_SRC_IP:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			goto err;
-		*dest = tuple->src.u3.ip;
+		*dest = (__force __u32)tuple->src.u3.ip;
 		return;
 	case NFT_CT_DST_IP:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			goto err;
-		*dest = tuple->dst.u3.ip;
+		*dest = (__force __u32)tuple->dst.u3.ip;
 		return;
 	case NFT_CT_SRC_IP6:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 22c3e05b52db..a67ea9c3ae57 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -266,7 +266,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		switch (priv->len) {
 		case 2:
-			old.v16 = get_unaligned((u16 *)(opt + offset));
+			old.v16 = (__force __be16)get_unaligned((u16 *)(opt + offset));
 			new.v16 = (__force __be16)nft_reg_load16(
 				&regs->data[priv->sreg]);
 
@@ -281,18 +281,18 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			if (old.v16 == new.v16)
 				return;
 
-			put_unaligned(new.v16, (u16*)(opt + offset));
+			put_unaligned(new.v16, (__be16*)(opt + offset));
 			inet_proto_csum_replace2(&tcph->check, pkt->skb,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = regs->data[priv->sreg];
-			old.v32 = get_unaligned((u32 *)(opt + offset));
+			new.v32 = nft_reg_load_be32(&regs->data[priv->sreg]);
+			old.v32 = (__force __be32)get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
 				return;
 
-			put_unaligned(new.v32, (u32*)(opt + offset));
+			put_unaligned(new.v32, (__be32*)(opt + offset));
 			inet_proto_csum_replace4(&tcph->check, pkt->skb,
 						 old.v32, new.v32, false);
 			break;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d0f9b1d51b0e..5edaaded706d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -383,8 +383,9 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 				    struct ip_tunnel_info *info,
 				    struct nft_tunnel_opts *opts)
 {
-	int err, rem, type = 0;
 	struct nlattr *nla;
+	__be16 type = 0;
+	int err, rem;
 
 	err = nla_validate_nested_deprecated(attr, NFTA_TUNNEL_KEY_OPTS_MAX,
 					     nft_tunnel_opts_policy, NULL);
-- 
2.35.1

