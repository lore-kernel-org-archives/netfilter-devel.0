From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Amanda conntrack/nat module update
Date: Sat, 2 Nov 2002 15:27:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102152747.L8635@sunbeam.de.gnumonks.org>
References: <20021101232337.GD16306@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pbf06CWejC5c8J2q"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021101232337.GD16306@pc.ilinx>; from netfilter@interlinx.bc.ca on Fri, Nov 01, 2002 at 06:23:37PM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pbf06CWejC5c8J2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2002 at 06:23:37PM -0500, netfilter@interlinx.bc.ca wrote:
> Hello Harald and friends,
>=20
> Please find attached an update patch to patch-o-matic for my Amanda
> protocol conntrack/nat helper.  This patch corrects a minor error in
> the Config.in indentation as well as, and more importantly, lengthens
> the timeout for the master Amanda connection from the default UDP
> stream timeout (normally 180 seconds) to 300 seconds.

thanks, patch applied.

> Thanx,
> b.
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--pbf06CWejC5c8J2q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9w+DjXaXGVTD0i/8RAsitAJ9AEwBntqx5uX7qt1mpNOGLBI/CuQCgkovI
nth25ArwjlaOmt2huzZQ0w4=
=itE3
-----END PGP SIGNATURE-----

--pbf06CWejC5c8J2q--
