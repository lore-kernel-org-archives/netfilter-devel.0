From: Alexander Samad <alex@samad.com.au>
Subject: Re: OR with the --set-mark flag
Date: Wed, 4 Aug 2004 14:10:02 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040804041002.GJ21117@samad.com.au>
References: <20040803151102.30082.31199.Mailman@vishnu.netfilter.org> <41101528.6080609@metavize.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <41101528.6080609@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I believe there is a patch in pom that allow this

but it patches iptables as well as the kernel

Alex

On Tue, Aug 03, 2004 at 03:43:52PM -0700, Robert Scott wrote:
> It appears that using the MARK target "--set-mark <value>" option always=
=20
> overwrites whatever mark is already there with <value>.  Is there a way=
=20
> to perform an OR operation with what is already there?
>=20
> --rb
>=20
>=20

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBEGGakZz88chpJ2MRAlXoAKCkcIAClqzGQahH6WbuqVyKaliyDACfSmkA
avHc4ePo8ObNc0d9lnSqwXo=
=c3rb
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
