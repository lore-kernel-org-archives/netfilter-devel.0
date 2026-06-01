Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425093769F8;
	Mon,  1 Jun 2026 11:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315182; cv=none; b=kVCeEMg25QFvG0w8e8FUsbh/7ORkAXE6+QtmsNowfe+kYJsj/XM0cmy+57167KTmL+mH6jm7p4J53uH+7AEzr76odrtmRT7xDPpHKtM84cEGhb7Vvu6mt+KOtIMyz2rjPgqUngCuJ6G352ksbh8O9lpbDW9ge1m7lsmPrnHB/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315182; c=relaxed/simple;
	bh=3tdKmuULcclcOJoxprNhJA0PtRjopICn1RCeNruzdv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u525JuFPrA6izXczV/1a9+mfq/cbyMLlXnyj1/XmliegG8twt8FxZKZUANJ61zIAKUohXwAP4ngoL2Bo8AZIdhQXijT1GdMawBXdnr6Zm5yuPixvl9LD2cMifqsBZossKBlz98vktidcVb9UOgbMaxZOSyNzj4C2ZI9LYulSPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NM+6StCp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NM+6StCp"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 10C94601BE;
	Mon,  1 Jun 2026 13:59:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315179;
	bh=HlG2ZcdHCMn982VRnbR1gzOObC5qTdEjng9WTNpotc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NM+6StCpcFuDxpBEOjFBouWwkLOgeANbxAT7FB4mjmxVYuy0qbDRls9SfrIbVipKU
	 2p2n9L4y9TcVYyIsmKTxmNtYcrfpCxblhckI96Ayg5Y3hhxTnbJqaR24qFvKam6ToO
	 e9Xu28PFuJqulvPe2ccoEe8jHPYZmqtu0tIKHruAxrAI1inknyzkt/gFvNVNsDbWBw
	 i0E8RAyaEfWx9VKIN8XmMnInv+BYA2Vp557/miPCT4h30mQvHbG09JfoweZl+m+8x8
	 hH5ivK7cOrcGHhWjeTev1DvF2t/zvcQ3fZbmdvXS9fL1cNnTRhQOJgXxtAzMQtz6b2
	 zF7M5AaHBwzhA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 9/9] netfilter: nft_byteorder: remove multi-register support
Date: Mon,  1 Jun 2026 13:59:23 +0200
Message-ID: <20260601115923.433946-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

