From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Thu, 29 Jan 2004 20:05:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040129190514.GN11761@sunbeam.de.gnumonks.org>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <pan.2004.01.28.10.30.03.44921@dungeon.inka.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gWPeGsYce+mZStT1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andreas Jellinghaus <aj@dungeon.inka.de>
Content-Disposition: inline
In-Reply-To: <pan.2004.01.28.10.30.03.44921@dungeon.inka.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gWPeGsYce+mZStT1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2004 at 11:30:04AM +0100, Andreas Jellinghaus wrote:
> ah_output to ah_output_finish and a new ah_output
> with:
> > +	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, skb->dev, ah_dummyde=
v,
> > +		       ah_output_finish);
>=20
> please add the same to ipip, ipgre and friends, to keep them
> in sync? what about ipv6?

yes, please wait until we have implemented in one case and proven that
it does what it is supposed to do.. after that we will sync up.

> Andreas
> p.s. I hope the idea with the new hook POSTENCAP died?

yes.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gWPeGsYce+mZStT1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAGVlqXaXGVTD0i/8RAhVTAJ9WeL/Wed/AfsUqr2pXVzE7Y72JQwCfQH8b
TU+3OyGnnUURwvy6v3rz7aU=
=lHQU
-----END PGP SIGNATURE-----

--gWPeGsYce+mZStT1--
