From: Richard Weinberger <richard@nod.at>
Subject: Re: xt_target checkentry()/destroy() semantics
Date: Wed, 11 Jan 2012 10:52:36 +0100
Message-ID: <4F0D5BE4.3040509@nod.at>
References: <4F0CE6C0.6080900@nod.at> <alpine.LNX.2.01.1201110741110.27346@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig89E7F84E4008BF92353A79E9"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735Ab2AKJwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:52:43 -0500
In-Reply-To: <alpine.LNX.2.01.1201110741110.27346@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig89E7F84E4008BF92353A79E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 11.01.2012 07:45, schrieb Jan Engelhardt:
> On Wednesday 2012-01-11 02:32, Richard Weinberger wrote:
>=20
>> Hi!
>>
>> I always thought that checkentry()/destroy() are being called upon rul=
e insertion/deletion.
>> So I assumed that this command sequence prints three times "test_tg_ch=
eck" and then three times
>> "test_tg_destroy". But it's not the case.
>=20
> One table-replace operation implies add-delete of all rules.

Okay, I did not know that my simple command sequence is causing a table-r=
eplacement.
Why?

I thought it appends (-A) only...

Thanks,
//richard


--------------enig89E7F84E4008BF92353A79E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPDVvoAAoJEN9758yqZn9e2mQIANOgb9Xo4T/oKZBRnGWW2nNC
IfTwZSWzpMXZ7Qj2/6/sSXYwrV2ZUVMj2G0YYB6kj3nI17hO4McEBAIr+zmgVciB
NWjl3qNiL62vY3T+QZJ4+PRI7owBWAo48WTSiGeEAOYlPyLpI/F9Lf02runqx63m
vmsOZpXhKL7IRnZ+Xl58FuX0oKJhl0strVgmY5ClBdhNt12QoEgd0I2CeBgouCLD
4Prf0SuMNXjfKcrKlUlq1GqVZGQAsb+bFgYpMVjRoNZmnZv16ofsuRMI7I9UKAHT
bGxJB040A6tvaxjMLdOKxMUOo+fALIV+3TkyNRXeJEYAt71xhtpFOzUBKd5Oemg=
=RTAw
-----END PGP SIGNATURE-----

--------------enig89E7F84E4008BF92353A79E9--
