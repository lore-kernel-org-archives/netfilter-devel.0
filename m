From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] connlimit match fixes for >= 2.6.10
Date: Tue, 15 Feb 2005 00:05:45 +0100
Message-ID: <20050214230545.GC3829@sunbeam.de.gnumonks.org>
References: <20050212213254.GA11884@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050212213254.GA11884@linuxace.com>
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


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 12, 2005 at 01:32:54PM -0800, Phil Oester wrote:
> Below updates connlimit for:
>=20
> 1) removal of nf_ct_info
> 2) removal of ctrack
>=20
> Fixes bugzilla #'s 268 and 286.

Ok, applied to the pom-ng 2.6 branch .  Can you close Bugzilla referring to=
 Rev. 3688 (http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branches/patch-o-m=
atic-ng/linux-2.6.11/?rev=3D3688)

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCES7JXaXGVTD0i/8RAirYAJ9JNDp0jQYV45jaNj8jaAB2bscAkACgjBV8
qapEO1sFXTcqwNwLo6NphUM=
=F12i
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
