From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Amanda conntrack/nat module update
Date: Sat, 2 Nov 2002 19:04:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102190448.T8635@sunbeam.de.gnumonks.org>
References: <20021101232337.GD16306@pc.ilinx> <1036244727.28830.66.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wFODXFufd9YTJ4hK"
Cc: netfilter@interlinx.bc.ca,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1036244727.28830.66.camel@tux>; from gandalf@wlug.westbo.se on Sat, Nov 02, 2002 at 02:45:27PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wFODXFufd9YTJ4hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2002 at 02:45:27PM +0100, Martin Josefsson wrote:
> On Sat, 2002-11-02 at 00:23, netfilter@interlinx.bc.ca wrote:
> > Hello Harald and friends,
> >=20
> > Please find attached an update patch to patch-o-matic for my Amanda
> > protocol conntrack/nat helper.  This patch corrects a minor error in
> > the Config.in indentation as well as, and more importantly, lengthens
> > the timeout for the master Amanda connection from the default UDP
> > stream timeout (normally 180 seconds) to 300 seconds.
> =20
> > I would be most appreciative if you could apply this patch to
> > patch-o-matic at your earliest convenience.
>=20
> Applied,

thanks, I tried to apply it 30mins later and had to discover that
my CVS was not up-to-date ;)  Sometimes I seem to forget that there is some=
body
else taking care of patch-o-matic now.  Thanks again.

> /Martin
=20

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--wFODXFufd9YTJ4hK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xBPAXaXGVTD0i/8RAh+EAKCsBhCQNqjtZvwj1BplQukoJQTo6gCfeQUR
fSVBjrPW7xDr5wU+oqR1Ybo=
=dyd3
-----END PGP SIGNATURE-----

--wFODXFufd9YTJ4hK--
