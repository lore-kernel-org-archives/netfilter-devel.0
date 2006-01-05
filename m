From: Heiko Schlittermann <hs@schlittermann.de>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Thu, 5 Jan 2006 10:41:36 +0100
Message-ID: <20060105094136.GX15217@schlittermann.de>
References: <20060104142750.GF15217@schlittermann.de>
	<Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
	<20060104164455.GH15217@schlittermann.de>
	<Pine.LNX.4.64.0601041750390.22709@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cqPFywB/e6uXot/h"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0601041750390.22709@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--cqPFywB/e6uXot/h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Krzysztof,

> It would also allow to extend ipt_time checks in the future.

Hm .... but then it be rewritten anyway, can't it?

> >To match --timestart 12:07 --timestop 13:10 really from 12:07:00 to=20
> >13:09:59.
>=20
> So please use --timestart 12:07 --timestop 13:09. We need ">" not ">=3D" =
to=20
> match a single minute, eg. --timestart 12:07 --timestop 12:07.

But isn't it a bit counter-intuitive?

If something happens from 7 to 10 I'd understand, that it starts at 7:00
and ends at 9:59.  Same with minutes, if some event should happen from
12:07 to 13:10 I'd understand that it happens first at 12:07:00 and last
at 13:09:59....

Or?



    Best regards from Dresden
    Viele Gr=C3=BC=C3=9Fe aus Dresden
    Heiko Schlittermann
--=20
 SCHLITTERMANN.de ---------------------------- internet & unix support -
 Heiko Schlittermann HS12-RIPE -----------------------------------------
 gnupg encrypted messages are welcome - key ID: 48D0359B ---------------
 gnupg fingerprint: 3061 CFBF 2D88 F034 E8D2  7E92 EE4E AC98 48D0 359B -

--cqPFywB/e6uXot/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDvOnQ7k6smEjQNZsRAhtyAJ4xqdD7LqCTQp6wP8DT5OgX2if4XQCgvj6g
FsQuW0J/WrY/m9oRqec9kd4=
=ycqU
-----END PGP SIGNATURE-----

--cqPFywB/e6uXot/h--
