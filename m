From: Harald Welte <laforge@netfilter.org>
Subject: Re: helper and handling IPv6 fragments
Date: Mon, 21 Feb 2005 10:01:05 +0100
Message-ID: <20050221090105.GX29256@sunbeam.de.gnumonks.org>
References: <200502161132.19312.michal@rokos.info>
	<200502171520.j1HFKH6U029405@toshiba.co.jp>
	<20050219185028.GN29256@sunbeam.de.gnumonks.org>
	<200502210416.j1L4Gt6e026758@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200502210416.j1L4Gt6e026758@toshiba.co.jp>
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


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 21, 2005 at 01:16:55PM +0900, Yasuyuki KOZAKAI wrote:
> > I'm not sure if I understand this proposal correctly. Do you suggest to
> > set the nfcache bit of the reassembled clone as soon as the first
> > fragment has passed the helper (and returned NF_ACCEPT) ?
>=20
> Yes, that's right. In the current code, no one touches the nfcache bit
> of reassembled clone. So we can utilize it for nf_conntrack.

Ok, I agree we should solve it this way.  Thanks for your clarification.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGaNRXaXGVTD0i/8RAsNoAKCghvFJEOaBFFBdL/fIfiuO9uwFygCfTgaM
M6Ys+uzgBQuSDPltnzeYChc=
=6OIb
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
