From: Harald Welte <laforge@netfilter.org>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 5 Jan 2004 13:03:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040105120332.GJ830@obroa-skai.de.gnumonks.org>
References: <20040101163627.GD3530@obroa-skai.de.gnumonks.org> <Pine.LNX.4.33.0401051150120.15063-100000@blackhole.kfki.hu> <20040105115533.GK1133@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mGCtrYeZ202LI9ZG"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20040105115533.GK1133@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mGCtrYeZ202LI9ZG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2004 at 12:55:33PM +0100, Herve Eychenne wrote:
> I think the convention of Debian Packages files with a line like
> Depends: zope, python2.1-popy (>=3D 2.0.8), python2.1-popy (<< 2.0.9)
> would just be perfect.
> I just hope there is some kind of out-of-the-box perl module which
> would deal with these kinds of versioning issues (handle parsing,
> compare versions, resolve recursive dependencies, etc).

I wish there was.  At least my last search of the CPAN didn't reveal
anything like that.  If anyone knows such a module, please send me a
link.

> That would imply versioning of patches, which would be a good
> thing.

no.  Currently we are just talking about dependencies of a patch towards
an installed kernel version.

Having one patch depend on a particular version of another patch is
something different - and I don't see a way to implement that without=20
storing that version information somewhere in the kernel tree.

>  Herve

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mGCtrYeZ202LI9ZG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+VKUXaXGVTD0i/8RAo3MAJ44gmqGIeeFHVdpEQDz1E3N3bmEWQCfWHzC
KKurGWQ1jBVvsGa23ZX2JL0=
=pHyN
-----END PGP SIGNATURE-----

--mGCtrYeZ202LI9ZG--
