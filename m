From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 21:42:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030530194240.GI29312@sunbeam.de.gnumonks.org>
References: <200305290113.58552.prez@srealm.net.au> <20030529083953.GB2461@sunbeam.de.gnumonks.org> <200305300133.44822.prez@srealm.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rV8arf8D5Dod9UkK"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
Content-Disposition: inline
In-Reply-To: <200305300133.44822.prez@srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rV8arf8D5Dod9UkK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2003 at 01:33:22AM -0400, Preston A. Elder wrote:

> I have my router box, say, 192.168.0.1, and a range of IP's behind it, sa=
y,=20
> 10.0.0.0/24, for arguments sake.  I also have an application on the route=
r=20
> box listening on 100 ports, say, 5000-5100.  My uplink interface is eth0,=
 and=20
> the interface with all the 10.0.0.0 addresses is on eth1.

a perfectly fine setup.

> Now, I add an iptables rules something like the following:
>=20
> iptbales -t nat -A PREROUTING -j REDIRECT -i eth0 -p tcp -d 10.0.0.0/24=
=20
> - --destination-port 1025:65535 --to-ports 5000-5100
>=20
> If I then telnet to 10.0.0.1 on port 5050, the connection is immediate, a=
nd my=20
> application receives a new connection on port 5050.  If, however, I telne=
t to=20
> 10.0.0.1 on port 5150, there is a small (but noticable) delay between whe=
n=20
> the telnet session shows the connection as established, and when the=20
> application receives the connection (on a random port between 5000 and 51=
00=20
> inclusive).

This is _definitely_ not a netfilter issue then.  We are not doing
transparent proxying but nat.  netfilter/iptables _never_ accept
connections on their own.  So you open a connection:

1. telnet 10.0.0.1 5150
2. syn packet is sent by telnet
3. syn packet is DNAT'ed by netfilter
4. syn packet arrives at server application
5. syn/ack packet is sent by server application
6. syn/ack packet is SNAT'ed by netfilter
7. syn/ack packet is received by telnet
 [further handshake goes on]
x. telnet application prints 'Connection established' (connect(2) call
   returns)

This is a fundamental tcp/ip operation, and it can certainly by no way
be anything that netfilter does, that would introduce a behaviour like

1. telnet 10.0.01 5150
2. telnet shows 'connection established'
3. connection 'arrives' at server

[which is what you have been describing, If I understood you correctly].

> - - I'm talking a system than can get thousands of new connections a seco=
nd=20
> (the hardware is up to it, we're talking gb's of ram, and SMP machines). =
 As=20
> with my above small test case, connecting to a port in the 'to-ports' ran=
ge=20
> gives me an immediate connection (on the application), but the delay betw=
een=20
> telnet showing the connection established, and the application receiving =
the=20
> connection (and establishing it) grows dramaticaly, even taking over a mi=
nute=20
> for the application to receive the connection.  Hell, even the time for=
=20
> telnet to show the connection as established is much greater when connect=
ing=20
> to a port outside the 'to-ports' range than when connecting to one within=
=20
> this range.

Again, no way.  This seems to be some issue with your server
application. =20

> - --=20
> PreZ
> Systems Administrator
> Shadow Realm

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rV8arf8D5Dod9UkK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+17QwXaXGVTD0i/8RAspiAJ4wDkGr6roV0/BZ78Ej4nE1AlmVkwCeKSa5
MI1lRCese1EybyGCBwTCKbE=
=DCJX
-----END PGP SIGNATURE-----

--rV8arf8D5Dod9UkK--
