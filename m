From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_time: module revision fixup
Date: Tue, 1 Feb 2005 11:45:46 +0100
Message-ID: <20050201104546.GW6878@sunbeam.de.gnumonks.org>
References: <20050107022117.GB26992@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mdGUb96ZZNqpHCXz"
Cc: netfilter-devel@lists.netfilter.org, Fabrice MARIE <fabrice@netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Content-Disposition: inline
In-Reply-To: <20050107022117.GB26992@ti64.telemetry-investments.com>
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


--mdGUb96ZZNqpHCXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 06, 2005 at 09:21:17PM -0500, Bill Rugolsky Jr. wrote:
> Use C99 initializers to allow for new match revision field.
> Update function parameter list to match the corresponding function protot=
ype.
>=20
> Signed-off-by: Bill Rugolsky <brugolsky@telemetry-investments.com>

Thanks, I committed your changes to svn. Please note that I've created a
new linux-2.6 specific directory for them. (Revision 3624)
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mdGUb96ZZNqpHCXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/13aXaXGVTD0i/8RAv/FAJ4tPRtOMFDzMjjXAbEhMeQe1LV0lwCaAliI
Y2TWv6pcxaombTxZbWlnj5w=
=BHtu
-----END PGP SIGNATURE-----

--mdGUb96ZZNqpHCXz--
