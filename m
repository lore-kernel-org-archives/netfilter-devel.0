From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 13:57:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217125710.GA981@sunbeam.de.gnumonks.org>
References: <20040214212340.GC7756@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 10:58:21AM +0100, Jozsef Kadlecsik wrote:
> > One of the first issues that I ran into was the use of vmalloc.
> > Please refer to http://lwn.net/Articles/57800/.
>=20
> Thank you pointing out the article! Let's consider the current version of
> ipset as the first, beta release (as it is :-). Actually, Linus'
> description when vmalloc is valid fits to the vmalloc usage in ipset
> (large arrays allocated), but I'll work on to eliminate it.

I just added another use of vmalloc: dstlimit.  I have to fix that, too.

It would be interesting though, to know how much of a performance
penalty it implies.

> OK!

Ok, I'll reorganize CVS later today.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMg+mXaXGVTD0i/8RArCvAJ4zGVFTmcbCSiw/I/1Y4FDKNaO1wgCfRPga
1FB8WwLmLkqW9Ch62FrakTA=
=1LGc
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
