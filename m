From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Some parameter fixes for ip(6)tables.c
Date: Fri, 1 Apr 2005 08:35:00 +0200
Message-ID: <20050401063500.GM19835@sunbeam.de.gnumonks.org>
References: <424144D6.2090107@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ShzQXCswyqjgWi6k"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <424144D6.2090107@outerspace.dyndns.org>
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


--ShzQXCswyqjgWi6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 23, 2005 at 12:28:38PM +0200, Jonas Berlin wrote:

> 1. the optflags array contains a '3' for the OPT_LINENUMBERS entry while
> everywhere else '0' is used. Thus the fix changes it

committed that change, thanks.

> 2. the commands_v_options two-dimensional array lacks a column for the -c
> flag. I tried to deduce feasible values, please look at them before accep=
ting=20
> :)
>=20
> 3. the inverse_for_options array lacks a row for the -c flag. By looking =
at
> the code I figured it does not allow the "!" inversion option, so I
> constructed the line accordingly.

erm, do you find something that actually implements CMD_CHECK? =20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ShzQXCswyqjgWi6k
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTOuUXaXGVTD0i/8RAs8wAJ9DUJAjB69bmXULRBRLYTGd0/SHygCgqpz6
miLP4BbcgrWx/2Wqizf1J6U=
=TLxs
-----END PGP SIGNATURE-----

--ShzQXCswyqjgWi6k--
