From: Harald Welte <laforge@netfilter.org>
Subject: Re: About tcp conntrack with UNREPLIED and ESTABLISHED
Date: Mon, 13 Oct 2003 10:15:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031013081529.GC21521@sunbeam.de.gnumonks.org>
References: <E1A8sgG-0005by-HU@kashyyyk.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: qianunix <qianunix@126.com>
Content-Disposition: inline
In-Reply-To: <E1A8sgG-0005by-HU@kashyyyk.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2003 at 10:45:20AM +0800, qianunix wrote:
> When I was using netfilter,rebooted system,then I found a conntrack:

_please_ always tell us which particular kernel version you are running,
and which patches from patch-o-matic you might have applied to that
kernel.

> tcp      6 430290 ESTABLISHED src=3D61.172.241.50 dst=3D1.2.3.4 sport=3D2=
1 dport=3D1055 [UNREPLIED] src=3D1.2.3.4 dst=3D61.172.241.50 sport=3D1055 d=
port=3D21 use=3D1
>=20
> the srp 1.2.3.4 is my firewall, and my doubt is that why the sport is 21?=
=20

because somebody seems to have opened a connection from that source.
You can verify this by running netstat.  It could also be a spoofed
connection, since it is yet unreplied and we don't know if your iptables
filtering ruleset has any anti-spoofing rules in place.

> I think 21 must be a dport, and that UNREPLIED and ESTABLISHED is
> here, it is impossible, so I think the tcp conntrack with UNREPLIED is
> invalid,don't you think so?  please help me,thanks.
=20
Yes.  This seems like either a 2.4.10 or a 2.4.20 kernel to me?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/il8hXaXGVTD0i/8RAqaDAJ9XqOs+FXWYZDxuZCPbRbW38BjyRwCeJb7k
VpYg9RJd0HeuIb8m1rj67D4=
=l/S+
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
