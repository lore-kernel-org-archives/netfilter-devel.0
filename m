From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Change masquerade code to use first IP address of
Date: Fri, 22 Oct 2004 12:52:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041022105203.GB3551@sunbeam.de.gnumonks.org>
References: <4175FCF2.E494D.3F15@iris2.directnic.com>
	<53512.217.169.232.210.1098252363.squirrel@217.169.232.210>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kUmo4NyTJbuJZ752"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ferry Huberts <ferry@Hupie.com>
Content-Disposition: inline
In-Reply-To: <53512.217.169.232.210.1098252363.squirrel@217.169.232.210>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--kUmo4NyTJbuJZ752
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2004 at 08:06:03AM +0200, Ferry Huberts wrote:
> In netfilter-devel Digest, Vol 3, Issue 20
>=20
> In response to Rusty's message
> Subject: [PATCH] Change masquerade code to use first IP address of
>         interface.
>=20
> I scream :-)
>=20
> I have an application that has multiple DHCP assigned addresses on an
> interface and I would like to tell netfilter to which interface
> address/name (eth0:0 or eth0 or eth0:1) it should MASQ.

MASQUERADE is and has always only been for the common [stupid]
dialup-with-dynamic-address case.

'eth0:0', etc. are _NOT_ interfaces.  They are a backwards compatibility
kludge to make stupid old bsd-like userspace tools [and sysadmis] work.
In reality, any interface can have multiple addresses, even without any
of those :X pseudo-devices.

> Is it possible to implement this as an option to the MASQ module?

I don't see how, sorry.

> Ferry Huberts

p.s.: Please don't full-quote.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kUmo4NyTJbuJZ752
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBeOZTXaXGVTD0i/8RAoMZAKCUDNMe2eJ39Z68IKEprHohlI8THwCfbCI7
hfFHe7UgoCgTMeIA2EeITs4=
=Et3o
-----END PGP SIGNATURE-----

--kUmo4NyTJbuJZ752--
