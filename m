From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH][TRIVIAL] remove unused callback in ip6t_ipv6header.c
Date: Fri, 12 Sep 2003 23:39:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912213909.GJ4398@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.51.0309101716380.14549@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwgQ89ZNnFUwFHTC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0309101716380.14549@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rwgQ89ZNnFUwFHTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2003 at 05:18:48PM +0200, Maciej Soltysiak wrote:
> Hi,
>=20
> this patch adds a patch to patch-o-matic/pedning directory that
> removes an unused destroy callback in ip6_ipv6header.c

thanks, applying to CVS now.

> Regards,
> Maciej
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rwgQ89ZNnFUwFHTC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/Yjz1XaXGVTD0i/8RAjl/AJ4+BoF/xCTWq2xFKPg9xbyreb9DTACglKa5
I9jsbGvhNzZZXHL+CjkzIrs=
=KOUj
-----END PGP SIGNATURE-----

--rwgQ89ZNnFUwFHTC--
