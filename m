From: Harald Welte <laforge@netfilter.org>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Thu, 19 Aug 2004 13:29:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819112910.GN3921@sunbeam.de.gnumonks.org>
References: <1092170081.9955.12.camel@dana.go-nix.ca> <411A1F1D.7080804@trash.net> <1092774843.10908.0.camel@dana.go-nix.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CBkz1G+j/QuiWKyF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Nix N. Nix" <nix@go-nix.ca>
Content-Disposition: inline
In-Reply-To: <1092774843.10908.0.camel@dana.go-nix.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CBkz1G+j/QuiWKyF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2004 at 04:34:03PM -0400, Nix N. Nix wrote:
> On Wed, 2004-08-11 at 09:29, Patrick McHardy wrote:
> > How do filenames which contain a quotation mark look ? I assume the=20
> > quotation
> > marks is escaped ? We should also handle this case.
>=20
> I submitted another patch which addresses this issue in a previous
> message a few days ago, however, I have received no feedback on it.=20
> Could somebody with a few minutes to spare please look it over ?

Those few minutes are exactly the problem.  I'm currently sitting about
14-16h per day in front of my workstation, but still it sometimes takes
a couple fo days until i catch up with netfilter-devel.

> I'm fairly new to this list, so I'm not familiar with the process of
> submitting patches, however, I would like this fix to eventually make it
> into ip_conntrack_irc.c.

Yes, the process is posting patches to this list.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CBkz1G+j/QuiWKyF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJI8GXaXGVTD0i/8RAkuuAJ4gbZcibZGERuEsphShCaB+i0nFogCcDtBs
kIAmMfMTIARvDUZ9UzGYa0Q=
=v/AT
-----END PGP SIGNATURE-----

--CBkz1G+j/QuiWKyF--
