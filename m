From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] pptp_conntrack-nat: Fix compile errors DEBUGP() macro
	in ip_nat_proto_gre.c and ip_nat_pptp.c,
	fix typo in ip_conntrack_pptp.h
Date: Tue, 1 Mar 2005 10:56:19 +0100
Message-ID: <20050301095619.GK6825@sunbeam.de.gnumonks.org>
References: <1268323301.20050226002305@stud.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Cc: netfilter-devel@lists.netfilter.org
To: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Content-Disposition: inline
In-Reply-To: <1268323301.20050226002305@stud.tue.nl>
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


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 26, 2005 at 12:23:05AM +0100, Sander Eikelenboom wrote:
> 3 small fixes:
> - Fixed compile errors in 2.6 DEBUGP() macro of  ip_nat_proto_gre.c and i=
p_nat_pptp.c
> - Fixed typo in ip_conntrack_pptp.h

thanks, applied.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD4DBQFCJDxDXaXGVTD0i/8RAufeAJQNMFDE3FGAch0G+rVe+xVff2lGAJ4z1QHQ
iVjwrDhczWmXIy/iunH9cw==
=6y0n
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