64bit byteorder conversion is broken when several registers need to be
converted because the source register array advances in steps for 4 bytes
instead of 8:

  for (i = ...
      src64 = nft_reg_load64(&src[i]);
                             ~~~~~ u32 *src
      nft_reg_store64(&dst64[i],

Remove the multi-register support, it has other issues as well:

Pablo points out that commit
caf3ef7468f7 ("netfilter: nf_tables: prevent OOB access in nft_byteorder_eval")
alters semantics: before the loop operated on registers, i.e.
 for ( ... )
   dst32[i] = htons((u16)src32[i])

 .. but after the patch it will operate on bytes, which makes this
 useless to convert e.g. concatenations, which store each compound
 in its own register.

Multi-convert of u32 has one theoretical application:

ct mark . meta mark . tcp dport @intervalset

Because ct mark and meta mark are host byte order, use with
intervals has to convert the byteorder for ct/meta mark value
to network byte order (bigendian).

nftables emits this:
 [ meta load mark => reg 1 ]
 [ byteorder reg 1 = hton(reg 1, 4, 4) ]
 [ ct load mark => reg 9 ]
 [ byteorder reg 9 = hton(reg 9, 4, 4) ]
 ...

I.e. two separate calls.  Theoretically it could be changed to do:
 [ meta load mark => reg 1 ]
 [ ct load mark => reg 9 ]
 [ byteorder reg 1 = htonl(reg 1, 4, 8) ]
 ...

But then all it would take to change the set to
meta mark . tcp dport . ct mark

... and we'd be back to two "byteorder" calls. IOW, support to
convert a range of registers is both dysfunctional and dubious.

Simplify this: remove the feature.

Pablo Neira Ayuso points out that nftables before 1.1.0 can generate
incorrect byteorder conversions, see 9fe58952c45a,
"evaluate: skip byteorder conversion for selector smaller than 2 bytes"
in nftables.git).  Affected rulesets fail to load with this change and
old userspace due to 'len != size' check.

Fixes: c301f0981fdd ("netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()")
Cc: <stable+noautosel@kernel.org> # may break rule load with old nftables versions
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/netfilter-devel/20240206104336.ctigqpkunom2ufmn@lion.mk-sys.cz/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_byteorder.c | 51 ++++++++++++++---------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 2316c77f4228..dfd41fc8d9b8 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -19,7 +19,6 @@ struct nft_byteorder {
 	u8			sreg;
 	u8			dreg;
 	enum nft_byteorder_ops	op:8;
-	u8			len;
 	u8			size;
 };
 
@@ -28,13 +27,8 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 			const struct nft_pktinfo *pkt)
 {
 	const struct nft_byteorder *priv = nft_expr_priv(expr);
-	u32 *src = &regs->data[priv->sreg];
+	const u32 *src = &regs->data[priv->sreg];
 	u32 *dst = &regs->data[priv->dreg];
-	u16 *s16, *d16;
-	unsigned int i;
-
-	s16 = (void *)src;
-	d16 = (void *)dst;
 
 	switch (priv->size) {
 	case 8: {
@@ -43,18 +37,14 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
-			for (i = 0; i < priv->len / 8; i++) {
-				src64 = nft_reg_load64(&src[i]);
-				nft_reg_store64(&dst64[i],
-						be64_to_cpu((__force __be64)src64));
-			}
+			src64 = nft_reg_load64(src);
+
+			nft_reg_store64(dst64, be64_to_cpu((__force __be64)src64));
 			break;
 		case NFT_BYTEORDER_HTON:
-			for (i = 0; i < priv->len / 8; i++) {
-				src64 = (__force __u64)
-					cpu_to_be64(nft_reg_load64(&src[i]));
-				nft_reg_store64(&dst64[i], src64);
-			}
+			src64 = (__force __u64)cpu_to_be64(nft_reg_load64(src));
+
+			nft_reg_store64(dst64, src64);
 			break;
 		}
 		break;
@@ -62,24 +52,20 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 	case 4:
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
-			for (i = 0; i < priv->len / 4; i++)
-				dst[i] = ntohl((__force __be32)src[i]);
+			*dst = ntohl((__force __be32)*src);
 			break;
 		case NFT_BYTEORDER_HTON:
-			for (i = 0; i < priv->len / 4; i++)
-				dst[i] = (__force __u32)htonl(src[i]);
+			*dst = (__force __u32)htonl(*src);
 			break;
 		}
 		break;
 	case 2:
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
-			for (i = 0; i < priv->len / 2; i++)
-				d16[i] = ntohs((__force __be16)s16[i]);
+			nft_reg_store16(dst, ntohs(nft_reg_load_be16(src)));
 			break;
 		case NFT_BYTEORDER_HTON:
-			for (i = 0; i < priv->len / 2; i++)
-				d16[i] = (__force __u16)htons(s16[i]);
+			nft_reg_store_be16(dst, htons(nft_reg_load16(src)));
 			break;
 		}
 		break;
@@ -137,20 +123,22 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	priv->len = len;
+	/* no longer support multi-reg conversions */
+	if (len != size)
+		return -EOPNOTSUPP;
 
 	err = nft_parse_register_load(ctx, tb[NFTA_BYTEORDER_SREG], &priv->sreg,
-				      priv->len);
+				      len);
 	if (err < 0)
 		return err;
 
 	err = nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
 				       &priv->dreg, NULL, NFT_DATA_VALUE,
-				       priv->len);
+				       len);
 	if (err < 0)
 		return err;
 
-	if (nft_reg_overlap(priv->sreg, priv->dreg, priv->len))
+	if (nft_reg_overlap(priv->sreg, priv->dreg, len))
 		return -EINVAL;
 
 	return 0;
@@ -167,10 +155,11 @@ static int nft_byteorder_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_BYTEORDER_OP, htonl(priv->op)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_BYTEORDER_LEN, htonl(priv->len)))
-		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_BYTEORDER_SIZE, htonl(priv->size)))
 		goto nla_put_failure;
+	/* compatibility for old userspace which permitted size != len */
+	if (nla_put_be32(skb, NFTA_BYTEORDER_LEN, htonl(priv->size)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.47.3

