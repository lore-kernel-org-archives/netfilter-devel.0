From: Harald Welte <laforge@netfilter.org>
Subject: Re: NetFilter unclean modue in 2.6.x kernels
Date: Mon, 24 Jan 2005 10:22:41 +0100
Message-ID: <20050124092241.GC14460@sunbeam.de.gnumonks.org>
References: <200501220013.56429.sov.rbsec@gmail.com>
	<20050121233328.GU14460@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
	<20050124085704.GA14460@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0501241009530.6574@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J9FDM06y/La6Wdcu"
Cc: "Oleg V. Sapon" <sov.rbsec@gmail.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0501241009530.6574@blackhole.kfki.hu>
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


--J9FDM06y/La6Wdcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 24, 2005 at 10:13:36AM +0100, Jozsef Kadlecsik wrote:

> As far as I remember, the main concern was due to the ckecking of the
> reserved fields, which can cause forward-incompatibility. Was something
> else against the match? Just asking :-)

yes, that's basically it, IIRC.

> Jozsef
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--J9FDM06y/La6Wdcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB9L5hXaXGVTD0i/8RAlGvAKCooFcuTcL8RUkeGdBUVS08f4gJnACgq6uC
JgNQvViTvVerjOmz0+AH4yI=
=kqmv
-----END PGP SIGNATURE-----

--J9FDM06y/La6Wdcu--
