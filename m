From: Alexander Samad <alex@samad.com.au>
Subject: Re: MARK-Operations problems
Date: Thu, 8 Jul 2004 17:18:41 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040708071841.GE16285@samad.com.au>
References: <20040708021802.GL6161@samad.com.au> <Pine.LNX.4.44.0407080852320.16639-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0407080852320.16639-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2004 at 08:57:51AM +0200, Henrik Nordstrom wrote:
> On Thu, 8 Jul 2004, Alexander Samad wrote:
>=20
> > Double checked this and I am pretty sure its pacthed all the right
> > modules are there (the ones that are created with the patch), the
> > strange bit is even a working command -j MARK --set-mark 0x01 fails with
> > the same error, but the unpatched iptables doesn't on the same patches
> > kernel
>=20
> The fact that the unpatched iptables works is a quite clear indication=20
> that the running kernel is not patched, at least not with the MARK=20
> operations patch.
>=20
> When iptables is built it is using the same headers as the kernel. If the=
=20
> headers used when building iptables is different from those used when=20
> building the running kernel then operations on matches/extensions will=20
> fail with size errors.
Okay will rebuild and retest!

>=20
> Another occation when such errors can happen is in special cases on 64-bit
> machines with split personality, with kernel running in 64-bits and
> userspace in 32-bits. This is maybe seen on SPARC-64 and Opteron I think,
> but is not very likely to be the cause of errors with the MARK operation.
>=20
>=20
> Regards
> Henrik
>=20
>=20

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA7PVRkZz88chpJ2MRArcNAKD6mhyUOuAihi654WRgFqU7xYO8PwCgl154
PX9XhiCduE005GyReUVgbzM=
=LINn
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
