From: Harald Welte <laforge@netfilter.org>
Subject: Re: Suggestion regarding masquerading / action when the link goes down
Date: Fri, 20 Jun 2003 10:15:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030620081518.GL26270@sunbeam.de.gnumonks.org>
References: <005001c32c4d$6e2c3240$7b00a8c0@chr> <20030619121154.GI20125@sunbeam.de.gnumonks.org> <3EF256E0.3090707@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8SdtHY/0P4yzaavF"
Cc: Christian Morgenstern <C.Morgenstern@gmx.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3EF256E0.3090707@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8SdtHY/0P4yzaavF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2003 at 10:35:44AM +1000, Philip Craig wrote:
>=20
> Shouldn't this be a new option for the MASQUERADE target, so that it
> can be set per rule rather than as a global setting for all rules?
>=20
> Alternatively, you could change the SNAT target so that it doesn't
> require an address to be specified.

Both of those ideas seem impractical.  The first would require this
choice to be saved together with the rule - that would increase the
targinfo structure size and thus render it incompatible with older
MASQUERADE targets.  The second ignores the fact that SNAT is a builtin
nat target of the nat core, which has no idea at all about interfaces.

> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
> SnapGear - Custom Embedded Solutions and Security Appliances

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8SdtHY/0P4yzaavF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+8sKWXaXGVTD0i/8RAgrhAJ4jXmIt6oxrod1y8AkuuKbQQ+BANgCghogf
XU1a37T6WSIlsULcRpCaIqU=
=oA7B
-----END PGP SIGNATURE-----

--8SdtHY/0P4yzaavF--
