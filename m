From: Eric Leblond <eric@inl.fr>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Mon, 08 Jan 2007 23:41:26 +0100
Message-ID: <1168296086.12298.6.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-XdBJzONId6gOaZOJxAMg"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20070107142607.GC13543@prithivi.gnumonks.org>
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


--=-XdBJzONId6gOaZOJxAMg
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,
Le dimanche 07 janvier 2007 =E0 15:26 +0100, Harald Welte a =E9crit :
> On Fri, Dec 29, 2006 at 12:40:47AM +0100, Eric Leblond wrote:
> > It will add 4*IFNAMSIZ =3D 64 octets to each nfnetlink_queue message bu=
t
> > this is not impressive as a part of the packet payload is usually sent.
>=20
> No, please don't do that. =20
> Also, I _really_ want to get rid of interface names throughout
> netfilter/iptables at some point in the future.  all 'next generation'
> subsystems (such as all nfnetlink based services) should just deal with
> ifindexes.
>=20
> Please put some functions into libnfnetlink, even if it doesn't natively
> belong there.   If there's more netlink unification, we can always make
> those just wrappers for the 'real new unified' ifindex/name resolving
> functions.

I've thought at this solution before getting interessed by pablo's
suggestion. But I've got a conception problem.

It is not correct to do a dump (and send a netlink message) for each
ifindex resolution. Thus, libnfnetlink needs to listen to netlink
interfaces message. A permanent "task" is thus needed to have the job
done : It can be a dedicated thread or a carefully hidden select.

In fact, if we omit the thread approach which is somehow intrusive, I
don't see a way to do this via a simple call to added functions.

Any idea welcome.

> [yes, I'm back, more or less]

Great news !

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-XdBJzONId6gOaZOJxAMg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFosiWnxA7CdMWjzIRArjUAJ9aVZeUobqgHbMZLn/TLod2UiHA1QCfRRLu
lyWLnbTY9A+gNSOShY47VBI=
=OuvC
-----END PGP SIGNATURE-----

--=-XdBJzONId6gOaZOJxAMg--
