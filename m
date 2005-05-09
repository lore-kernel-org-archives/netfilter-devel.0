From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables-batch 2nd try
Date: Mon, 9 May 2005 11:02:44 +0200
Message-ID: <20050509090244.GD30482@sunbeam.de.gnumonks.org>
References: <20050421122008.GA22032@suse.de> <426BC783.3030603@trash.net>
	<20050427125808.GA16169@suse.de>
	<20050506114151.GJ30482@sunbeam.de.gnumonks.org>
	<20050509085603.GA12173@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H921gYJRPBFtu+nv"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050509085603.GA12173@suse.de>
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


--H921gYJRPBFtu+nv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2005 at 10:56:03AM +0200, Ludwig Nussel wrote:
>=20
> > My main objective is that the functionality between iptables-restore and
> > iptables-batch is pretty much the same.  I think either a converter
> > before iptables-restore, or modifications to iptables-restore would be a
> > better way.
>=20
> There isn't much code to share between iptables-restore and
> iptables-batch. Although the functionality is similar they work
> differently.
=20
The question would then rather be: why is there no code share since the
functionality is similar? ;)

I'm honestly interested in the technical reasons. =20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--H921gYJRPBFtu+nv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCfyc0XaXGVTD0i/8RAkE9AKC01oSf/SmBu3xOF1zUzr13rwFNxwCgoGOP
xRfnMr5IiSxLO1CrG57nvpM=
=yWPj
-----END PGP SIGNATURE-----

--H921gYJRPBFtu+nv--
