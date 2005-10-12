From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 08:36:23 +0200
Message-ID: <20051012063623.GC4237@rama.de.gnumonks.org>
References: <434AE28B.2070607@trash.net>
	<20051010.150623.94217913.davem@davemloft.net>
	<20051011142304.GA4756@rama.de.gnumonks.org>
	<20051011.123920.104724390.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051011.123920.104724390.davem@davemloft.net>
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


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 12:39:20PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Tue, 11 Oct 2005 16:23:04 +0200
>=20
> > given that discontiguous processor id's seem to be very rare, I think
> > it's fine to waste some memory on those few systems by ussing this
> > "allocate array from 0 to max smp processor id" approach.
>=20
> Let's get your patch working first :-)  The original reporter
> said that your patch still OOPSes when he tries to start
> using iptables.  Didn't you see that?

Yes, I did.  Please note my emails are heavily delayed, since I'm almost
every day travelling (either plane or train).

> On thinking about this some more, the duplication of _all_ of this
> information per-cpu is quite questionable, at least the "read mostly"
> parts that just describe the rules.  The counters make tons of sense,
> per cpu, but that's the majority of it.

Yes, it makes no sense. I never questioned that.  I really dislike a lot
of these strange things in ip_tables.  Unfortunately a change of
something fundamental like this will require lots of code auditing
(basically all match/target extensions).  At the moment a match/target
can modify it's cpu-local matchinfo, and maybe it's not suposed to
change global state.  Also, anything that writes to target/matchinfo
would then require additional (write)locking.

It definitely is a design mistake, I think Rusty admitted to that even
someyears ago.  But now we have to live with the legacy, and now we need
a quick fix, not a complete redesign :)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDTK7mXaXGVTD0i/8RAljwAKCQ/56xa/SDGG+yPdYgRZo1KoskSwCdGZDY
L1zElwp+YDnV1MWfCRYsLsY=
=Qp8b
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
