Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879B42EB86D
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 09:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757584224; cv=none; b=qJR/mXa+dezpQ7Z8TIXQXGaN3OQhf7OWI14y+jzC0uumIhEoDGlg7t2POyXtqmhfXUhOCddMX2fhJveuLc0vJJEGoLJrg6GBAtPnZmamVMK2rhC1ToxuLyuygc9C9FSvdHViYYUqcYZIPIX1br2hWHxqzMXxsZbaXrbHv+LN1AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757584224; c=relaxed/simple;
	bh=BHNwajLwmMvaEID1Y0XJJoS5qKgnGsykwzlYGqqezek=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aTVIUoJotJMItsrWDiRurPdA88ExCmxz6r47zMUdQpBDNF7cE8s6RwajV96QIzolUs+Ea53gJ1O2EoS7iwEX0nXM2j3nKrBVKPWAvysHJ6wswBWFao7C1lewX/uMgGluz+ODIhx8YctkLCr2TMhNRSOfSublXxAfw0mUl04yeUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7584C60324; Thu, 11 Sep 2025 11:50:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 defer] netfilter: nft_byteorder: remove multi-register support
Date: Thu, 11 Sep 2025 11:50:00 +0200
Message-ID: <20250911095009.22744-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
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
 Sending this for the patchwork backlog so I don't forget about it.
 I think its still too early for this round due to above backwards
 compat issue.

 net/netfilter/nft_byteorder.c | 52 ++++++++++++++---------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index af9206a3afd1..8dbd918ef5a2 100644
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
@@ -175,7 +164,8 @@ static bool nft_byteorder_reduce(struct nft_regs_track *track,
 {
 	struct nft_byteorder *priv = nft_expr_priv(expr);
 
-	nft_reg_track_cancel(track, priv->dreg, priv->len);
+	/* warning: relies on NFTA_BYTEORDER_SIZE == BYTEORDER_LEN */
+	nft_reg_track_cancel(track, priv->dreg, priv->size);
 
 	return false;
 }
-- 
2.49.1

