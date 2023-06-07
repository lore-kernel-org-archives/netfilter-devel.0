Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88129C7EE23
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jun 2023 17:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjFGRcW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjFGRcU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 13:32:20 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357FE1FE2
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2023 10:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o6Z5aAfxf2Y14W4mg2YwAjTdy5Q3ZR5JDDUAFG0O48Y=; b=lO4XRJzxCDHpN47f34Lfh/U3zt
        beK5Lu3YSJe4gIwv7sFYPdfs81w39ioQChGdIBWS0w/uLygzi127ZCyCi9Z3QanMIiyZ8inYOC3ZO
        QX4boPbmEOsDmle42rITNds3Wjr/FtFJMHLgzchSjry28mtEirByA+q9CwMQs7wl8W8OePy3qR6J+
        46QPp8NWish3y/FKdSEA7jjNCMWDU/081EQI/svMm4BR+Dfq69vTDJ80+r4n76Osz84veenGqVful
        2smQ7DnUpJSRb1p+VSPu/6/j2OezQV9ocO1bBjMiV4xES6VMVR2oFxfNAlG7y8nPwEbW2DTE+dU89
        HN/vTkbA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6x0r-001T9H-0m; Wed, 07 Jun 2023 18:32:01 +0100
Date:   Wed, 7 Jun 2023 18:31:59 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     ValdikSS <iam@valdikss.org.ru>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: String matcher "algo bm" broken in OUTPUT since 5.3.x
Message-ID: <20230607173159.GI187342@celephais.dreamlands>
References: <aec130b2-acaf-83f2-2729-fd48dcb0a698@valdikss.org.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="R1bsX10XZWiSvuti"
Content-Disposition: inline
In-Reply-To: <aec130b2-acaf-83f2-2729-fd48dcb0a698@valdikss.org.ru>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--R1bsX10XZWiSvuti
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-05-31, at 11:05:14 +0300, ValdikSS wrote:
> Since at least kernel 5.3.x (2019) and up to current 6.2.15, iptables -m
> string --algo bm does not work when added to the OUTPUT chain.
>
> Quick reproducer (algo bm, does not work properly):
> > # iptables -I OUTPUT -p tcp -m string --algo bm --string 'GET /' -j DROP
> > $ curl -s example.com | head -n3
> >=20
> >   ^^^^ curl executes successfully
>=20
> This works (algo kmp, works properly):
> > # iptables -I OUTPUT -p tcp -m string --algo kmp --string 'GET /' -j DR=
OP
> > $ curl -s example.com | head -n
> >=20
> >   ^^^^ curl does not execute successfully

I've reproduced this.  I'll have a crack at fixing it.

> See:
> https://bugzilla.netfilter.org/show_bug.cgi?id=3D1390

J.



--R1bsX10XZWiSvuti
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmSAvwcACgkQKYasCr3x
BA1f2Q/+Mk3QuQ4Y7lcE6TymRiXSi2i4UmlAtK02tRAZra6D2bc7ta5LDH1SJPxA
/bUQ9u+kSUOjNe7N7Lbd4J7GnPk2cmmnAiMWUXmSuMpHT832u/TqXbLtxJpDQ9pX
EJGY6oZPRW6C4KpWf8Bdxn33/ncwUkDLUG9QbffY5XgFJvjgEWTJdTUXui6M95GZ
L9zBsu0ELlIVKMLMLrh/AYXPZPyMRYZGkdHLeFDO032fk0d9h887IARW9RhrZRKP
Mwoq1mvbno+SSvhk8uN7OZjDsUJY7e7nzh3+aXwnb3mNdRbDLANrHvZeH0kf1gIg
PU0iWjuE6/fS+Wy4t/Jk+i4s5FvcvoxiEEdyl9FzENilcL7WwSYI8wgrJu4kMZVr
cNVfj1rcUQfz0kLuEcPn2YxUddT7F8PMgzDwu1GiP9ceX/INXa0t/zxwzFdE0f48
8Mt/z8Y1p4pScBKenswDv3+CFv5uJGmB2W0W2s9FSCLZt67jCJa+XHZrTEmgbUAH
PqistgrCzFtCyqZTHPwDPK+NbOc9gbhtnrMTbDp2Q+uuNHtfD3ZqYyqp8xtIKUXb
RTDjJ14X4FU5wOKgpyvAxHxyPNVsGJSxxvMy2ihj9gCcM5mVCn8Z3FSlduFpOFCT
YC2WEwuVDmXD/joceyORR8U+YjCLxKCAwg/Dtkhkm7u+7aUQ1TU=
=kjY4
-----END PGP SIGNATURE-----

--R1bsX10XZWiSvuti--
