From: Harald Welte <laforge@netfilter.org>
Subject: Re: conntrack and nat questions
Date: Tue, 14 Oct 2003 13:05:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031014110500.GC3752@obroa-skai.de.gnumonks.org>
References: <BAY7-F124K8r6beUzmR00017515@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ?i ???_ <yenzon_hscc@hotmail.com>
Content-Disposition: inline
In-Reply-To: <BAY7-F124K8r6beUzmR00017515@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2003 at 10:27:07AM +0800, ?i ???_ wrote:
> Hi laforge,
>=20
> I am spencer from taiwan.
> After I read your "conntrack+nat how to" documentation, I got a few=20
> questions, hope you could give me advice...^^
>=20
> As we know, conntrack helper has nothing to do with nat helper,=20
> and nat helper will do the things as "nat" does, like changing the IP=20
> address and port. In that case, why we need conntrack?

because connection tracking is about tracking the state of a connection.
only in very rare protocols you can live with _just_ a nat helper.

> If there is a alg without conntrack what fault the alg will get?

This totally depends on the protocol.  if you just need to change ip
addresses (like the SNMP module we have), you don't need conntrack.  As
soon as you have related connections (like ftp data connections), you'll
need a conntrack helper.

> In nat helper, it will call two functions, ip_conntrack_change_expect() a=
nd=20
> ip_nat_setup_info(). What are their purpose?

change_expect() alters the expectation issued by the conntrack heper.

nat_setup_info() set's up the nat bindings for a just-arrived new
related connection (when the expectation was confirmed)

> Thanks. ^^b
> spencer.

Please direct further questions to the netfilter-devel mailinglist, as
indicated on http://netfilter.org/contact.html

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/i9hcXaXGVTD0i/8RArmAAJ4kWRGz09N2J3WUL6xIgSRiLJPleACdGAlw
FLSKhG94ZP/J2v5oEYt/XBU=
=cXhW
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
