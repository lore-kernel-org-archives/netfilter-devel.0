From: Harald Welte <laforge@netfilter.org>
Subject: Re: use of vmalloc within netfilter (was Re: [ANNOUNCE] IP sets)
Date: Mon, 23 Feb 2004 19:33:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040223183332.GN13386@sunbeam.de.gnumonks.org>
References: <20040218081250.20edb2b5.ak@suse.de> <Pine.LNX.4.33.0402231812460.20487-200000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A2x6GFCQWVc4i5ud"
Cc: Andi Kleen <ak@suse.de>, gandalf@wlug.westbo.se,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402231812460.20487-200000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--A2x6GFCQWVc4i5ud
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2004 at 06:19:12PM +0100, Jozsef Kadlecsik wrote:
> Attached is a possible solution to avoid using vmalloc. The difference
> should really be measured. Any takers? :-)

Thanks Jozsef,

I am currently into some netfilter/iptables profiling anyway and will
give your patch a try.  Expect some results until wednesday.


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

--A2x6GFCQWVc4i5ud
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAOkd8XaXGVTD0i/8RAr0yAJ9QcC2QDc0hDcjx6sO+oNKbbHqPKwCfbdDd
7KhT2NyzGzpnp7+aW8bXrt8=
=GCK2
-----END PGP SIGNATURE-----

--A2x6GFCQWVc4i5ud--
