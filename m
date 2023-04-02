Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71211C7619A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Apr 2023 18:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjDBSYD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Apr 2023 14:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDBSYC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2023 14:24:02 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC3C527F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Apr 2023 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MKo/Chimmi9h3F4YC5EJcnjvwgWo1XG+fgjBS+04bGA=; b=UGgzg4fMfNiZWrz+VOzyItOGH1
        SucfMsPa4ewZW6CxELoZsMUNp1nqzJk+3+UaYzndTLC8bK5a4HisfqH/+2uFZG9Eol5rKCQPRbdi+
        r24ZQ72+yuiZuxd9gR9+X9wcuFlJjBiiiyKhEUqPOpZElIkFMVvYTpWCapo7ttnYHVcU2rwu3Jdor
        q3Usm1z+Oe7C9/8l+bdsX5EfEPJKilj7EXtAvUl5JRbjByKnKR2dGskQPFbCYNUPd5cDNDlEEaPst
        VvEzOrhoScrIjBgGSYgWPFoDXA7yiUSVZShCiBanAgpohNCLYhERx1VkBlHbHahuILRVvJBiB+KBE
        ZIJW/qIg==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pj2Mv-00Fftr-J4; Sun, 02 Apr 2023 19:23:57 +0100
Date:   Sun, 2 Apr 2023 19:23:56 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] build: use pkg-config for libpcap
Message-ID: <20230402182356.GE730228@celephais.dreamlands>
References: <20230331223601.315215-1-hi@alyssa.is>
 <20230401114304.GB730228@celephais.dreamlands>
 <20230401192545.7bbscvjfvak3zc74@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5RM55OQoS5p5b+4z"
Content-Disposition: inline
In-Reply-To: <20230401192545.7bbscvjfvak3zc74@x220>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--5RM55OQoS5p5b+4z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-04-01, at 19:25:45 +0000, Alyssa Ross wrote:
> On Sat, Apr 01, 2023 at 12:43:04PM +0100, Jeremy Sowden wrote:
> > On 2023-03-31, at 22:36:01 +0000, Alyssa Ross wrote:
> > > If building statically, with libpcap built with libnl support, linking
> > > will fail, as the compiler won't be able to find the libnl symbols
> > > since static libraries don't contain dependency information.  To fix
> > > this, use pkg-config to find the flags for linking libpcap, since the
> > > pkg-config files contain the neccesary dependency information.
> >                                ^^^^^^^^^
> > "necessary"
> >
> > > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> >
> > LGTM.  The only thing I would say is that pkg-config support was added
> > to libpcap comparatively recently (2018).  When I made similar changes
> > to ulogd2 last year, I added a fall-back to pcap-config:
> >
> >   https://git.netfilter.org/ulogd2/commit/?id=3Dbe4df8f66eb843dc19c7d1f=
ed7c33fd7a40c2e21
>=20
> That's quite a lot of extra code.  Is it likely that people will want
> to build a version of iptables that is five years newer than their
> libpcap?

Not sure I'd call it a lot of code, but I agree that there probably
aren't very many users who would benefit.

J.

--5RM55OQoS5p5b+4z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQpyCgACgkQKYasCr3x
BA2E9hAAtGPjKo9QUHHKra/7+BV5BYA6pPCBS1EuEqfJ+zlNQPF6KNCldzGEw4+g
XOGiHOTO258tH4eCIOIFXQFcWLvVh3YOSTGycOmxCiZb52fY5MNc2OeTKIpJh+Mi
dkyyoAF9yd3aD7fRexfDvS7K1c2Z55MZU6RujSz3nYy7D5yrFjWooI0Z7XKDQn07
ZFfQ3Srn4mBy+kDS/YPuaDDKawx8T82XlCfcD94QQHLppVkoJCTamXZL2bw0WUOK
fw87xkOdHDdFmmI2S94Cd+urNV8pFd14yPyjVasBKyZELvCEgfgGXGC2LOjOyux/
elk5/DIf32Xuvcs80B1ejQ9Cg39qo1Sxpn53jYZTPqhX5kxWGt7CMWdI7KDn8Z6d
f83ZUvybkdzM/lJ5XUFZ0dSKoTQKbIiuDgMRrsWan2p+hQ0NP3W6KVE+vbT9ARUG
mAGCW8KMVTZF/jPny7o7qMMZULuM5gkog2XSz9shZ2xqTrf8X0Mxh71oDpCJ8z6j
3YoZx+yaHsPFRWvW6bzhMdfGPcAT3ZjPhSREMhftu1KGfLsEw5ExHS32SrE1GMBz
aptJubTZAouDd66T0yEQetSiecJ6ko9mrgY2slN9077sLLcCL4BzpWxBWePz8gza
3ioF0MlPLZIJ5UdwSgj6h6lS9NNM9PkAxgtsXypJVUiDVkmUHUo=
=BvqV
-----END PGP SIGNATURE-----

--5RM55OQoS5p5b+4z--
