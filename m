From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 15:29:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229142939.GE15558@sunbeam.de.gnumonks.org>
References: <20040229101116.GA10012@pcw.home.local> <Pine.LNX.4.44.0402291121270.25361-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Cc: Willy TARREAU <willy@w.ods.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402291121270.25361-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 29, 2004 at 11:25:06AM +0100, Henrik Nordstrom wrote:
> On Sun, 29 Feb 2004, Willy TARREAU wrote:
>=20
> >   - first, I didn't find how to specify where my iptables sources is
> >     installed, so I had to enter it by hand each time I restarted it.
> >     I did not find any env variable in the perl code, and I must say
> >     that my understanding of perl is, hmmm.. very limited.
>=20
> There is a --path=3D option which can specify the path to both iptables a=
nd=20
> the kernl.

JFYI: I just changed that option to have a more obvious name (and not encode
two path names within a single parameter), as well as documentign it via
'./runme --help'

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAQfdTXaXGVTD0i/8RAk3QAJ44H1ahnEt9A4KINbfclwNcETrywgCfb5sC
nC34krY4H5SnunF6oRjXuF8=
=Ue3S
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
