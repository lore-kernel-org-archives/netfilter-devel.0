Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0388C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 17:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54CFB22D6D
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 17:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="HO4/uRLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfIAREe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 13:04:34 -0400
Received: from kadath.azazel.net ([81.187.231.250]:50712 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbfIAREe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 13:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kfvSvjP085Pgn1JpZPw4x36LCTbN1BG0JON5RKf7OjA=; b=HO4/uRLHfRg5tG/zBK1eySeh8X
        QrFHtPEqA6qJ3ADmaCGJHkuCYUl9VjU7Rx+BRo0/xkvGyzgFFvBzwrZJ+dCT5yQZmH+0RVFvJLoEm
        +sYOn0o3mYOlkaQZkyNfl+TTDrvFm6CVRiDiO/w2NEkdPPgSgwhWTTcsgBiR35EqWivZ86m7mcG/n
        oVBvTrpWzRrC68V+dCI/IhUtPoxe19oCyPMiWfBsO/8u6kJBk5brPZWiyuaOVoyH1QJoXWicbLhP3
        exgHvdRx83dI1g/uMQEIqkeYD/cHlFE+4Hv4Zy9m3bAQmiBosJYC87NB8za85rEuo++O8N775WXHT
        oSYOXj9g==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4THD-00064h-TJ; Sun, 01 Sep 2019 18:04:31 +0100
Date:   Sun, 1 Sep 2019 18:04:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Franta =?utf-8?Q?Hanzl=C3=ADk?= <franta@hanzlici.cz>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons v2 1/2] xt_pknock, xt_SYSRQ: don't set
 shash_desc::flags.
Message-ID: <20190901170430.GA28258@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
 <20190812115742.21770-1-jeremy@azazel.net>
 <20190812115742.21770-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1908122317330.19510@n3.vanv.qr>
 <20190812165731.GC5190@azazel.net>
 <20190819213411.6aaabd42@franta.hanzlici.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20190819213411.6aaabd42@franta.hanzlici.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-08-19, at 21:34:11 +0200, Franta Hanzl=C3=ADk wrote:
> On Mon, 12 Aug 2019 17:57:31 +0100 Jeremy Sowden wrote:
> > On 2019-08-12, at 23:17:52 +0800, Jan Engelhardt wrote:
> > > On Monday 2019-08-12 19:57, Jeremy Sowden wrote:
> > > >shash_desc::flags was removed from the kernel in 5.1.
> > > >
> > > >Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > >---
> > > > extensions/pknock/xt_pknock.c | 1 -
> > > > extensions/xt_SYSRQ.c         | 1 -
> > > > 2 files changed, 2 deletions(-)
> > > >
> > > >diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pk=
nock.c
> > > >index c76901ac4c1a..8021ea07e1b9 100644
> > > >--- a/extensions/pknock/xt_pknock.c
> > > >+++ b/extensions/pknock/xt_pknock.c
> > > >@@ -1125,7 +1125,6 @@ static int __init xt_pknock_mt_init(void)
> > > >
> > > > 	crypto.size =3D crypto_shash_digestsize(crypto.tfm);
> > > > 	crypto.desc.tfm =3D crypto.tfm;
> > > >-	crypto.desc.flags =3D 0;
> > >
> > > But this will still be needed for 5.0 I guess, so it cannot just be
> > > unconditionally removed.
> >
> > That assignment was actually superfluous anyway, because crypto.desc is
> > zero-initialized when crypto is initialized (xt_pknock.c, ll. 110ff.):
> >
> > [...]
> >
> > Adding an initializer to the variable declaration in xt_SYSRQ.c will do
> > the same thing.
>
> Hi Jeremy, thanks for Your patches!
> Please, they are only here in mail list, or also in any repo?
> Or will be some new package release and I should wait?
>
> My xtables-addons v3.3 package list SourceForge as project home site,
> but I can't find there nothing newer than stuff from March 2019:
> https://sourceforge.net/p/xtables-addons/xtables-addons/ci/master/tree/

There are open MR's:

  https://sourceforge.net/p/xtables-addons/xtables-addons/merge-requests/12/
  https://sourceforge.net/p/xtables-addons/xtables-addons/merge-requests/13/

J.

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1r+hUACgkQ0Z7UzfnX
9sP3Lg//ROm8dgNgIwdMsqCmzluePpA9rFsrW203T0+H5d4wUZGWvu4IMTgrjmIp
u4ftcnCRLYBSakL/mUPEMXB1wSVLcZaPqgEfSKpRYKtzha4nxLj7uR8R0urvmc9v
NIZ2MBDU4sj4/qTLyZ0ScJKS/9koy4aivt56cvwKW+V78fmF7C2Dlh9kbB5ra4nc
xaRw6KY0agOatEJCedBW/j3HSo45T03vmGTcy63n08cS7Vrbj8xUdd9cQ6hHXqO+
rh8fAoAwys2nLZ3I5zsBxo7gSLQ6KPfjV6DpX8aWKtPcD6xzkv+2q1rYzB/HohRS
XsuUwdHyrZ3sL02Fun+nH4bdoI1gEgjITa0po55ikEYLDi1oqh2iRSpMkcqhirSb
5F9bxiqaMoiZ4hhHtT5apLgycVkSswP89aLtSwJB1VarpKZzwUrZnsamj1b5RWSy
MP5ImNIuofb+jeKeJHqVXdjFG19CoFz9AyUXHRRre65gbQ4e9zZqtVXfEsoeS0A6
l6OpZgT5RJ69yotdSqyfZmmnsr497AiF7n/sv0yZmP4o13B+IbDdHXIeiDwd+SA7
nypwaQbkGV1wZcCZNN0HAnMyuGoTDllXKyZ6n8LmFo8CMmQTdCkRTy60+A8ziYev
QcMTAaepDxYJpJn+LvM80gWjgw0FU/87rq6hnVdMftyC+pQJDA4=
=BhqX
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
