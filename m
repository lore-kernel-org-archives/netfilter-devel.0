Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECB7C33CB1
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 11:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 198BD20716
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 11:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Qv1vG2z0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgA0L5l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jan 2020 06:57:41 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48622 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgA0L5l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 06:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/2gvG5Tu6i9ZJECJG+V0Nxu6YRL29alaUMIJTFYQ3nY=; b=Qv1vG2z0rWKw8wNuPhG1El1d0X
        XvDep9zm3vsjAix3QOocmjID/uoa5RnII23QGowsanHUdPWQSixX61IR1DZw8rOHE5U6df5KgDulf
        5e5mg7EbUsIH203zl8ldzRgYQUi2mcDglFamDj5Z+M+oGmngNyz83jouUU17yFvmfcNZdysspTj/Z
        xifQacLkUu+1KRWOU0xFcQw1py9vvKgDQVxE9MElW5tCWIaAkjOl4sGx7+Kp0YFFkM/ix0XqmmJMe
        zAbCqT4EckYozoIdSrF8RjayauzpAgo7uhpZBNhecShnGfzQVIPrZsm+XbPuQ3gCbtduc/S9ExEw6
        qIFNyP1Q==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iw2KR-0006Tc-Ue; Mon, 27 Jan 2020 11:13:16 +0000
Date:   Mon, 27 Jan 2020 11:13:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200127111314.GA377617@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116144833.jeshvfqvjpbl6fez@salvia>
 <20200116145954.GC18463@azazel.net>
 <20200126111251.e4kncc54umrq7mea@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20200126111251.e4kncc54umrq7mea@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-26, at 12:12:51 +0100, Pablo Neira Ayuso wrote:
> I've been looking into (ab)using bitwise to implement add/sub. I would
> like to not add nft_arith for only this, and it seems to me much of
> your code can be reused.
>
> Do you think something like this would work?

Absolutely.

A couple of questions.  What's the use-case?  I find the combination of
applying the delta to every u32 and having a carry curious.  Do you want
to support bigendian arithmetic (i.e., carrying to the left) as well?

I've suggested a couple of changes below.

J.

