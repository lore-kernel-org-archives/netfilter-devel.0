From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC][PATCH] NAT reservations
Date: Thu, 11 Dec 2003 14:14:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211131437.GD22826@sunbeam.de.gnumonks.org>
References: <3FCF5F23.5060800@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSHpc5A+GJc9BHcd"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <3FCF5F23.5060800@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HSHpc5A+GJc9BHcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2003 at 05:21:55PM +0100, KOVACS Krisztian wrote:
>=20
>   Hi,
>=20
>   Any feedback is welcome. :)

Looks fine so far, however two cosmetic remarks:

don't change existing definitions for bits in bitmasks.  this annoys
developers who know them out of their head, didn't notice your change
and then try to debug something.

also, please try to not export that many new symbols.  range reservation
and range removal should be enough, the __ symbols aren't even used
outside the code, are they?

>   Regards,
>     Krisztian KOVACS
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HSHpc5A+GJc9BHcd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2G28XaXGVTD0i/8RAn/NAJ4jtpaIdOJruC7j8+LPFww+u9qH/QCfVLPL
d3uWt89nShnpXqQegPYampM=
=1VTV
-----END PGP SIGNATURE-----

--HSHpc5A+GJc9BHcd--
