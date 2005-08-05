From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Remove ip_conntrack <-> nfnetlink dependency
Date: Fri, 5 Aug 2005 21:26:05 +0200
Message-ID: <20050805192605.GJ13345@rama.de.gnumonks.org>
References: <42F2B521.2050408@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42F2B521.2050408@eurodev.net>
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


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 02:38:57AM +0200, Pablo Neira wrote:
> @Patrick: This patch is related to one of the patches that you submitted =
some=20
> time ago.
>=20
> Currently there's a dependency between nfnetlink and ip_conntrack. If the=
=20
> second if loaded, the first will be too because needs ip_conntrack needs =
the=20
> symbol __nfa_fill.
>=20
> The following patch resolves such dependency by inlining __nfa_fill, I do=
n't=20
> know if this solution is the best though since this could increase the
> size of the ip_conntrack_netlink binary. Anyway we could leave it that
> way until the generic netlink layer comes (I mean RTA_* and NFA_*
> unification).

I would rather put __nfa_fill() into an #ifdef CONFIG_NETFILTER_NETLINK
section of net/core/netfilter.c, together with a nice comment why it has
to be there and cannot be put in net/netfilter/nfnetlink.c

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC871MXaXGVTD0i/8RAliFAJ9vGRH0fIWgznjDLjeBRj3cJuWQegCfc+d7
19Y28fpWy/tIX0pg/FdPCPE=
=Ht8A
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
