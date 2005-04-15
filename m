From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] goto update so that iptables-save and iptables -L work
	correctly
Date: Fri, 15 Apr 2005 11:32:18 +0200
Message-ID: <20050415093218.GF25433@sunbeam.de.gnumonks.org>
References: <425C68C4.5000304@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZGTJogoWKdbG5sF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <425C68C4.5000304@outerspace.dyndns.org>
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


--VZGTJogoWKdbG5sF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2005 at 12:33:08AM +0000, Jonas Berlin wrote:
> The attached file is meant to go into patch-o-matic-ng/goto/
>=20
> In iptables -L it will show as [goto] in the match extension part (the
> rightmost column). If you think it should be displayed somehow else, I'm
> open to suggestions.

thanks, applied (appended to goto/iptables.patch)
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VZGTJogoWKdbG5sF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCX4oiXaXGVTD0i/8RAsUFAJ49vZDdzgtSyO0ojnIwuuPe/k+nUACePI2v
t6iki5vYu0XmBpUixfoaQZ0=
=b3ux
-----END PGP SIGNATURE-----

--VZGTJogoWKdbG5sF--
