From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: use of vmalloc within netfilter (was Re: [ANNOUNCE] IP sets)
Date: Wed, 25 Feb 2004 18:32:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077730350.8283.1284.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0402231812460.20487-200000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1IlAg0mRnptU9V+RyNU9"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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


--=-1IlAg0mRnptU9V+RyNU9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-02-23 at 18:19, Jozsef Kadlecsik wrote:

> Attached is a possible solution to avoid using vmalloc. The difference
> should really be measured. Any takers? :-)

It's missing a memset() after the last kmalloc()

--=20
/Martin

--=-1IlAg0mRnptU9V+RyNU9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAPNwuWm2vlfa207ERApP7AKCYAylkM2d1NRPeVVX9mFyMep0BgwCbBFZU
QflFN2kz88bem/5029LcaLE=
=LtC+
-----END PGP SIGNATURE-----

--=-1IlAg0mRnptU9V+RyNU9--
