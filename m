From: Harald Welte <laforge@netfilter.org>
Subject: Re: About connbytes
Date: Thu, 18 Nov 2004 23:49:38 +0100
Message-ID: <20041118224938.GE6790@sunbeam.de.gnumonks.org>
References: <419052E5.4080609@koba.com.ar>
	<20041109090422.GQ22257@sunbeam.de.gnumonks.org>
	<f663f63604111813174cc28048@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Cc: "koba@koba.com.ar" <koba@koba.com.ar>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mike Carlton <mikecarlton@gmail.com>
Content-Disposition: inline
In-Reply-To: <f663f63604111813174cc28048@mail.gmail.com>
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


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 18, 2004 at 01:17:15PM -0800, Mike Carlton wrote:
> I have the same problem with an outdated libopt_connbytes.c
>=20
> The latest snapshot
> ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-1.3.0-20041114.tar=
=2Ebz2
> as well as the most recent browsable version I can find
> http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/extensions/li=
bipt_connbytes.c?rev=3D3071&view=3Dmarkup
>=20
> are both old. =20
>=20
> Can you give us a link to the current subversion version you refer to?

I'm sorry.  I misinterpreted the original mail and thought the claim was
that header file and kernel code were out ouf sync.  In fact, the
libipt_connbytes.c really was out of sync with the kernel
implementation.

I've now spent a couple of minutes and tried to bring libipt_connbytes
in sync with the kernel part in patch-o-matic-ng (Rev. 3284)

Unfortunately I lack the time for testing beyond the 'compile test'.  If
you could provide any feedback, that would be appreciated.

> Thanks,
> --Mike Carlton
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBnScCXaXGVTD0i/8RAkwEAJwMoAfbD4cZ6Ox1NxMNEXnsEUk/OACcDRYr
+Zcg+iAyPwJPPvT1Bd+lcZE=
=eGX9
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
