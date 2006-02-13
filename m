From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Mon, 13 Feb 2006 12:20:28 +0100
Message-ID: <20060213112028.GU4601@sunbeam.de.gnumonks.org>
References: <43EFF1F0.1090701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l4+/aJnPlhOv5JVj"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <43EFF1F0.1090701@netfilter.org>
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


--l4+/aJnPlhOv5JVj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2006 at 03:41:52AM +0100, Pablo Neira Ayuso wrote:
> [NF_CONNTRACK] first conntrack ID must be 1 not 2
>=20
> The first conntrack ID must be 1. If a new conntrack is created, the
> general ID counter must be post-incremented instead pre-incremented
> since [ip|nf]_conntrack_next_id is initialized to 1. Same applies for
> expectations.

looks clean to me.  Interesting question though: Does it matter whether
we start with 1 or 2?  Am I missing something?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--l4+/aJnPlhOv5JVj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8Gt8XaXGVTD0i/8RAgMZAJ9la70HYaqNQKgPgbl5fiPM1ciiQwCeL7lv
jTQELrlEL8hDUH4Zu7B8Vls=
=90uf
-----END PGP SIGNATURE-----

--l4+/aJnPlhOv5JVj--
