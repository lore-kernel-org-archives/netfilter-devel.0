From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] document multiport invert option
Date: Thu, 09 Sep 2004 12:07:23 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1094724443.8900.2.camel@localhost.localdomain>
References: <20040908233535.GA17162@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-K0osncvELbk3Lqm2WmRQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040908233535.GA17162@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-K0osncvELbk3Lqm2WmRQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-09-09 at 01:35, Phil Oester wrote:
> The man/-h pages for multiport don't document that you can use
> inversion.  This can be confusing, since multiport uses '! --port x'
> instead of '--dport ! x' like tcp/udp.
>=20
> This closes bugzilla #143

I believe neither multiport or mport has invert support, they don't
complain when you add a inverted rule but the resulting rule won't be
inverted so I'm not going to apply this patch.

--=20
/Martin

--=-K0osncvELbk3Lqm2WmRQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD4DBQBBQCtbWm2vlfa207ERAnmQAKCB953vDv7Cdd2VglrOkZY4yZfj1ACYguOP
nW8ifw407uGcm1v5BK/gRQ==
=CK3o
-----END PGP SIGNATURE-----

--=-K0osncvELbk3Lqm2WmRQ--
