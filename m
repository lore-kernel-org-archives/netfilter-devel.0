Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D32C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 16:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B0E20684
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 16:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="K5AIjiol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfHLQ5e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:57:34 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46442 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfHLQ5e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 12:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KOaIcwMI9vEcwXjgyBqoY01/xJQfvf98z4bfMSISCIM=; b=K5AIjiol61DELUyyghYpxNlr0Z
        05UXK9emSe3gvEDEi/AU7QTJUuwj7LJnHMFQ36AKO9tYncZ81DEiYqVmpypxTH5xq8Dd1007JZSUm
        lqwxltXRLgUp3pYuIKaiDT+Kfcqa+HeROwHsi9LSltauIg3gdRfW4MBSG3RYDbtwqNeHuwmjn1IxB
        r4s024MtE9nJVPQcyA8RQIdLIl/1158lAhnOsHSxUvCvVmpSTnip+FOVuwmzm9EbaWbb+g7cn+Xqg
        XMuXzUNlF0Lh5DQuqIFhPQHhpznk3QhvMzFg9T6pLhFkvhu5V9B31lpk07sjr6qhtcRYwgbx96EQk
        rcUcFiaQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hxDdV-0000nH-0Y; Mon, 12 Aug 2019 17:57:33 +0100
Date:   Mon, 12 Aug 2019 17:57:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Franta =?utf-8?Q?Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: Re: [PATCH xtables-addons v2 1/2] xt_pknock, xt_SYSRQ: don't set
 shash_desc::flags.
Message-ID: <20190812165731.GC5190@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
 <20190812115742.21770-1-jeremy@azazel.net>
 <20190812115742.21770-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1908122317330.19510@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1908122317330.19510@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: multipart/mixed; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-12, at 23:17:52 +0800, Jan Engelhardt wrote:
> On Monday 2019-08-12 19:57, Jeremy Sowden wrote:
> >shash_desc::flags was removed from the kernel in 5.1.
> >
> >Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> >---
> > extensions/pknock/xt_pknock.c | 1 -
> > extensions/xt_SYSRQ.c         | 1 -
> > 2 files changed, 2 deletions(-)
> >
> >diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
> >index c76901ac4c1a..8021ea07e1b9 100644
> >--- a/extensions/pknock/xt_pknock.c
> >+++ b/extensions/pknock/xt_pknock.c
> >@@ -1125,7 +1125,6 @@ static int __init xt_pknock_mt_init(void)
> >
> > 	crypto.size = crypto_shash_digestsize(crypto.tfm);
> > 	crypto.desc.tfm = crypto.tfm;
> >-	crypto.desc.flags = 0;
>
> But this will still be needed for 5.0 I guess, so it cannot just be
> unconditionally removed.

That assignment was actually superfluous anyway, because crypto.desc is
zero-initialized when crypto is initialized (xt_pknock.c, ll. 110ff.):

  static struct {
          const char *algo;
          struct crypto_shash *tfm;
          unsigned int size;
          struct shash_desc desc;
  } crypto = {
          .algo	= "hmac(sha256)",
          .tfm	= NULL,
          .size	= 0
  };

In fact the explicit zero-initialization of .tfm and .size is also
superfluous and can be removed:

  static struct {
          const char *algo;
          struct crypto_shash *tfm;
          unsigned int size;
          struct shash_desc desc;
  } crypto = {
          .algo	= "hmac(sha256)",
  };

Adding an initializer to the variable declaration in xt_SYSRQ.c will do
the same thing.  Patch attached.

J.

--0vzXIDBeUiKkjNJl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-xt_pknock-xt_SYSRQ-don-t-set-shash_desc-flags.patch"
Content-Transfer-Encoding: quoted-printable

=46rom ea440005076686ba946da433049d4e68c4672984 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 11 Aug 2019 14:08:42 +0100
Subject: [PATCH] xt_pknock, xt_SYSRQ: don't set shash_desc::flags.

shash_desc::flags was removed from the kernel in 5.1, so removed the
explicit assignment of zero to it.

In the case of xt_pknock.c, the change is backwards-compatible because
the shash_desc was already zero-initialized when the enclosing crypto
struct was initialized.  In the case of xt_SYSRQ.c, we add an
initializer for the shash_desc which will ensure that all members which
are not explicitly initialized will be initialized to zero, including
=2Eflags in the case of older kernels.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/xt_pknock.c | 1 -
 extensions/xt_SYSRQ.c         | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index c76901ac4c1a..8021ea07e1b9 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -1125,7 +1125,6 @@ static int __init xt_pknock_mt_init(void)
=20
 	crypto.size =3D crypto_shash_digestsize(crypto.tfm);
 	crypto.desc.tfm =3D crypto.tfm;
-	crypto.desc.flags =3D 0;
=20
 	pde =3D proc_mkdir("xt_pknock", init_net.proc_net);
 	if (pde =3D=3D NULL) {
diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index c386c7e2db5d..f04bd2cdc0f2 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -74,7 +74,7 @@ static unsigned int sysrq_tg(const void *pdata, uint16_t =
len)
 {
 	const char *data =3D pdata;
 	int i, n;
-	struct shash_desc desc;
+	struct shash_desc desc =3D { .tfm =3D sysrq_tfm };
 	int ret;
 	long new_seqno =3D 0;
=20
@@ -113,8 +113,6 @@ static unsigned int sysrq_tg(const void *pdata, uint16_=
t len)
 		return NF_DROP;
 	}
=20
-	desc.tfm   =3D sysrq_tfm;
-	desc.flags =3D 0;
 	ret =3D crypto_shash_init(&desc);
 	if (ret !=3D 0)
 		goto hash_fail;
--=20
2.20.1


--0vzXIDBeUiKkjNJl--

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1RmnsACgkQ0Z7UzfnX
9sM+4Q//Sh6FV4awBbZdqVpKbr3mKO7daQzxEUNhuVvlAITncptt7usl20tsDNht
4eJzJLCUwW6+U57Z9Mgz0jLjvAPkqpsaLEIPfeJ5SosbnQDYTC1GT0MQBLRWferw
GL4tTYYrUio+QQm64eh/L6Uark6FqHJdTd3edd2QOIJ95vLrAd1FyirVMelSlZJK
4Z8XLUCdbLpk+DV3cgkyDs4FomEbxtjhnfOpqbiNrMHxt6qpojnWMaF3v0YRM7mi
s4FZDmA4RgdRuL5VLg7tntMt6LlMBvK+lHXENTtXh4Ldqov1Oe5yXPy97s01isPa
ea2NHC7QwlbfgYgnIdCs8jJUj1Cr1Y9MbE7fmSKmCDzkjF19li76EneIK/tLGXaf
vLxh7jXzAMGjLiM15A3N98TbfBlo5DzcIUQ/DhDr56BruU9aYsfrMtsYKKfRgBlS
jngDqu3WaMRkon3HUzTwlnSjZokexf57j4fchav4EpdGZm70GjT/NY3fb8tGVj6t
NX9EqZqu9FYFINtlfnDXLjLFB4phGLLG+L9F6D6M+jF07DVndi2qkzRqop/LjTKZ
8Mo8NO649/QUklrtH9Yr2sIr9z7JWYaWIvTu1M8eKpEcyQ7wEn0vxLjDTIiIT2aB
hT/ristPs5bE6C4QrQ5rEIC6IrU0CH3dzvnv/jhnTOiUfLBHUyY=
=hLVK
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
