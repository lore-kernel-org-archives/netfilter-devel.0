From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] conntrack-acct "workaround" for 2.6.9+
Date: Sat, 19 Feb 2005 19:52:53 +0100
Message-ID: <20050219185253.GO29256@sunbeam.de.gnumonks.org>
References: <4213E350.8060604@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <jberlin@niksula.hut.fi>
Content-Disposition: inline
In-Reply-To: <4213E350.8060604@niksula.hut.fi>
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


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 17, 2005 at 02:20:32AM +0200, Jonas Berlin wrote:
> patch-o-matic-ng fails to detect that conntrack-acct is already applied=
=20
> (I don't know how it does the detection) and thus fails when trying to=20
> apply it.
>=20
> However, if an empty file called linux-2.6.9.patch is placed in the=20
> conntrack-acct/ directory, everything works just fine.

conntrack-acct shouldn't be in patch-o-matic in the first place.  As we
decided (after conntrack-acct was in) only new features / new modules
should be part of patch-o-matic.

In my current post-2.6.11 patch-o-matic branch in svn, I'm also getting
rid of all those pathes (especially patch-o-matic-ng/conntrack-*)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCF4sEXaXGVTD0i/8RAp7MAKCsMqJDUUdRFPB5SKDJvNZZsFPmcQCcCjac
nzPO3UQM2U68hCEI+rLIiIA=
=HBI0
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
