From: Eric Leblond <eric@inl.fr>
Subject: Re: misc ulogd2 fixes
Date: Thu, 17 Sep 2009 21:40:32 +0200
Message-ID: <1253216432.21074.4.camel@ice-age>
References: <1253215700-15032-1-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0RUtfDzEtynen7wvf4Jo"
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34733 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbZIQTks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:40:48 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id CAE49940167
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 21:40:47 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id EE65394018A
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 21:40:44 +0200 (CEST)
In-Reply-To: <1253215700-15032-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-0RUtfDzEtynen7wvf4Jo
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 17 septembre 2009 =E0 21:28 +0200, Pierre Chifflier a =E9crit :
> Hi,
>=20
> These patches fix two problems in ulogd:
> - the debian directory in ulogd sources is outdated, and useless (it has
>   errors and is not maintained). It's easy to maintain it outside the
>   sources anyway

And as you are one of the debian maintainner of ulogd, I trust you on
this.

> - some views in the flat SQL schema are wrong, they use ip_protocol
>   instead of oob_family

Both patches have been applied to the tree.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-0RUtfDzEtynen7wvf4Jo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKspCtnxA7CdMWjzIRAh4xAJ4/vY9B/L5t54c5F8XKDCfB7IPlNwCdG7qs
LFd4JNp+3L8Agb4/iOC+MZo=
=tiFT
-----END PGP SIGNATURE-----

--=-0RUtfDzEtynen7wvf4Jo--

