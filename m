From: Harald Welte <laforge@netfilter.org>
Subject: Re: how to flush conntrack entry?
Date: Mon, 3 Nov 2003 08:43:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103074343.GL1536@sunbeam.de.gnumonks.org>
References: <003201c39f75$3e40a5c0$0200200a@wangle>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w+ok4pmHMnU+ibn4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sina <wanglonge@vip.sina.com>
Content-Disposition: inline
In-Reply-To: <003201c39f75$3e40a5c0$0200200a@wangle>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--w+ok4pmHMnU+ibn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2003 at 02:07:12PM +0800, sina wrote:
> hello
> i run into the problem described here and i wondered if someone knows of
> a solution:
>=20
>        +----------+
>        |  SNAT    |
> private|--------> |(eth1: public ip)
>   ip   +----------+
>=20
> 1) setup masquerading=20
> (iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADING)
>=20
> and ping continuously from private to public. all ok.
>=20
> 2) flush the NAT
>=20
> iptables -t nat -F
>=20
> (ping will stop working obviously but i don't kill the ping process,
> just keep sending echo, no reply)

it will not stop working 'obviously'.  It will just stop working because
you were using MASQUERADE, and MASQUERADE [still] has the policy of
flushing all conntrack/nat entries associated with the IP address of the
outgoing interface.  Would you be using SNAT, it would continue to work.

> looking at the ip_conntrack proc entry it was noticed that:
>=20
> after flushing (step 2) an UNREPLIED entry for icmp is there
> (no reply hence unreplied) but its ttl does not decrement.
> (ping echos are still hitting the nat box from private side)

yes, that is true.

> question is: is there a way to achieve this (looks like start
> decrementing that ttl or reseting it to zero in conntrack) in the nat
> box without having to stop the pings on the host side ?

you can reload ip_conntrack.o at the time when you re-initialize your
nat table ruleset.

> thanks,
> marian

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--w+ok4pmHMnU+ibn4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pgcvXaXGVTD0i/8RAm7/AKCpNOzvzaZ2qnCPPtiPt1BWTC4tkwCfbOAD
QdLqXZhpqWHgUQUVkiem7Gg=
=Ot+2
-----END PGP SIGNATURE-----

--w+ok4pmHMnU+ibn4--
