From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] datalen variable unused in ftp helper.
Date: Wed, 17 Mar 2004 15:10:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040317141005.GE21899@sunbeam.de.gnumonks.org>
References: <404E0A4D.3070303@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AjmyJqqohANyBN/e"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <404E0A4D.3070303@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 09, 2004 at 07:17:49PM +0100, Pablo Neira wrote:
> Hi,
>=20
> I found that the variable datalen in the ftp helper is sometimes used=20
> and sometimes not. Attached to this email the patch to fix this.
>=20
> regards,
> Pablo

Pablo, I seem to loose track of your dozens of patches.  Could you
please re-send all patches that do not yet show up in a current 2.6.x
tree?   I'll then review and submit all of them in one 'flush'

Thanks again.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AjmyJqqohANyBN/e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWFw9XaXGVTD0i/8RAj+IAJ0RcHRgUaxeeU7axZmlmRJZL0j76ACfbZRf
Dn93MmdP1U9nc9Ai1idyf/c=
=WMlu
-----END PGP SIGNATURE-----

--AjmyJqqohANyBN/e--
