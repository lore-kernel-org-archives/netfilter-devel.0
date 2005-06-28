From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 09:07:38 +0200
Message-ID: <20050628070738.GD13239@sunbeam.de.gnumonks.org>
References: <42C03F2E.30706@eurodev.net>
	<20050627202621.GY19928@sunbeam.de.gnumonks.org>
	<42C0AF26.1040705@eurodev.net> <42C0C9B2.20704@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wb5NtZlyOqqy58h0"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42C0C9B2.20704@trash.net>
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


--Wb5NtZlyOqqy58h0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2005 at 05:53:22AM +0200, Patrick McHardy wrote:
> Pablo Neira wrote:
> > Harald Welte wrote:
> >>> - Implement ip_conntrack_stats dumping and reset (accounting)
> >>
> >> you want to dump the statistics via netlink?  i'm not sure whether that
> >> is required.  lnstat is the only program using those counters, and usi=
ng
> >> /proc seems fine for that.
> >=20
> > Could this be useful for accounting purposes? I mean, dump and reset as
> > a single operation, something similar to conntrack -L -z, say conntrack
> > -S -z.
>=20
> I think it is convenient for anyone wanting to access these statistics
> without parsing /proc to have everything accessible through a single
> interface.

=2E.. and it is already implemented in current svn ;)

> destroy notifications are sent anyway, so we get the stats. What's the
> difference to normal destruction?

I agree.

> > I could use multicast netlink subscrition, so the client can get
> > subscribed to those events that the user considers interesting.
>=20
> That sounds like the right thing to do.

well, but we still create a horrible amount of event messages, let's say
in case of a syn flood...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Wb5NtZlyOqqy58h0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwPc6XaXGVTD0i/8RAuHMAJ0d4sNATk8NQezixdU7e+II645EHACfQjm0
n7XPzzHSAgOq7dhEqp1CtRA=
=RE+J
-----END PGP SIGNATURE-----

--Wb5NtZlyOqqy58h0--
