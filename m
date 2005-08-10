From: Harald Welte <laforge@netfilter.org>
Subject: Re: libnfnetlink_queue API
Date: Wed, 10 Aug 2005 17:55:47 +0200
Message-ID: <20050810155546.GB4059@rama.de.gnumonks.org>
References: <1123628597.3680.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	vincent@inl.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eleblond@inl.fr>
Content-Disposition: inline
In-Reply-To: <1123628597.3680.7.camel@localhost.localdomain>
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


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2005 at 01:03:17AM +0200, Eric Leblond wrote:
> Hi,
>=20
> I've begin the port of NuFW to libnfnetlink_queue. I thus have some
> remarks on the current API. It lacks a way to cleanly "parse" the
> message. I think you point it in a previous mail.=20

yes, it's still incomplete.  Since I don't know the applications too
well, I didn't add that part.

> The idea of the callback is cool.

thanks ;)

> Vincent and I are really interested in defining and coding the API for
> message parsing. I think NuFW has almost all the problematics required
> to be a good benchmark on API definition.

sure, go ahead.  Send patches (or written proposals).=20

> Is there already somebody working on it ?=20

No, not that I'm aware of.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC+iOCXaXGVTD0i/8RAvCSAKCqe0oUvqHgl/E0nGM9T1FWF/Hw2QCeOISS
NVUP+3nNWT3vV710dfxozTo=
=lU61
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
