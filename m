From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Thu, 29 May 2003 10:39:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030529083953.GB2461@sunbeam.de.gnumonks.org>
References: <200305290113.58552.prez@srealm.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
Content-Disposition: inline
In-Reply-To: <200305290113.58552.prez@srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2003 at 01:13:47AM -0400, Preston A. Elder wrote:

> Hi,
>=20
> I am in an enterprise environment and I'm having some problems with connt=
rack=20
> specifically.

> They're running 2.4.20 kernels (mostly vanilla) with iptables 1.2.7a.

Do not use 2.4.20 if you want to use connection tracking.  2.4.20
connection tracking is totally broken due to a change introduced in the
core kernel.

Please do always use patch-o-matic from CVS.  The patch you want to
apply for fixing this bug is 10_confirm_fix.patch

Also, considering=20

> echo 524280 >/proc/sys/net/ipv4/ip_conntrack_max

without using a larger hash size (modprobe ip_conntrack hashsize=3Dfoo,
wherer foo should be a prime number and in the range of 524280/2)

> to be re-directed to a local port, which is achieved with the command:
> /sbin/iptables -t nat -A PREROUTING -j DNAT -i eth0 -p tcp -d <ip-range>=
=20
> - --destination-port 1024:65535 --to-destination <local_ip>:<local_port>
>=20
> Every inbound connection incurs an entry in the connection tracking
> table.  It seems, however, that we may be overloading the conntrack
> system. =20

I've seen systems with way more conntrack entries and higher bandwith.
Using NAT however, might have a big performance impact.

> The conntrack table itself very quickly grows - but it does not clean its=
elf=20
> up when the connection itself dissapears, instead it waits for some=20
> pre-determined timeout value,=20

With a non-broken kernel it is 2 minutes, that is TIME_WAIT of a TCP
socket.

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

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+1cdZXaXGVTD0i/8RAn+hAJoDYt48e8hLJDml2dhhiuatJgDXUACgqeMI
0gSx9SBc35N7kpzHHLERRcg=
=L5GR
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
