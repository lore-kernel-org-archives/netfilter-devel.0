Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79E8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 09:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiDIJkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbiDIJkZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 05:40:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C091D7619
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 02:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rJNH2zwr4Y/bjqnQ/7ajdFt/89sWLopf464IBJT+Lsk=; b=MfEjrHLRSGPcUlnW/ahPrphLB6
        1OXpSTFElw43AdwhP154dFaJ/+TqEhd5U+9V+TlM1Z6ypYCjfXg4pX5IRG2ArHciDVK6wJl9VQA97
        W4qwsJQdJDbpLjbzJUNGlKva2MxsedMlAgeREq1Mw9SE8/iti/bsNs8EQIqER3gcYB6dhpVAOuBKi
        7zxzyhcMNXcYrk4sL2zc7WdweM/xL+GajTX5esNut/6r5NtPPcbSoDKQU3bi9rxhKArWOiipI0gUm
        67QxTfNri3k8cD4KxTEa6gq1O10/11DZCXqsWHWqnV6fhjcqrpoXKoPdt96rGvACKEvIdvT/Es4xi
        pJ9mH0qw==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nd7Xq-00CHVj-IP; Sat, 09 Apr 2022 10:38:14 +0100
Date:   Sat, 9 Apr 2022 10:38:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next PATCH v2 1/5] netfilter: bitwise: keep track of
 bit-length of expressions
Message-ID: <YlFUBZg+983PofgH@azazel.net>
References: <20220404120417.188410-1-jeremy@azazel.net>
 <20220404120417.188410-2-jeremy@azazel.net>
 <20220408232703.GG7920@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eQTgEAeSRJ+rOWCT"
Content-Disposition: inline
In-Reply-To: <20220408232703.GG7920@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--eQTgEAeSRJ+rOWCT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-04-09, at 01:27:03 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> > index f590ee1c8a1b..cdace40c6ba0 100644
> > --- a/net/netfilter/nft_bitwise.c
> > +++ b/net/netfilter/nft_bitwise.c
> > @@ -23,6 +23,7 @@ struct nft_bitwise {
> >  	struct nft_data		mask;
> >  	struct nft_data		xor;
> >  	struct nft_data		data;
> > +	u8                      nbits;
> >  };
> > =20
> >  static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
> > @@ -88,6 +89,7 @@ static const struct nla_policy nft_bitwise_policy[NFT=
A_BITWISE_MAX + 1] =3D {
> >  	[NFTA_BITWISE_XOR]	=3D { .type =3D NLA_NESTED },
> >  	[NFTA_BITWISE_OP]	=3D { .type =3D NLA_U32 },
> >  	[NFTA_BITWISE_DATA]	=3D { .type =3D NLA_NESTED },
> > +	[NFTA_BITWISE_NBITS]	=3D { .type =3D NLA_U32 },
>=20
> NLA_U8?
>=20
> Atm values > 255 are accepted but silently truncated to u8.

Good point.  I imagine I copied and pasted the types from `len`, which
also has `NLA_U32` and `u8`.  It, however, is parsed correctly:

  err =3D nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
  if (err < 0)
    return err;

Since `len` is `u8`, `nbits` will need to be `u16`.  My inclination is
to leave the netlink type as NLA_U32 and parse it as follows:

  err =3D nft_parse_u32_check(tb[NFTA_BITWISE_NBITS], U8_MAX * BITS_PER_BYT=
E,
                            &nbits);
  if (err < 0)
    return err;

J.

--eQTgEAeSRJ+rOWCT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmJRU/wACgkQKYasCr3x
BA0HiBAAt8GKK3XcGDNqiG5BcK+UH/QEbWvmihMIpGxhBU5Nlay4G90ONH1XfSZx
AvPyQQuNIxQHdJF7eHxPnSqt/WCdnpoIOptQhzHY1rKveh08vUZLTgOS1wqEjVpb
YVlwcrB6RpZ0UYonlJAmu2Dzpit3K5YFoODO3xzJw7ToZTgQhePJWLk1T/Garr6A
04X1t3EkQYBlJz6vtMtnomvGjc99G0y7xV0N9uTYq6Uny49riDcjUUGeqebDBe6e
OnR/MdDOl0Sf2FRrnp5ZRrAorNkX03Wq7JT/gY8WPc+MNcQtAZkA8yUtRaeYIO7Z
VHDoRBgY6L+1zG9xTiGsl4VUCKeUm7JV3TDOQ6ZtkojUNQE5QDr/HSMmK8skjZ66
E4+xupVppVNctgNd0NR8o+gka92ADj1Uxfljp7x5JbmOkiUHHWtmqAsnXajEOsNq
6YhRMuh7957Ky6Jqh1OjRtuN64AFEQ1XTKlLDZVm32R+18rcPhMTwjiZnttTQGv9
jNuQH7ntKkeWvgZwhgQnkXYKXPnfCN0BmtAIs5t7u/BATcupjSYmUw2sBlVylZag
b+zWhkGDWiqpDaE9+4EDqLLGpHkV8ZGTQ+n3skutdVsSLUGqatmHJWobt2wuhv+n
kJNEEBJE+tzhjyrSbmWW387ZOwywSlgqSlSE1jNL9ufT6WSU+pA=
=XeZi
-----END PGP SIGNATURE-----

--eQTgEAeSRJ+rOWCT--
