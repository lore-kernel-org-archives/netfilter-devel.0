Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E01C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7519920730
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="BpYeNslM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgAPLly (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:41:54 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33016 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgAPLlx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 06:41:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pB3XbtL+5Or8wRXYjdUD2czcm+bxytyigwYtMuaamMM=; b=BpYeNslMjIAMJ/2YtmwBs70Kkz
        uFChlQOcvv3z8s2BrXcTjVFIKGp4UVrkjIyrqThP/5+pZ6pcY2/scVtQTxGRPbA/j61uanUgKP86l
        X4A0iJKpSfmW9ARGBMK89gtK2sYXCqiZ1VuKzJht8jmCf3sVFihEkpZPSZLDSxSArFNUpuf7289LY
        08lrvRnnOhfNfGlxm3alcCuzdyPYs6ilNEPk5l5D4B0w2wu3pzSDOKiFoYGNZqvHeToseFeQejxql
        W8gnFUb6KqCEkr0l6t2hLQMvBdaeeG8qw91K1x8g2Y1U462CZp2vp67nsM4rDGo9rtWsrNgLC2cbc
        k3rEnFTg==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1is3X6-0006lU-Od; Thu, 16 Jan 2020 11:41:52 +0000
Date:   Thu, 16 Jan 2020 11:41:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200116114152.GA18463@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116085133.GG999973@azazel.net>
 <20200116112247.pfhkhii6b44iiw3n@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20200116112247.pfhkhii6b44iiw3n@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-16, at 12:22:47 +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 16, 2020 at 08:51:33AM +0000, Jeremy Sowden wrote:
> > On 2020-01-15, at 21:32:06 +0000, Jeremy Sowden wrote:
> > > The connmark xtables extension supports bit-shifts.  Add support
> > > for shifts to nft_bitwise in order to allow nftables to do
> > > likewise, e.g.:
> > >
> > >   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
> > >   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
> > >
> > > Changes since v3:
> > >
> > >   * the length of shift values sent by nft may be less than
> > >   sizeof(u32).
> >
> > Actually, having thought about this some more, I believe I had it
> > right in v3.  The difference between v3 and v4 is this:
> >
> >   @@ -146,7 +146,7 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
> >                               tb[NFTA_BITWISE_DATA]);
> >           if (err < 0)
> >                   return err;
> >   -       if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
> >   +       if (d.type != NFT_DATA_VALUE || d.len > sizeof(u32) ||
> >               priv->data.data[0] >= BITS_PER_TYPE(u32)) {
>
> Why restrict this to 32-bits?

Because of how I implemented the shifts.  Here's the current rshift:

  static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
                                      const struct nft_bitwise *priv)
  {
          u32 shift = priv->data.data[0];
          unsigned int i;
          u32 carry = 0;

          for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
                  dst[i] = carry | (src[i] >> shift);
                  carry = src[i] << (BITS_PER_TYPE(u32) - shift);
          }
  }

In order to support larger shifts, it would need to look something
like:

  static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
                                      const struct nft_bitwise *priv)
  {
          unsigned len = DIV_ROUND_UP(priv->len, sizeof(u32));
          unsigned int d = shift / BITS_PER_TYPE(u32), s = 0;
          u32 shift = priv->data.data[0];
          u32 carry = 0;

          if (d > 0) {
                  memset(dst, '\0', d * sizeof(*dst));
                  shift %= BITS_PER_TYPE(u32);
          }

          for (s = 0; d < len; d++, s++) {
                  dst[d] = carry | (src[s] >> shift);
                  carry = src[s] << (BITS_PER_TYPE(u32) - shift);
          }
  }

J.

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4gS/IACgkQonv1GCHZ
79cCsAv8DHuGqWLLMf9tctTqgSejm2y5WpWhBI6oJ3SEbX9w4HSCSfhaVpnHE7D8
C2xrPbtLsXYJUJCIg7Sj2O+WkuMkW0/aLsM+0kqXRPliaKZy7P8f8ESLbgx6Pt05
NQFfvRrw8HNyeKF50tl4ypK9zJIrlyLWni7+qkX6tkXM/Mbwxd0l7+W00eEAp2MI
TyO9rUX+dpsI6TbISYS2JpcxgeKOkFPTit2CiX3AO6xO9Fsn3utmO9Y0MqXjCW03
+BnPXP7z62v7IittcUedtvPvDh24dG1GjgNqNNkAry4H7SDMIdtuDE6oFVo+oRlf
nyJI1bMf22jt7r59bmPJ5zyA4umdO4Lb5lYl5y0/nA0b+PCQBUDYVorrMUKf18/m
SwsuWZa1V9A0kLc5WklK4ccmp44zCiBef69YBJpTWBDtdu7fYpuDEexNCax98J3d
GbfcnGXBWz6Heu9S/6helhZyNmO0OJqmkkhmYin0bQcflthb7FhoEjlfce0ZXw8I
s5ygn8gj
=iYea
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
