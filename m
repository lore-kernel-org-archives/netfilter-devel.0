From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Thu, 23 Oct 2003 12:57:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031023105739.GL1418@sunbeam.de.gnumonks.org>
References: <3F964F9D.D5C69498@fy.chalmers.se> <20031023090238.GE1418@sunbeam.de.gnumonks.org> <3F97A4C5.982725B0@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F4+N/OgRSdC8YnqX"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
Content-Disposition: inline
In-Reply-To: <3F97A4C5.982725B0@fy.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--F4+N/OgRSdC8YnqX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2003 at 11:52:05AM +0200, Andy Polyakov wrote:
> > Just a quick unrelated question: Why would somebody be using ipchains on
> > a 2.6 kernel?
>=20
> Well, I use it, because it was on my computer since eternity and I used
> to it. It's hardly a "crime":-):-):-)

No, it's not a crime - just a very strange thing to do (at least from my
experience).

> > What about using iptables?  Does it produce a similar behaviour?
>=20
> I don't know. I'll check at some point, but not right away...

That would be helpful, since it would become a way more important bug if
it was in iptables.

> > think this is the first time within at least a year that we've had any
> > report of somebody using (or finding bugs) in the ipfwadm/ipchains
> > compat layer... it wasn't even frequently used with 2.4.x
>=20
> Well, then it probably should have disappeared from 2.6. I mean if the
> code is there, then it should work and is actually expected to work.

Actually we were thinking about removal - and I am still tempted to do
so. =20

> > yes, please.  Especially a means of reproduction without running
> > proprietary software (and thus being repruducable for me) would be very
> > helpful.
>=20
> Would eth0:1 be sufficient? A.

Yes, it would.  Can you confirm the bug happens when you use ipchains,
an alias interface and reuse adresses/ports from a machine behind that
interface?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--F4+N/OgRSdC8YnqX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/l7QjXaXGVTD0i/8RAgJkAJ4pqkn1ozcZmw7MwoRvKVzWUBlsjQCeICBm
rE1gHwu7WXz2mNIsSRnluKA=
=B94W
-----END PGP SIGNATURE-----

--F4+N/OgRSdC8YnqX--
