From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] IPv6 port of the nth match.
Date: Sat, 3 May 2003 14:56:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030503125626.GB29373@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.51.0304301648010.15553@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0304301648010.15553@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2003 at 04:49:30PM +0200, Maciej Soltysiak wrote:
> Hi,
>=20
> here is a patch to add nth match to ip6tables.
> Based on Fabrice Marie's IPv4 module.

Thanks!

Please read the comment in extensions/Makefile.=20

You can either

1) add the kernel header file to iptables userspace include directory
and add the name of the extension to PF{6}_EXT_LIB, or:

2) add a .test file.


Since the original nth and random match both use '2', I have updated
your patches accordingly.


> Regards,
> Maciej Soltysiak
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+s7x6XaXGVTD0i/8RApHiAKCK1ypAOIQmW8gxgF1zjJ+c1OzSKQCeJjT1
84KCqQUm5tDfSLj6IpBfBIQ=
=2zfX
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
