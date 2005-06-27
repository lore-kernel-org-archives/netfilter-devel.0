From: Harald Welte <laforge@netfilter.org>
Subject: Re: RSH helper concurrent sessions fix
Date: Mon, 27 Jun 2005 11:06:37 +0200
Message-ID: <20050627090637.GD19928@sunbeam.de.gnumonks.org>
References: <JBEOIOMFMBOPMPLFDIALKENHCJAA.aberle@infotech.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="72pTQ1Q5L511SwPT"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sebastian Aberle <aberle@infotech.de>
Content-Disposition: inline
In-Reply-To: <JBEOIOMFMBOPMPLFDIALKENHCJAA.aberle@infotech.de>
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


--72pTQ1Q5L511SwPT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2005 at 05:22:00PM +0200, Sebastian Aberle wrote:
> Hi,
>=20
> here is a fix for a small error I discovered in the RSH conntrack
> helper when trying to establish multiple concurrent sessions to a host
> (working for me, at least).

Thanks for your patch.

It's up to Jozsef (Cc) to comment (and ACK/NACK) on this, he's the author of
the rsh helper.

Jozsef?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--72pTQ1Q5L511SwPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv8GdXaXGVTD0i/8RAo62AJ4sh7D736W3iKbDLtCRkTQRI7lLyQCfWEDO
7TtgAtvOzLlhqRFkt4Df3eU=
=H6IC
-----END PGP SIGNATURE-----

--72pTQ1Q5L511SwPT--
