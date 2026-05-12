Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28821A6824
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778592988; cv=none; b=Gcpd6wIGAtvktqK3VyfasT/j3Vrm4VzuO+TkpFYqIVNP9q6uR7W6KS7Ty5LL7gZ0VxvLA7ucI2G0SJEscFPqrH/mWq9A6LQ6uyG6Bmkypl43eFUffSA/Bu356VBNgVMjM2pHbpPzVnobCx8X5XUPVg3HpL/chlEAnGm7+20WnKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778592988; c=relaxed/simple;
	bh=iDiycwu3H21RJK+wtrQiD4rVJTpoDz6fG+Chk7ymFvE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WekUax7JMi6goqFWprvQrEk1XjHpKVRGQc6Qyl/Qx+TgpIZ5olLbQ1ZitoWBmPoPQb1qwZggMtxcb+9JBjzRft7HbHy3pEMs3xxAAFSJ7lF3J0ylS3MtTDhUL4aMP6k9KEXzUtmY2O7bWir8vS6nOykJI+AbeWswodmz9F+MWc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7A4D060D66; Tue, 12 May 2026 15:36:24 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 nf-next] netfilter: nft_byteorder: remove multi-register support
Date: Tue, 12 May 2026 15:36:14 +0200
Message-ID: <20260512133617.8191-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 v3: proposing this for inclusion again; sashiko also points out the
 breakage in nft_byteorder as drive-by result.

 net/netfilter/nft_byteorder.c | 49 ++++++++++++++---------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index e00dddfa2fc0..a60791b84694 100644
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
@@ -137,16 +123,18 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
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
 
 	return nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
-					priv->len);
+					len);
 }
 
 static int nft_byteorder_dump(struct sk_buff *skb,
@@ -160,10 +148,11 @@ static int nft_byteorder_dump(struct sk_buff *skb,
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
2.53.0

