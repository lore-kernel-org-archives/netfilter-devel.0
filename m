From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Tue, 17 Feb 2004 22:37:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217213721.GG30968@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu> <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com> <20040206185242.GM2312@obroa-skai.de.gnumonks.org> <4028D0E5.8000003@trash.net> <20040214200326.GQ7756@sunbeam.de.gnumonks.org> <402F4366.7020302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NPukt5Otb9an/u20"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <402F4366.7020302@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NPukt5Otb9an/u20
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2004 at 11:01:10AM +0100, Patrick McHardy wrote:

> I like the idea. So assuming that long hash chains are a result of "bad
> luck" with the jenkins hash, we would just change the secret, rehash,
> and repeat if some chains are still too long ? At what point do you
> propose rehashing, at the moment the chain length exceeds some threshold
> (or thereafter, defered to occur out of packet processing context), or
> when dumping over netlink ?

Mh. I am not really sure what might be the best solution.  It should
definitely not happen within softirq context, though.
=20
> >Also, Jozsef proposed a flip/flop bit mechanism that would solve that
> >problem.  What do you say to his proposal?
>=20
> Can I find his proposal somewhere ?

Message-Id: <Pine.LNX.4.33.0310201018510.12485-100000@blackhole.kfki.hu>

http://lists.netfilter.org/pipermail/netfilter-devel/2003-October/012821.ht=
ml

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NPukt5Otb9an/u20
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMomRXaXGVTD0i/8RArBOAJ44mlqEmGqKEil/gMKkbAm+QuDXjACgqlKX
Ox9jf/8y1n2YAoB6qaso7wU=
=6cJ2
-----END PGP SIGNATURE-----

--NPukt5Otb9an/u20--
