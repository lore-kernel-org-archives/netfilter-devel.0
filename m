From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 20:52:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020185258.GD20288@sunbeam.de.gnumonks.org>
References: <20031020071545.GA21521@sunbeam.de.gnumonks.org> <3F9426C1.6070908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F9426C1.6070908@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Actually, another point is what to do with expectations. =20

It's not as problematic as with conntrack's, but in general it's the
same.  Let's say:

- conntrack helper creates expectation for typle xyz
- userspace gets a list of unconfirmed expects
- expectation for tuple xyz is confirmed
- conntrack helper creates a new expectation for tuple xyz
- userspace wants to remove expectation by referring to tuple xyz.

At least in this case, that might actually be what the user wants -
since there is not much difference between the two expectations, other
than time passing in between.

If the helper is automatically re-adding expectation upon confirmation,
than the user can race with incoming connections in order to 'break the
circle' ;)=20

I think there is not too much point in removing expect's anyway.  The
real need is for adding and modyfing expectations, in case there is a
userspace conntrack/nat helper.

What do you think?


btw: In the failover code, I have another problem with regard to
expect's:  A sibling conntrack has a pointer to the master expect, not
the master conntrack.  But i somehow need to replicate that pointer.
Without Krisztians idmap (that I've already ripped out), I'm now passing
the master conntrack's tuple and the expectation's tuple.    This works
while doing normal sync:  There can always be only one unconfirmed
expectation for every tuple.

However, when doing a initial sync (or a full-resync), I cannot
replicate the whole tree of master and siblings - because I first
replicate the conntracks and then later have to fill in the [confirmed]
expectations as glue in between. =20

The only idea I have is to use the 'seq' number.  However, this again
only works for TCP.

Any other options?

(in the Future, I think we will at least optionally have per-connection
byte and packet counters.  Then the 'seq' field could be initialized to
the byte counter at the time the expectation was raised.  This would
solve the udp case [and other udp races which Patrick can tell us
nightmares of]. However, this is once again enlarging conntrack - but
only if somebody wants to use 'connbytes' match or create netflow-style
connection logs.  But we could require that compile option in case
somebody wants to enable failover)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/lC8KXaXGVTD0i/8RAqFXAJ9L/f6y/ndH5oOAHOu7vjPnZ1Or7ACfW6+d
jlF3l2Wcc7m+KFmXEUW0488=
=YCqy
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
