From: Harald Welte <laforge@netfilter.org>
Subject: Re: Handling a protocol through SNAT
Date: Tue, 11 Mar 2003 18:36:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030311173605.GL19521@sunbeam.de.gnumonks.org>
References: <87k7f7jg53.fsf@stark.dyndns.tv> <20030311125502.GD19521@sunbeam.de.gnumonks.org> <87r89dj03y.fsf@stark.dyndns.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Greg Stark <gsstark@mit.edu>
Content-Disposition: inline
In-Reply-To: <87r89dj03y.fsf@stark.dyndns.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2003 at 12:15:29PM -0500, Greg Stark wrote:
> > > The client doesn't normally send anything from that port.
> >=20
> > Can't you do DNAT for this?  W
>=20
> the port is a random high port allocated dynamically with bind=20

so you really need some kind of conntrack/nat helper module...

> > This is definitely wrong. We implement 'symmetric NAPT'.   There has to
> > be something about your particular setup that gives you this impression.
>=20
> Hm, perhaps I jumped the gun when I noticed it worked for the "last" one.=
 in
> fact it seems to work for all of them for a while and then stop for some.=
 Are
> the default timeouts really short? Like a couple minutes?

once the connectioin is established, the timeout is 5 days.  For further
information on TCP timeouts, please see
/usr/src/linux/net/ipv4/netfilter/ip_conntrack_proto_tcp.c

We try to use the normal TCP stack timeouts, so for SYN_SENT it's 2
minutes, etc.

> > iptables -t nat -A PREROUTING -j DNAT -p tcp --dport XYZ
> > --to-destination client:port
>=20
> I tried this, I must be doing something wrong though because it doesn't s=
eem
> to do anything at all. No packets get through.

Try to debug further.  There is something about your setup.  Look at the
incoming packets with tcpdump.  Try if you find corresponding conntrack
entries in /proc/net/ip_conntrack, etc.

> iptables -t nat -A PREROUTING -j DNAT -p tcp --dport 33384
> --to-destination 10.4.0.2:33384

> Btw, there is a small bug, iptables says "Bad IP address 10.4.2" if I
> use that form.

This is not a bug.  10.4.2 is not an ip address.

> greg

please 'cc' the list when replying to this mail.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+bh6FXaXGVTD0i/8RAlJPAJ4zCejUtEUrRjFoYFkjgSwGwr7toQCdHtYm
i62KPmOBVlWXt0piU9AIAow=
=TCED
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
