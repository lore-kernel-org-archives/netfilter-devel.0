From: Harald Welte <laforge@netfilter.org>
Subject: Re: Redirect problem in bridge
Date: Wed, 23 Jul 2003 14:15:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030723121548.GM3733@naboo>
References: <00c301c3502c$f6cae120$33c909c0@rsaxena>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sl5MdczEF/OU2Miu"
Cc: NetFilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ravi Saxena <rsaxena@networkprograms.com>
Content-Disposition: inline
In-Reply-To: <00c301c3502c$f6cae120$33c909c0@rsaxena>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--sl5MdczEF/OU2Miu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2003 at 02:10:52PM +0530, Ravi Saxena wrote:
> BlankHello All,
>=20
> I'm using bridge-nf-0.0.7-against-2.4.19.diff patch for bridge firewallin=
g.
>=20
> But I am facing a problem in adding this rule.
>=20
> iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 80=
80
> it always give error as invalid arguments.
>=20
> Can anyone suggest the reason.

you most likely just need to recompile your iptables program.

> regards
> Ravi Saxena

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sl5MdczEF/OU2Miu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/HnxzXaXGVTD0i/8RAgplAKCV5Fyk8wVzSgYgXvKgXqWfBJDVNACfWJ90
vSsi9Vb4g4/HTOSQz+DkVLw=
=GU45
-----END PGP SIGNATURE-----

--sl5MdczEF/OU2Miu--
