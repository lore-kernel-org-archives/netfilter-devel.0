From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] build: use _DEFAULT_SOURCE for newer glibc
Date: Thu, 20 Aug 2015 06:49:49 -0400
Message-ID: <20150820104949.GD21236@vapier>
References: <1439935658-17834-1-git-send-email-vapier@gentoo.org>
 <alpine.LSU.2.20.1508190908430.11093@nerf40.vanv.qr>
 <20150819130829.GY1584@vapier>
 <alpine.LSU.2.20.1508201011460.28043@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9UV9rz0O2dU/yYYn"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:38793 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbbHTKtz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 06:49:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1508201011460.28043@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--9UV9rz0O2dU/yYYn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20 Aug 2015 10:12, Jan Engelhardt wrote:
> On Wednesday 2015-08-19 15:08, Mike Frysinger wrote:
> >On 19 Aug 2015 09:09, Jan Engelhardt wrote:
> >> On Wednesday 2015-08-19 00:07, Mike Frysinger wrote:
> >> >Since _BSD_SOURCE is deprecated with newer glibc versions, we get bui=
ld
> >> >warnings when using only that define.  Add the newer _DEFAULT_SOURCE =
to
> >> >quiet things down.
> >>=20
> >> Why do we even need _BSD_SOURCE/_ISOC99_SOURCE/_DEFAULT_SOURCE? The=20
> >> thing apparently builds without it (glibc-2.19), too.
> >
> >i would check with the guy who committed this ;)
> >
> >    build: resolve compile abort in libxt_limit on RHEL5
> >   =20
> >    libxt_limit.c: In function 'print_rate':
> >        libxt_limit.c:124: error: 'INFINITY' undeclared (first use in
> >        this function)
>=20
> Well if that is the case, have you checked that using _DEFAULT_SOURCE
> over _ISOC99_SOURCE+_BSD_SOURCE still works on RHEL5?

i know it won't because _DEFAULT_SOURCE is new to glibc-2.19
-mike

--9UV9rz0O2dU/yYYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV1bDNAAoJEEFjO5/oN/WBckoQAJBRc4dcGcJ4xn6V5DpmoNSP
iGcnqfhK19tPWXKy0WN/uh5EF4CRKBv5xUCDUU19kkPaRpKjFL4DYIr8e3TvRaV0
+EMdssnunAIX8ABvC+LJ0v8l6sOKCCnHupgVZTInPapOKvEACctv4fcjgyKlfXsU
BEok00fDlh+/FrjV9ptSdraGO/KD4ScVgp8WnXVpVpTZn4UnHGPfZKWc6geqja2n
n3Idg/AuKnIPucH/hoiccAxJb0POcXa2MZISm3b6inOvt340EXocYuRDlR4aK1Wu
kHGnOFARwhQcqZmK+/J4X1Rip8r3mV4pUYgxRIlCXAjFSJtCTyYWMPX341p3H14I
9rFK+aKS15uOChDUoLRSSXr3R5wE2am9tzk/MTHW6TiwRl04sdGdoMhRvECq5dpY
k0Smr1n5IBZxwZXBRPo38JI28eZXuFZ9hR/xgH20Pmtb0e0dDC8pkAYdqUkXvpDg
9dwm6L/0j8Ytnr2ifZSw8hdpZRdxzBQK2pR9kb3cqZ7LdK1aVYNO6nNbZ4MTW8Bc
EyESdAIsbyw+IW7iDCUQK4dEMGh1l81dzCBnVPIin85WxXZrwr5OlcT1MqWU0kYg
ycfiPouHY/cS3oEhE/iUDmvYwE3Rwvh1NuBKrTJ9sNofYUFEy80RQmBmeBbhkuQQ
Li1ieeYiFka8FOR/7sjx
=Gb2z
-----END PGP SIGNATURE-----

--9UV9rz0O2dU/yYYn--
