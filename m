From: Heiko Schlittermann <hs@schlittermann.de>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 4 Jan 2006 17:44:55 +0100
Message-ID: <20060104164455.GH15217@schlittermann.de>
References: <20060104142750.GF15217@schlittermann.de>
	<Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iGVyjpQW5Zz5Bf9E"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
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


--iGVyjpQW5Zz5Bf9E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Krzysztof & *,

Krzysztof Oledzki <olenf@ans.pl> (Mi 04 Jan 2006 16:47:43 CET):
>=20
> How about this (also attached) one? Untested, but should work.
> [NETFILTER] Support for timestart > timestop in ipt_time (eg. 21:00 - 15:=
00)
>=20
> Based on a patch from Heiko Schlittermann <hs@schlittermann.de>

My "compound return" looked shorter :) but I admit, that your's is
better readable.  I don't know, which one is faster or if good gcc
optimimzes both the same way ...  (I learned to save every bit ;-)

> -	if ((packet_time < info->time_start) || (packet_time > info->time_stop))
> -		return 0;
> +	if (info->time_start < info->time_stop) {
> +		if ((packet_time < info->time_start) || (packet_time > info->time_stop=
))
> +			return 0;
> +	} else {
> +		if ((packet_time < info->time_start) && (packet_time > info->time_stop=
))
> +			return 0;
> +	}


But I'd like to see:

	if (info->time_start < info->time_stop) {
		if ((packet_time < info->time_start) || (packet_time >=3D info->time_stop=
))
			return 0;
	} else {
		if ((packet_time < info->time_start) && (packet_time >=3D info->time_stop=
))
			return 0;
	}

   =20
To match --timestart 12:07 --timestop 13:10 really from 12:07:00 to 13:09:5=
9.



    Best regards from Dresden
    Viele Gr=C3=BC=C3=9Fe aus Dresden
    Heiko Schlittermann
--=20
 SCHLITTERMANN.de ---------------------------- internet & unix support -
 Heiko Schlittermann HS12-RIPE -----------------------------------------
 gnupg encrypted messages are welcome - key ID: 48D0359B ---------------
 gnupg fingerprint: 3061 CFBF 2D88 F034 E8D2  7E92 EE4E AC98 48D0 359B -

--iGVyjpQW5Zz5Bf9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDu/uH7k6smEjQNZsRAnysAJ0VT2IAf8Hy+SokhezfAn1ZDvHAHgCeLmyx
vU5eH7DXspjqachPbTHFyo8=
=xnav
-----END PGP SIGNATURE-----

--iGVyjpQW5Zz5Bf9E--
