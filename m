From: Eric Leblond <eric@regit.org>
Subject: Re: ulog: ulogd.conf.5 man page
Date: Sat, 08 Jun 2013 12:37:02 +0200
Message-ID: <1370687822.5642.8.camel@ice-age.regit.org>
References: <51AA46ED.5060208@bootc.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JIKdR1E7wCvpDJb14oPX"
Cc: netfilter-devel@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53141 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3FHKhI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:37:08 -0400
In-Reply-To: <51AA46ED.5060208@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-JIKdR1E7wCvpDJb14oPX
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Sorry for the late answer.

Le samedi 01 juin 2013 =E0 20:09 +0100, Chris Boot a =E9crit :
> Hi,
>=20
> As part of my work in packaging ulogd 2.x for Debian, I'd like to write
> a man page for the ulogd.conf configuration file. I started out writing
> this a few days ago and I have progressed quite well:
>=20
> https://github.com/bootc/ulogd2/blob/add-ulogd.conf.5-wip/ulogd.conf.5
>=20
> I'm send this email because as I write, I realise I'm either repeating
> or replacing (by augmentation) quite a bit of the content in the
> ulogd.sgml file.

It seems this is the case indeed.

>  Before I sink quite a few more hours into fleshing out
> the file, I wanted to check whether I'm going in the right direction and
> whether/how I need to change what I'm doing to have the work accepted
> upstream.
>=20
> I think a man page will be very useful to have - I often find myself
> reaching for them - I just want to know if I'm going about it from
> completely the wrong angle.

I agree that a man page for configuration can be useful but it should be
made from the ulogd.sgml file as there is tool similar to docbook2man
which should be able to do the transformation.

BR,

--=-JIKdR1E7wCvpDJb14oPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRswlOnxA7CdMWjzIRArXWAJsG4ti7Z6BAyoNJtjKsiKClfMjYngCffMul
ZIs7jHjiAeFZuP8L1wAYE0k=
=pxSJ
-----END PGP SIGNATURE-----

--=-JIKdR1E7wCvpDJb14oPX--

