From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH][MARKCB] Balancing connections betewen a few internet links with HA.
Date: Sun, 21 Sep 2003 16:22:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921142233.GD20986@sunbeam.de.gnumonks.org>
References: <3F68C63E.4070309@zobniow.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciek Zobniow <maciek@zobniow.net>
Content-Disposition: inline
In-Reply-To: <3F68C63E.4070309@zobniow.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2003 at 10:38:22PM +0200, Maciek Zobniow wrote:
> The patch and explanation you can find on
> http://markcb.zobniow.net

Hi!

May I ask, why did you invent a special Target?

You can build a solution based on the CONNMARK target/match, together
with the 'nth' match, the MARK target and policyrouting.

> Best Regards
> Maciej Zobniow

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbQpXaXGVTD0i/8RAkvBAKCPaMsMPieq76yqMOw7/PI6TL0UagCgkl1P
+tkruoszu8vxOBvoG/NoFfs=
=MHj+
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
