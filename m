Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82913C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5478A61267
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhHVQf0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhHVQf0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:35:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F180DC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8lZTgfC1Rc+auVW0on2yBLQELWKL9IsCtfvG9GFscvE=; b=mcy/lzw+vUDQT8XNq/8En4Zz7v
        5ZGuUhrSiLxA7CGUQ1dDn3IEMqWlZkA7DYBMq/eJLIu8Ae+IbdyPdUQec6/RPXIj5LP2o4IfG6aG2
        DE/YcUC/cDNOBdzoktB34vw0+GhTX8RWZcvUxwdkw6k9onztvT70a7emGVPhOmGkpIUj26SNiAiX5
        tqTCDUlp0wxfxbpp0tV+EfJs0PwYjkbR5MQAujtLtZqZxdB4DEVeWSdfMwJWjFW6JdX75ZEse6uLX
        vZhxpq1gicE5M0IIQPiM8QWpQNO85c2J3s8m9Ch38wvlgDRT/mO4bGoDffNofwQ3KIF3IA0iwq8+W
        MghTITXA==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqQl-008Pz2-03; Sun, 22 Aug 2021 17:34:43 +0100
Date:   Sun, 22 Aug 2021 17:34:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Grzegorz =?utf-8?Q?Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xtables-addons 3.18 condition - Improved network
 namespace support
Message-ID: <YSJ8ocdMzhJG1Idt@azazel.net>
References: <61659029-f22f-0036-7bda-46fe24352d30@interia.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dR2UShVSrUZ29NAS"
Content-Disposition: inline
In-Reply-To: <61659029-f22f-0036-7bda-46fe24352d30@interia.eu>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--dR2UShVSrUZ29NAS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-08-22, at 18:14:13 +0200, Grzegorz Kuczy=C5=84ski wrote:
> My intention was removed special var 'after_clear'. The main idea was
> use a list as a flag.
>
> But Jeremy has right, I used list_empty_careful() in wrong place.
> I can change this for that:
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 static void condition_mt_destr=
oy(const struct xt_mtdtor_param *par)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 const struct xt_condition_mtinfo *info =3D par->matchinf=
o;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct condition_variable *var =3D info->condvar;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct condition_net *cnet =3D get_condition_pernet(par-=
>net);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mutex_lock(&proc_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 // is called after net namespace deleted?
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (list_empty_careful(&cnet->conditions_list)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_un=
lock(&proc_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (--var->refcount =3D=3D 0) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del=
(&var->list);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 remove_p=
roc_entry(var->name, cnet->proc_net_condition);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_un=
lock(&proc_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(va=
r);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mutex_unlock(&proc_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>
> But now I realized that one var bool is less expensive than call a
> function.  So my improved is turned out the fail :) ... sorry for
> taking the time.

I think there are some improvements that can be made.  Will send
patches.

J.

--dR2UShVSrUZ29NAS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEifKEACgkQKYasCr3x
BA19NQ/9H15ACKG5fS6hC+AImkI3GPm91VrBUWIfsyFHVivpb0L89jZ0yZw9/bsg
iDxtJNZ0zXQV5YEIETwIDUu0dWVb3ypU11sdXv2ZsDwStHACYyP6v38pBaGwZnkL
+IHh4T0vS1GN+4R8OvTU54XOkvsdao6rs5ASSU4s227L/7w/BEZsVQrcPcKihrZ/
MmnuwNIghCiF9h5QpWsSnkp+t+VAPO8vr2tQEvxqbwnXh7hwRFeVXDtqxicf3cjn
eDXP8akgQ7Nk+fsB09lR8ykzPN82NcnvTJUutzMM30KtYSl3O2ar/aM6aDsbfpFm
jyeupqGoypd+qWYNkVCr4w5eldwlRAbpghZuH6qEY9FLmhvASqhm9aGLgZi03H1R
BF8mg672S4ZRc1s/EoKpfBGaWW3+b7/Go3MvKE2qYmZk8oh88M80Ow19N3jJoO89
Pn+Brfu27ANAmPb1mZ6/kItBvS3nH/dmwTrfr7sz4+lA14amFS1god3HjPgKruoP
SSMoROfJqlc1BYy4GipbsBtpo30umtticpgGGPlYJdu4NnH+UZQfbTiN69Xv9Gjb
c+gseLaSfU1pZR7aWtHomWKWMxfTmqfUcHLTl5LD/ul0YZAeMELcwxeuGBqjLS/v
viVOE3Q1XH24kgw/S1pw7P7bYicroWxOv8wsAU8Yx5GHHMLwHGY=
=N22f
-----END PGP SIGNATURE-----

--dR2UShVSrUZ29NAS--
