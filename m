From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables-save dump option
Date: Thu, 19 Aug 2004 12:14:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819101422.GE3921@sunbeam.de.gnumonks.org>
References: <20040817204256.GC23109@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3C3ZMpwu25Mtx3MN"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20040817204256.GC23109@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3C3ZMpwu25Mtx3MN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2004 at 10:42:56PM +0200, Herve Eychenne wrote:
>  Hi,
>=20
> Can someone tell me (Harald ?) what is the interest of the -d (--dump)
> option in iptables-save? I don't see it, as it does the same as
> iptables-save without any arguments... (and it is undocumented in the
> manpage)

The initial idea was to make a binary dump instead of the ASCII parsed
save file format.  This was never implemented though (and I don't think
it's worth adding it anymore).

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

--3C3ZMpwu25Mtx3MN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJH1+XaXGVTD0i/8RAvjoAJ0dy/KNlOtHqJ//wlvfZ+cUSGAwjwCgrkbE
1+efs5QXDMP/CZ28rw4Eo38=
=mElu
-----END PGP SIGNATURE-----

--3C3ZMpwu25Mtx3MN--
