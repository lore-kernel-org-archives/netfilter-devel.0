From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH]: fix all iptables problems with '!' (hopefully)
Date: Tue, 7 Jan 2003 18:15:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107171526.GL1353@sunbeam.de.gnumonks.org>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int> <3E193B0E.9030602@trash.net> <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr> <3E19A1D8.7080605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8cpS+6Cx+xtICsjy"
Cc: Costa Tsaousis <costa@tsaousis.gr>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E19A1D8.7080605@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8cpS+6Cx+xtICsjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 04:33:44PM +0100, Patrick McHardy wrote:
> In fact ! is used in many matches in a non-boolean context.
> After the patch is applied, both it always possible
> (! --uid-owner xxx / --uid-owner ! xxx).
> It would still be nice to have the helptexts unified concerning
> the use of '!', i think.

This is why I'm still unsure whether to apply your patch or not.

I'd rather like to enforce one unique syntax than offering two different
options giving the same result (and possibly causing confusion with the
user).

> Regards,
> Patrick

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--8cpS+6Cx+xtICsjy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GwsuXaXGVTD0i/8RAu85AKChBdkNICGK8Fog1S70zeVTxw2bFQCgkEVL
YvvCQ6x+kouvqX/6pBZ+Yb4=
=pLOA
-----END PGP SIGNATURE-----

--8cpS+6Cx+xtICsjy--
