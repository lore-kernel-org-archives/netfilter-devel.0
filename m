From: Harald Welte <laforge@netfilter.org>
Subject: Re: about install iptables_1.2.9
Date: Sat, 14 Feb 2004 21:58:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214205855.GA7756@sunbeam.de.gnumonks.org>
References: <002e01c409bf$04029c60$831e708c@yeta>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="alCHniwhwUTljuKz"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yeta <yeta@orchid.ee.ntu.edu.tw>
Content-Disposition: inline
In-Reply-To: <002e01c409bf$04029c60$831e708c@yeta>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--alCHniwhwUTljuKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 14, 2004 at 08:22:28PM +0800, yeta wrote:
>=20
>=20
> hi.=20
> I have try to install iptables_1.2.9. But it has some error messages,
> they seems similar problems.

This looks strange.  libipt_conntrack.c includes ip_conntrack.h and
ip_conntrack_tuple.h.  They both contain the IPS_* and IP_CT_DIR_* macro
definitions.

So I cannot see how this coulde possibly happen.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--alCHniwhwUTljuKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALowPXaXGVTD0i/8RAsCaAKCXaN5WzfUde5GOpRB/bS74+IHrfgCfb0Qn
Wo3LpND8CKAdc86vv3hAogk=
=xa5u
-----END PGP SIGNATURE-----

--alCHniwhwUTljuKz--
