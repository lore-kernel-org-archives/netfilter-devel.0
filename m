From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Fri, 31 Jan 2003 11:16:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131101645.GC9073@naboo.cybercafe42>
References: <20030128234654.29362.28104.Mailman@kashyyyk> <15927.22044.618895.821767@isis.cs3-inc.com> <20030129090945.A880@linux.karinthy.hu> <15927.62265.746506.765623@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Cc: Laszlo Valko <valko@linux.karinthy.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15927.62265.746506.765623@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2003 at 07:28:57AM -0800, Don Cohen wrote:
> Laszlo Valko writes:
>  > Hi Don!
>  >=20
>  > May I ask you to change those u_int8_t's to u_int32_t in=20
>  > struct ipt_u32_location_element, struct ipt_u32_value_element,
>  > struct ipt_u32_test, struct ipt_u32?
>  >=20
>  > There's really no point in making those integers 1 byte long when every
>  > second field is (a multiple of) 4 byte long and thus will eventually g=
et
>  > padded during compilation. It just complicates matters.
>=20
> Now that I've dumped it in Harald's lap I guess it's up to him.
> But I don't see how it complicates matters.

I also disagree with Laszlo. We don't need cross-architecture
compatibility of those structures anyway.=20

>  > > +struct ipt_u32_test
>  > > +{
>  > > +	u_int8_t nnums;
>  > > +	struct ipt_u32_location_element location[U32MAXSIZE+1];
>  > > +	u_int8_t nvalues;
>  > > +	struct ipt_u32_value_element value[U32MAXSIZE+1];
>  > > +};
>=20
> In this one case at least it might help to put the two 8's together,
> right?=20

yes, it should. depending on compiler and archtiecture, though.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Ok0NXaXGVTD0i/8RAiBKAJ0V0BCXW153HMnnNVMRLR/v4HwjUQCgjBEU
EqodBmFUAufClbmB56RDh68=
=J424
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
