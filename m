Return-Path: <SRS0=HcD6=3P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686FFC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jan 2020 11:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC662071A
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jan 2020 11:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgAZLM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Jan 2020 06:12:57 -0500
Received: from correo.us.es ([193.147.175.20]:34602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgAZLM5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Jan 2020 06:12:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7374BEF423
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jan 2020 12:12:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63B0CDA705
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jan 2020 12:12:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 59597DA703; Sun, 26 Jan 2020 12:12:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2875CDA701;
        Sun, 26 Jan 2020 12:12:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Jan 2020 12:12:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0B2A642EE38F;
        Sun, 26 Jan 2020 12:12:52 +0100 (CET)
Date:   Sun, 26 Jan 2020 12:12:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200126111251.e4kncc54umrq7mea@salvia>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116144833.jeshvfqvjpbl6fez@salvia>
 <20200116145954.GC18463@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vkggtlnvzx32gc2"
Content-Disposition: inline
In-Reply-To: <20200116145954.GC18463@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--5vkggtlnvzx32gc2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jeremy,

I've been looking into (ab)using bitwise to implement add/sub. I would
like to not add nft_arith for only this, and it seems to me much of
your code can be reused.

Do you think something like this would work?

Thanks.

--5vkggtlnvzx32gc2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="arith.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/=
netfilter/nf_tables.h
index 065218a20bb7..c4078359b6e4 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -508,11 +508,15 @@ enum nft_immediate_attributes {
  *                    XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_ADD: add operation
+ * @NFT_BITWISE_SUB: subtract operation
  */
 enum nft_bitwise_ops {
 	NFT_BITWISE_BOOL,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_ADD,
+	NFT_BITWISE_SUB,
 };
=20
 /**
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 0ed2281f03be..fd0cd2b4722a 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -60,6 +60,38 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 =
*src,
 	}
 }
=20
+static void nft_bitwise_eval_add(u32 *dst, const u32 *src,
+				 const struct nft_bitwise *priv)
+{
+	u32 delta =3D priv->data.data[0];
+	unsigned int i, words;
+	u32 tmp =3D 0;
+
+	words =3D DIV_ROUND_UP(priv->len, sizeof(u32));
+	for (i =3D 0; i < words; i++) {
+		tmp =3D src[i];
+		dst[i] =3D src[i] + delta;
+		if (dst[i] < tmp && i + 1 < words)
+			dst[i + 1]++;
+	}
+}
+
+static void nft_bitwise_eval_sub(u32 *dst, const u32 *src,
+				 const struct nft_bitwise *priv)
+{
+	u32 delta =3D priv->data.data[0];
+	unsigned int i, words;
+	u32 tmp =3D 0;
+
+	words =3D DIV_ROUND_UP(priv->len, sizeof(u32));
+	for (i =3D 0; i < words; i++) {
+		tmp =3D src[i];
+		dst[i] =3D src[i] - delta;
+		if (dst[i] > tmp && i + 1 < words)
+			dst[i + 1]--;
+	}
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
@@ -77,6 +109,12 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 	case NFT_BITWISE_RSHIFT:
 		nft_bitwise_eval_rshift(dst, src, priv);
 		break;
+	case NFT_BITWISE_ADD:
+		nft_bitwise_eval_add(dst, src, priv);
+		break;
+	case NFT_BITWISE_SUB:
+		nft_bitwise_eval_sub(dst, src, priv);
+		break;
 	}
 }
=20
@@ -129,8 +167,8 @@ static int nft_bitwise_init_bool(struct nft_bitwise *pr=
iv,
 	return err;
 }
=20
-static int nft_bitwise_init_shift(struct nft_bitwise *priv,
-				  const struct nlattr *const tb[])
+static int nft_bitwise_init_data(struct nft_bitwise *priv,
+				 const struct nlattr *const tb[])
 {
 	struct nft_data_desc d;
 	int err;
@@ -191,6 +229,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		case NFT_BITWISE_BOOL:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
+		case NFT_BITWISE_ADD:
+		case NFT_BITWISE_SUB:
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -205,7 +245,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
-		err =3D nft_bitwise_init_shift(priv, tb);
+	case NFT_BITWISE_ADD:
+	case NFT_BITWISE_SUB:
+		err =3D nft_bitwise_init_data(priv, tb);
 		break;
 	}
=20
@@ -226,8 +268,8 @@ static int nft_bitwise_dump_bool(struct sk_buff *skb,
 	return 0;
 }
=20
-static int nft_bitwise_dump_shift(struct sk_buff *skb,
-				  const struct nft_bitwise *priv)
+static int nft_bitwise_dump_data(struct sk_buff *skb,
+				 const struct nft_bitwise *priv)
 {
 	if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
 			  NFT_DATA_VALUE, sizeof(u32)) < 0)
@@ -255,7 +297,9 @@ static int nft_bitwise_dump(struct sk_buff *skb, const =
struct nft_expr *expr)
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
-		err =3D nft_bitwise_dump_shift(skb, priv);
+	case NFT_BITWISE_ADD:
+	case NFT_BITWISE_SUB:
+		err =3D nft_bitwise_dump_data(skb, priv);
 		break;
 	}
=20

--5vkggtlnvzx32gc2--
