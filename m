From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to fill a ipt_entry structure to add a rule using iptc_append_entry()
Date: Tue, 22 Jun 2004 17:49:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040622154903.GK24374@sunbeam.de.gnumonks.org>
References: <20040622114755.61596.qmail@web20024.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DmRfE5nj5SdCaIcH"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: babula allu <allubabula@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20040622114755.61596.qmail@web20024.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DmRfE5nj5SdCaIcH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 22, 2004 at 04:47:55AM -0700, babula allu wrote:
> Hi,
>=20
>=20
> I am trying to add a simple rule to INPUT chain using
> iptc_append_entry  but it fails.It says invalid
> argument.
>=20
>  I also tried sending the same ipt_entry structure
> which was returned by the iptc_first_rule API.In this
> case iptc_append _entry doesn't return an error but
> iptables -L doesn't display the rule in the list also.
>=20
> If somebody knows about the cause and solution please
> help me.

1) please read http://www.netfilter.org/contact.html

2) libiptc is not a public interface, we do not encourage neither
   support anybody using it.

> Babula

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DmRfE5nj5SdCaIcH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA2FTvXaXGVTD0i/8RAiyUAJ9ndr4ZZMpRkDTA335KLEQvIZ+5cwCfW+lf
91qQtmzflheLdHaSpQBGkjI=
=2alI
-----END PGP SIGNATURE-----

--DmRfE5nj5SdCaIcH--
