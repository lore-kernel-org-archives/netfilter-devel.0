Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99209C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 08:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BEAA2077B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 08:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="TA13/sJK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgAPIvg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 03:51:36 -0500
Received: from kadath.azazel.net ([81.187.231.250]:54734 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731453AbgAPIvg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 03:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e4HEE8R+8nl/wzoOkJeHrPqet1xLxMkrhs30dggb2hg=; b=TA13/sJKej5xleI135b5/de2i5
        /VQQHhw8vXDxz0Kb0hxmZtaARPylZVJHCTzYZzMl5YHklzf8mmXElmb3OZbNrleJk+GZZmdwFaEg9
        7l38zzemFkhn/LR+UYJgmgNUnqDhVcoeJORJpYJdK+jpZ2vrxq6+EYtoYiGGbf70rwNDAfAJDTFcV
        ZXnkb0inTQ31SsXn3L8fLSAiLSKMv+Euwg+YKqSs0oEpU1Jp/MSJq2XnS8xdcWAXD4vt8aa2MUmya
        h1WuJ2H3PXkxGtweFYwwSirxEIs2HrMWl1HvSm5OG2VMcPkYC/wr7dLedd8WgGfZ8chxglJwvTBk/
        VD24WKwA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1is0sH-0007ty-5E; Thu, 16 Jan 2020 08:51:33 +0000
Date:   Thu, 16 Jan 2020 08:51:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200116085133.GG999973@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
Content-Disposition: inline
In-Reply-To: <20200115213216.77493-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-15, at 21:32:06 +0000, Jeremy Sowden wrote:
> The connmark xtables extension supports bit-shifts.  Add support for
> shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:
>
>   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
>   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
>
> Changes since v3:
>
>   * the length of shift values sent by nft may be less than sizeof(u32).

Actually, having thought about this some more, I believe I had it right
in v3.  The difference between v3 and v4 is this:

  @@ -146,7 +146,7 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
                              tb[NFTA_BITWISE_DATA]);
          if (err < 0)
                  return err;
  -       if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
  +       if (d.type != NFT_DATA_VALUE || d.len > sizeof(u32) ||
              priv->data.data[0] >= BITS_PER_TYPE(u32)) {
                  nft_data_release(&priv->data, d.type);
                  return -EINVAL;

However, I now think the problem is in userspace and nft should always
send four bytes.  If it sends fewer, it makes it more complicated to get
the endianness right.

Unless you think there are other changes needed that will required a v5,
shall we just ignore v4 and stick with v3?

> Changes since v2:
>
>   * convert NFTA_BITWISE_DATA from u32 to nft_data;
>   * add check that shift value is not too large;
>   * use BITS_PER_TYPE to get the size of u32, rather than hard-coding it
>     when evaluating shifts.
>
> Changes since v1:
>
>   * more white-space fixes;
>   * move bitwise op enum to UAPI;
>   * add NFTA_BITWISE_OP and NFTA_BITWISE_DATA;
>   * remove NFTA_BITWISE_LSHIFT and NFTA_BITWISE_RSHIFT;
>   * add helpers for initializaing, evaluating and dumping different
>     types of operation.
>
> Jeremy Sowden (10):
>   netfilter: nf_tables: white-space fixes.
>   netfilter: bitwise: remove NULL comparisons from attribute checks.
>   netfilter: bitwise: replace gotos with returns.
>   netfilter: bitwise: add NFTA_BITWISE_OP attribute.
>   netfilter: bitwise: add helper for initializing boolean operations.
>   netfilter: bitwise: add helper for evaluating boolean operations.
>   netfilter: bitwise: add helper for dumping boolean operations.
>   netfilter: bitwise: only offload boolean operations.
>   netfilter: bitwise: add NFTA_BITWISE_DATA attribute.
>   netfilter: bitwise: add support for shifts.
>
>  include/uapi/linux/netfilter/nf_tables.h |  24 ++-
>  net/netfilter/nft_bitwise.c              | 217 ++++++++++++++++++-----
>  net/netfilter/nft_set_bitmap.c           |   4 +-
>  net/netfilter/nft_set_hash.c             |   2 +-
>  4 files changed, 200 insertions(+), 47 deletions(-)
>
> --
> 2.24.1

J.

--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4gJAUACgkQonv1GCHZ
79dD9Av+ODipcdiRyz4zbtzge3qpV6Q74cFZwqg/hi+bONes631Xe9VjYFEcaHbm
RHSC94GIrol/9+y4YBMcxBBJMyabVMozqYSo8PZ08FJxRTVqB6Sknj4l6y1tNQQY
SNmuKD9C72VXBdc+PheArrmnsswCH97smw71vRuRPdwgFaC/GVP8FEyaJcT6mt3B
mqDxwhayXqfBdhgpAFHAB6wkRrgfX7lJ8yps1xc0HDkHhM6KIj9jX607SyJXNkIi
rt/ClSaC9S4XQ4P1pXq3DplrNoXS0Cot9t05gJDXqczvqG/LhdQo+9GOGsU0JpkS
U7VWx3bfY1ecbN3XD0HguJ40Uhl6EQH4f0uCVJXmAp5i2KP2/HSP4eXyZvCDo0iC
ncmn6lUlJjxCp9zbksNmQus3cAArpn5YqyzkQxjb+Pn7VxaH+qeqnpK8hKrj7S3p
fgAUs2dKeriz6z9y1i0Aml+gMBbgCkXi76qqDNyOi0zNWMhFSB7snX/H/FJM7nG/
W/RTJwb9
=Gpsx
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
