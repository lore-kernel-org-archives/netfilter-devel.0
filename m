From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] New full-mac match code - how to send to core team ?
Date: Sun, 29 Feb 2004 22:13:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229211316.GR15558@sunbeam.de.gnumonks.org>
References: <4038A7DB.9040703@mail.telepac.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cxfMsoqvp1jUizWj"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jorge Miguel Ferreira <jorgemiguelferreira@mail.telepac.pt>
Content-Disposition: inline
In-Reply-To: <4038A7DB.9040703@mail.telepac.pt>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cxfMsoqvp1jUizWj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 22, 2004 at 01:00:11PM +0000, Jorge Miguel Ferreira wrote:
> I have one new match ( fullmac ) rule that i have to make because the need
> to match clients that are behind a wireless AP ( formely ap918bk=20
> micronet ) -
> And the simpler rule -m mac doesn't go to compare the real mac address=20
> because
> the AP copy the PC-mac to dest-mac and AP insterts it own mac to the=20
> src-mac.
> So i make this code ( based on the original rule , but adapted to=20
> compare the full-mac ).
>=20
> How to send this new reliq to coreteam to make it possible at=20
> kernel+iptables ?

Please send us=20

a) libipt_fullmac.c
b) ipt_fullmac.c

and a patch (diff -u) for anything else you might have changed in either
the kernel or the iptables source tree.=20

Please send your email to netfilter-devel@lists.netfilter.org

> I have it working here, and tested ok.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cxfMsoqvp1jUizWj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAQlXsXaXGVTD0i/8RAqI/AKCARvE3Xh2K3+xzEMTe6E46eS6YlwCfZX0L
k2r1hT9L4GYeEZUzCB0T6r4=
=HxFO
-----END PGP SIGNATURE-----

--cxfMsoqvp1jUizWj--
