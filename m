From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp-conntrack-nat will not apply to 2.4.29 - Workaround
Date: Tue, 1 Feb 2005 14:20:19 +0100
Message-ID: <20050201132019.GH6878@sunbeam.de.gnumonks.org>
References: <41F20482.4090300@hivemynd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IPaxb0UBFekg84Ij"
Cc: netfilter-devel@lists.netfilter.org
To: Stephen Jones <hivemynd@hivemynd.net>
Content-Disposition: inline
In-Reply-To: <41F20482.4090300@hivemynd.net>
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


--IPaxb0UBFekg84Ij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 22, 2005 at 01:45:06AM -0600, Stephen Jones wrote:
> I don't know enough about the structure of the Config.in files to=20
> suggest an appropriate, permanent solution :(

fixed in svn now.

> PS: The nat-reservations patch is incompatible with the=20
> pptp-conntrack-nat patch, perhaps a check in the pom-ng could prevent=20
> people from accidentally "shooting themselves in the foot" with these=20
> two? :)

committed to svn (Reviion 3628)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IPaxb0UBFekg84Ij
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/4ITXaXGVTD0i/8RAjzEAJoCNQde6+gRceksonVDb1GWdVbvxQCfcyLu
K4weXcmRgNtpABEjjHHnLkM=
=qmUm
-----END PGP SIGNATURE-----

--IPaxb0UBFekg84Ij--
