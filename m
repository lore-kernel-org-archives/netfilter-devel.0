From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] New Target SWITCH
Date: Wed, 2 Oct 2002 15:37:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021002153736.B13233@sunbeam.de.gnumonks.org>
References: <200209241349.g8ODnQI01594@gonzalo.hq.sinectis.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: garana@uolsinectis.com.ar
Content-Disposition: inline
In-Reply-To: <200209241349.g8ODnQI01594@gonzalo.hq.sinectis.com.ar>; from garana@uolsinectis.com.ar on Tue, Sep 24, 2002 at 10:49:26AM -0300
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2002 at 10:49:26AM -0300, garana@uolsinectis.com.ar wrote:
> Hi,
>=20
>   I am developing a new target which should redirect
> packets to a given host, no matter what routing table
> says.

where is the difference between this and the ROUTE target?

And even if there is a difference, the functionality seems to be quite
similar, doesn't it make sense to implement the two functions in a single
target?

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mvagXaXGVTD0i/8RAi46AJ47VWSIhQu55tbeUTv7m37+cr0OgwCgoyL9
tAqOOQvw7pFoLLBUtWGH+sU=
=/V2K
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
