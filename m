From: netfilter@interlinx.bc.ca
Subject: Re: [PATCH] Connection tracking/NAT for Amanda
Date: Wed, 18 Sep 2002 11:49:01 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918154901.GD4059@pc.ilinx>
References: <20020913201501.GD2689@pc.ilinx> <20020915132946.K3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20020915132946.K3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2002 at 01:29:46PM +0200, Harald Welte wrote:
> On Fri, Sep 13, 2002 at 04:15:01PM -0400, netfilter@interlinx.bc.ca wrote:
> > Please find attached a patch (to p-o-m) which adds both connection
> > tracking and NAT support for the Amanda backup protocol.
> >=20
>=20
> thanks, applied to patch-o-matic.

Thanks Harald.  Please do note, that the patch you applied does depend
on a previous patch I sent that I did not see any comment on; whether
it was applied or not or otherwise.  I don't think it was applied.
The message I sent previously with the patch can be found at:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/009012.html

If you don't like the ip_nat_mangle_multi_udp_packet() function it can
be removed from the patch, but the rest is needed.

Thanx,
b.

--=20
Brian J. Murrell

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9iKBtl3EQlGLyuXARAnG1AJ9YZTsFmN2A/6q71Ne+Lig6TKITHQCePlxz
dh5FR0wh/WxmuY0ti9FcUhU=
=kDi7
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
