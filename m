From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Fix definition of NFNL_HEADER_LEN
Date: Mon, 31 Oct 2005 19:50:19 +0100
Message-ID: <20051031185019.GH4479@sunbeam.de.gnumonks.org>
References: <43637289.7020403@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FKwKGrdyenXpCzpq"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43637289.7020403@eurodev.net>
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


--FKwKGrdyenXpCzpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 29, 2005 at 03:00:57PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> The current definition of NFNL_HEADER_LEN isn't OK. NLMSG_LENGTH already =
includes the size of the=20
> netlink header. We have to use NLMSG_ALIGN instead. NLMSG_LENGTH is a bit=
 misleading, I didn't=20
> notice this at first sight either.

thanks, applied.

> BTW, I think that we should add some kind of versioning of libnfnetlink a=
s well, still missing.

yes, although I have to admit I don't [yet] know how symbol versioning
actually works.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FKwKGrdyenXpCzpq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDZmdrXaXGVTD0i/8RApczAJoCWTEMimxWGthVw8/5h8AwcxtCmACeJDbV
CW7KmwKzS83852E81hw6XtM=
=SOmw
-----END PGP SIGNATURE-----

--FKwKGrdyenXpCzpq--
