From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 09:06:29 +0200
Message-ID: <20050628070628.GC13239@sunbeam.de.gnumonks.org>
References: <42C03F2E.30706@eurodev.net>
	<20050627202621.GY19928@sunbeam.de.gnumonks.org>
	<42C0AF26.1040705@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42C0AF26.1040705@eurodev.net>
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


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2005 at 04:00:06AM +0200, Pablo Neira wrote:
> >I don't understand why the order of the expectation list was changed,
> >though.  Would you please explain why this was done?
>=20
> Because of the table dumping logic I was using.

I see.=20

> >>- Implement ip_conntrack_stats dumping and reset (accounting)
> >
> >you want to dump the statistics via netlink?  i'm not sure whether that
> >is required.  lnstat is the only program using those counters, and using
> >/proc seems fine for that.
>=20
> Could this be useful for accounting purposes? I mean, dump and reset as=
=20
> a single operation, something similar to conntrack -L -z, say conntrack=
=20
> -S -z.

oh, you're referring to ip_conntrack_acct (the accounting), not
ip_conntrack_stat (the statistics) ?  /me is confused.

Isn't that what the CTRZERO message type already does?

> An atomical operation to dump conntrack information and then destroy it.=
=20
> For example, if someone does:
>=20
> conntrack -D --orig-src 1.1.1.1 --orig-dst 2.2.2.2 -p tcp=20
> --orig-src-port 10 --orig-dst-port 20
>=20
> the it sends the conntrack info and destroy it. This could be worth it=20
> for accounting.

I think it could be useful, indeed.

> >I'm not sure if we could somehow (cleanly) tie into the scoket
> >close/destroy code.  If yes, we could check if we can reduce the mask at
> >socket destroy time.
>=20
> I think there's no sane way to do this but let me check the netlink code=
=20
> again. I could use multicast netlink subscrition, so the client can get=
=20
> subscribed to those events that the user considers interesting.

Well, maybe we can extend the netlink code to achieve what we're
interested in. =20

Multicast netlink groups are already used for my clumsy tcp/udp/icmp/...
distinction.  I think it is not a good solution for ctnetlink, since the
kernel then sends all events, independent of any process interested in
them or not.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwPb0XaXGVTD0i/8RAuUmAJ4wP+LMckgbWhIN1885Of9n7P4LEACbBxMN
O6R/QNOSt8dPZAUlggpAkZw=
=qlqv
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
