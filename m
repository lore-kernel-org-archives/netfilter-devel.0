From: Alexander Samad <alex@samad.com.au>
Subject: Re: IPMARK nfcache
Date: Sun, 30 Oct 2005 16:49:26 +1100
Message-ID: <20051030054926.GD10248@samad.com.au>
References: <20051028221728.GC10248@samad.com.au>
	<Pine.GSO.4.63.0510291849040.28447@galaxy.agh.edu.pl>
	<Pine.GSO.4.63.0510291912370.28447@galaxy.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grzegorz Janoszka <Grzegorz.Janoszka@pro.onet.pl>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.63.0510291912370.28447@galaxy.agh.edu.pl>
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


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 29, 2005 at 07:12:44PM +0200, Grzegorz Janoszka wrote:
> On Sat, 29 Oct 2005, Grzegorz Janoszka wrote:
>=20
> >My IPMARK was based on original MARK target. You can look what has chang=
ed=20
> >in libipt_MARK.c and correct it.
>=20
> http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D2689
>=20
> The patch dedicated to net/ipv4/netfilter/ipt_MARK.c should go to=20
> ipt_IPMARK.c
>=20
> >I don't know if I have to submit a new patch or it will be corrected by=
=20
> >netfilter developers?
>=20
> I suggest you make the changes, can you do it?
Cool, will give it a go!

>=20
> --=20
> Grzegorz Janoszka
>=20

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDZF7mkZz88chpJ2MRArXWAJ4smrnyAW2loMcXA7V2R8DKVA5UMwCfQaIt
inAvxjDppDeuXGV0k3OkBe8=
=mQBs
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--
