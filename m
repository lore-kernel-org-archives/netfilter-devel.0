From: Harald Welte <laforge@netfilter.org>
Subject: Re: [announce] arptables userspace tool
Date: Wed, 11 Jun 2003 23:19:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611211924.GG32593@sunbeam.de.gnumonks.org>
References: <200306092318.08599.bdschuym@pandora.be> <20030611123426.GN32593@sunbeam.de.gnumonks.org> <200306111933.19734.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oIKd4Ysag+ysiDHn"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200306111933.19734.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oIKd4Ysag+ysiDHn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2003 at 07:33:19PM +0200, Bart De Schuymer wrote:
> > oh no.  Please not yet another copy+past 'port' of anything inside
> > netfilter/iptables. *sigh*.  This is driving me mad...
>=20
> I see. Not that I want to drive you to complete mental insanity, but
> arptables happens to be a part of the 2.4 and 2.5 kernel (already 15
> months) and didn't have a userspace tool to use it.=20

Yes, I am well aware of that fact.

> Since the kernel arptables part is basically a copy/paste action
> performed upon iptables (done by David Miller), it surprises me that
> you'd think the accompanying userspace tool would not be.

In both cases I think exactly the same way.  As well as with
iptables/ip6tables/ebtables.

No, it's not your fault, it's ours.  Why don't we provide something
flexible enough to deal with all cases.  In particular, it's my problem.
Why don't I find  all the time I want to work on pkttables.

> I must admit your reply puzzles me, but there's enough war already so I'l=
l=20
> just let it pass.

No, I don't want to start any war.  I just wanted to express my very
ambiguous feeling towards all of those 'ports'.

> cheers,
> Bart

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oIKd4Ysag+ysiDHn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+55zcXaXGVTD0i/8RAmmJAJsGYdjjJ+7SS730EnT05cCWw4K9PQCgmij1
1rRLfsYOnXmEINqnNUapVYk=
=ESn/
-----END PGP SIGNATURE-----

--oIKd4Ysag+ysiDHn--
