From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] [LIBNFNETLINK] fixes
Date: Sun, 15 Jan 2006 19:12:21 +0100
Message-ID: <20060115181221.GJ6740@sunbeam.de.gnumonks.org>
References: <43C9B94E.9040409@netfilter.org>
	<20060115094521.GG6740@sunbeam.de.gnumonks.org>
	<43CA5DBD.1010507@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mu9njEoJVcULXJK5"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43CA5DBD.1010507@eurodev.net>
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


--mu9njEoJVcULXJK5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2006 at 03:35:41PM +0100, Pablo Neira Ayuso wrote:
> Harald Welte wrote:
> >>The patch attached fixes two issues in libnfnetlink:
> >>
> >>- subsys_id was not set in nfnl_subsys_open
> >>- set nfnlh->local.nl_pid in nfnl_open since nfnl_talk checks that:
> >>h->nlmsg_pid !=3D nfnlh->local.nl_pid
> >=20
> > unfortunately no patch attached...
>=20
> :( sorry about that, patch attached.

thanks, will review and apply.

> >>Now the libnetfilter_conntrack test says OK again ;)
> >=20
> > great. sorry for the breakage, but I hope you can appreciate the beauty
> > of this new concept.  Being able to talk to all nfnetlink subsystems at
> > the same time through one socket...
>=20
> Sure, it's a nice rework. And it's really promising that now we can have
> helpers in userspace, as Rusty dreamed in early stages :).
>=20
> BTW, are we going to distribute the further application helpers
> (implemented in userspace) separately or living somewhere in
> libnetfilter_cthelper?

the helpers are applications (daemons) that link against
libnetfilter_cthelper.  They will not be themselves (apart from some
example code) be in the library package.

We _might_ want to provide some addidional helper infrastructure,
something more than libnetfilter_cthelper, but I don't have any precise
plans yet.  Something with a common handling for logging, config files,
etc. might be neat.  But anyway, that's optional and for later down the
road.

The kernel bits, libnetfilter_queue, libnetfilter_conntrack and
libnetfilter_cthelper is everything you technically need for writing an
userspace helper.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mu9njEoJVcULXJK5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDypCFXaXGVTD0i/8RAux+AKCYtUxTk09a3KR1MSq6X8CN3QkT5wCgjsOV
zmI3E8Y6kszB5is9iBSporY=
=/Bo4
-----END PGP SIGNATURE-----

--mu9njEoJVcULXJK5--
