Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D6ECD6E55
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 09:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjJKJqU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 05:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjJKJqT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 05:46:19 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDEB92
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 02:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lP+QU9yJCVnYr+pSRT7yKZBdblfdyAER5z/qI3xcRQ0=; b=HjFwSUWTs6QdT1nut4RQyX7Gfd
        mt+pkcB1DtcPrODtTxMLoY3lfCZBDbIAjSij8+JxAOeCVAyrgNtk1uVur/JxIbP81Hm+azE4QVcvD
        6ZMTnrQz2PEABMgIzzBVL+gUfeNwOBGIw56QqkrhvtIG6JJKXkxQggFAxUgYYd3vmUzAMtsF91WXE
        CYi7Kmif5IlfT6Qp3VBRHOzNl8lUf9fk++lE2wpI/8IgK+Fbyq/WKuzU3T8V2D20AD9OK5RBHqwtD
        pRfTrFU91hwLMskstPcZciKpnLpefinCCVyBwnf9RoJbNWi0uFTC++WvTscSX7ZEwLNtugJmURnfD
        lXfyfPgA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qqVnC-002soN-0e;
        Wed, 11 Oct 2023 10:46:14 +0100
Date:   Wed, 11 Oct 2023 10:46:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <20231011094613.GB1438255@celephais.dreamlands>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSPltyxV10hYvsr+@calendula>
 <ZSUPsdpvPNDOl8TY@calendula>
 <20231010200838.GA1438255@celephais.dreamlands>
 <ZSXOXM0kmZay+HcB@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e1N3AyohCBpJS+wO"
Content-Disposition: inline
In-Reply-To: <ZSXOXM0kmZay+HcB@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--e1N3AyohCBpJS+wO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-10-11, at 00:21:16 +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 10, 2023 at 09:08:38PM +0100, Jeremy Sowden wrote:
> > On 2023-10-10, at 10:54:51 +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Oct 09, 2023 at 01:36:29PM +0200, Pablo Neira Ayuso wrote:
> > > > This is a small batch offering fixes for nftables 0.9.8. It only
> > > > includes the fixes for the implicit chain regression in recent
> > > > kernels.
> > > >=20
> > > > This is a few dependency patches that are missing in 0.9.8 are
> > > > required:
> > > >=20
> > > >         3542e49cf539 ("evaluate: init cmd pointer for new on-stack =
context")
> > > >         a3ac2527724d ("src: split chain list in table")
> > > >         4e718641397c ("cache: rename chain_htable to cache_chain_ht=
")
> > > >=20
> > > > a3ac2527724d is fixing an issue with the cache that is required by =
the
> > > > fixes. Then, the backport fixes for the implicit chain regression w=
ith
> > > > Linux -stable:
> > > >=20
> > > >         3975430b12d9 ("src: expand table command before evaluation")
> > > >         27c753e4a8d4 ("rule: expand standalone chain that contains =
rules")
> > > >         784597a4ed63 ("rule: add helper function to expand chain ru=
les into commands")
> > > >=20
> > > > I tested with tests/shell at the time of the nftables 0.9.8 release
> > > > (*I did not use git HEAD tests/shell as I did for 1.0.6*).
> > > >=20
> > > > I have kept back the backport of this patch intentionally:
> > > >=20
> > > >         56c90a2dd2eb ("evaluate: expand sets and maps before evalua=
tion")
> > > >=20
> > > > this depends on the new src/interval.c code, in 0.9.8 overlap and
> > > > automerge come a later stage and cache is not updated incrementally,
> > > > I tried the tests coming in this patch and it works fine.
> > > >=20
> > > > I did run a few more tests with rulesets that I have been collecting
> > > > from people that occasionally send them to me for my personal rules=
et
> > > > repo.
> > > >=20
> > > > I: results: [OK] 266 [FAILED] 0 [TOTAL] 266
> > > >=20
> > > > This has been tested with latest Linux kernel 5.10 -stable.
> > >=20
> > > Amendment:
> > >=20
> > > I: results: [OK] 264 [FAILED] 2 [TOTAL] 266
> > >=20
> > > But this is because stateful expression in sets are not available in =
5.10.
> > >=20
> > > W: [FAILED]     ././testcases/sets/0059set_update_multistmt_0
> > > W: [FAILED]     ././testcases/sets/0060set_multistmt_0
> > >
> > > and tests/shell in 0.9.8 has not feature detection support.
> >=20
> > This is very helpful.  Thanks.
> >=20
> > My immediate interest is getting the implicit chain regression fixes
> > into Debian 11, so for that I'm going to cherry-pick:
> >=20
> >   4e718641397c ("cache: rename chain_htable to cache_chain_ht")
> >   a3ac2527724d ("src: split chain list in table")
> >   784597a4ed63 ("rule: add helper function to expand chain rules into c=
ommands")
> >   27c753e4a8d4 ("rule: expand standalone chain that contains rules")
> >   3975430b12d9 ("src: expand table command before evaluation")
>=20
> This is also needed:
>=20
>     3542e49cf539 ("evaluate: init cmd pointer for new on-stack context")
>=20
> otherwise the test with implicit chain in 0.9.8 crashes, it is a
> dependency patch.

Thanks.

J.

--e1N3AyohCBpJS+wO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmUmbt4ACgkQKYasCr3x
BA2I8g//UYyN+gx0DZcIS8sVIMXZFv3XWyUa638imWaHhrRIc7Cs4GZuAQ/p+xK4
HSjFRjlD7+jaMlCn+H7Sn26jPRCVLBHHGBKTs+6+GcZVG7lkxZlKG6huUzqLk0po
q/6qNnJ9RVPKnRxAO13dv67RqqWqEbSplHohzGsI67i0/GwtvEVGAFDQZzdjuFhZ
pGMgGUPQ80vGjTZKMEofKm5eRIRNSb/a85ssBkkBZPjLMYB+w233dB4BBK/YF2oQ
gC4xiu0rcmS/BMnjktmncsbhQT8bBwtZXMvTbjgcLX0cPi7CHuZzEpZZg7HyBHBW
HANgGusGuxZ3DOZzGHwTy4ZINN6osyqdbG34J+q3PRs7fui7TAJ8163+ik58iMMd
v0pkj+fFA/CsFj/Ea7wNX4oz8ctxlU24me2E4oqxvNGpQ42k5L4z4+/n53SSvWpw
h4G5pNwrNm7Ynb5BfaNj9duJ1ivtGtmPoSLC2KHT29/BmgB2eIQVTcVTDJA0szcF
fIP+nMUfn2cE/4t1eOQfbSeFnW6lBoJvDGddg0IdvHdihs3G66VRmM3YIRYNsJdj
qduHDaEypzviz/Gl2jio1BlecktQm7/+jEIJV3YXH0s9Ww7urSRQmrdmVwq7nEUD
4rrJM5W8Dy9sscWhZdrRO164keaWhXvHh2gKrE+7theEhtgUm08=
=BA2E
-----END PGP SIGNATURE-----

--e1N3AyohCBpJS+wO--
