From: Harald Welte <laforge@netfilter.org>
Subject: Re: pkttables ?
Date: Fri, 12 Sep 2003 23:29:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912212954.GH4398@obroa-skai.de.gnumonks.org>
References: <20030909223617.GB862@c3.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhjHhnbe5PrRcwjY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Illes Marton <illes@c3.hu>
Content-Disposition: inline
In-Reply-To: <20030909223617.GB862@c3.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mhjHhnbe5PrRcwjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2003 at 12:36:17AM +0200, Illes Marton wrote:
> Hi All!
>=20
> I was just wondering where could I find pkttables, cause I am really
> interested in it!
>=20
> Is it available somewhere, or when will it be available?

I'm currently trying to re-work it based on the changes we've discussed
at the workshop.  Especially the TLV encoding has made some
architectural changes necessarry.

Also, I'm now merging with 2.6.x - all previous code was still 2.4.x
based.

I'll publish it as soon I have some code that at least compiles.

> thanks,
> Marton

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mhjHhnbe5PrRcwjY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/YjrSXaXGVTD0i/8RAgp+AKCIcPOunqYcSADVHwrt3Z38c3cjjQCZAcKo
bI2mhMH2H5+/54rQmh5AFF8=
=SoDC
-----END PGP SIGNATURE-----

--mhjHhnbe5PrRcwjY--
