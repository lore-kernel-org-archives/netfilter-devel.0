From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] IP sets
Date: Sat, 14 Feb 2004 22:23:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214212340.GC7756@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0402091505440.23818-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rAc+36e7LRL7Dg7x"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402091505440.23818-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rAc+36e7LRL7Dg7x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 09, 2004 at 03:41:56PM +0100, Jozsef Kadlecsik wrote:
> Hello,
>=20
> The IP sets support is available from the netfilter cvs repository!

Thanks a lot, I will take some time to review the code.

One of the first issues that I ran into was the use of vmalloc.
Please refer to http://lwn.net/Articles/57800/.

In fact, we should even consider to not use it for ip_tables itself,
too.

Since ipset is sufficiently independent (in fact, totally independent)
of iptables, we could make it a seperate package, and thus a seperate
cvs module.  What do you think?

> Best regards,
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

--rAc+36e7LRL7Dg7x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALpHcXaXGVTD0i/8RAlLlAJ49eVq/Zhb+sCL9y6Y2Vn+sRmE4mwCgsbNX
f+2U6ys3H8vXdSnszR7og7o=
=TErS
-----END PGP SIGNATURE-----

--rAc+36e7LRL7Dg7x--