> Thanks.
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h
> b/include/uapi/linux/netfilter/nf_tables.h
> index 065218a20bb7..c4078359b6e4 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -508,11 +508,15 @@ enum nft_immediate_attributes {
>   *                    XOR boolean operations
>   * @NFT_BITWISE_LSHIFT: left-shift operation
>   * @NFT_BITWISE_RSHIFT: right-shift operation
> + * @NFT_BITWISE_ADD: add operation
> + * @NFT_BITWISE_SUB: subtract operation
>   */
>  enum nft_bitwise_ops {
>  	NFT_BITWISE_BOOL,
>  	NFT_BITWISE_LSHIFT,
>  	NFT_BITWISE_RSHIFT,
> +	NFT_BITWISE_ADD,
> +	NFT_BITWISE_SUB,
>  };
>
>  /**
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index 0ed2281f03be..fd0cd2b4722a 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -60,6 +60,38 @@ static void nft_bitwise_eval_rshift(u32 *dst, const
> u32 *src,
>  	}
>  }
>
> +static void nft_bitwise_eval_add(u32 *dst, const u32 *src,
> +				 const struct nft_bitwise *priv)
> +{
> +	u32 delta = priv->data.data[0];
> +	unsigned int i, words;
> +	u32 tmp = 0;
> +
> +	words = DIV_ROUND_UP(priv->len, sizeof(u32));
> +	for (i = 0; i < words; i++) {
> +		tmp = src[i];
> +		dst[i] = src[i] + delta;
> +		if (dst[i] < tmp && i + 1 < words)
> +			dst[i + 1]++;
> +	}
> +}

for (i = 0; i < words; i++) {
	dst[i] = src[i] + delta + tmp;
	tmp = dst[i] < src[i] ? 1 : 0;
}

> +static void nft_bitwise_eval_sub(u32 *dst, const u32 *src,
> +				 const struct nft_bitwise *priv)
> +{
> +	u32 delta = priv->data.data[0];
> +	unsigned int i, words;
> +	u32 tmp = 0;
> +
> +	words = DIV_ROUND_UP(priv->len, sizeof(u32));
> +	for (i = 0; i < words; i++) {
> +		tmp = src[i];
> +		dst[i] = src[i] - delta;
> +		if (dst[i] > tmp && i + 1 < words)
> +			dst[i + 1]--;
> +	}
> +}

for (i = 0; i < words; i++) {
	dst[i] = src[i] - delta - tmp;
	tmp = dst[i] > src[i] ? 1 : 0;
}

>  void nft_bitwise_eval(const struct nft_expr *expr,
>  		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
>  {
> @@ -77,6 +109,12 @@ void nft_bitwise_eval(const struct nft_expr *expr,
>  	case NFT_BITWISE_RSHIFT:
>  		nft_bitwise_eval_rshift(dst, src, priv);
>  		break;
> +	case NFT_BITWISE_ADD:
> +		nft_bitwise_eval_add(dst, src, priv);
> +		break;
> +	case NFT_BITWISE_SUB:
> +		nft_bitwise_eval_sub(dst, src, priv);
> +		break;
>  	}
>  }
>
> @@ -129,8 +167,8 @@ static int nft_bitwise_init_bool(struct
> nft_bitwise *priv,
>  	return err;
>  }
>
> -static int nft_bitwise_init_shift(struct nft_bitwise *priv,
> -				  const struct nlattr *const tb[])
> +static int nft_bitwise_init_data(struct nft_bitwise *priv,
> +				 const struct nlattr *const tb[])
>  {
>  	struct nft_data_desc d;
>  	int err;
> @@ -191,6 +229,8 @@ static int nft_bitwise_init(const struct nft_ctx
> *ctx,
>  		case NFT_BITWISE_BOOL:
>  		case NFT_BITWISE_LSHIFT:
>  		case NFT_BITWISE_RSHIFT:
> +		case NFT_BITWISE_ADD:
> +		case NFT_BITWISE_SUB:
>  			break;
>  		default:
>  			return -EOPNOTSUPP;
> @@ -205,7 +245,9 @@ static int nft_bitwise_init(const struct nft_ctx
> *ctx,
>  		break;
>  	case NFT_BITWISE_LSHIFT:
>  	case NFT_BITWISE_RSHIFT:
> -		err = nft_bitwise_init_shift(priv, tb);
> +	case NFT_BITWISE_ADD:
> +	case NFT_BITWISE_SUB:
> +		err = nft_bitwise_init_data(priv, tb);
>  		break;
>  	}
>
> @@ -226,8 +268,8 @@ static int nft_bitwise_dump_bool(struct sk_buff
> *skb,
>  	return 0;
>  }
>
> -static int nft_bitwise_dump_shift(struct sk_buff *skb,
> -				  const struct nft_bitwise *priv)
> +static int nft_bitwise_dump_data(struct sk_buff *skb,
> +				 const struct nft_bitwise *priv)
>  {
>  	if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
>  			  NFT_DATA_VALUE, sizeof(u32)) < 0)
> @@ -255,7 +297,9 @@ static int nft_bitwise_dump(struct sk_buff *skb,
> const struct nft_expr *expr)
>  		break;
>  	case NFT_BITWISE_LSHIFT:
>  	case NFT_BITWISE_RSHIFT:
> -		err = nft_bitwise_dump_shift(skb, priv);
> +	case NFT_BITWISE_ADD:
> +	case NFT_BITWISE_SUB:
> +		err = nft_bitwise_dump_data(skb, priv);
>  		break;
>  	}
>

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4uxcMACgkQonv1GCHZ
79e7ewv+LB2K5gs1CEDCzlC3NgykukGNo3AfGDxZ5SvV32clS4rIVeuXcHvQrvsv
xDHYrHYJqdKTJOz0aflXR7bsWck6r32H0AHIWE0yy16piqRpy2AS5BP6mBjVNomq
I55aAsW/k8mCz+3Nbc4/N+4tnNIyp8z5e9ylQJgTpNZcs/6SF0ARsYsjD6XjCm7N
ZEf0RX5KRBn0q88pKxceNJ+d6r0pJXf4k5tfOc2f8mI40QYDRUIyRwnB1zgMyBOP
nVRk9GQj2i8F0H+IP+q43+caLzjXBsz3WIpwNLe0Wu2DLhqDS7k5D+kaFU3EqQOr
SBRSpu0fhlTZyA8nt33l6Zuw3xnQMm5jIFPPDeWJMqMIFI536Gxz4F1NIcNWXNJ5
9Bq6otV7Vp4FsMubFo+/Q1Gjf6kYb2Tys3Q3BgFDlN625HD9LZuX3q4RSOyJiD9r
9jmYx7SD7+FlSzvo7NrmKjct+POXaluSnL+Drl+cSeY8rFgBsn1HyIWhuI3e4P4r
UEXWF3EX
=x3Iv
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
