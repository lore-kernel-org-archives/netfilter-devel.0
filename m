From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Some parameter fixes for ip(6)tables.c
Date: Sun, 10 Apr 2005 22:43:05 +0200
Message-ID: <20050410204305.GR9155@sunbeam.de.gnumonks.org>
References: <424144D6.2090107@outerspace.dyndns.org>
	<20050401063500.GM19835@sunbeam.de.gnumonks.org>
	<425866CC.3020809@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9Vkydzf3ccYCnyC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <425866CC.3020809@outerspace.dyndns.org>
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


--m9Vkydzf3ccYCnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 09, 2005 at 11:35:40PM +0000, Jonas Berlin wrote:

> Quoting Harald Welte on 2005-04-01 06:35 UTC:
>=20
> |> 2. the commands_v_options two-dimensional array lacks a column for the
> |> -c flag. I tried to deduce feasible values, please look at them before
> |> accepting :)
> |>
> |> 3. the inverse_for_options array lacks a row for the -c flag. By
> |> looking at the code I figured it does not allow the "!" inversion
> |> option, so I constructed the line accordingly.
> |
> |
> | erm, do you find something that actually implements CMD_CHECK?
>=20
> No I didn't..
>=20
> What would you like me to do? Should I improve my patch to take out
> CMD_CHECK and adjust the bit masks accordingly?=20

just remove CMD_CHECK and anything relating to it.

> Unless I got something
> wrong, my fix 3 above wasn't related to CMD_CHECK in any way..?

sorry, my mistake.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--m9Vkydzf3ccYCnyC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWY/ZXaXGVTD0i/8RAkDlAJsHjQ3qohd7zjkWkGcjOu9stlk9SACeIVHU
oLPVJvold3kUbExr3Edzyhk=
=jbqt
-----END PGP SIGNATURE-----

--m9Vkydzf3ccYCnyC--
