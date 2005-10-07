From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Sat, 8 Oct 2005 00:04:35 +0200
Message-ID: <20051007220435.GJ4450@rama.customers.eurospot.com>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>, kaber@trash.net
Content-Disposition: inline
In-Reply-To: <20051007.132619.129111295.davem@davemloft.net>
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


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

On Fri, Oct 07, 2005 at 01:26:19PM -0700, David S. Miller wrote:
>=20
> > I know this is too late for 2.6.14, so do you want me to hold back such
> > patches or do you already have a 2.6.15 queue?
> >=20
> > [NETFILTER] Use only 32bit counters for CONNTRACK_ACCT
> >=20
> > Initially we used 64bit counters for conntrack-based accounting, since =
we
> > had no event mechanism to tell userspace that our counters are about to
> > overflow.  With nfnetlink_conntrack, we now have such a event mechanism=
 and
> > thus can save 16bytes per connection.
> >=20
> > Signed-off-by: Harald Welte <laforge@netfilter.org>
>=20
> I would like to actually suggest you keep the 64-bit counters.

That's surprising ;)

> Is there a truly strong reason to shrink them to be 32-bits?

Because we now can do better (by signalling the event and having
userspace accounting daemon take care of it) while not wasting
rediculous amounts of memory.  I mean, everywhere we try to make struct
ip_conntrack smaller (similar to the skb diet), and those 64bit counters
are really large.  We need four of them.  Yes, they're only present if
you actually enable CONNTRACK_ACCT.  But like we all know, most people
(and esp. distributions) will just enable them - at least as soon as
ulogd2 (or even other accounting daemons) are finished.  ulogd2 is
almost there, so I think it can be released when 2.6.14 final hits the
road.

If you actually try to estimate how many connections will have more than
4GB traffic in a single direction, then (at least currently) that will
be quite few.  And for those who overflow, we get the event.

The likely candidates for logging the accounting data (NETFLOW and IPFIX
flow exchange formats) both don't have the notion of a connection, so
sending a per-flow record every time the counter raises above 2GB is
perfectly fine with them.

If you really really want to veto that change, I'd offer at least two
compromises:

1) at least shrink the two packet counters to 32bits
2) make the counters 64bit on 64bit archs, and 32bits on 32bit archs

I'm still in favour of the 32bit ones, as I think Patrick is, too.

Greetings from workshop.netfilter.org,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvDzXaXGVTD0i/8RAvdDAKCNxvb93tSDDCccaBwz+LfDe5aBFACfS535
NOwBJf/Y0R8u+ZBkq+rYPfc=
=mFS6
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
