From: Harald Welte <laforge@netfilter.org>
Subject: Re: Can't checkout netfilter/userspace from CVS (???)
Date: Sat, 14 Feb 2004 21:46:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214204623.GY7756@sunbeam.de.gnumonks.org>
References: <402C1F8E.4060500@vialink.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V6LUty14dADzmtgW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Juan Carlos Castro y Castro <jcastro@vialink.com.br>
Content-Disposition: inline
In-Reply-To: <402C1F8E.4060500@vialink.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--V6LUty14dADzmtgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2004 at 10:51:26PM -0200, Juan Carlos Castro y Castro wrote:
> netfilter-patch-o-matic checks out OK, but...
>=20
> root@jcwork:/usr/src/cvs>cvs -d=20
> :pserver:cvs:cvs@pserver.netfilter.org:/cvspublic co netfilter/userspace
> cvs server: warning: new-born netfilter/userspace has disappeared

it's now called 'iptables' (cvs
-d:pserver:cvs:cvs@pserver.netfilter.org:/cvspublic co iptables)

I have to update the webpage to reflect this reorganization.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--V6LUty14dADzmtgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALokfXaXGVTD0i/8RAp2FAJ4odl9E4SaB6UkizOSMr3ZMJpYLZwCdFF1u
SNosmt6f4bJtpm9iVVwPaac=
=gNYF
-----END PGP SIGNATURE-----

--V6LUty14dADzmtgW--
