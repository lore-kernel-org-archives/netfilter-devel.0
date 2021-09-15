Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0536AC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 15:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4E261246
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 15:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhIOPGR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:06:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56984 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhIOPGR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 11:06:17 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 41B7A60140;
        Wed, 15 Sep 2021 17:03:39 +0200 (CEST)
Date:   Wed, 15 Sep 2021 17:04:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Python bindings crash when more than one Nftables is instantiated
Message-ID: <20210915150448.GA19577@salvia>
References: <5dcf2dd4-0fdf-30d7-6588-1e571c486289@average.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <5dcf2dd4-0fdf-30d7-6588-1e571c486289@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 14, 2021 at 07:46:16PM +0200, Eugene Crosser wrote:
> Hello,
>=20
> it seems to me that this should not be happening. Use case is not as
> pathological as it may seem: your program may be using different third pa=
rty
> modules, each of them instantiate `Nftables` interface.
>=20
> $ sudo python
> [sudo] password for echerkashin:
> Python 3.9.7 (default, Sep  3 2021, 06:18:44)
> [GCC 11.2.0] on linux
> Type "help", "copyright", "credits" or "license" for more information.
> >>> from nftables import Nftables
> >>> n1=3DNftables()
> >>> n2=3DNftables()
> >>> <Ctrl-D>
> double free or corruption (top)
> Aborted
>=20
> Note that it happens on exit (possibly on the second call to __del__()).
>=20
> nftables v0.9.9

Upstream fix:

http://git.netfilter.org/nftables/commit/?id=3Db85769f9397c72ab62387ccc5b7a=
66d0c3ff5f21

Thanks for reporting.

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmFCC4sACgkQ1GSBvS7Z
kBkYIw//YKsr9dq/9z1OdUCOEJrYhf9o5C8wJc8L4+JJUg7ZW/WjZLPgtJA/368H
C7Lf+N5GiPmIPK67/zZAudUkIpuLC2gTtzdawfxbwcCwN4uJgM1C3gD6qvKo4CnL
hh3Uuf44d29IX9lQe7sDZL0DxhYo+aklm8FE4f9YTfSFdQF/BKf5YMTRUfg/SWPY
cgd85NvXNjWvEhiSIazmPfqhKsPhz5c1PWI1QfRz7ZrrBNi0ZF0yX4p9D8MgnKZz
kXmLnuwTv2+eoGmD+qXzVn2PkvKY64rPuQkfEaDSJeyjT9ShfSDnTO5vaZY2z10j
evCBD2orn497CTW2eMgVsnhEQCjSvqZoNjnYBaV/pWRLgj9ACPEu7A4uIAYTgvBK
zRF4ze/Hryn94rHb3cDtkHOxzmhYee/6uND/z07CVeEnxqYjCmprla9Wk1CRcnE0
h16JOjorplxNmBRFWl6vum3l5Mq8V9bHqudczkdt38oQikBQdpo40pDmxKim/hGf
P7grDIriEXQuQ3fOUVocED1yVL34t3O1lkvvDDabZvHhWDGirh2ICk3/5Tmx2BB6
jHhFB1mHjHqL/axySeGbm+GEmP6b8Stt30H25YLusVcwTQQmWztp/NxsPb3n05UZ
Pq53wk+CWFYufiNaokdhCmtkBeaYKf3pduOUl4ZFGiCv1MjuXvs=
=Et57
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
